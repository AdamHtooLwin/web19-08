
pipeline {
    agent {
        dockerfile {
          label "cpu-1-ci"
          filename 'build/Dockerfile'
        }
    }
    stages {
        stage('build') {
            steps {
                echo 'Hello world build!'
            }
        }
        stage('test') {
            steps {
                sh '''
                    sudo service postgresql start
                    sudo su postgres -c "createuser -s jenkins"
                    ./scripts/test.sh
                '''
            }
        }
        stage('deploy') {
            steps {
                echo 'Hello world deploy!' 
            }
        }
    }
}

