# ==========================================
#  FASTFETCH GIF MANAGER (ZSH NATIVE)
# ==========================================
_FF_GIF_DIR="$HOME/Pictures/gifs_fetch"
_FF_PNG_DIR="$HOME/Pictures/pngs_fetch"
_FF_DB_FILE="$HOME/Pictures/ff_database.txt"
_FF_CONFIG="$HOME/.config/fastfetch/config.jsonc"
_FF_LINK_GIF="$HOME/.config/fastfetch/logo.gif"
_FF_LINK_PNG="$HOME/.config/fastfetch/logo.png"

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
# 1. FUNCIÓN PRINCIPAL (Logic Core)
# ------------------------------------------
ff() {
    local W=25 H=15 PT=0 PR=0 PB=0 PL=0
    local target_media="" filename="" term=$(_ff_detect_term)
    local media_dir ext

    if [[ "$term" == "ghostty" ]]; then
        media_dir="$_FF_PNG_DIR"
        ext="png"
    else
        media_dir="$_FF_GIF_DIR"
        ext="gif"
    fi

    # A) Selección del archivo (random dentro del pool correspondiente a la terminal)
    if [[ -n "$1" ]]; then
        if [[ -f "$media_dir/$1" ]]; then
            target_media="$media_dir/$1"
        else
            echo "❌ Error: '$1' no existe en $media_dir"
            return 1
        fi
    else
        local -a files=("$media_dir"/*.${ext}(N))
        if (( ${#files} == 0 )); then
            echo "❌ Error: $media_dir vacío o sin .$ext"
            return 1
        fi
        target_media=${files[RANDOM % ${#files} + 1]}
    fi
    filename=$(basename "$target_media")

    # B) Leer Database (misma DB para ambos, keyed por filename con extensión incluida)
    if [[ -f "$_FF_DB_FILE" ]]; then
        local line_num=$(grep -Fnm 1 "$filename" "$_FF_DB_FILE" | cut -d: -f1)
        if [[ -n "$line_num" ]]; then
            local props_line=$((line_num + 1))
            local props=$(sed "${props_line}q;d" "$_FF_DB_FILE")
            [[ -n "$props" ]] && eval "$props"
        fi
    fi

    # C) Aplicar Cambios según terminal
    if [[ "$term" == "ghostty" ]]; then
        ln -sf "$target_media" "$_FF_LINK_PNG"
        sed -i -E 's/"type":[[:space:]]*"kitty-icat"/"type": "kitty-direct"/' "$_FF_CONFIG"
        sed -i -E "s|\"source\":[[:space:]]*\"[^\"]*\"|\"source\": \"$_FF_LINK_PNG\"|" "$_FF_CONFIG"
    else
        ln -sf "$target_media" "$_FF_LINK_GIF"
        sed -i -E 's/"type":[[:space:]]*"kitty-direct"/"type": "kitty-icat"/' "$_FF_CONFIG"
        sed -i -E "s|\"source\":[[:space:]]*\"[^\"]*\"|\"source\": \"$_FF_LINK_GIF\"|" "$_FF_CONFIG"
    fi

    sed -i -E "s/\"width\":[[:space:]]*[0-9]+/\"width\": $W/" "$_FF_CONFIG"
    sed -i -E "s/\"height\":[[:space:]]*[0-9]+/\"height\": $H/" "$_FF_CONFIG"
    sed -i -E "s/\"top\":[[:space:]]*[0-9]+/\"top\": $PT/" "$_FF_CONFIG"
    sed -i -E "s/\"right\":[[:space:]]*[0-9]+/\"right\": $PR/" "$_FF_CONFIG"
    sed -i -E "s/\"bottom\":[[:space:]]*[0-9]+/\"bottom\": $PB/" "$_FF_CONFIG"
    sed -i -E "s/\"left\":[[:space:]]*[0-9]+/\"left\": $PL/" "$_FF_CONFIG"

    fastfetch
}

# ------------------------------------------
# 2. CONFIG SETTER (CLI Tool)
# ------------------------------------------
ff-set() {
    local name=$1
    local props=$2
    if [[ -z "$name" || -z "$props" ]]; then
        echo "⚠️  Uso: ff-set archivo.gif \"W=30 PT=5\"   (o archivo.png)"
        return 1
    fi
    local line_num=$(grep -Fnm 1 "$name" "$_FF_DB_FILE" | cut -d: -f1)
    if [[ -n "$line_num" ]]; then
        sed -i "${line_num},$(($line_num + 1))d" "$_FF_DB_FILE"
        echo "🔄 Actualizando config de $name..."
    else
        echo "✨ Creando nueva config para $name..."
    fi
    echo "$name" >> "$_FF_DB_FILE"
    echo "$props" >> "$_FF_DB_FILE"
    ff "$name"
}

# ------------------------------------------
# 3. UTILIDADES Y AUTOCOMPLETADO
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
compdef _ff_completions ff
compdef _ff_completions ff-set
