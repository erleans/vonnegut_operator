vonnegut_operator
=====

This operator is for deploying and managing vonnegut on Kubernetes. It creates a CRD for kind `VonnegutCluster`. A `VonnegutCluster` resource defines how many chains and replicas for each chain the vonnegut cluster has. Each chain is a `StatefulSet` managed by the vonnegut controller.

```
apiVersion: "vonnegutoperator.spacetimeinsight.com/v1alpha1"
kind: VonnegutCluster
metadata:
  name: my-vg-cluster
spec:
  image: vonnegut
  chains: 2
  replicas: 2
```
