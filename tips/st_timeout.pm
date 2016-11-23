#!/usr/bin/env/perl

#Hooking AI_pre
#Using timeout on openkore

package st_timeout;
use strict;
use warnings;

Plugins::register("[OPK-TUTO] Timeout example", "Periodically checks", \&on_unload, \&on_reload);
my $phook = Plugins::addHook("AI_pre", \&onLoop);
my %checkTimeout = ( time => time(), timeout => 10 );

sub onLoop {
	if ( timeOut (\%checkTimeout) ) { #If last time called was 10s ago, we can next step
	prepare("loop");
	}
}

sub prepare {
  #do your editions
}
