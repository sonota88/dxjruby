DXRuby/DXOpal の JRuby 移植です。
ある程度実装進んできましたが未実装の部分も残っています。


# Setup

```sh
  # JRuby 処理系のダウンロードなど
./dxjruby setup
```


# Run example

```sh
(
  cd java
  ./build.sh make-jar
)
./dxjruby run examples/dxopal/top_page/main.rb
```


# License

MIT


# Acknowledgements

- [DXOpal](https://github.com/yhara/dxopal)
  - 一部のコードは DXOpal からフォークしたものです
