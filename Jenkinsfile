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
            }
        }
	
	stage('test') {
	    steps {
	        echo 'Testing!'
	    }
	}

        stage('deploy') {
            steps {
                echo 'Hello world deploy!' 
            }
        }
    }
}

