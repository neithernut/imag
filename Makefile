toml = $@/Cargo.toml
bin = $@/target/debug/$@

doc-crate-toml=./.imag-documentation/Cargo.toml

ECHO=$(shell which echo) -e
CARGO=$(shell which cargo)

BINS=$(shell find -maxdepth 1 -name "imag-*" -type d)
LIBS=$(shell find -maxdepth 1 -name "libimag*" -type d)

BIN_TARGETS=$(patsubst imag-%,,$(BINS))
LIB_TARGETS=$(LIBS)
LIB_TARGETS_TEST=$(foreach x,$(subst ./,,$(LIBS)),test-$(x))
TARGETS=$(BIN_TARGETS) $(LIB_TARGETS)
RELEASE_TARGETS=$(foreach x,$(TARGETS),$(x)-release)
INSTALL_TARGETS=$(foreach x,$(BIN_TARGETS),$(x)-install)
UPDATE_TARGETS=$(foreach x,$(TARGETS),$(x)-update)
CLEAN_TARGETS=$(foreach x,$(TARGETS),$(x)-clean)

all: $(TARGETS)
	@$(ECHO) "\t[ALL    ]"

imag-bin:
	@$(ECHO) "\t[IMAG   ][BUILD  ]"
	@$(CARGO) build --manifest-path ./bin/Cargo.toml

imag-bin-release:
	@$(ECHO) "\t[IMAG   ][RELEASE]"
	@$(CARGO) release --manifest-path ./bin/Cargo.toml

imag-bin-update:
	@$(ECHO) "\t[IMAG   ][UPDATE ]"
	@$(CARGO) update --manifest-path ./bin/Cargo.toml

imag-bin-install:
	@$(ECHO) "\t[IMAG   ][INSTALL]"
	@$(CARGO) install --path ./bin/Cargo.toml

imag-bin-clean:
	@$(ECHO) "\t[IMAG   ][CLEAN  ]"
	@$(CARGO) clean --manifest-path ./bin/Cargo.toml

release: $(RELEASE_TARGETS) imag-bin-release
	@$(ECHO) "\t[RELEASE]"

bin: $(BIN_TARGETS) imag-bin
	@$(ECHO) "\t[ALLBIN ]"

lib: $(LIB_TARGETS)
	@$(ECHO) "\t[ALLLIB ]"

lib-test: $(LIB_TARGETS_TEST)

install: $(INSTALL_TARGETS)
	@$(ECHO) "\t[INSTALL]"

update: $(UPDATE_TARGETS)
	@$(ECHO) "\t[UPDATE ]"

clean: $(CLEAN_TARGETS) imag-bin-clean
	@$(ECHO) "\t[CLEAN  ]"

$(TARGETS): %: .FORCE
	@$(ECHO) "\t[CARGO  ]:\t$@"
	@$(CARGO) build --manifest-path ./$@/Cargo.toml

$(RELEASE_TARGETS): %: .FORCE
	@$(ECHO) "\t[RELEASE]:\t$(subst -release,,$@)"
	@$(CARGO) build --release --manifest-path ./$(subst -release,,$@)/Cargo.toml

$(LIB_TARGETS_TEST): %: .FORCE
	@$(ECHO) "\t[TEST   ]:\t$@"
	@$(CARGO) test --manifest-path ./$(subst test-,,$@)/Cargo.toml

$(INSTALL_TARGETS): %: .FORCE imag-bin-install
	@$(ECHO) "\t[INSTALL]:\t$(subst -install,,$@)"
	@$(CARGO) install --force --path ./$(subst -install,,$@)

$(UPDATE_TARGETS): %: .FORCE
	@$(ECHO) "\t[UPDATE ]:\t$(subst -update,,$@)"
	@$(CARGO) update --manifest-path ./$(subst -update,,$@)/Cargo.toml

$(CLEAN_TARGETS): %: .FORCE
	@$(ECHO) "\t[CLEAN  ]:\t$(subst -clean,,$@)"
	@$(CARGO) clean --manifest-path ./$(subst -clean,,$@)/Cargo.toml

.FORCE:

