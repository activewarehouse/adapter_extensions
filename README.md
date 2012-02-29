AdapterExtensions add extra abilities to Rails ActiveRecord adapters, including:

* bulk load
* truncate table
* copy table
* add select into table

### Compatibility matrix

<table>
  <tr>
    <th></th>
    <th>rails-3 branch</th>
    <th>v0.9.5</th>
  </tr>
  <tr>
    <th>ActiveRecord adapters</th>
    <td></td>
    <td></td>
  <tr>
    <td>mysql</td>
    <td>OK</td>
    <td>OK</td>
  </tr>
  <tr>
    <td>mysql2</td>
    <td>OK</td>
    <td>Unsupported</td>
  </tr>
  <tr>
    <td>postgresql</td>
    <td>OK</td>
    <td>OK</td>
  </tr>
  <tr>
    <td>sqlserver</td>
    <td>Work in progress</td>
    <td>Broken</td>
  </tr>
  <tr>
    <th>ActiveRecord/ActiveSupport versions</th>
    <td>&gt;= 3</td>
    <td>&lt; 3</td>
  </tr>
  <tr>
    <th>Ruby versions</th>
  </tr>
  <tr>
    <td>MRI 1.9.3</td>
    <td>OK</td>
    <td>Untested</td>
  </tr>
  <tr>
    <td>MRI 1.8.7</td>
    <td>OK</td>
    <td>Should be OK</td>
  </tr>   
</table>

### Important notes on MySQL support

#### Security warning

Be sure to first read and understand the [security implications](http://dev.mysql.com/doc/refman/5.0/en/load-data-local.html) of `LOAD DATA LOCAL INFILE`. In particular, having this enabled on a web app is probably not a good idea.

#### v0.9.5

v0.9.5 will always use `LOAD DATA LOCAL INFILE` for bulk load - this is not configurable.

#### rails-3 branch

This version should by default use `LOAD DATA INFILE` for safer defaults.

You can override this by passing `:local_infile => true` though.

#### Troubleshooting LOCAL INFILE

If you enable `:local_infile => true` and meet the following error, then you'll have to work it around.

```
The used command is not allowed with this MySQL version: LOAD DATA LOCAL INFILE
```

For mysql2 with AR >= 3.1:

- use [this fork](https://github.com/activewarehouse/mysql2) until [this pull-request](https://github.com/brianmario/mysql2/pull/242) is merged 
- add `local_infile: true` to your database.yml

For mysql2 with AR < 3.1:

- no current easy solution afaik

For mysql:

- try this [untested patch](https://github.com/activewarehouse/adapter_extensions/issues/7)

### Notes on SQLServer support

v0.9.5 had a broken support for SQLServer.

The rails-3 branch has a work-in-progress bulk import using `freebcp`. More tweaking needed.

### Running the tests

You may have to tweak the Rakefile and database.yml a bit, but roughly:

```
rake ci:create_db
rake "ci:run_one[mysql2,test/config/gemfiles/Gemfile.rails-3.2.x]"
```

You can also run a matrix of tests using:

```
rake ci:run_matrix
```

### License

MIT

### Contributors

* Thibaut Barrère (current maintainer)
* original code by Anthony Eden and probably others (let me know if you read this!)
* thanks to [Zach Dennis](https://github.com/zdennis/activerecord-import) for his work where I borrowed ideas for the rails-3 branch
