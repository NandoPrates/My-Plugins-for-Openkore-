#!/usr/bin/env/perl

#Hooking AI_pre
#Using timeout on openkore
#Openkore plugin -> Feel Free to copy
package st_timeout;
use strict;
use warnings;
use Log qw (message);

Plugins::register("[OPK-TUTO] Timeout example", "Periodically checks", \&on_unload, \&on_reload);

my $timeout = 10;
my $phook = Plugins::addHook("AI_pre", \&onLoop);
my %checkTimeout = ( time => time(), timeout => $timeout );

sub on_unload { Plugins::delHook($phook); }

sub on_reload { on_unload(); }

sub onLoop {
	if ( timeOut (\%checkTimeout) ) { #If last time called was 10s ago, we can next step
	prepare("loop");
	}
}

sub prepare {
  #do your editions
}

1;
