# OS detection
IS_MACOS=false
IS_LINUX=false
IS_WSL=false

[[ "$OSTYPE" == "darwin"* ]] && IS_MACOS=true
[[ "$OSTYPE" == "linux-gnu"* && $(grep -i -c 'Microsoft' /proc/version) -eq 0 ]] && IS_LINUX=true
[[ "$OSTYPE" == "linux-gnu"* && $(grep -i -c 'Microsoft' /proc/version) -gt 0 ]] && IS_WSL=true

# Carrega um arquivo de config SÓ se voce for dono do arquivo e da pasta, e a
# pasta nao for gravavel por terceiros. Usado nas pastas ~/.zsh/{programs,work}
# que sao lidas em bloco no login (evita executar algo plantado ali).
_safe_source() {
  emulate -L zsh
  setopt local_options extended_glob
  local f=$1 d=${1:h}
  [[ -r $f ]] || return 0
  if [[ ! -O $f || ! -O $d ]]; then
    print -u2 "zsh: ignorado (voce nao e dono do arquivo/pasta): $f"
    return 1
  fi
  if [[ -n ${d}(#qNW) ]]; then
    print -u2 "zsh: ignorado (pasta gravavel por todos): $d"
    return 1
  fi
  source "$f"
}
