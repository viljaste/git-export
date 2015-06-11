#!/usr/bin/env bash

WORKING_DIR="$(pwd)"

hash git 2> /dev/null

if [ "${?}" -ne 0 ]; then
  echo "git-export: git command not found."

  exit 1
fi

help() {
  cat << EOF
git-export: Usage: git-export [SOURCE] <BRANCH> <REVISION_FROM:REVISION_TO> <DESTINATION>
EOF

  exit 1
}

if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  help
fi

unknown_command() {
  echo "git-export: Unknown command. See 'git-export --help'"

  exit 1
}

if [ "${#}" -lt 3 ] || [ "${#}" -gt 4 ]; then
  unknown_command
fi

DESTINATION="${@: -1}"

if [ -d "${DESTINATION}" ]; then
  echo "git-export: Destination directory already exists: ${DESTINATION}"

  exit 1
fi

mkdir -p "${DESTINATION}"

cd "${DESTINATION}"

DESTINATION="$(pwd)"

SOURCE="${WORKING_DIR}"

if [ "${#}" -gt 3 ]; then
  SOURCE="${1}"
fi

TMP="$(mktemp -d)"

git clone "${SOURCE}" "${TMP}" > /dev/null 2>&1

if [ "${?}" -ne 0 ]; then
  echo "git-export: Invalid repository."

  exit 1
fi

SOURCE="${TMP}"

cd "${SOURCE}"

BRANCH="${1}"

if [ "${#}" -gt 3 ]; then
  BRANCH="${2}"
fi

git checkout -f "${BRANCH}"

REVISION="${2}"

if [ "${#}" -gt 3 ]; then
  REVISION="${3}"
fi

REVISION_FROM="$(echo ${REVISION} | cut -d ':' -f1)"
REVISION_TO="$(echo ${REVISION} | cut -d ':' -f2)"

# Since git diff-tree doesn't work properly for the initial commit, we use some clever technique to make it work.
if [[ "$(git rev-list HEAD | tail -n 1)" == ${REVISION_FROM}* ]]; then
  REVISION_TO="${REVISION_FROM}"
  REVISION_FROM="$(git hash-object -t tree /dev/null)"

  RESULTS="$(git diff-tree -r --name-status ${REVISION_FROM} ${REVISION_TO} 2> /dev/null | awk '{ print $1 ":" $2 }')"
else
  RESULTS="$(git diff-tree -r --name-status ${REVISION_FROM}^ ${REVISION_TO} 2> /dev/null | awk '{ print $1 ":" $2 }')"
fi

if [ -z "${RESULTS}" ]; then
  echo "git-export: No results."

  exit 1
fi

echo "$(git rev-parse ${REVISION_TO})" > "${DESTINATION}/REVISION.txt"

DELETED_FILES=""

for LINE in ${RESULTS}; do
  FILE="$(echo ${LINE} | awk -F : '{ st = index($0, ":"); print substr($0, st + 1) }')"
  RELATIVE_PATH="${FILE/${SOURCE}}"

  if [ "$(echo ${LINE} | cut -d ':' -f1)" == "D" ]; then
    DELETED_FILES="${DELETED_FILES}\ngit-export: Deleted file: ${RELATIVE_PATH}"

    continue
  fi

  if [ "${RELATIVE_PATH:0:1}" == "/" ]; then
    RELATIVE_PATH="$(echo ${RELATIVE_PATH} | cut -c 2-)"
  fi

  cd "${DESTINATION}"

  DIRECTORY="$(dirname ${RELATIVE_PATH})"

  if [ ! -d "${DIRECTORY}" ]; then
    mkdir -p "${DIRECTORY}"
  fi

  echo "git-export: Exporting file: ${RELATIVE_PATH}"

  cd "${SOURCE}"

  git show "${REVISION_TO}:${RELATIVE_PATH}" > "${DESTINATION}/${RELATIVE_PATH}"
done

if [ ! -z "${DELETED_FILES}" ]; then
  echo -e "${DELETED_FILES}"
fi

rm -rf "${SOURCE}"

cd "${WORKING_DIR}"
