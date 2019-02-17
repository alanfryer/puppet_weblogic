def notifyHipChat(String buildStatus = 'STARTED') {
    // Build status of null means success.
    buildStatus = buildStatus ?: 'SUCCESS'

    def color

    if (buildStatus == 'STARTED') {
        color = 'YELLOW'
    } else if (buildStatus == 'SUCCESS') {
        color = 'GREEN'
    } else if (buildStatus == 'UNSTABLE') {
        color = 'RED'
    } else {
        color = 'GREEN'
    }

    def msg = "${buildStatus}: `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n${env.BUILD_URL}"
    //hipchatSend(color: color,  notify: true,  failOnError: true, message: msg, textFormat: true)
    
      emailext (
      subject: "Status: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """<p>${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>""",
        , to: "alanfryer@yahoo.co.uk"
    )
}

def createYaml() {
        def content = """
        ---
        # Generated by Job: ${env.JOB_NAME} : Build No: ${env.BUILD_NUMBER}
        weblogic_base::domain_name:                   '${ENVIRONMENT}-domain'
        weblogic_base::machine_name:                  '${ENVIRONMENT}-machine'
        weblogic_base::weblogic_user:                 'weblogic'
        weblogic_base::weblogic_password:             'welcome2'
        weblogic_base::nodemanager_port:              8556
        weblogic_base::adminserver_listen_port:       8001
        weblogic_base::adminserver_startup_arguments: '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -Djava.security.egd=file:/dev/./urandom'
        """.stripIndent()
        return content
}

def createResp() {
        def content = """
        ---
        # Generated by Job: ${env.JOB_NAME} : Build No: ${env.BUILD_NUMBER}
        MACHINE=
        NODE_MANAGER_USER=
        NODE_MANAGER_PASSWORD=changeme
        MANAGED_SERVER=
        """.stripIndent()
        return content
}

def updateResp() {
    def respFile = readFile(file: "WLS.resp")
    respFile = respFile.replaceAll(".*MACHINE=.*", "MACHINE=${MACHINE}")
    respFile = respFile.replaceAll(".*MANAGED_SERVER=.*", "MANAGED_SERVER=${MANAGED_SERVER}")
    respFile = respFile.replaceAll(".*NODE_MANAGER_USER=.*", "NODE_MANAGER_USER=${NODEMANAGER_USER}")
    respFile = respFile.replaceAll(".*NODE_MANAGER_PASSWORD=.*", "NODE_MANAGER_PASSWORD=${NODEMANAGER_PASSWORD}")
    writeFile(file: "WLS.resp", text: respFile)
}
def updateResp1() {
    sh """
    #!/bin/bash
    mv ${MODULE_PATH}/WLS.resp ${MODULE_PATH}/WLS.bkp
    sed -e 's/.*NODE_MANAGER_USER=.*/NODE_MANAGER_USER=weblogic/' \
    -e 's/.*NODE_MANAGER_PASSWORD=.*/NODE_MANAGER_PASSWORD=password/' \
    -e 's/.*MANAGED_SERVER=.*/MANAGED_SERVER=UKCMKG101/' \
    -e 's/.*MACHINE=.*/MACHINE=machine1/' \
    < ${MODULE_PATH}/WLS.bkp > ${MODULE_PATH}/WLS.resp
    """.stripIndent()
}

podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'git', image: 'alpine/git', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true)
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ]
  ) {
    node('mypod') {
        
        stage('Clone repository') {
            container('git') {
            git branch: 'master', credentialsId: 'github', url: 'https://github.com/alanfryer/puppet_weblogic/'

            yamlContent = createYaml()

            def yamlFile = "${MODULE_PATH}/weblogic_base/data/environments/${ENVIRONMENT}.yaml"
            sh "mkdir -p ${MODULE_PATH}/weblogic_base/data/environments"
            sh "echo '${yamlContent}' > ${yamlFile}"
            
            respContent = createResp()
            sh "echo '${respContent}' > ${MODULE_PATH}/WLS.resp"
            updateResp()
            sh "tar -czvf install_weblogic.tar.gz *"
            }
        }

    }
}

