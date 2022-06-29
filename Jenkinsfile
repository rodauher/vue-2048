pipeline {
    agent any
    options {
        ansiColor('xterm')
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    stages {
        stage('Build') {
            steps {
                sh "docker-compose build"
            }
        }
        stage('Scan'){
            steps{
            parallel(
               a:{ sh "trivy image -f json -o results-image.json server-vue:latest"
               recordIssues(tools: [trivy(id:'1' ,pattern: 'results-image.json')])},
               b:{sh "trivy fs --security-checks vuln,secret,config -f json -o results-fs.json ./"
               recordIssues(tools: [trivy(id:'2',pattern: 'results-fs.json')])}
               )
            }
        }
        stage('Publish') {
            steps {
               sshagent(['github-ssh']) {
                   sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
                   sh 'git push --tags'
               }
            }
        }
       stage('DockerHub'){
            steps {
            withCredentials([usernamePassword(credentialsId: 'Vue-2048', passwordVariable: 'PASSWD', usernameVariable: 'USER')]) {
                sh 'echo ${PASSWD} | docker login -u ${USER} --password-stdin'
                sh 'docker tag server-vue ${USER}/prueba-2048:latest'
                sh 'docker tag server-vue ${USER}/prueba-2048:BUILD-1.0.${BUILD_NUMBER}'
                sh 'docker push ${USER}/prueba-2048:latest'
                sh 'docker push ${USER}/prueba-2048:BUILD-1.0.${BUILD_NUMBER}'
            }
            }
       }
    }
}
