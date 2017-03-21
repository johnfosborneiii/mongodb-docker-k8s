## Easiest way to test

```
cd db
docker build -t mongodb-enterprise .

cd ../ops-manager/mms-server/
docker build -t mms-server .

docker run --net=host mongodb-enterprise
docker run -it --net=host mms-server
```
