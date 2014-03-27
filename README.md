# Grnline

[![Build Status](https://travis-ci.org/yoshihara/grnline.png?branch=master)](https://travis-ci.org/yoshihara/grnline)

## Description

GrnLine is the wrapper for the interactive mode of [groonga](http://groonga.org/).

Grnline is created by Ruby.
This uses [grnwrap](https://github.com/michisu/grnwrap) as a
reference. grnwrap is created by Python.

## Installation

```
$ gem install grnline
```

## Usage

You can use the options of groonga as ones for Grnline. For example,
you execute groonga with a new database:

    $ grnline -n <groonga-db>

Then, Grnline has the own options. Please see ```grnline -- -h```.
When you want to know groonga's options, please type ```grnline -h```.

## Author

Haruka Yoshihara (yshr04hrk at gmail.com)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
