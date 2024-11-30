pushd ~
tar --create --file - \
    Books \
    Documents \
    Downloads \
    orgfiles \
    roam \
    Pictures \
    problems \
    projects \
    .config/emacs \
    .config/home-manager \
    .config/zsh/zsh_history \
    .ssh \
    | pv -ab | zstd -T0 -c > "$(date '+%Y-%m-%d')-backup.tar.zst"
popd
