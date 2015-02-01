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
      && sudo cp "${TMP}/git-export.sh" /usr/local/bin/git-export

## Examples

### Repository from working directory

    git-export dd7a2464813725f24cbd1b09cde629a9213d34f8:HEAD ~/exported_files

### Repository from directory

    git-export ~/files_under_version_control dd7a2464813725f24cbd1b09cde629a9213d34f8:403a6cb0e10c9438596def1d926606864b147d15 ~/exported_files

### Repository from URL

    git-export http://git.simpledrupalcloud.com/simpledrupalcloud/dev.git dd7a2464813725f24cbd1b09cde629a9213d34f8:master ~/exported_files

## License

**MIT**
