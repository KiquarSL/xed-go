#!/system/bin/sh
set -e

source "$LOCAL/bin/utils" 

# CONFIGURATION
LSP_DIR_KT="$HOME/.lsp/go"
GOPLS_LSP_VERSION="$1"

# HELPERS

install() {
	info "Installing Go..."
	apt update
	apt install golang-go
	
    info "Installing Go Language Server ${GOPLS_LSP_VERSION}..."
	go install golang.org/x/tools/gopls@$GOPLS_LSP_VERSION
	lh -s /home/go/bin/gopls $LSP_DIR_KT/gopls
    chmod +x "$LSP_DIR_KT/gopls"
	
	echo "$GOPLS_LSP_VERSION" > $LSP_DIR_KT/version.txt
}

# MAIN
case "$1" in
    --uninstall)
        info "Uninstalling Go..."
        rm -rf "$LSP_DIR_KT"
		rm -rf /home/go
        info "Uninstalled successfully."
        exit 0
        ;;
    --update)
        info "Updating Kotlin LSP..."
        rm -rf "$LSP_DIR_KT"
        install
        exit 0
        ;;
    *)
        install
        if ! grep -q "export PATH=\$PATH:$LSP_DIR_KT/" ~/.bashrc; then
            echo "export PATH=\$PATH:$LSP_DIR_KT/" >> ~/.bashrc
        fi
		
        info "All done! Restart your terminal or run: source ~/.bashrc"
        exit 0
        ;;
esac