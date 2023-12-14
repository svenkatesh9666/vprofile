pipeline {
    agent any
       stages {
        stage('Checkout') {
           steps {
         sh 'echo passed'
            git branch: 'main', url: 'https://github.com/sekhar334/vprofile.git'
           }
        }
        
           stage('Build and Test') {
           steps {
             sh 'ls -ltr'
        // build the project and create a JAR file
              sh 'mvn clean package'
            }
        }
        
           stage('Static Code Analysis') {
               environment {
               SONAR_URL = "http://3.95.34.252:9000"
           }
               steps {
             withCredentials([string(credentialsId: 'sonar', variable: 'SONAR_AUTH_TOKEN')]) {
              sh 'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
           }
        }
    }
            stage('Deploy to Nexus') {
            steps {
                // Deploy artifacts to Nexus
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '18.208.127.193:8081',
                    groupId: 'com.visualpathit',
                    version: 'v2',
                    repository: 'mavenhst',
                    credentialsId: 'nexus',
                    artifacts: [
                        [artifactId: 'vprofile', type: 'war', classifier: '', file: 'target/vprofile-v2.war']
                    ]
                )
            }
        }
            stage('Build Image') {
            steps {
                script {
                    // Build Docker image
                    docker.build("vprofile:latest")
                }
            }
        }
           stage('Run Container') {
            steps {
                script {
                    // Run Docker container
                    docker.image("vprofile:latest").run('-d -p 9090:8080 --name visualpathit')
                }
            }
        }
            stage('Push to DockerHub') {
            steps {
                script {
                    // Login to DockerHub
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    }

                    // Push the Docker image to DockerHub
                    sh 'docker push guna0334/vprofile:latest'
                }
            }
        }
    }
   }         
