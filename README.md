git-export
==========

Exports only modified or newly added files between two revisions from the GIT repository.

Usage
-----

    git-export [REPOSITORY] <REVISION_FROM:REVISION_TO> <TARGET>

Install
-------

    TMP="$(mktemp -d)" \
      && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/git-export.git "${TMP}" \
      && sudo cp "${TMP}/git-export.sh" /usr/local/bin/git-export \
      && sudo chmod +x /usr/local/bin/git-export

## How to use

### Repository from working directory

    git-export dd7a2464:HEAD ~/exported_files

### Repository from directory

    git-export ~/files_under_version_control dd7a246:403a6cb ~/exported_files

### Repository from URL

    git-export http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git dd7a246:master ~/exported_files

## License

**MIT**
