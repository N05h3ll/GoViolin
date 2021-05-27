 pipeline{
    agent any
    environment {
        dockerImage = 'n05h3ll/instabug-challenge'
        userEmail = 'm0.ash.aziz98@gmail.com'
    }
    stages{
        stage("Build"){
            steps{
                echo "========Building Image========"
                
                // Building image with docker engine
                script {
                    docker.build("${dockerImage}")
                    }
                }
            post{
            // Success scenario
                success{
                    echo "========Build Finished Successfully========"
                }
                // Failure scenario
                failure{
                    echo "========Build Failed========"
                    script {
                        mail bcc: '', body: 'Building your docker image with build number #-${BUILD_NUMBER} failed, please review this step.', cc: '', from: '', replyTo: '', subject: '[${BUILD_NUMBER}] - Build Failed', to: '${userEmail}'
                    }
                }
                }
            }
        stage("Push to Dockerhub"){
            steps{
                echo "========Pushing Image========"
                // Getting docker credentials
                withDockerRegistry(credentialsId: 'dockerHub', url: ''){
                    sh 'docker login'
                    sh 'docker push ${dockerImage}'
                }
            }
            post{
            // Success scenario
                success{
                    echo "========Pushed Successfully========"
                }
                // Failure scenario
                failure{
                echo "========Image Pushing Failed========"
                script {
                        mail bcc: '', body: 'Pushing your image to dockerhub failed, please review this step.', cc: '', from: '', replyTo: '', subject: '[${BUILD_NUMBER}] - Push Failed', to: '${userEmail}'
                    }
                }
            }
        }
        stage("Deploy to kubernetes"){
            steps{
                sh 'kubectl apply -f kubernetes-deployment-service.yaml'
            }
            post{
                success{
                    echo "========Deployed Successfully========"
                }
                failure{
                    echo "========Deployment Failed========"
                script {
                        mail bcc: '', body: 'Delpoying application with build number #-${BUILD_NUMBER} to kubernetes failed, please review this step.', cc: '', from: '', replyTo: '', subject: '[${BUILD_NUMBER}] - Kubernetes deployment Failed', to: '${userEmail}'
                    
                }
            }
        }
    }
        stage("Cleanup docker image"){
                steps{
                    sh 'docker rmi $registry:$BUILD_NUMBER'
                }
                post{
                    success{
                        echo "========Deleted Successfully========"
                    }
                    failure{
                        echo "========Cleanup Failed========"
                    script {
                            mail bcc: '', body: 'Deleting docker image with with ID ${BUILD_NUMBER} failed, please review this step.', cc: '', from: '', replyTo: '', subject: '[${BUILD_NUMBER}] - Kubernetes deployment Failed', to: '${userEmail}'
                        
                    }
                }
            }
        }
    post{
    // Success scenario
        success{
            echo "========Pipeline executed successfully ========"
        }
        // Failure scenario
        failure{
            echo "========Pipeline execution failed========"
            script {
                        mail bcc: '', body: 'Pipeline execution with number  #-${BUILD_NUMBER} failed, please review the process.', cc: '', from: '', replyTo: '', subject: '[${BUILD_NUMBER}] - Pipeline Failure', to: '${userEmail}'
                    }
        }
    }
}
 }