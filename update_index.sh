#!/usr/bin/env bash

readonly workdir=$(dirname $(readlink -f "$0"))
readonly index_dir=${BAD_MIRROR_INDEX:-"${workdir}/crates.io-index"}
readonly upstream=${BAD_MIRROR_UPSTREAM:-"https://github.com/rust-lang/crates.io-index.git"};
readonly origin=${BAD_MIRROR_ORIGIN};
readonly download=${BAD_MIRROR_HOST};

set -ex

if [[ -d ${HOME}/.ssh ]]; then 
    chmod 700 ${HOME}/.ssh;
fi

if [[ -f ${HOME}/.ssh/id_rsa ]]; then
    chmod 600 ${HOME}/.ssh/id_rsa;
fi

if [[ -z "${origin}" ]]; then
    echo "ERROR: no env BAD_MIRROR_ORIGIN found";
    exit 1
fi

if [[ -z "${download}" ]]; then
    echo "ERROR: no env BAD_MIRROR_HOST found";
    exit 1
fi

if [[ ! -d "${index_dir}/.git" ]]; then
    git clone --origin upstream ${upstream} ${index_dir};

    pushd ${index_dir};

    git remote add origin ${origin};
    git fetch origin;

    echo "{\"dl\":\"https://${download}/crates/{crate}/{crate}-{version}.crate\"}" > config.json
    git config --local user.email "DCjanus@dcjanus.com"
    git config --local user.name "DCjanus"
    git commit --all --message "set download url"

    popd
fi

pushd ${index_dir}
while [[ 1 ]]; do
    git fetch upstream -q;
    git rebase upstream/master master -q;
    echo "updated from upstream";

    git push origin master -f -q;
    echo "updated to origin";

    sleep 300;
    echo ""
done
popd