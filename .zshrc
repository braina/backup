
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
# https://github.com/sorin-ionescu/prezto
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi





# Customize to your needs...

[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

# 環境変数
export LANG=ja_JP.UTF-8

KEYTIMEOUT=1
 
# 色を使用出来るようにする
autoload -Uz colors
colors

#nodebrewのpath
export PATH=$HOME/.nodebrew/current/bin:$PATH

# vim 風キーバインドにする
bindkey -v

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000


## プロンプト指定
PROMPT="
[%n] %{${fg[yellow]}%}%~%{${reset_color}%}
%(?.%{$fg[blue]%}.%{$fg[magenta]%})%(?!(* '◡')!(* ;-;%)) %{${reset_color}%}%{$fg[red]%}❯%{$fg[yellow]%}❯%{$fg[cyan]%}❯ %{${reset_color}%}"
# プロンプト指定(コマンドの続き)
PROMPT2='[%n]> '

# もしかして時のプロンプト指定
setopt CORRECT_ALL
SPROMPT="%{$fg[white]%}%{$suggest%}(*'~'%)? %{$fg[red]%}❯%{$fg[yellow]%}❯%{$fg[cyan]%}❯ Do you mean %{$fg[red]%}%B%r%b %{$fg[white]%}?[Yes, No, Abort, Edit]:${reset_color} "


# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
 
# beep を無効にする
setopt no_beep
 


# エイリアス
 
alias la='ls -a'
alias ll='ls -l'
 
alias rm='rm -i'
alias cp='cp'
alias mv='mv -i'
 
alias mkdir='mkdir -p'
 
# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '
 
# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'
alias -g P='| peco'


alias cal='vim -c Calendar'
alias clock='vim -c Calendar-view=clock'

alias twitter='vim -c TweetVimHomeTimeline' 
alias tweet='vim -c TweetVimSay' 

alias :q='exit' 

alias chrome='open /Applications/Google\ Chrome.app'


# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

alias ctags='/usr/local/Cellar/ctags/5.8_1/bin/ctags'
if [ -f ~/.bashrc ]; then

	. ~/.bashrc

fi
# フローコントロールを無効にする
setopt no_flow_control
 
# Ctrl+Dでzshを終了しない
setopt ignore_eof
 
# '#' 以降をコメントとして扱う
setopt interactive_comments
 
# ディレクトリ名だけでcdする
setopt auto_cd
 
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
 
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
 
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
 
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
 
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
 
# 高機能なワイルドカード展開を使用する
setopt extended_glob


[[ -s /usr/share/autojump/autojump.zsh ]] && . /usr/share/autojump/autojump.zsh
# for homebrew
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh


# peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history




# OS 別の設定
case ${OSTYPE} in
	darwin*)
		#Mac用の設定
		export CLICOLOR=1
		alias ls='ls -G -F'
		;;
	linux*)
		#Linux用の設定
		alias ls='ls -F --color=auto'
		;;
esac



# cdしたらlsする
chpwd() {
	ls_abbrev
}
ls_abbrev() {
	# -a : Do not ignore entries starting with ..
	# -C : Force multi-column output.
	# -F : Append indicator (one of */=>@|) to entries.
	local cmd_ls='ls'
	local -a opt_ls
	opt_ls=('-CF' '--color=always')
	case "${OSTYPE}" in
		freebsd*|darwin*)
			if type gls > /dev/null 2>&1; then
				cmd_ls='gls'
			else
				# -G : Enable colorized output.
				opt_ls=('-aCFG')
			fi
			;;
	esac

	local ls_result
	ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

	local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

	if [ $ls_lines -gt 10 ]; then
		echo "$ls_result" | head -n 5
		echo '...'
		echo "$ls_result" | tail -n 5
		echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
	else
		echo "$ls_result"
	fi
}


