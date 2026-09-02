# Golang
if command -v go >/dev/null 2>&1; then
    # Define GOPATH se não estiver definido ou estiver incorreto
    if [ -z "$GOPATH" ] || [ "$GOPATH" = "/bin/" ]; then
        export GOPATH=$HOME/go
    fi
    
    # Adiciona os diretórios do Go ao PATH
    export PATH=$PATH:$(go env GOPATH)/bin
    export PATH=$PATH:$(go env GOROOT)/bin
    
    # Garantir que o diretório bin existe
    mkdir -p $(go env GOPATH)/bin
fi