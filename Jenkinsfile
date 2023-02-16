pipeline{
     agent any
     parameters{
        choice(name:"ENVIRONMENTS",choices:["staging","prod"],description:"Engineers inputs the environment to deploy into")
     }
     environment{
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
        stage("Initializa Terraform and Plan ECS FARGATE Deployment"){
            when{
                expression{params.ENVIRONMENTS}
            }
            steps{
                 withAWS(credentials:'aws-credentials',region:'us-east-1') {
                    dir("terraform/env/${params.ENVIRONMENTS}"){
                        sh "terraform init"
                        sh "terraform plan -out tfplan"
                    }
            }                                     
            }
        }
        stage("Deploy ECS infrastructure"){
            steps{
                withAWS(credentials:'aws-credentials',region:'us-east-1') {
                    dir("terraform/env/${params.ENVIRONMENTS}"){
                        sh "terraform apply tfplan "
                    }
            }     
            }
        }
     }
}