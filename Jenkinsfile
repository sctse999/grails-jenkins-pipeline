node {
    def app;
    def pwd = pwd()
    String commit_id;

    String env = "staging";
    String tagName;
    String imageName = "grails-jenkins-pipeline";
    String serviceName = "gjp"

    stage('Checkout') {
        checkout scm
        sh "git rev-parse HEAD > .git/commit-id"
        commit_id = readFile('.git/commit-id').trim().take(7)
        tagName = "${commit_id}-${env}"
    }

    stage('Test app') {
        docker.image('proactivehk/grails-docker:3.2.7').inside("-v $pwd:/app") { c ->
            sh 'grails test-app'

        }
    }

    stage('Build app') {
        docker.image('proactivehk/grails-docker:3.2.7').inside("-v $pwd:/app") { c ->
            sh 'grails war'
        }
    }

    stage('Build image') {
        app = docker.build "proactivehk/${imageName}:${tagName}"
    }

    stage('Publish image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker_hub') {
            app.push "${tagName}"
            app.push "latest-${env}"
        }
    }

    stage('Deploy') {
        sh "docker service update --image proactivehk/${imageName}:${tagName} ${serviceName}"
    }


}
