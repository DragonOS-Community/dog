#TOOLCHAIN="+nightly-2023-08-15-x86_64-unknown-linux-gnu"
RUSTFLAGS+=""

ifdef DADK_CURRENT_BUILD_DIR
# 如果是在dadk中编译，那么安装到dadk的安装目录中
	INSTALL_DIR = $(DADK_CURRENT_BUILD_DIR)
else
# 如果是在本地编译，那么安装到当前目录下的install目录中
	INSTALL_DIR = ./install
endif

ifeq ($(ARCH), x86_64)
	export RUST_TARGET=x86_64-unknown-linux-musl
else ifeq ($(ARCH), riscv64)
	export RUST_TARGET=riscv64gc-unknown-linux-gnu
else 
# 默认为x86_86，用于本地编译
	export RUST_TARGET=x86_64-unknown-linux-musl
endif

FEATURES=--no-default-features --features with_idna --features  with_tls --features with_https  --features with_rustls

run:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) run $(FEATURES) --target $(RUST_TARGET)

build:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) build $(FEATURES) --target $(RUST_TARGET)

clean:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) clean --target $(RUST_TARGET)

test:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) test $(FEATURES) --target $(RUST_TARGET)

doc:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) doc $(FEATURES) --target $(RUST_TARGET)

fmt:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) fmt $(FEATURES) 

fmt-check:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) fmt --check $(FEATURES) 

run-release:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) run --target $(RUST_TARGET) $(FEATURES)  --release

build-release:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) build --target $(RUST_TARGET) $(FEATURES)  --release

clean-release:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) clean --target $(RUST_TARGET) $(FEATURES)  --release

test-release:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) test --target $(RUST_TARGET) $(FEATURES) --release

.PHONY: install
install:
	RUSTFLAGS=$(RUSTFLAGS) cargo $(TOOLCHAIN) install --target $(RUST_TARGET) $(FEATURES) --path . --no-track --root $(INSTALL_DIR) --force