pipeline{
     agent any
     environment{
        TERRAFORM_VERSION="1.3.9"
        REGION = "us-east-1"
        AWS_ACCOUNT = "072056452537"
        REPO_URL="${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com"
        IMAGE="yace"
     }
     stages{
        stage("Checkout project"){
            steps{
                git branch: 'master', credentialsId: 'github-private-key', url: 'git@github.com:azubuikeokom/cloudwatch-monitoring.git'
            }
        }
        stage("Build custom image and push to ECR"){
            steps{
                withAWS(credentials:'aws-credentials',region:'us-east-1') {
                    echo "${env.BUILD_ID}"
                    sh 'aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin "${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com" '
                    sh "docker build -t ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE}:v${env.BUILD_ID} ."
                    sh "docker push ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE}:v${env.BUILD_ID}"
            }
            }
        }
        stage("Deploy ECS FARGATE infrastructure"){
            steps{
                 withAWS(credentials:'aws-credentials',region:'us-east-1') {
                    sh "cd terraform/env/staging"
                    sh "terraform init"
                    sh "terraform apply -out tfplan"
            }                                     
            }
        }
        stage("Deploy ECS infrastructure"){
            steps{
                echo 'Deploy'
                echo "${env.JENKINS_BASE_URL}"
            }
        }
     }
}