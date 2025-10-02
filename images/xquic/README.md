# xquic

## Source

[https://github.com/alibaba/xquic](https://github.com/alibaba/xquic)

## Supported Versions

1.7.1, 1.7.2, 1.8.2, 1.8.3

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
