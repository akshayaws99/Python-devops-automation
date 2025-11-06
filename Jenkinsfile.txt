
---

### `Jenkinsfile`
```groovy
pipeline {
  agent any

  environment {
    PYTHONUNBUFFERED = '1'
  }

  stages {
    stage('Install deps') {
      steps {
        sh 'python3 -m venv venv || true'
        sh '. venv/bin/activate && pip install -r requirements.txt'
      }
    }
    stage('K8s: Check pods') {
      steps {
        sh '. venv/bin/activate && python3 scripts/k8s/list_pods.py'
      }
    }
    stage('AWS: Cleanup EBS (optional)') {
      steps {
        sh '. venv/bin/activate && python3 scripts/aws/cleanup_ebs.py'
      }
    }
    stage('Notify') {
      steps {
        sh '. venv/bin/activate && python3 scripts/monitoring/send_slack_alert.py "Jenkins pipeline finished"'
      }
    }
  }
  post {
    failure {
      sh '. venv/bin/activate && python3 scripts/monitoring/send_slack_alert.py "Pipeline FAILED"'
    }
  }
}
