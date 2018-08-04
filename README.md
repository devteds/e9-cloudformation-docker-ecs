# Docker on Amazon ECS using AWS CloudFormation & CLI

Devteds [Episode #9](https://devteds.com/episodes/9-docker-on-amazon-ecs-using-cloudformation)

Create and run docker container on Amazon ECS using CloudFormation and CLI.

- Containerize a simple REST API application
- Use AWS CLI to create Amazon ECR repository
- Build docker image and push to ECR
- CloudFormation stack to create VPC, Subnets, InternetGateway etc
- CloudFormation stack to create IAM role
- CloudFormation stack to create ECS Cluster, Loadbalancer & Listener, Security groups etc
- CloudFormation stack to deploy docker container

[Episode video link](https://youtu.be/Gr2yTSsVSqg)

[![Episode Video Link](https://i.ytimg.com/vi/Gr2yTSsVSqg/hqdefault.jpg)](https://youtu.be/Gr2yTSsVSqg)

Visit https://devteds.com to watch all the episodes

## Terminal Window Logs

### Code

```
mkdir ~/projs
git clone https://github.com/devteds/e9-cloudformation-docker-ecs.git docker-on-ecs
cd docker-on-ecs
```

### Dockerize a simple app

```
# Run on local
docker build -t books-api ./app/
docker run -it -p 4567:4567 --rm books-api:latest
open http://localhost:4567/
open http://localhost:4567/stat
open http://localhost:4567/api/books
```

### Push Docker Image to ECR

```
aws ecr create-repository --repository-name books-api
aws ecr get-login --no-include-email | sh
IMAGE_REPO=$(aws ecr describe-repositories --repository-names books-api --query 'repositories[0].repositoryUri' --output text)
docker tag books-api:latest $IMAGE_REPO:v1
docker push $IMAGE_REPO:v1
```

### Create CloudFormation Stacks

```
aws cloudformation create-stack --template-body file://$PWD/infra/vpc.yml --stack-name vpc

aws cloudformation create-stack --template-body file://$PWD/infra/iam.yml --stack-name iam --capabilities CAPABILITY_IAM

aws cloudformation create-stack --template-body file://$PWD/infra/app-cluster.yml --stack-name app-cluster

# Edit the api.yml to update Image tag/URL under Task > ContainerDefinitions and,
aws cloudformation create-stack --template-body file://$PWD/infra/api.yml --stack-name api
```

Copy the `BooksApiEndpoint` value from `api` stack output on AWS Management Console. Make a request to that URL on browser or any REST client.


## References

Find the resources and references on https://devteds.com/episodes/9-docker-on-amazon-ecs-using-cloudformation


