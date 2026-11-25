#!/usr/bin/env bash
set -euo pipefail
profile="${1:?profile required}"
test "$(id -un)" = vscode
git --version
case "$profile" in
  universal) tools="python node npm java mvn gradle dotnet go rustc cargo gcc clang cmake php composer terraform aws kubectl helm doctl ansible";;
  python) tools="python pip gcc";;
  java) tools="java javac mvn gradle";;
  web) tools="node npm";;
  cpp) tools="gcc g++ clang cmake ninja gdb";;
  dotnet) tools="dotnet";;
  go) tools="go";;
  rust) tools="rustc cargo";;
  devops) tools="python terraform aws kubectl helm doctl ansible";;
  fintech) tools="python node npm psql";;
  ai) tools="python";;
  embedded) tools="gcc arm-none-eabi-gcc avr-gcc avrdude openocd";;
  *) exit 2;;
esac
for tool in $tools; do
  command -v "$tool"
  case "$tool" in
    java|javac) "$tool" -version;;
    go|terraform|doctl) "$tool" version;;
    kubectl) kubectl version --client;;
    helm) helm version --short;;
    gdb|avrdude|openocd) command -v "$tool";;
    *) "$tool" --version;;
  esac
done
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
printf 'int main(void){return 0;}\n' > "$tmp/main.c"
gcc "$tmp/main.c" -o "$tmp/main"
"$tmp/main"
if [[ "$profile" == ai ]]; then
  /opt/ai/bin/python -c 'import numpy, pandas, scipy, sklearn; assert numpy.arange(3).sum() == 3'
fi
if [[ "$profile" == embedded ]]; then
  arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -c "$tmp/main.c" -o "$tmp/arm.o"
  avr-gcc -mmcu=atmega328p -c "$tmp/main.c" -o "$tmp/avr.o"
fi
if command -v python >/dev/null; then
  python -c 'assert sum(range(5)) == 10'
fi
if command -v node >/dev/null; then
  node -e 'if (2 + 2 !== 4) process.exit(1)'
fi
if command -v javac >/dev/null; then
  printf 'class Main { public static void main(String[] args) { System.out.println("ok"); } }\n' > "$tmp/Main.java"
  javac "$tmp/Main.java"
  java -cp "$tmp" Main
fi
if command -v go >/dev/null; then
  printf 'package main\nfunc main() {}\n' > "$tmp/main.go"
  go build -o "$tmp/go-smoke" "$tmp/main.go"
  "$tmp/go-smoke"
fi
if command -v rustc >/dev/null; then
  printf 'fn main() {}\n' > "$tmp/main.rs"
  rustc "$tmp/main.rs" -o "$tmp/rust-smoke"
  "$tmp/rust-smoke"
fi
if command -v dotnet >/dev/null; then
  dotnet new console --no-restore --output "$tmp/dotnet-smoke"
  dotnet run --project "$tmp/dotnet-smoke"
fi
if [[ "$profile" == devops || "$profile" == universal ]]; then
  printf 'terraform {}\n' > "$tmp/main.tf"
  terraform -chdir="$tmp" validate
  ansible localhost -i localhost, -c local -m ping
fi
