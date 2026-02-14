files=".vimrc .bashrc .tmux.conf .gitconfig"
for f in $files ; do
    fullpath="$HOME/$f"
    rm -f $fullpath
    nodot=$(echo $f | sed 's/^\.//')
    ln -s "$PWD/$nodot" $fullpath
done

# claude code config
mkdir -p ~/.claude
rm -f ~/.claude/settings.json
ln -s "$PWD/claude/settings.json" ~/.claude/settings.json
rm -f ~/.claude/commands
ln -s "$PWD/claude/commands" ~/.claude/commands

mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/autoload

# first get pathogen, then each of the plugins we want
echo 'Ensuring pathogen is up to date ...'
curl -Sso ~/.vim/autoload/pathogen.vim 'https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim' || (echo "failed" && exit)
pushd ~/.vim/bundle &>/dev/null
if [ ! -d ag ] ; then
    echo 'Installing ag ...'
    git clone https://github.com/rking/ag.vim ag
    echo ''
fi
if [ ! -d fugitive ] ; then
    echo 'Installing fugitive ...'
    git clone https://github.com/tpope/vim-fugitive.git fugitive
    echo ''
fi
if [ ! -d ctrlp ] ; then
    echo 'Installing ctrlp ...'
    git clone https://github.com/kien/ctrlp.vim.git ctrlp
    echo ''
fi
popd &>/dev/null
