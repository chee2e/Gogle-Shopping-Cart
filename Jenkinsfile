pipeline {
    agent  {
        label 'dind-agent'
    }
    stages {
        stage('Build image') {
            steps {
                script {
                    app = docker.build("class-mino-01/store")
                }
            }
        }
        
        stage("Push image to AR") {
            steps {
                script {
                    docker.withRegistry('https://asia.gcr.io', 'gcr:class-mino-01') {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('K8S Manifest Update') {

            steps {

                git credentialsId: 'chee2e',
                    url: 'https://github.com/chee2e/Argo_CD.git',
                    branch: 'main'

                sh "sed -i 's/store:.*\$/store:${env.BUILD_NUMBER}/g' deploy_store.yaml"
                sh "git add deploy_store.yaml"
                sh "git commit -m '[UPDATE] store ${env.BUILD_NUMBER} image versioning'"

                withCredentials([gitUsernamePassword(credentialsId: 'chee2e')]) {
                    sh "git push -u origin main"
                }
            }
            post {
                    failure {
                    echo 'Update failure !'
                    }
                    success {
                    echo 'Update success !'
                    }
            }
        }

    }             

}
