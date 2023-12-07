pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'adamhaddad/mongo-demo-2'
        DOCKER_REGISTRY_CREDENTIALS = 'ADAMHADDAD'
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/AD3M-HADDAD/mongo-demo-2.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=mongo-demo-2 \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=mongo-demo-2 '''
                }
            }
        }
        stage("quality gate"){
            steps {
                script {
                  waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token' 
                }
           }
        }
        stage('Build and Test') {
            steps {
                sh './mvnw clean install'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(env.DOCKER_IMAGE, '-f Dockerfile .')
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_REGISTRY_CREDENTIALS) {
                        docker.image(env.DOCKER_IMAGE).push()
                    }
                }
            }
        }
        stage('Pull Docker Image from Docker Registry') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_REGISTRY_CREDENTIALS) {
                        docker.image(env.DOCKER_IMAGE).pull()
                    }
                }
            }
        }
    }
}
