pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'master', description: 'Branch for tests')
        string(name: 'TAG', defaultValue: 'herokuapp', description: 'Cucumber tags')
        string(name: 'USERNAME', defaultValue: 'Test User Panda', description: 'text for step I print to console user name')
        string(name: 'TEST_FILE_NAME', defaultValue: '', description: 'for step print file content')
    }

    tools { allure 'allureReport' }

    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timestamps()
    }

    triggers {
        pollSCM('H/2 * * * *')
        upstream(upstreamProjects: 'secondHerokuapp', threshold: hudson.model.Result.SUCCESS)
    }

    stages {
        stage('Checkout') {
            steps {
                deleteDir()
                echo 'Pulling code...'
                checkout scmGit(
                    branches: [[name: "*/${params.BRANCH}"]], 
                    userRemoteConfigs: [[credentialsId: 'githubAuthToken', url: 'https://github.com/DianaReviako/testWdio']]
                )
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }

        stage('Get Message from Upstream') {
            steps {
                script {
                    fetchArtifact('secondHerokuapp', 'text.txt')
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    cleanUp(['allure-results', 'allure'])
                }
                echo 'Running tests...'
                bat "npm run test -- --cucumberOpts.tagExpression=\"@${params.TAG}\""
            }
        }
    }

    post {
        always {
            allure includeProperties: false, jdk: '', results: [[path: 'allure-results']]
        }
    }
}

def fetchArtifact(String projName, String fileName) {
    echo ">>> Fetching ${fileName} from ${projName}..."
    copyArtifacts(
        projectName: projName,
        filter: fileName,
        selector: lastSuccessful(),
        optional: true
    )
    if (fileExists(fileName)) {
        echo ">>> Artifact ${fileName} found. Content:"
        bat "type ${fileName}"
    } else {
        echo ">>> WARNING: ${fileName} not found."
    }
}

def cleanUp(List folders) {
    folders.each { folder ->
        echo ">>> Cleaning up folder: ${folder}"
        bat "if exist ${folder} rmdir /s /q ${folder}"
    }
}