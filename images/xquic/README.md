# xquic

## Source

[https://github.com/alibaba/xquic](https://github.com/alibaba/xquic)

## Requiered Server Parameters

```bash
-p [PORT]
```

## Requiered Client Parameters

```bash
-a [IP] -p [PORT]
```

## Note

- Server requires the SNI extension with the Common Name (CN) that is passed.
- Client crashes after start. Needs to be fixed.
