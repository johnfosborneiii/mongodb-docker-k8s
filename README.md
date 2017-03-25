# Overview

**WARNING: This is only a Proof-Of-Concept example and it is not meant to be used in
production. Use at your own risk.**

## Development

### Prerequisites

- TBD

### Installing

To build the images, run:

#### base

```
bin/build-image.sh base
```

#### mongod

```
bin/build-image.sh mongod
```

#### mms-app

```
bin/build-image.sh mms-app
```

### Testing

- TBD

## Quickstart

To create a MongoDB replica set on OCP, you can use the template included in this repository and create a new deployment right away:

```
$ oc new-app k8s/replica/mongodb-clustered.json
```

Since the provided template uses ephemeral storage, after every redeploy you get
an empty database, and **all data from a previous deploy is lost**.

## Documentation

### Service

This resource defines a [headless service](http://kubernetes.io/v1.0/docs/user-guide/services.html#headless-services)
that serves as an entry point to the replica set. The service endpoints are
the pods created by the `mongodb` DeploymentConfig.

A headless service allows using DNS queries to discover other MongoDB
endpoints from inside the container, by querying the service name (e.g.: `dig
mongodb A +short +search`).

### DeploymentConfig

This resource defines a [deployment configuration](https://docs.openshift.org/latest/architecture/core_concepts/deployments.html#deployments-and-deployment-configurations) to manage replica set members.
Each member starts the MongoDB server without replication data. Once it is
ready, it advertises itself to the current replica set [PRIMARY](https://docs.mongodb.com/manual/core/replica-set-primary/#replica-set-primary),
which will then add it to the replica set. When a member pod is destroyed, it
is automatically removed from the replica set.

To add/remove members to the replica set you can use the `oc scale` command.
This will scale the deployment up to 5 pods:

```
$ oc scale dc mongodb --replicas=5
```

The provided template will start three replicas by default.
MongoDB recommends using an [odd number of replicas](http://docs.mongodb.org/v2.4/tutorial/deploy-replica-set/#overview).

#### Post-deployment Hook

The DeploymentConfig has a post-deployment hook that runs once after every
deploy, and is responsible for initializing the replica set, as well as creating
the database and users. The hook terminates after the initialization is complete,
a PRIMARY is elected and data is replicated to other members of the replica set.

## Configuration

There are a few environment variables that can be used to configure the
replica set, all of them have default values.

* `MONGODB_REPLICA_NAME` - name of the replica set (default: `rs0`).
* `MONGODB_SERVICE_NAME` - name of the MongoDB service (default: `mongodb`, used by DNS lookup).
* `MONGODB_ADMIN_PASSWORD` - password for the `admin` user (roles: 'dbAdminAnyDatabase', 'userAdminAnyDatabase', 'readWriteAnyDatabase', 'clusterAdmin') (default: *generated*).
* `MONGODB_DATABASE` - name of the database (default: `userdb`)
* `MONGODB_USER` - the name of the regular MongoDB user (roles: 'readWrite' for `$MONGODB_DATABASE`) (default: *generated*).
* `MONGODB_PASSWORD` - the regular MongoDB user password (default: *generated*).
* `MONGODB_KEYFILE_VALUE` - value for '[keyFile](http://docs.mongodb.org/v2.4/tutorial/generate-key-file/)' file that MongoDB members use for authorization internally (default: *generated*).

The patterns for generated values are defined in the template parameters.

## Uninstalling

- TBD


## Limitations

- TBD

## Community

- TBD
