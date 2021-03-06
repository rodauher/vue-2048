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
    stage('Scan') {
      when { expression { false } }
      steps {
        parallel(
          a: {
            sh "trivy image -f json -o results-image.json server-vue:latest"
            recordIssues(tools: [trivy(id: '1', pattern: 'results-image.json')])
          },
          b: {
            sh "trivy fs --security-checks vuln,secret,config -f json -o results-fs.json ./"
            recordIssues(tools: [trivy(id: '2', pattern: 'results-fs.json')])
          }
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
    stage('DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'Vue-2048', passwordVariable: 'PASSWD', usernameVariable: 'USER')]) {
          //sh 'echo ${PASSWD} | docker login ghcr.io -u ${USER} --password-stdin'
          //sh 'docker tag rodauher/prueba-2048:latest ${USER}/prueba-2048:BUILD-1.0.${BUILD_NUMBER}'
          //sh 'docker push ${USER}/prueba-2048:latest'
        }
        withCredentials([usernamePassword(credentialsId: 'DockerGHCR', passwordVariable: 'PASSWD', usernameVariable: 'USER')]) {
          sh 'echo ${PASSWD} | docker login ghcr.io -u rodauher --password-stdin'
          sh 'docker tag ${USER}/prueba-2048:latest ghcr.io/${USER}/prueba-2048:latest'
          sh 'docker tag ${USER}/prueba-2048:latest ghcr.io/${USER}/prueba-2048:BUILD-1.0.${BUILD_NUMBER}'
          sh 'docker push ghcr.io/${USER}/prueba-2048:latest'
          sh 'docker push ghcr.io/${USER}/prueba-2048:BUILD-1.0.${BUILD_NUMBER}'
        }
      }
    }
//    stage('Terraform') {
//      steps {
//        withAWS(credentials: 'Administrator-AWS', endpointUrl: 'https://306654547360.signin.aws.amazon.com/console', region: 'eu-west-1') {
//          sh 'terraform -chdir=terraform/ init'
//          sh 'terraform -chdir=terraform/ apply -input=false -auto-approve'
//        }
//      }
//    }
//    stage('Ansible') {
//      steps {
//        withAWS(credentials: 'Administrator-AWS', endpointUrl: 'https://306654547360.signin.aws.amazon.com/console', region: 'eu-west-1') {
//          ansiblePlaybook credentialsId: 'SSH-EC2', disableHostKeyChecking: true, inventory: 'ansible/aws_ec2.yml', playbook: 'ansible/aws-ec2-plugin.yml', colorized: true
//        }
//      }
//    }
    stage('Minikube') {
      steps {
        withKubeConfig(caCertificate: '', clusterName: 'minikube', contextName: '', credentialsId: 'Minikube-cert', namespace: 'default', serverUrl: 'https://192.168.49.2:8443') {
          sh 'kubectl apply -f vue2048.yaml'
          sh 'kubectl get nodes'
          sh 'kubectl get services'
        }
      }
    }
  }
}

