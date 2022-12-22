## HCP Packer and Terraform Demo in Azure

This repository contains Packer and Terraform HCL definitions for a basic end-to-end demonstration in Azure.
_* This was tested with Terraform v1.3.4_

### Pre-Requisites
- An existing Terraform Cloud Organization with *Team & Governance Plan* features enabled.
- An **HCP Packer Registry** with the *Plus* tier of service.
- An Azure Service Principal credential. You'll need the *Subscription ID*, *Tenant ID*, *Client ID*, and *Client Secret ID* for Packer builds and Terraform Plans/Applies.
- A Terraform Cloud Workspace with a VCS connection to the *azure/terraform* folder.
- A **Variable Set** in your Terraform Cloud Organization containing the following **Environment Variables**:
    - HCP_CLIENT_ID
    - HCP_CLIENT_SECRET *(sensitive)*
    - ARM_SUBSCRIPTION_ID
    - ARM_TENANT_ID
    - ARM_CLIENT_ID
    - ARM_CLIENT_SECRET *(sensitive)*
- An **_HCP-Packer_ Run Task** in your Terraform Cloud Organization.
    - Retrieve the **Endpoint URL** and **HMAC Key** from the HCP Packer *Integrate with Terraform Cloud* page under portal.cloud.hashicorp.com.
- Assign the **_HCP-Packer_ Run Task** to the target Workspace and configure it for _Mandatory_.

### Required Code Updates 
- Update the *az.pkvars.hcl* files within each packer build folder with your Azure Service Principal credentials.
- Update the *build.sh* script with the **HCP Client ID** and **HCP Client Secret**.

### Demo Script

#### Step 1 - Base Image Build
This build uses an Azure Ubuntu iamge and installs Apache2 to serve as the organizations base image.
- From within the *azure subfolder* run the following
```
./build.sh packer-1-base
```
- Once build completes, create a *production* channel for *acme-base* image and assign the newly built iteration to the channel.

#### Step 2 - Web Application Image Build
This build uses the production base image and deploys our application (an HTML file).
- From within the *azure subfolder* run the following
```
./build.sh packer-2-webapp
```
- Once build completes, create a *production* channel for *acme-webapp* image and assign the newly built iteration to the channel.

#### Step 3 - Initial Application Deployment
Use Terraform to deploy a simple VPC and our application image.
- Run a Terraform Plan and Apply.
- Use the *Terraform Output* to launch the URL for our cat pictures.

#### Step 4 - Revoke Vulnerable Images
Oh No!  A zero-day Apache2 vulnerability has been identified.  We knew we should have used Nginx.
- Within **HCP Packer**, revoke the *acme-base* and *acme-webapp* iterations.
- Run a Terraform Plan and Apply.
- Observe how the **_HCP-Packer_ Run Task** prevented the revoked images from being deployed.

#### Step 5 - Build Development Base Image
We'll replace Apache2 with Nginx to remediate the vulnerability.   We will build a new development base image so we can test the new image prior to a production rollout.
This build uses an Azure Ubuntu image and installs Nginx to replace Apache2.
- From within the *azure subfolder* run the following
```
./build.sh packer-3-base-update
```
- Once build completes, create a *development* channel for *acme-base* image and assign the newly built iteration to the channel.

#### Step 6 - Build Development Application Image
This build uses the new development base image and deploys our application (new HTML file).
- From within the *azure subfolder* run the following
```
./build.sh packer-4-webapp-update
```
- Once build completes, create a *development* channel for *acme-webapp* image and assign the newly built iteration to the channel.

#### Step 7 - Deploy Updated Application Image
Use Terraform to deploy a the new VPC and our application image.
- Edit the **_web_app.tf_** file in the *azure/terraform* directory.
    - Change the **_hcp_packer_iteration, channel_** variable to **_development_**.
- Run a Terraform Plan and Apply.
- Use the *Terraform Output* to launch the URL for our cat pictures.
