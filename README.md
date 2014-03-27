# Grnline

[![Build Status](https://travis-ci.org/yoshihara/grnline.png?branch=master)](https://travis-ci.org/yoshihara/grnline)

## Description

GrnLine is the wrapper for the interactive mode of [Groonga](http://groonga.org/).

Grnline is created by Ruby.
This uses [grnwrap](https://github.com/michisu/grnwrap) as a
reference. grnwrap is created by Python.

## Installation

```
$ gem install grnline
```

## Usage

You can use the options of Groonga as ones for Grnline. For example,
you execute Groonga with a new database:

    $ grnline -n <Groonga-db>

Then, Grnline has the own options. Please see ```grnline -- -h```.
When you want to know Groonga's options, please type ```grnline -h```.

## Depedencies

  * Ruby >= 1.9.3
  * Groonga

## Author

Haruka Yoshihara (h.yoshihara@everyleaf.com)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
