pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'master', description: 'In which branch to run the tests?')
        string(name: 'TAG', defaultValue: 'herokuapp', description: 'What tests are we running?')
    }

    tools {
        allure 'allureReport'
    }

    options {
        skipDefaultCheckout() 
        checkoutToSubdirectory('')
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    // triggers {
        // githubPush()
        // pollSCM('H/2 * * * *')
        // upstream(upstreamProjects: 'secondHerokuapp', threshold: hudson.model.Result.SUCCESS)
        // cron('H/2 * * * *')
    // }

    stages {
        stage('Checkout') {
            steps {
                echo 'Pull code from repo'
                checkout scmGit(
                    branches: [[name: "*/${params.BRANCH}"]], 
                    extensions: [], 
                    userRemoteConfigs: [[credentialsId: 'githubAuthToken', url: 'https://github.com/DianaReviako/testWdio']]
                )
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Install dependencies...'
                bat 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Cleaning old allure results...'
                bat 'if exist allure-results rmdir /s /q allure-results'
                bat 'if exist allure rmdir /s /q allure' 
        
                echo 'Run tests'
                bat "npm run test -- --tags \"@${params.TAG}\""
            }
        }
    }

    post {
        always {
            echo 'Publishing Allure Report...'
            allure includeProperties: false, 
                   jdk: '', 
                   results: [[path: 'allure/allure-results']] 
        }
        success {
            echo 'Hooray! Tests passed successfully.'
        }
        failure {
            echo 'Oops, something went wrong. Check the logs!'
        }
    }
}