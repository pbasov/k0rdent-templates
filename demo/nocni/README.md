Template itself is released as an OCI chart in this repo `ghcr.io/pbasov/k0rdent-templates/aws-standalone-cp-nocni:0.0.1`.

- apply `repo.yaml`
- apply `clustertemplate.yaml`
- create aws credentials
- ensure AMI with cri-o is available
- apply `cluster.yaml`