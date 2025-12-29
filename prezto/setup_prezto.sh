# 安全のためバックアップを取りつつ prezto をクローンして .zpreztorc をリンクし、zsh 再起動
backup="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"; mkdir -p "$backup"
[ -e "$HOME/.zpreztorc" ] && mv "$HOME/.zpreztorc" "$backup/"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
ln -sfn ~/dotfiles/.zpreztorc ~/.zpreztorc
cd "${ZDOTDIR:-$HOME}/.zprezto" && git submodule update --init --recursive || true
exec zsh
