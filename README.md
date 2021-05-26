# Super homework

## About implementation

I decided to completely rewrite this work, because is much more interesting and well architected

### What we have
* Separated import data and report building
* Postgres database
* Bonus: little DSL to reduce boilerplate code

### How to start it

You have to put file data_large.txt in data directory (ungzipped, sorry for incomplete)

```
docker-compose up -d
rake db:create
rake db:migrate
rake import_data
rake report
```

### How to test

```
rspec
```

## Known issues
* Source CSV file does not downloads from internet
* Source CSV file not gzipped (have no time to improve)
* Code not linted
* Dirty rake db:create
* Not build docker container
* Long export data (I suppose it would be better to use clickhouse or some other fast DB sollutiion or batch generate session report, but I done with it)