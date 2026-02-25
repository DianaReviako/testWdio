pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'master', description: 'Branch for tests')
        string(name: 'TAG', defaultValue: 'herokuapp', description: 'Cucumber tags')
        string(name: 'USERNAME', defaultValue: 'Test User Panda', description: 'text for step I print to console user name')
        string(name: 'TEST_FILE_NAME', defaultValue: 'myTest.txt', description: 'for step print file content')
    }

    environment {
        CURRENT_USER = "${params.USERNAME}"
        BASE_URL = "https://the-internet.herokuapp.com"
    }

    tools { allure 'allureReport' }

    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timestamps()
    }

    triggers {
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
                    fetchArtifact('secondHerokuapp', "${params.TEST_FILE_NAME}")
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

        stage('Change env variable') {
            steps {
                withEnv(["TEST_USER=${env.CURRENT_USER}"]) {
                    echo "Inside withEnv block: TEST_USER is ${TEST_USER}"
                }
            }
        }
    }

    post {
        always {
            allure includeProperties: false, jdk: '', results: [[path: 'allure-results']]
        }

        success {
            script {
                def emailBody = readFile('email-template.html')
                
                emailext to: 'eschoodzin@gmail.com',
                    subject: "✅ Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: emailBody,
                    mimeType: 'text/html'
            }
        }

        failure {
            script {
            mail to: 'eschoodzin@gmail.com',
                 subject: "❌ Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: """Bummer, the build crashed.
                 
            Check the errors here: ${env.BUILD_URL}console

            Parameters:
            - Branch: ${params.BRANCH}
            - Tag: ${params.TAG}
            """
            }
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
    if (fileName && fileExists(fileName)) {
        echo ">>> Artifact ${fileName} found. Content:"
        bat "type ${fileName}"
    } else {
        echo ">>> WARNING: FileName is empty or file not found."
    }
}

def cleanUp(List folders) {
    folders.each { folder ->
        echo ">>> Cleaning up folder: ${folder}"
        bat "if exist ${folder} rmdir /s /q ${folder}"
    }
}