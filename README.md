DXRuby/DXOpal の JRuby 移植です。
まだまだ作りかけです。


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
./dxjruby run examples/dxopal_top_page/main.rb
```


# License

MIT


# Acknowledgements

- [DXOpal](https://github.com/yhara/dxopal)
  - 一部のコードは DXOpal からフォークしたものです
