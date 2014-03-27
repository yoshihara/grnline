# News

## <a id="0-0-4">0.0.4</a>: 2014-03-28

### Implements

* Showed lazy pretty print JSON responses.
  Using lazy pretty print, short arrays are shown as the line, and values in hashes are align verticaly.

e.g.) a response of status command.
Before:

```
[
  [
    0,
    1369743525.62977,
    9.20295715332031e-05
  ],
  {
    "alloc_count":129,
    "starttime":1369743522,
    "uptime":3,
    "version":"3.0.1",
    "n_queries":0,
    "cache_hit_rate":0.0,
    "command_version":1,
    "default_command_version":1,
    "max_command_version":2
  }
]
```

After:

```
[
  [0, 1369743525.62977, 9.20295715332031e-05],
  {
    "alloc_count"            :129,
    "starttime"              :1369743522,
    "uptime"                 :3,
    "version"                :"3.0.1",
    "n_queries"              :0,
    "cache_hit_rate"         :0.0,
    "command_version"        :1,
    "default_command_version":1,
    "max_command_version"    :2
  }
]
```

## <a id="0-0-3">0.0.3</a>: 2013-11-23

### Improvements

* Showed the build status image in Travis-CI.
* Added groonga's command parameters (e.g. "--name", "--table", "--output_columns"...) to the completion list.
* Added groonga's function (e.g. "now", "rand", "geo_distance"...) to the completion list.
* Supported command history. It is stored to the file "ENV['HOME']/.grnline-history".
* Added "*" in command-line prefix when you typed a continuous command.

### Changes

* Removed "groonga" string from command-line prefix.

## <a id="0-0-2">0.0.2</a>: 2013-05-31

### Improvements

* tools: sorted groonga commands alphabetically before printing.

### Fixes

* Added missing groonga commands ("tokenize" and "normalize").
* tools: fix a typo in the filename.

## <a id="0-0-1">0.0.1</a>: 2013-05-31

The first release !
