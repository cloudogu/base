#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

ADDITIONAL_CERTIFICATES_DIR_KEY="certificate/additional"
ADDITIONAL_CERTIFICATES_TOC="${ADDITIONAL_CERTIFICATES_DIR_KEY}/toc"

function run_main() {
  DIRECTORY="/etc/ssl"
  STORE="${1:-$DIRECTORY/ca-certificates.crt}"

  # create ssl directory
  if [ ! -d "$DIRECTORY" ]; then
    mkdir "$DIRECTORY"
  fi

  CERTIFICATE="$(mktemp)"
  additionalCertificatesFile=$(mktemp)

  doguctl config --global certificate/server.crt > "${CERTIFICATE}"

  createAdditionalCertificates "${additionalCertificatesFile}"

  cat /etc/ssl/certs/ca-certificates.crt "${CERTIFICATE}" "${ADDITIONAL_CERTIFICATES}" > "${STORE}"

  # cleanup temp files
  rm -f "${CERTIFICATE}"
  rm -f "${additionalCertificatesFile}"
}

function createAdditionalCertificates() {
  additionalCertificatesFile="${1}"

  if [[ ! existAdditionalCertificates ]]; then
    return
  fi

  local additionalCertTOC
  additionalCertTOC="$(doguctl config --global "${ADDITIONAL_CERTIFICATES_TOC}")"

  for certAlias in "${additionalCertTOC}" ; do
    local cert
    cert="$(doguctl config --global "${ADDITIONAL_CERTIFICATES_DIR_KEY}/${certAlias}")"
    echo cert >> additionalCertificatesFile
  done
}

function existAdditionalCertificates() {
  additionalCertTOC="$(doguctl config --global "${ADDITIONAL_CERTIFICATES_TOC}")"

  # test empty string pattern substitution, see https://unix.stackexchange.com/a/146945/440116
  if [[ -z "${additionalCertTOC// }" ]] ; then
    return 1
  fi

  echo huhu
  return 0
}

function addAdditionalCertificatesToFile() {
  local certFile="${1}"
}

# make the script only run when executed, not when sourced from bats tests)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_main
fi