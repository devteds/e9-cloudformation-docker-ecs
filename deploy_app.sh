#!/bin/bash

# Usage: ./deploy_app.sh <CLUSTER NAME> <SERVICE NAME> <TASK FAMILY>

CLUSTER=$1
SERVICE=$2
TASK_FAMILY=$3

# Get the current task definition
TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition "${TASK_FAMILY}")

# Use 'jq' (json processor) to read current container and task properties
CONTAINER_DEFINITIONS=$(echo "$TASK_DEFINITION" | jq '. | .taskDefinition.containerDefinitions')
TASK_EXEC_ROLE_ARN=$(echo "$TASK_DEFINITION" | jq '. | .taskDefinition.executionRoleArn | tostring' | cut -d'/' -f2 | sed -e 's/"$//')
TASK_CPU=$(echo "$TASK_DEFINITION" | jq '. | .taskDefinition.cpu | tonumber')
TASK_MEMORY=$(echo "$TASK_DEFINITION" | jq '. | .taskDefinition.memory | tonumber')

# Register new task. No change to container definition.
aws ecs register-task-definition --family ${TASK_FAMILY} --requires-compatibilities FARGATE --network-mode awsvpc --task-role-arn $TASK_EXEC_ROLE_ARN --execution-role-arn $TASK_EXEC_ROLE_ARN --cpu ${TASK_CPU} --memory ${TASK_MEMORY} --container-definitions "${CONTAINER_DEFINITIONS}"

# Update service to use new task defn - This should pick the new image for the new revision of task defn
aws ecs update-service --cluster "${CLUSTER}" --service "${SERVICE}"  --task-definition "${TASK_FAMILY}"
