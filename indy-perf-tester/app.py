#!/usr/bin/env python

import os
import sys
import time
import requests
import json

from ruamel.yaml import YAML
from datetime import datetime as dt
# from urlparse import urlparse
from urllib.parse import urlparse

ENVAR_TEST_CONFIG = 'test_configfile'
ENVAR_BUILD_NAME = 'build_name'
ENVAR_INDY_URL = 'indy_url'
ENVAR_PROXY_PORT = 'proxy_port'


TEST_BUILDS_SECTION = 'builds'
TEST_SOURCE_BASEDIR = 'source-base-directory'
TEST_PROMOTE_BY_PATH_FLAG = 'promote-by-path'
TEST_STORES = 'stores'


BUILD_SOURCE_DIR = 'source-directory'
BUILD_GIT_BRANCH = 'git-branch'


DEFAULT_STORES = [
    {          
        'type': 'hosted', 
        'name': 'builds', 
        'allow_releases': True
    },
    {
          'type': 'hosted', 
          'name': 'shared-imports', 
          'allow_releases': True
    },
    {
        'type': 'group', 
        'name': 'builds', 
        'constituents': [
            "maven:hosted:builds"
        ]
    },
    {
          'type': 'group', 
          'name': 'brew_proxies'
    }
]

SETTINGS = """
<?xml version="1.0"?>
<settings>
  <localRepository>/tmp/repository</localRepository>
  <mirrors>
    <mirror>
      <id>indy</id>
      <mirrorOf>*</mirrorOf>
      <url>%(url)s/api/folo/track/%(id)s/maven/group/%(id)s</url>
    </mirror>
  </mirrors>
  <proxies>
    <proxy>
      <id>indy-httprox</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>%(host)s</host>
      <port>%(proxy_port)s</port>
      <username>%(id)s+tracking</username>
      <password>foo</password>
      <nonProxyHosts>%(host)s</nonProxyHosts>
    </proxy>
  </proxies>
  <profiles>
    <profile>
      <id>resolve-settings</id>
      <repositories>
        <repository>
          <id>central</id>
          <url>%(url)s/api/folo/track/%(id)s/maven/group/%(id)s</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>false</enabled>
          </snapshots>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <id>central</id>
          <url>%(url)s/api/folo/track/%(id)s/maven/group/%(id)s</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>false</enabled>
          </snapshots>
        </pluginRepository>
      </pluginRepositories>
    </profile>
    
    <profile>
      <id>deploy-settings</id>
      <properties>
        <altDeploymentRepository>%(id)s::default::%(url)s/api/folo/track/%(id)s/maven/hosted/%(id)s</altDeploymentRepository>
      </properties>
    </profile>
    
  </profiles>
  <activeProfiles>
    <activeProfile>resolve-settings</activeProfile>
    
    <activeProfile>deploy-settings</activeProfile>
    
  </activeProfiles>
</settings>
"""

POST_HEADERS = {'content-type': 'application/json', 'accept': 'application/json'}


def run_build():
    """ 
    Main entry point. Read envars, setup build dir, checkout sources, and execute the build.

    Build steps include:
    
        * Setup all relevant repositories and groups in Indy
        * Checkout project source code
        * Execute PME against DA URL (TODO)
        * Setup a Maven settings.xml for the build
        * Execute Maven with the given settings.xml
        * Pull the resulting tracking record
        * Promote dependencies
        * Promote build output
        * Cleanup relevant repos / groups from Indy

    NOTE: This process should mimic the calls and sequence executed by PNC as closely as possible!
    """

    # try:
    (test_config, build_name, indy_url, proxy_port) = read_test_config()
    (build, src_basedir, promote_by_path, stores) = validate_and_extract_build(test_config, build_name)

    tid_base = f"build_{build_name}"

    project_src_dirname = build.get(BUILD_SOURCE_DIR) or build_name
    project_src_dir = os.path.join( src_basedir, project_src_dirname)

    git_branch = build.get(BUILD_GIT_BRANCH) or 'master'
    builddir = setup_builddir(os.getcwd(), project_src_dir, git_branch, tid_base)

    tid = os.path.basename(builddir)
    parsed = urlparse(indy_url)
    params = {
        'url':indy_url, 
        'id': tid, 
        'host': parsed.hostname, 
        'port': parsed.port, 
        'proxy_port': proxy_port
    }

    create_repos_and_settings(builddir, stores, params);

    do_pme(builddir)
    do_build(builddir)
    seal_folo_report(params)

    folo_report = pull_folo_report(params)
    promote_deps_by_path(folo_report, params)

    if promote_by_path is True:
        promote_output_by_path(params)
    else:
        promote_output_by_group(params)

    cleanup_build_group(params)

    # except (KeyboardInterrupt,SystemExit,Exception) as e:
    #     print(e)

def read_test_config():
    """ Read the test configuration that this worker should run, from envars. """

    test_configfile = os.environ.get(ENVAR_TEST_CONFIG)
    indy_url = os.environ.get(ENVAR_INDY_URL)
    proxy_port = os.environ.get(ENVAR_PROXY_PORT) or '8081'
    build_name = os.environ.get(ENVAR_BUILD_NAME)

    errors = []
    if indy_url is None:
        errors.append(f"Missing Indy URL envar: {ENVAR_INDY_URL}")

    if build_name is None:
        errors.append(f"Missing build name envar: {ENVAR_BUILD_NAME}")

    if test_configfile is None:
        errors.append(f"Missing test config-file envar: {ENVAR_TEST_CONFIG}")
    elif os.path.exists(test_configfile):
        with open( test_configfile ) as f:
            yaml = YAML(typ='safe')
            test_config = yaml.load(f)
    else:
        errors.append( f"Missing test config file {test_configfile}")

    if len(errors) > 0:
        print("\n".join(errors))
        raise Exception("Invalid configuration")

    return (test_config, build_name, indy_url, proxy_port)

def validate_and_extract_build(test_config, build_name):
    """ Retrieve the configuration for this current build from a larger test-suite profile config, and validate that
        all necessary parameters are available. Also, pull the Indy URL from the test-suite config.
    """

    builds = test_config.get(TEST_BUILDS_SECTION) or {}
    build = builds.get(build_name)
    src_basedir = test_config.get(TEST_SOURCE_BASEDIR) or os.getcwd()
    promote_by_path = test_config.get(TEST_PROMOTE_BY_PATH_FLAG) or True
    base_stores = test_config.get(TEST_STORES) or DEFAULT_STORES

    if build is None:
        print(f"Test configuration is invalid. Missing build config for {build_name}")
        raise Exception("Invalid configuration")

    return (build, src_basedir, promote_by_path, base_stores)


def setup_builddir(builds_dir, projectdir, branch, tid_base):
    """ Setup physical directory for executing the build, then checkout the sources there. """

    if os.path.isdir(builds_dir) is False:
        os.makedirs(builds_dir)

    builddir="%s/%s-%s" % (builds_dir, tid_base, dt.now().strftime("%Y%m%dT%H%M%S"))

    run_cmd("git clone -l -b %s file://%s %s" % (branch, projectdir, builddir))
    
    return os.path.join(os.getcwd(), builddir)


def run_cmd(cmd, fail=True):
    """Run the specified command. If fail == True, and a non-zero exit value 
       is returned from the process, raise an exception
    """
    print(cmd)
    ret = os.system(cmd)
    if ret != 0:
        print("Error running command: %s (return value: %s)" % (cmd, ret))
        if fail:
            raise Exception("Failed to run: '%s' (return value: %s)" % (cmd, ret))


def create_repos_and_settings(builddir, stores, params):
    """
    Create the necessary hosted repos and groups, then generate a Maven settings.xml file 
    to work with them.
    """

    create_missing_stores(stores, params)

    # Write the settings.xml we need for this build
    with open("%s/settings.xml" % builddir, 'w') as f:
        f.write(SETTINGS % params)


def create_missing_stores(stores, params):
    stores.append({
        'type': 'hosted', 
        'key': f"maven:hosted:{params['id']}", 
        'disabled': False, 
        'doctype': 'hosted', 
        'name': params['id'], 
        'allow_releases': True
    })

    stores.append({
        'type': 'group', 
        'name': params['id'], 
        'constituents': [
            f"maven:hosted:{params['id']}", 
            'maven:group:builds',
            'maven:group:brew_proxies',
            'maven:hosted:shared-imports',
            'maven:group:public'
        ]
    })

    for store in stores:
        store_type = store['type']
        package_type = store.get('package_type')
        if package_type is None:
            package_type = 'maven'
            store['package_type'] = package_type

        name = store['name']
        store['key'] = f"{package_type}:{store_type}:{name}"
        store['doctype'] = store_type
        store['disabled'] = False

        base_url = f"{params['url']}/api/admin/stores/{package_type}/{store_type}"
        resp = requests.head(f"{base_url}/{store['name']}")
        if resp.status_code == 404:
            print("POSTing: %s" % json.dumps(store, indent=2))

            resp = requests.post(base_url, json=store, headers=POST_HEADERS)
            resp.raise_for_status()


def do_pme(builddir):
    """ TODO: Run PME, which should talk to DA and pull metadata files from the Indy instance. """


def do_build(builddir):
    run_cmd("mvn -f %(d)s/pom.xml -s %(d)s/settings.xml clean deploy 2>&1 | tee %(d)s/build.log" % {'d': builddir}, fail=False)


def seal_folo_report(params):
    """Seal the Folo tracking report after the build completes"""

    print("Sealing folo tracking report for: %(id)s" % params)
    resp = requests.post("%(url)s/api/folo/admin/%(id)s/record" % params, data={})
    resp.raise_for_status()


def pull_folo_report(params):
    """Pull the Folo tracking report associated with the current build"""

    print("Retrieving folo tracking report for: %(id)s" % params)
    resp = requests.get("%(url)s/api/folo/admin/%(id)s/record" % params)
    resp.raise_for_status()

    return resp.json()


def promote_deps_by_path(folo_report, params):
    """Run by-path promotion of downloaded content"""
    to_promote = {}

    downloads = folo_report.get('downloads')
    if downloads is not None:
        for download in downloads:
            key = download['storeKey']
            mode = download['accessChannel']
            if mode == 'MAVEN_REPO' and key.startswith('remote:'):
                path = download['path']

                paths = to_promote.get(key)
                if paths is None:
                    paths = []
                    to_promote[key]=paths

                    paths.append(path)

    print("Promoting dependencies from %s sources into hosted:shared-imports" % len(to_promote.keys()))
    for key in to_promote:
        req = {'source': key, 'target': 'hosted:shared-imports', 'paths': to_promote[key]}
        resp = requests.post("%(url)s/api/promotion/paths/promote" % params, json=req, headers=POST_HEADERS)
        resp.raise_for_status()

def promote_output_by_path(params):
    """Run by-path promotion of uploaded content"""

    print("Promoting build output in hosted:%(id)s to membership of hosted:builds" % params)
    req = {'source': 'hosted:%(id)s' % params, 'target': 'hosted:builds'}
    resp = requests.post("%(url)s/api/promotion/paths/promote" % params, json=req, headers=POST_HEADERS)
    resp.raise_for_status()


def promote_output_by_group(params):
    """Run by-group promotion of uploaded content"""

    print("Promoting build output in hosted:%(id)s to membership of group:builds" % params)
    req = {'source': 'hosted:%(id)s' % params, 'targetGroup': 'builds'}
    resp = requests.post("%(url)s/api/promotion/groups/promote" % params, json=req, headers=POST_HEADERS)
    resp.raise_for_status()


def cleanup_build_group(params):
    """Remove the group created specifically to channel content into this build,
       since we're done with it now.
    """

    print("Deleting temporary group:%(id)s used for build time only" % params)
    resp = requests.delete("%(url)s/api/admin/group/%(id)s" % params)
    resp.raise_for_status()


if __name__ == "__main__":
    run_build()
