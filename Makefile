APP_NAME   = CmdCHistory
BINARY     = .build/release/$(APP_NAME)
APP_BUNDLE = $(APP_NAME).app
BUNDLE_ID  = com.local.cmdchistory

.PHONY: all build bundle install open verify test clean

all: bundle

build:
	swift build -c release

bundle: build
	rm -rf $(APP_BUNDLE)
	mkdir -p $(APP_BUNDLE)/Contents/MacOS
	mkdir -p $(APP_BUNDLE)/Contents/Resources
	cp $(BINARY) $(APP_BUNDLE)/Contents/MacOS/
	cp Info.plist $(APP_BUNDLE)/Contents/
	cp AppIcon.icns $(APP_BUNDLE)/Contents/Resources/
	codesign --force -s - --entitlements entitlements.plist $(APP_BUNDLE)
	@echo ""
	@echo "✓ Built $(APP_BUNDLE)"
	@echo "  Run 'make verify' to confirm no network entitlement is present."

install: bundle
	cp -r $(APP_BUNDLE) ~/Applications/ 2>/dev/null || cp -r $(APP_BUNDLE) /Applications/
	@echo "✓ Installed to Applications"

open: bundle
	open $(APP_BUNDLE)

# Verify the kernel-enforced guarantee: no network entitlement present.
# Look for absence of com.apple.security.network.client in the output.
verify:
	@echo "=== Entitlements baked into $(APP_BUNDLE) ==="
	@codesign -d --entitlements :- $(APP_BUNDLE) 2>/dev/null || echo "(ad-hoc signed)"
	@echo ""
	@echo "com.apple.security.app-sandbox=true means kernel blocks all outbound sockets."
	@echo "com.apple.security.network.client should NOT appear above."

test:
	swift run TestRunner

clean:
	rm -rf .build $(APP_BUNDLE)
