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
