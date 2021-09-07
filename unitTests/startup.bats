#!/usr/bin/env bash
# Bind an unbound BATS variable that fails all tests when combined with 'set -o nounset'
export BATS_TEST_START_TIME="0"

load '/workspace/target/bats_libs/bats-support/load.bash'
load '/workspace/target/bats_libs/bats-assert/load.bash'
load '/workspace/target/bats_libs/bats-mock/load.bash'

setup() {
  export STARTUP_DIR=/workspace/

  # bats-mock/mock_create needs to be injected into the path so the production code will find the mock
  doguctl="$(mock_create)"
  export doguctl
  export PATH="${PATH}:${BATS_TMPDIR}"
  ln -s "${doguctl}" "${BATS_TMPDIR}/doguctl"
}

teardown() {
  rm "${BATS_TMPDIR}/doguctl"
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

