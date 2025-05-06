DXRuby/DXOpal の JRuby 移植です。

# Setup

```sh
  # JRuby 処理系のダウンロードなど
./setup.sh
```


# Run example

```sh
(
  cd java
  ./build.sh make-jar
)
./dxjruby.sh examples/ball.rb
```


# License

MIT


# Acknowledgements

- [DXOpal](https://github.com/yhara/dxopal)
  - 一部のコードは DXOpal からフォークしたものです
