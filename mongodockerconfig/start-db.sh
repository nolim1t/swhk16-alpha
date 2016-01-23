MONGOHOST=`boot2docker ip`:27017
DOCKERDB=db1
DOCKERUSER=nolim1t

docker run -p $MONGOHOST:27017 --name $DOCKERDB -d mongo:3.0
