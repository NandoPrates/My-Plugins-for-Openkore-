#!/usr/bin/env/perl

#Simple perl script // It's not an openkore plugin...
#What it does :?
#1--- It get all kafra from all towns and save it to a file!!!
package RatearRatemy;

use strict;
use warnings;
use LWP::Simple;

my ($link, $content, $php, @towns, @ids, @logs);

sub get_npc_byname {
my $mapname = shift;
my $name = shift;
	$link = 'http://ratemyserver.net/index.php?page=npc_shop_warp&map=MAPNAME';
	$link =~ s/mapname/$mapname/ig;

	$content = get($link);
	#<a href=id="t#npc_6127" class="nsw_sl">Kafra Employee</a>
	while ($content =~ /(.*)id=(\d+).*$name/ig) {
			push @ids, $2;
	}
	return scalar @ids;
}

sub get_maps {
$link = 'http://ratemyserver.net/index.php?page=areainfo&area=5999';
$content = get($link);
	while ($content =~ /\<b\>Map: (\w+)\<\/b\>/ig) {
		push @towns, $1;
	}
}

sub get_npc_pos {
	for (my $i=0;$i<scalar @towns;$i++) {
		get_npc_byname("$towns[$i]", "Kafra");
	}
		for (my $i = 0;$i < scalar @ids;$i++) {
				#nsw_npc_search.php?nid=6127&na=1&re=0
				$php = "http://ratemyserver.net/nsw_npc_search.php?nid=$ids[$i]&na=1&re=0";
				$content = get($php);
					if ($content =~ /Map & Position:\<\/b\> \<br\> (.*)\<\/small\>/ig) {
						push @logs, $1;
					}
		}
}

sub logs {
open F, ">npc.txt";
print F join("\n", @logs);
close (F);
}

get_maps();
get_npc_pos();
logs();

system("pause");

1;
