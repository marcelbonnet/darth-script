# What is this

The script helps me to deploy and undeploy one or more <Directory>
and/or <VirtualHost>.

# Modifying

All paths are easely configurable (script global variables).

# What it does

My /usr/local/etc/apache24/httpd.conf has this entry:

```
IncludeOptional etc/apache24/sites-enabled/*.conf
```

And two dirs under /usr/local/etc/apache24/ :

```sites-available/``` conf files in this directory contains <Directory> or <VirtualHost> entries.

```sites-enabled/``` this script create symlinks to conf files in ```sites-available/``` to deploy them

The script generates a index of enabled and available files under /usr/local/etc/apache24/data


# Usage

$ apache-sites -h

Maybe you need to change some lines to fit your needs.
