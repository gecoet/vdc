# Features

The toolkit is focused on deploying and managing _governable_ environments in Microsoft Azure.
It assists in satisfying the security and compliance requirements related to cloud infrastructure at enterprise scale. 

To do this, the toolkit provides:
* Modularized assets for composing a custom solution
* References implementations that use the modular assets

The toolkit supports both manual execution and automated execution.
Manual execution is intended for learning and some design-time activities.
Automated execution is encouraged.

## Reference implementations

The toolkit provides a catelog of reference implementations. 
These includes:
* setting up landing zones 

## Reference architetures and implementations

## Modular deployments

Ability to specify which module to deploy
Each deployment also deploys Policies and/or RBAC (as ARM templates)


## Resource group and Subscription deployments

Support for Resource Group and Subscription scope deployment by analyzing a deployment template


## Limits the chance of Azure Resource Manger REST API throttling

Deployment using a phased wait, after 10 loops the wait time doubles its initial time. Wait time starts at 6 seconds per loop.

## Storage of your CI/CD details, deployment outputs and Resource state

 CI/CD details such as UserId that triggered a deployment, CommitId, BuildId, ReleaseId, etc.
Resource state retrieved by invoking Azure Resource Graph
