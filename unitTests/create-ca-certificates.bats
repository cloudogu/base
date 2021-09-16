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
  mock_set_output "${doguctl}" "\n" 1

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run existAdditionalCertificates

  assert_failure
  assert_equal "$(mock_get_call_num "${doguctl}")" "1"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --default NV --global certificate/additional/toc"
}

@test "existAdditionalCertificates() should return true for set etcd key" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "alias1 alias2\n" 1

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run existAdditionalCertificates

  assert_success
  assert_equal "$(mock_get_call_num "${doguctl}")" "1"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --default NV --global certificate/additional/toc"
}

@test "createAdditionalCertificates() should concat etcd values into a given file" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "alias1 alias2\n" 1
  mock_set_output "${doguctl}" "alias1 alias2\n" 2
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nCERT FOR CONTENT1\n-----END CERTIFICATE-----\n" 3
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nCERT FOR CONTENT2\n-----END CERTIFICATE-----\n" 4

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run createAdditionalCertificates "${tempCertFile}"

  assert_line "Adding additional certificates from global config..."
  assert_exist "${tempCertFile}"
  assert_file_not_empty "${tempCertFile}"
  assert_file_contains "${tempCertFile}" "CERT FOR CONTENT1"
  assert_file_contains "${tempCertFile}" "CERT FOR CONTENT2"
  assert_equal "$(mock_get_call_num "${doguctl}")" "4"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --default NV --global certificate/additional/toc"
  assert_equal "$(mock_get_call_args "${doguctl}" "2")" "config --global certificate/additional/toc"
  assert_equal "$(mock_get_call_args "${doguctl}" "3")" "config --global certificate/additional/alias1"
  assert_equal "$(mock_get_call_args "${doguctl}" "4")" "config --global certificate/additional/alias2"
}

@test "createAdditionalCertificates() should not concat etcd values into a given file" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" ""

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run createAdditionalCertificates "${tempCertFile}"

  assert_file_empty "${tempCertFile}"
  assert_equal "$(mock_get_call_num "${doguctl}")" "1"
  assert_equal "$(mock_get_call_args "${doguctl}" "0")" "config --default NV --global certificate/additional/toc"
}

@test "run_main() should create custom certificate store from base and additional certificates" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nHELLO BASE CERTIFICATE\n-----END CERTIFICATE-----\n" 1
  mock_set_output "${doguctl}" "alias1 alias2\n" 2
  mock_set_output "${doguctl}" "alias1 alias2\n" 3
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nCERT FOR CONTENT1\n-----END CERTIFICATE-----\n" 4
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nCERT FOR CONTENT2\n-----END CERTIFICATE-----\n" 5

  source /workspace/resources/usr/bin/create-ca-certificates.sh
  export DEFAULT_ROOT_CERTIFICATES=/workspace/unitTests/etc/ssl/ca-certificates.crt

  run run_main "${tempCertFile}"

  assert_exist "${tempCertFile}"
  assert_file_not_empty "${tempCertFile}"
  assert_file_contains "${tempCertFile}" "HELLO ROOT CERTIFICATE"
  assert_file_contains "${tempCertFile}" "HELLO BASE CERTIFICATE"
  assert_file_contains "${tempCertFile}" "CERT FOR CONTENT1"
  assert_file_contains "${tempCertFile}" "CERT FOR CONTENT2"
  assert_equal "$(mock_get_call_num "${doguctl}")" "5"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --global certificate/server.crt"
  assert_equal "$(mock_get_call_args "${doguctl}" "2")" "config --default NV --global certificate/additional/toc"
  assert_equal "$(mock_get_call_args "${doguctl}" "3")" "config --global certificate/additional/toc"
  assert_equal "$(mock_get_call_args "${doguctl}" "4")" "config --global certificate/additional/alias1"
  assert_equal "$(mock_get_call_args "${doguctl}" "5")" "config --global certificate/additional/alias2"
}

@test "run_main() should create default certificate store from root, base, and additional certificates" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nHELLO BASE CERTIFICATE\n-----END CERTIFICATE-----\n" 1
  mock_set_output "${doguctl}" "alias1 alias2\n" 2
  mock_set_output "${doguctl}" "alias1 alias2\n" 3
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nCERT FOR CONTENT1\n-----END CERTIFICATE-----\n" 4
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nCERT FOR CONTENT2\n-----END CERTIFICATE-----\n" 5

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run run_main

  assert_exist "/etc/ssl/ca-certificates.crt"
  assert_file_not_empty "/etc/ssl/ca-certificates.crt"
  cat "/etc/ssl/ca-certificates.crt"
  # workaround because assert_file_not_contains is no longer supported
  local result=0
  grep -v "HELLO ROOT CERTIFICATE" "/etc/ssl/ca-certificates.crt" || result=$?
  assert_equal "$result" "0"
  local numberOfCertificates
  numberOfCertificates="$(grep -c "BEGIN CERTIFICATE" /etc/ssl/ca-certificates.crt)"
  [ ${numberOfCertificates} -gt 10 ]
  assert_file_contains "/etc/ssl/ca-certificates.crt" "HELLO BASE CERTIFICATE"
  assert_file_contains "/etc/ssl/ca-certificates.crt" "CERT FOR CONTENT1"
  assert_file_contains "/etc/ssl/ca-certificates.crt" "CERT FOR CONTENT2"
  assert_equal "$(mock_get_call_num "${doguctl}")" "5"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --global certificate/server.crt"
  assert_equal "$(mock_get_call_args "${doguctl}" "2")" "config --default NV --global certificate/additional/toc"
  assert_equal "$(mock_get_call_args "${doguctl}" "3")" "config --global certificate/additional/toc"
  assert_equal "$(mock_get_call_args "${doguctl}" "4")" "config --global certificate/additional/alias1"
  assert_equal "$(mock_get_call_args "${doguctl}" "5")" "config --global certificate/additional/alias2"
}

@test "run_main() should create default certificate store from root, base but without additional certificates" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nHELLO BASE CERTIFICATE\n-----END CERTIFICATE-----\n" 1
  mock_set_output "${doguctl}" "" 2

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run run_main

  assert_exist "/etc/ssl/ca-certificates.crt"
  assert_file_not_empty "/etc/ssl/ca-certificates.crt"
  cat "/etc/ssl/ca-certificates.crt"
  # workaround because assert_file_not_contains is no longer supported
  local result=0
  grep -v "HELLO ROOT CERTIFICATE" "/etc/ssl/ca-certificates.crt" || result=$?
  assert_equal "$result" "0"
  local numberOfCertificates
  numberOfCertificates="$(grep -c "BEGIN CERTIFICATE" /etc/ssl/ca-certificates.crt)"
  [ ${numberOfCertificates} -gt 10 ]
  assert_file_contains "/etc/ssl/ca-certificates.crt" "HELLO BASE CERTIFICATE"
  assert_equal "$(mock_get_call_num "${doguctl}")" "2"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --global certificate/server.crt"
  assert_equal "$(mock_get_call_args "${doguctl}" "2")" "config --default NV --global certificate/additional/toc"
}

@test "run_main() should create custom certificate store from root, base but without additional certificates" {
  mock_set_status "${doguctl}" 0
  mock_set_output "${doguctl}" "-----BEGIN CERTIFICATE-----\nHELLO BASE CERTIFICATE\n-----END CERTIFICATE-----\n" 1
  mock_set_output "${doguctl}" "" 2

  source /workspace/resources/usr/bin/create-ca-certificates.sh

  run run_main "${tempCertFile}"

  assert_exist "${tempCertFile}"
  assert_file_not_empty "${tempCertFile}"
  cat "${tempCertFile}"
  # workaround because assert_file_not_contains is no longer supported
  local result=0
  grep -v "HELLO ROOT CERTIFICATE" "${tempCertFile}" || result=$?
  assert_equal "$result" "0"
  result=0
  grep -v "HELLO CONTENT1 CERTIFICATE" "${tempCertFile}" || result=$?
  assert_equal "$result" "0"
  local numberOfCertificates
  numberOfCertificates="$(grep -c "BEGIN CERTIFICATE" /etc/ssl/ca-certificates.crt)"
  [ ${numberOfCertificates} -gt 10 ]
  assert_file_contains "${tempCertFile}" "HELLO BASE CERTIFICATE"
  assert_equal "$(mock_get_call_num "${doguctl}")" "2"
  assert_equal "$(mock_get_call_args "${doguctl}" "1")" "config --global certificate/server.crt"
  assert_equal "$(mock_get_call_args "${doguctl}" "2")" "config --default NV --global certificate/additional/toc"
}
