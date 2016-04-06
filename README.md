### Mesos/Marathon Cluster on Vagrant

##### Steps

###### 1.

```
vagrant up mesos-master
vagrant up mesos-slave1
vagrant up mesos-slave2
vagrant up mesos-slave3
```

###### 2.

> browse to http://10.141.141.10:5050 (mesos)
> browse to http://10.141.141.10:8080 (marathon)

###### 3.

> create the Jupyter marathon app

```
{
  "id": "nerve-jspark-dev",
  "instances": 1,
  "mem": 512,
  "ports": [8888],
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "jupyter/all-spark-notebook:latest",
      "network": "HOST",
      "pid": "host",
      "forcePullImage": false
    }
},
   "env": {
        "ZK_HOSTS": "10.141.141.10:2181",
        "TINI_SUBREAPER": "true"
    }
}
```

save it as ``vagrant-nerve-jspark-dev-1.json``

###### 4.

> launch the Jupyter notebook in marathon

``` curl -X POST http://10.141.141.10:8080/v2/apps -d @vagrant-nerve-jspark-dev-1.json -H "Content-type: application/json" ```


> more work need to put this behind HAProxy... :)
