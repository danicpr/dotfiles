# ==========================================
# FASTFETCH GIF MANAGER (ZSH NATIVE)
# ==========================================
_FF_GIF_DIR="$HOME/Pictures/gifs_fetch"
_FF_PNG_DIR="$HOME/Pictures/pngs_fetch"
_FF_DB_FILE="$HOME/Pictures/ff_database.txt"
_FF_CONFIG="$HOME/.config/fastfetch/config.jsonc"

# ------------------------------------------
# 0. DETECCIÓN DE TERMINAL
# ------------------------------------------
_ff_detect_term() {
    if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
        echo "ghostty"
    elif [[ -n "$KITTY_PID" || -n "$KITTY_WINDOW_ID" ]]; then
        echo "kitty"
    else
        echo "other"
    fi
}

# ------------------------------------------
# 1. PARSER DE PROPIEDADES
# ------------------------------------------
_ff_parse_props() {
    local props="${1-}"
    local token key value
    local ff_w=25 ff_h=15 ff_pt=0 ff_pr=0 ff_pb=0 ff_pl=0
    local -a tokens
    tokens=()

    if [[ -n "$props" ]]; then
        read -rA tokens <<< "$props"
    fi

    for token in "${tokens[@]}"; do
        key="${token%%=*}"
        value="${token#*=}"
        case "$key" in
            W|H|PT|PR|PB|PL) ;;
            *) return 2 ;;
        esac
        if [[ ! "$value" =~ '^[0-9]+$' ]]; then
            return 2
        fi
        case "$key" in
            W) ff_w="$value" ;;
            H) ff_h="$value" ;;
            PT) ff_pt="$value" ;;
            PR) ff_pr="$value" ;;
            PB) ff_pb="$value" ;;
            PL) ff_pl="$value" ;;
        esac
    done

    FF_W="$ff_w"
    FF_H="$ff_h"
    FF_PT="$ff_pt"
    FF_PR="$ff_pr"
    FF_PB="$ff_pb"
    FF_PL="$ff_pl"
    return 0
}

# ------------------------------------------
# 2. FUNCIÓN PRINCIPAL
# ------------------------------------------
ff() {
    local W H PT PR PB PL
    local target_media="" filename="" term=$(_ff_detect_term)
    local media_dir ext props="" line_num props_line
    local temp_config ff_status logo_type

    if [[ "$term" == "ghostty" ]]; then
        media_dir="$_FF_PNG_DIR"
        ext="png"
    else
        media_dir="$_FF_GIF_DIR"
        ext="gif"
    fi

    # Selección del archivo dentro del pool de la terminal.
    if [[ -n "${1-}" ]]; then
        if [[ -f "$media_dir/$1" ]]; then
            target_media="$media_dir/$1"
        else
            echo "Error: '$1' no existe en $media_dir" >&2
            return 1
        fi
    else
        local -a files
        files=("$media_dir"/*.${ext}(N))
        if (( ${#files} == 0 )); then
            echo "Error: $media_dir está vacío o no contiene .$ext" >&2
            return 1
        fi
        target_media="${files[RANDOM % ${#files} + 1]}"
    fi
    filename="${target_media##*/}"

    # Las propiedades se leen sin ejecutar contenido de la base.
    if [[ -f "$_FF_DB_FILE" ]]; then
        line_num=$(grep -Fnm 1 -- "$filename" "$_FF_DB_FILE" | cut -d: -f1)
        if [[ -n "$line_num" ]]; then
            props_line=$((line_num + 1))
            props=$(sed "${props_line}q;d" "$_FF_DB_FILE")
        fi
    fi
    if ! _ff_parse_props "$props"; then
        echo "Error: propiedades inválidas para '$filename'" >&2
        return 2
    fi

    if [[ ! -f "$_FF_CONFIG" ]]; then
        echo "Error: no existe $_FF_CONFIG" >&2
        return 1
    fi
    temp_config=$(mktemp "${TMPDIR:-/tmp}/fastfetch-config.XXXXXX") || return 1
    trap 'rm -f -- "$temp_config"' EXIT
    if ! cp -- "$_FF_CONFIG" "$temp_config"; then
        rm -f -- "$temp_config"
        trap - EXIT
        return 1
    fi

    if [[ "$term" == "ghostty" ]]; then
        logo_type="kitty-direct"
    else
        logo_type="kitty-icat"
    fi
    if ! sed -i -E \
        -e "s|\"type\"[[:space:]]*:[[:space:]]*\"[^\"]*\"|\"type\": \"$logo_type\"|" \
        -e "s|\"source\"[[:space:]]*:[[:space:]]*\"[^\"]*\"|\"source\": \"$target_media\"|" \
        -e "s|\"width\"[[:space:]]*:[[:space:]]*[0-9]+|\"width\": $FF_W|" \
        -e "s|\"height\"[[:space:]]*:[[:space:]]*[0-9]+|\"height\": $FF_H|" \
        -e "s|\"top\"[[:space:]]*:[[:space:]]*[0-9]+|\"top\": $FF_PT|" \
        -e "s|\"right\"[[:space:]]*:[[:space:]]*[0-9]+|\"right\": $FF_PR|" \
        -e "s|\"bottom\"[[:space:]]*:[[:space:]]*[0-9]+|\"bottom\": $FF_PB|" \
        -e "s|\"left\"[[:space:]]*:[[:space:]]*[0-9]+|\"left\": $FF_PL|" \
        "$temp_config"; then
        rm -f -- "$temp_config"
        trap - EXIT
        return 1
    fi

    fastfetch --config "$temp_config"
    ff_status=$?
    rm -f -- "$temp_config"
    trap - EXIT
    return "$ff_status"
}

# ------------------------------------------
# 3. CONFIG SETTER
# ------------------------------------------
ff-set() {
    local name="${1-}"
    local props="${2-}"
    local line_num

    if [[ -z "$name" || -z "$props" ]]; then
        echo 'Uso: ff-set archivo.gif "W=30 PT=5"' >&2
        return 1
    fi
    if ! _ff_parse_props "$props"; then
        echo "Error: propiedades inválidas: $props" >&2
        return 2
    fi

    if [[ -f "$_FF_DB_FILE" ]]; then
        line_num=$(grep -Fnm 1 -- "$name" "$_FF_DB_FILE" | cut -d: -f1)
        if [[ -n "$line_num" ]]; then
            sed -i "${line_num},$((line_num + 1))d" "$_FF_DB_FILE"
        fi
    fi
    print -r -- "$name" >> "$_FF_DB_FILE"
    print -r -- "$props" >> "$_FF_DB_FILE"
    ff "$name"
}

# ------------------------------------------
# 4. UTILIDADES Y AUTOCOMPLETADO
# ------------------------------------------
alias ff-db="nvim $_FF_DB_FILE"

_ff_completions() {
    local term=$(_ff_detect_term)
    if [[ "$term" == "ghostty" ]]; then
        _path_files -W "$_FF_PNG_DIR" -g "*.png"
    else
        _path_files -W "$_FF_GIF_DIR" -g "*.gif"
    fi
}

if (( $+functions[compdef] )); then
    compdef _ff_completions ff
    compdef _ff_completions ff-set
fi
