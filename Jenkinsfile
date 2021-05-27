 pipeline{
    agent any
    environment {
        dockerImage = "n05h3ll/instabug-challenge"
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
                    emailext body: "Building your docker image with build number #- ${BUILD_NUMBER} failed, please review this step.", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "[ ${BUILD_NUMBER} ] - Build Failed"
                }
                }
            }
        stage("Push to Dockerhub"){
            steps{
                echo "========Pushing Image========"
                // Getting docker credentials
                withDockerRegistry(credentialsId: "dockerHub", url: ""){
                    sh "docker login"
                    sh "docker push ${dockerImage}"
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
                emailext body: "Pushing your image to dockerhub failed, please review this step.", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "${BUILD_NUMBER} - Push Failed"
                }
            }
        }
        stage("Deploy to kubernetes"){
            steps{
                sh "kubectl apply -f kubernetes-deployment-service.yaml"
            }
            post{
                success{
                    echo "========Deployed Successfully========"
                }
                failure{
                    echo "========Deployment Failed========"
                    emailext body: "Delpoying application with build number #- ${BUILD_NUMBER} to kubernetes failed, please review this step.", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "[ ${BUILD_NUMBER} ] - Kubernetes deployment Failed"
            }
        }
    }
        stage("Cleanup docker image"){
                steps{
                    sh "docker rmi $registry:$BUILD_NUMBER"
                }
                post{
                    success{
                        echo "========Deleted Successfully========"
                    }
                    failure{
                        echo "========Cleanup Failed========"
                        emailext body: "Deleting docker image with with ID ${BUILD_NUMBER} failed, please review this step.", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "[ ${BUILD_NUMBER} ] - Cleanup Failed"
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
            emailext body: "Pipeline execution with number  #- ${BUILD_NUMBER} failed, please review the process.", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "[ ${BUILD_NUMBER} ] - Pipeline Failure"
        }
    }
}