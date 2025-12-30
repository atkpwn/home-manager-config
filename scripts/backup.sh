pushd ~
tar --create --file - \
    Books \
    Documents \
    Downloads \
    orgfiles \
    Pictures \
    problems \
    projects \
    .config/emacs \
    .config/home-manager \
    .config/zsh/history \
    .ssh \
    | pv -ab | zstd -T0 -c > "$(date '+%Y-%m-%d')-backup.tar.zst"
popd
