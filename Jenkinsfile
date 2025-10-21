pipeline {
    agent any

    stages {
        stage('Checkout in Parallel') {
            parallel {
                stage('Checkout hg-environment-config') {
                    steps {
                        dir('hg-environment-config') {
                            checkout([
                                $class: 'GitSCM',
                                branches: [[name: '*/main']],
                                userRemoteConfigs: [[
                                    url: 'https://github.com/Hydrogarden-App/hg-environment-config.git',
                                    credentialsId: 'hydrogarden-app-jenkers'
                                ]]
                            ])
                        }
                    }
                }
            }
        }

        stage('Build services') {
            parallel {
                stage('Build hg-mysql') {
                    steps {
                        dir('hg-environment-config/images/hg-mysql') {
                            sh 'docker build -t hg-mysql:latest .'
                        }
                    }
                }

                stage('Build hg-nginx') {
                    steps {
                        dir('hg-environment-config/images/hg-nginx') {
                            sh 'docker build -t hg-nginx:latest .'
                        }
                    }
                }

                stage('Build hg-rabbitmq') {
                    steps {
                        dir('hg-environment-config/images/hg-rabbitmq') {
                            sh 'docker build -t hg-rabbitmq:latest .'
                        }
                    }
                }

                stage('Build hg-util-logrotate') {
                    steps {
                        dir('hg-environment-config/images/hg-util-logrotate') {
                            sh 'docker build -t hg-util-logrotate:latest .'
                        }
                    }
                }
            }
        }

        stage('Swap docker-compose.yaml') {
            steps {
                dir('hg-environment-config/server/docker') {
                    sh 'mv docker-compose.yaml /opt/hydrogarden/docker/docker-compose.yaml'
                }
            }
        }

        stage('Restart all services') {
            steps {
                script {
                    sh '''
                        cd /opt/hydrogarden/docker
                        docker compose down
                        docker compose up -d
                    '''
                }
            }
        }
    }
}
