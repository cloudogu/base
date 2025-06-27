#!groovy
@Library(['github.com/cloudogu/ces-build-lib@4.2.0', 'github.com/cloudogu/dogu-build-lib@v3.2.0'])
import com.cloudogu.ces.cesbuildlib.*
import com.cloudogu.ces.dogubuildlib.*

timestamps {
    node('sos') {

        properties([
                // Keep only the last x builds to preserve space
                buildDiscarder(logRotator(numToKeepStr: '10')),
                // Don't run concurrent builds for a branch, because they use the same workspace directory
                disableConcurrentBuilds(),
                parameters([
                        booleanParam(name: 'PublishRelease', description: 'Publish a RELEASE image to the registry.', defaultValue: false),
                        booleanParam(name: 'PublishPrerelease', description: 'Publish a prerelease image to the registry.', defaultValue: false),
                        choice(name: 'TrivySeverityLevels', choices: [TrivySeverityLevel.CRITICAL, TrivySeverityLevel.HIGH_AND_ABOVE, TrivySeverityLevel.MEDIUM_AND_ABOVE, TrivySeverityLevel.ALL], description: 'The levels to scan with trivy', defaultValue: TrivySeverityLevel.CRITICAL),
                        choice(name: 'TrivyStrategy', choices: [TrivyScanStrategy.UNSTABLE, TrivyScanStrategy.FAIL, TrivyScanStrategy.IGNORE], description: 'Define whether the build should be unstable, fail or whether the error should be ignored if any vulnerability was found.', defaultValue: TrivyScanStrategy.UNSTABLE),
                ])
        ])

        Git git = new Git(this, "cesmarvin")
        GitHub github = new GitHub(this, git)
        Changelog changelog = new Changelog(this)

        stage('Checkout') {
            checkout scm
        }

        final String alpineVersion = sh(returnStdout: true, script: 'awk -F\'=\' \'/^ALPINE_VERSION=/{gsub(/"/, "", $2); print $2}\' Makefile').trim()
        final String changeCounter = sh(returnStdout: true, script: 'awk -F\'=\' \'/^CHANGE_COUNTER=/{gsub(/"/, "", $2); print $2}\' Makefile').trim()

        final String imageName = sh(returnStdout: true, script: 'awk -F\'=\' \'/^IMAGE_NAME=/{gsub(/"/, "", $2); print $2}\' Makefile').trim()
        final String imageVersion = "${alpineVersion}-${changeCounter}"

        stage('Download doguctl') {
            final String doguctlPath = "packages/doguctl.tar.gz"
            final String doguctlVersion = sh(returnStdout: true, script: 'awk -F\'=\' \'/^DOGUCTL_VERSION=/{gsub(/"/, "", $2); print $2}\' Makefile').trim()
            final String doguctlSha = sh(returnStdout: true, script: 'awk -F\'=\' \'/^DOGUCTL_VER_SHA=/{gsub(/"/, "", $2); print $2}\' Makefile').trim()
            withCredentials([string(credentialsId: 'github-pat-doguctl', variable: 'GITHUB_PAT')]) {
                fileDownloadOperation(
                        url: "https://github.com/cloudogu/doguctl/releases/download/v${doguctlVersion}/doguctl-${doguctlVersion}.tar.gz",
                        targetLocation: 'packages/'
                )
                sh """
                set -eu
                mv "packages/doguctl-${doguctlVersion}.tar.gz" "${doguctlPath}"
                file "${doguctlPath}"
                echo "${doguctlSha}" "${doguctlPath}" | sha256sum -c -
            """
            }
        }

        stage('Lint') {
            lintDockerfile()
            final String scriptFiles = sh(returnStdout: true, script: "find resources -iname '*.sh' | xargs").trim()
            shellCheck(scriptFiles)
        }

        stage('Build') {
            sh "make build"
        }

        stage('Test') {
            sh "make unit-test-shell-local"
        }

        stage('Trivy scan') {
            Trivy trivy = new Trivy(this)
            trivy.scanImage("${imageName}:${imageVersion}", params.TrivySeverityLevels, params.TrivyStrategy)
            trivy.saveFormattedTrivyReport(TrivyScanFormat.TABLE)
            trivy.saveFormattedTrivyReport(TrivyScanFormat.JSON)
            trivy.saveFormattedTrivyReport(TrivyScanFormat.HTML)
        }

        if (params.PublishPrerelease) {
            stage('Publish prerelease') {
                withCredentials([[$class          : 'UsernamePasswordMultiBinding',
                                  credentialsId   : "harborrobotprerelease",
                                  usernameVariable: 'TOKEN_ID',
                                  passwordVariable: 'TOKEN_SECRET']]) {
                    sh "docker login -u ${escapeToken(env.TOKEN_ID)} -p ${escapeToken(env.TOKEN_SECRET)} registry.cloudogu.com"
                    sh "make deploy-prerelease"
                }
            }
        }

        if (params.PublishRelease) {
            final String currentTag = sh(returnStdout: true, script: "git tag --points-at HEAD").trim()
            stage('Validate tag') {
                if (!currentTag.matches("^v\\d\\.\\d\\.\\d.*")) {
                    error("Tag in unknown format: ${currentTag}")
                }
            }
            stage('Publish release') {
                println("Publishing release at tag: ${currentTag}")
                withCredentials([[$class          : 'UsernamePasswordMultiBinding',
                                  credentialsId   : "cesmarvin-setup",
                                  usernameVariable: 'TOKEN_ID',
                                  passwordVariable: 'TOKEN_SECRET']]) {
                    sh "docker login -u ${escapeToken(env.TOKEN_ID)} -p ${escapeToken(env.TOKEN_SECRET)} registry.cloudogu.com"
                    sh "make deploy"
                }
                github.createReleaseWithChangelog(imageVersion, changelog)
            }
        }

    }
}

static def escapeToken(String token) {
    token = token.replaceAll("\\\$", '\\\\\\\$')
    return token
}
