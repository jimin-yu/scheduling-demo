Scheduling Demo
===============
![demo page](./public/demo-page.png)
start local server
------------------

1) `bundle install`

2) create `.env` file
```
DB_USERNAME={username}
DB_PASSWORD={password}
```

3) database setting
```
mysql.server start

rails db:create
rails db:migrate
rails db:seed
```

4) `rails s`

5) visit `http://localhost:3000/schedule`


cluster test
------------
