# Deploying ArgoCD on GKE to deploy scalable applications

## POC objectives

Validate the possible use of ArgoCD in a Kubernetes environment to manage scalable applications reliably using GitOps principles in the context of a scalable, automated, and consistent deployment pipeline.

## Infra architecture

The infrastructure consists of the following logical components:

- **Kubernetes Cluster**: A managed GKE (Google Kubernetes Engine) cluster.
- **ArgoCD**: A continuous delivery tool for Kubernetes, deployed within the GKE cluster.
- **Git Repository**: A Git repository hosted on GitHub, containing application manifests and configurations.
- **CI/CD Pipeline**: Integrated with GitHub Actions for automated testing and deployment.
- **Networking**: The ArgoCD application should be accessed using a standard HTTPS connection on a load balancer to the cluster.
- **Cloud Type**: Public cloud infrastructure on Google Cloud Platform (GCP).

## Scenario

Describe step-by-step the scenario. Write it using this format (BDD style).

### STEP 01

```
//given -> A GitHub repository containing the Kubernetes manifests and application configurations.
//when -> A change (e.g., a new commit) is pushed to the repository.
//then -> ArgoCD detects the change, syncs the new configuration, and deploys the updated application to the Kubernetes cluster.
```

### STEP 02

```
//given -> ArgoCD is deployed and configured within the GKE cluster, with access to the GitHub repository.
//when -> The application state in the GitHub repository is updated (e.g., a new version of the application is committed).
//then -> ArgoCD pulls the latest changes, applies them to the Kubernetes cluster, and updates the application to the new version.
```

### STEP 03

```
//given -> The application is successfully deployed and running in the Kubernetes cluster.
//when -> An issue is detected in the deployed application (e.g., a failing health check).
//then -> ArgoCD reverts to the previous stable state from the GitHub repository, restoring the application's functionality.
```

### STEP 04

```
//given -> The application is updated on the git repository 
//when -> The application is scheduled to be updated outside of business hours
//then -> ArgoCD will refuse the change to be applied before the next working day
```

### STEP 05

```
//given -> A new commit is pushed on the git repository
//when -> The commit is not signed by a Ops GPG key
//then -> ArgoCD will refuse the sync of the application
```

## Cost

<analysis of load-related costs.>

<option to reduce or adapt costs (practices, subscription)>

## Return of experience

<take a position on the poc that has been produced.>

<Did it validate the announced objectives?>
