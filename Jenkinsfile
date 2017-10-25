node {
    def app;
    def pwd = pwd()
    String commit_id;

    String env = "staging";
    String tagName;
    String imageName = "grails-jenkins-pipeline";
    String serviceName = "gjp2_app"

    stage('Checkout') {
        checkout scm
        sh "git rev-parse HEAD > .git/commit-id"
        commit_id = readFile('.git/commit-id').trim().take(7)
        tagName = "${commit_id}-${env}"
    }

    stage('Test app') {
        sh "./gradlew --stop"

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
        sh "docker build --build-arg COMMIT_ID=${commit_id} -t proactivehk/${imageName}:${tagName} ."
        app = docker.image("proactivehk/${imageName}:${tagName}");
    }

    stage('Publish image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker_hub') {
            app.push "${tagName}"
            app.push "latest"
        }
    }

    stage('Deploy') {
        sh "docker service update --image proactivehk/${imageName}:${tagName} ${serviceName}"
    }
}
