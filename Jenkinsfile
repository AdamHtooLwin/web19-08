pipeline {
    agent { docker { image 'ruby:2.6' } }
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

