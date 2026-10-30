#!/usr/bin/env bash

# Limites

range_min=1
range_max=100

# Mensagens do jogo

msg[0]='Você acertou em %s tentativas!'
msg[1]='Mais alto!'
msg[2]='Mais baixo!'
msg[3]='Eu pedi um número!'
msg[4]="Eu disse entre $range_min e $range_max!"

# Prompts

prompt[0]="Digite um número entre $range_min e $range_max: "
prompt[1]='Tecle algo para continuar...'
prompt[2]='Quer jogar novamente (S/n)?'

# Saída
msg_quit='Saindo...'

# Título do jogo
game_title='GuessGame'

# Funções: validação e conferência de dados

is_number() [[ $1 =~ ^-?[0-9]+$ ]]

in_range() [[ $1 -ge $range_min && $1 -le $range_max ]]

is_higher() [[ $1 -gt $secret_target ]]

is_lower() [[ $1 -lt $secret_target ]]

check_guess() {
    is_number $1 || return 3
    in_range $1  || return 4

    is_lower $1  && return 1
    is_higher $1 && return 2
	
    return 0
}

# Função: gerar alvo
get_secret() ((secret_target = RANDOM % (range_max - range_min + 1) + range_min))

# Inicializador
set_game() {
    count=1
    guesses=''
    get_secret
}

guess_update() {
    local r

    case $1 in
	1) r='↑';;
	2) r='↓';;	
	*) r='-';;
    esac	

    guesses+="$count:$guess$r "
    ((count++))

    echo "${msg[$1]}"

    read -sN1 -p "${prompt[1]} " go
}

main() {
    set_game

    while :; do
	clear
	printf '%s\n\n' "$game_title"
	
	[[ "$guesses" ]] && printf '%s\n\n' "$guesses"

	read -e -p "${prompt[0]}" guess

	check_guess "$guess" || { guess_update $?; continue; }
	
	printf "${msg[0]}\n" $count
	printf '\n%s' "${prompt[2]}"

	read -sN1 again

	[[ ${again,} = n ]] && break

	set_game
    done

    printf '\n\n%s\n\n' "$msg_quit"
}

main
