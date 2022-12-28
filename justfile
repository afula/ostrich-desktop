# Homebrew installs LLVM in a place that is not visible to ffigen.
# This explicitly specifies the place where the LLVM dylibs are kept.
#set shell := ["cmd.exe", "/c"]
llvm_path := if os() == "macos" {
    "--llvm-path /Users/myway/Downloads/clang+llvm-14.0.0-x86_64-apple-darwin"
} else {
    ""
}

default: gen lint

gen:
    flutter_rust_bridge_codegen {{llvm_path}} \
        --rust-input native/src/api.rs \
        --dart-output lib/unit/bridge_generated.dart \
        --c-output ios/Runner/bridge_generated.h \
        --c-output macos/Runner/bridge_generated.h \

android:
    cd native && cargo ndk -t armeabi-v7a -t arm64-v8a -o ../example/android/app/src/main/jniLibs build --release

lint:
    cd native && cargo fmt
    dart format .

clean:
    flutter clean
    cd native && cargo clean