package main

import (
	"flag"
)

type Opts struct {
	Port         int
	Verbose      bool
	Version      bool
}

func ParseOpts() *Opts {
	opts := new(Opts)

	flag.IntVar(&opts.Port, "port", 80, "Port")
	flag.BoolVar(&opts.Verbose, "verbose", false, "Show debugging and extraneous information")
	flag.BoolVar(&opts.Version, "version", false, "Print version and exit")

	flag.Parse()

	return opts
}