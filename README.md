DXRuby/DXOpal の JRuby 移植です。
基本的な機能は揃ってきましたが未実装の部分もまだまだあります。


# Setup

```sh
  # JRuby 処理系のダウンロードなど
./dxjruby setup

  # dxjruby-{version}.jar のビルド
(
  cd java
  ./build.sh make-jar
)
```


# Run example

```sh
./dxjruby run examples/dxopal/top_page/main.rb
```


# License

MIT


# Acknowledgements

- [DXOpal](https://github.com/yhara/dxopal)
  - 一部のコードは DXOpal からフォークしたものです
