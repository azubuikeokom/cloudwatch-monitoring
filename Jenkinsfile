pipeline{
     agent any
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
        stage("Build custom Docker IMAGE"){
            steps{
                withAWS(credentials:'aws-credentials',region:'us-east-1') {
                    sh 'aws ecr get-login-password --REGION ${REGION} | docker login --username AWS --password-stdin "${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com" '
                    sh 'docker build -t "${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE}:${env.BUILD_ID}" . '
                    sh 'docker push "${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE}:${env.BUILD_ID}"  '
            }
            }
        }
        stage("Push imgae to AWS ECR"){
            steps{

                echo 'Hello pushing'
                           
            }
        }
        stage("Deploy ECS infrastructure"){
            steps{
                echo 'Deploy'
            }
        }
     }
}