# How to run

There are two types of indy running mode:

* Standalone mode: in this mode, indy will use direct storage to hold all artifacts. Just run `docker-compose up -d ` to start it (default docker-compose.yaml for this mode)
* Path-mapped storage mode: in this mode, indy will use cassandra storage to store all path information for artifacts and hide the real absolute paths for storage with hashed-style paths. This is working for cluster mode of districuted storage support. Use `docker-compose -f docker-compose-cassandra.yaml up -d` to start in this mode. Note that you should create /tmp/cassandra in your local machine for cassandra storage volume.

