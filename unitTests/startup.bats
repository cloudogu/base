#!/usr/bin/env bash
# Bind an unbound BATS variable that fails all tests when combined with 'set -o nounset'
export BATS_TEST_START_TIME="0"


load '/workspace/target/bats_libs/bats-support/load.bash'
load '/workspace/target/bats_libs/bats-assert/load.bash'
load '/workspace/target/bats_libs/bats-mock/load.bash'
load '/workspace/target/bats_libs/bats-file/load.bash'

setup() {
  export STARTUP_DIR=/workspace/

  # bats-mock/mock_create needs to be injected into the path so the production code will find the mock
  doguctl="$(mock_create)"
  export doguctl
  export PATH="${PATH}:${BATS_TMPDIR}"
  ln -s "${doguctl}" "${BATS_TMPDIR}/doguctl"
  tempCertFile="$(mktemp)"
  export tempCertFile
  BATSLIB_FILE_PATH_REM="#${TEST_TEMP_DIR}"
  BATSLIB_FILE_PATH_ADD='<temp>'
}

teardown() {
  rm "${BATS_TMPDIR}/doguctl"
  rm "${tempCertFile}"
}

@test "existAdditionalCertificates() should return false for unset etcd key" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "\n"

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run existAdditionalCertificates

  assert_failure
  assert_equal "$(mock_get_call_num "${doguctl}")" "1"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --global certificate/additional/toc"
}

@test "existAdditionalCertificates() should return true for set etcd key" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "alias1 alias2\n"

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run existAdditionalCertificates

  assert_success
  assert_equal "$(mock_get_call_num "${doguctl}")" "1"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --global certificate/additional/toc"
}

@test "createAdditionalCertificates() should concat etcd values into a given file" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "alias1 alias2\n" 1
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nCERT FOR CONTENT1\n-----END CERTIFICATE-----\n" 2
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nCERT FOR CONTENT2\n-----END CERTIFICATE-----\n" 3

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run createAdditionalCertificates "${tempCertFile}"

  assert_exist "${tempCertFile}"
  cat "${tempCertFile}"
  assert_file_not_empty "${tempCertFile}"
  assert_file_contains "${tempCertFile}" "CERT FOR CONTENT1"
  assert_file_contains "${tempCertFile}" "CERT FOR CONTENT2"
  assert_equal "$(mock_get_call_num "${doguctl}")" "3"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --global certificate/additional/toc"
  assert_equal "$(mock_get_call_args "${doguctl}" "2")" "config --global certificate/additional/alias1"
  assert_equal "$(mock_get_call_args "${doguctl}" "3")" "config --global certificate/additional/alias2"
}

