Overview

This document explains how to use pg_dump, pg_restore, and psql to dump and restore schemas or tables from a PostgreSQL database. 

pg_dump and pg_restore 

pg_dump is the standard data backup application that comes with an installation of pgAdmin or PostgreSQL. Use it to backup schemas, tables, or an entire database. Depending on the data format you create with pg_dump, you'll need to run psql or pg_restore to restore your data to an instance of PostgreSQL. pg_restore, psql, and pg_dump are installed with an instance of pgAdmin or PostgreSQL.  

Data Formats 

pg_dump can output in one of four formats: plain, custom, directory, or tar. This document only covers the plain and custom formats. Please see the PostgreSQL documentation for more information about other formats. 

The plain format is human-readable and flexible, for scripts to consume. Restore a dump in the plain format using psql. The custom format is a flexible binary format, with a much smaller disk size than the plain format. The custom format must be used with pg_restore. 

Examples Using pg_dump, pg_restore, and psql 

For additional information about all the parameters used in these examples, please see the PostgreSQL documentation.  

Some important notes about the parameters used in the pg_dump examples: 

    The parameters --no-owner and --no-privileges indicate to pg_dump that it will not back-up any information about owners or privileges about the objects. These flags are important when moving data between databases that may not have the same set of roles defined.  

    The --file flag indicates the file to output.  

    Multiple --schema flags may be specified to back-up more than one schema to a file.  

    The --no-tablespaces flag indicates that pg_restore should restore the backup to the default database tablespace. 

    The --exclude-table=TABLE flag enables you to exclude a table or view from the dump file. This flag is useful if you are restoring a schema with a view that depends on a table in a schema you're not restoring. 

Some important notes about the parameters used in the pg_restore examples: 

    The parameters --no-privileges, --no-owner, and --no-acl indicate to pg_restore that it should not restore any information about owners or privileges about the objects. These flags are important when moving data between database that may not have the same set of roles defined. 

    The -j NUMBER parameter tells pg_restore to restore schemas or tables in a NUMBER of streams. 

    The --disable-triggers flag tells pg_restore to disable triggers when restoring rows to a table. 

    The --exit-on-error flag tells pg_restore to exit if any error is encountered during the restore process.  

This example demonstrates executing pg_dump to a dump a schema to a single, plain format file.  

`pg_dump --host hostname --port 5432 --username dfollensbee --format plain --no-owner --no-privileges --no-tablespaces --no-unlogged-table-data --file "c:\some\path\output.sql" --schema someschema some_database `

To restore the data, created in the previous example, use psql as in the following example: 

`psql --quiet -h other_hostname -d other_database -U dfollensbee -f "c:\some\path\output.sql" `

This example demonstrates executing pg_dump to dump a schema to a single, custom format file. 

`pg_dump --host hostname --port 5432 --username dfollensbee --format custom --no-owner --no-privileges --no-tablespaces --no-unlogged-table-data --file "c:\some\path\output.dump" --schema someschema some_database `

To restore the data, created in the previous example, use pg_restore as in the following example: 

`pg_restore --no-privileges --no-owner -j 2 --no-acl --disable-triggers -h other_hostname -U dfollensbee --exit-on-error --dbname other_database "c:\some\path\output.dump" `
