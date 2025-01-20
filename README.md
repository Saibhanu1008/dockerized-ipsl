# IPSL Tool Deployment with Amazon ECS

This project provides a fully automated solution to build, containerize, and deploy the **IPSL Tool** using **Docker** and **Amazon ECS**. The goal is to streamline the deployment process and ensure a consistent runtime environment across all stages.

## Project Highlights
- Utilized **Docker** to containerize the IPSL tool for consistent deployment.
- Leveraged **Amazon ECS** to orchestrate and manage containerized workloads.
- Automated the build and deployment process using **GitHub Actions** (or Jenkins, as needed).
- Included detailed task definitions and reusable infrastructure-as-code for scalable deployments.

---

## Files and Directories
- **`Dockerfile`**: Defines the container environment and includes installation steps for the IPSL tool.
- **`ipsl-tool/install.sh`**: Shell script that installs the IPSL tool and its dependencies.
- **`task-definition.json`**: Specifies the ECS task definition, including memory, CPU, and logging configurations.
- **`.github/workflows/deploy.yml`**: GitHub Actions workflow to automate image building, pushing to Amazon ECR, and deployment to ECS.

---

## Prerequisites
Before using this project, ensure the following are set up:

1. **AWS CLI**:
   - Install and configure the AWS CLI on your local machine with appropriate credentials.
   - Region and profile should be set up using `aws configure`.

2. **Amazon ECR Repository**:
   - Create an ECR repository for the `ipsl-tool` image:
     ```bash
     aws ecr create-repository --repository-name ipsl-tool
     ```

3. **Amazon ECS Cluster**:
   - Set up an ECS cluster:
     ```bash
     aws ecs create-cluster --cluster-name ipsl-tool-cluster
     ```

---

## Deployment Steps

### 1. Clone the Repository
   Clone this repository to your local machine:
   ```bash
   git clone https://github.com/<your-username>/ipsl-tool-deployment.git
   cd ipsl-tool-deployment
   ```

### 2. Build the Docker Image
   Build the Docker image locally:
   ```bash
   docker build -t ipsl-tool .
   ```

### 3. Push the Docker Image to Amazon ECR
   Authenticate with Amazon ECR:
   ```bash
   aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<your-region>.amazonaws.com
   ```
   Tag and push the image:
   ```bash
   docker tag ipsl-tool:latest <account-id>.dkr.ecr.<your-region>.amazonaws.com/ipsl-tool:latest
   docker push <account-id>.dkr.ecr.<your-region>.amazonaws.com/ipsl-tool:latest
   ```

### 4. Register the ECS Task Definition
   Register the task definition using the provided `task-definition.json`:
   ```bash
   aws ecs register-task-definition --cli-input-json file://task-definition.json
   ```

### 5. Deploy the Task to ECS
   Create a service to run the task on your ECS cluster:
   ```bash
   aws ecs create-service \
       --cluster ipsl-tool-cluster \
       --service-name ipsl-tool-service \
       --task-definition ipsl-tool-task \
       --desired-count 1
   ```

### 6. Monitor the Deployment
   Check the ECS service status:
   ```bash
   aws ecs describe-services --cluster ipsl-tool-cluster --services ipsl-tool-service
   ```

   View logs in **Amazon CloudWatch Logs** for troubleshooting.

---

## Example Output
After deploying, the service will be accessible via the **ECS Load Balancer** or the public IP of the running ECS container instance.

---

## Key Learnings
- **Containerization**: Streamlined application packaging using Docker.
- **Cloud Orchestration**: Hands-on experience with Amazon ECS for managing containerized applications.
- **CI/CD Automation**: Integrated GitHub Actions for end-to-end pipeline automation.
- **Scalability**: Configured ECS services to easily scale up/down based on demand.

---

## Next Steps
1. Set up auto-scaling for ECS services.
2. Integrate secrets management using **AWS Secrets Manager**.
3. Implement additional monitoring using **CloudWatch Metrics and Alarms**.

