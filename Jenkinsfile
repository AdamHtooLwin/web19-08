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
                sh 'ruby --version'
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

