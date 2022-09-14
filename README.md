
## docker build
```
make all -e VERSION=2.3.0
```

## docker run
```
docker run -p 9030:9030 -p 8030:8030 -p 8040:8040 --privileged=true -itd --name star3 ionio/starrocks:2.3.0
```
