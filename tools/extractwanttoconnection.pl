#!/usr/bin/env/perl

use strict;
use warnings;


my $lines;
my $file = "Rakki-RO.exe";
my $packet;
open F, "<$file";

binmode F;

my %list = (
"20101124a" => "0x0436",
"20111005a" => "0x083c",
"20120307f" => "0x086A",
"20120410a" => "0x094b",
"20120418a" => "0x022D",
"20120702a" => "0x0363",
"20130320" => "0x0888",
"20130515a" => "0x0943",
"20130522" => "0x08A9",
"20130529" => "0x0919",
"20130605" => "0x022D",
"20130612" => "0x0919",
"20130618" => "0x095B",
"20130626" => "0x088C",
"20130703" => "0x022D",
"20130710" => "0x022D",
"20130717" => "0x091D",
"20130807" => "0x022D",
"20131223" => "0x022D",
"20141016" => "0x086E",
"20141022b" => "0x093b",
"20150513a" => "0x0363",
"20150916" => "0x0969",
"20151001b" => "0x022d",
"20151104a" => "0x0360",
);

while (<F>) {
	$lines = unpack("H*", $_);
		if ($lines =~ /.*?FF15(.){8}B8(..)(..)0000668985/ig) {
			$packet = sprintf("0x%04D", $3.$2);
			print "Packet login map found : $packet\n";
		}
}

foreach (keys %list) {
	if ($list{$_} eq $packet) {
		print "Recommended sT : " . $_ . "\n";
	}
}

<>;
close(F);
