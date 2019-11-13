pipeline {
    agent {
        dockerfile {
          filename 'build/Dockerfile'
        }
    }

    stages {
        stage('build') {
            steps {
                sh 'ruby --version'
		sh 'cat /etc/passwd'
		sh 'whoami'
            }
        }
	
	stage('test') {
	    steps {
	        echo 'Testing!'
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

