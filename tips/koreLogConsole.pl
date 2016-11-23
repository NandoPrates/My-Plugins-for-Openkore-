#!/usr/bin/env/perl

package korelogConsole;

use strict;
use warnings;
use Log qw (message);
use Globals;
use Utils;
use Plugins;

#my $datadir = $Plugins::current_plugin_folder;?

Plugins::register("[OPK-TUTO] Hooking openkore console", "Openkore console hook", \&on_unload, \&on_reload);
my $logHook = Log::addHook(\&on_Log, "consoleHook");

sub on_unload { Log::delHook($logHook); }

sub on_reload { on_unload(); }

sub on_Log {
my ($type, $domain, $level, $globalVerbosity, $message, $user_data) = @_;
	if ( $type eq "message" ) {
	    if ($message =~ /pattern/ig) {
	    #do your editions
	    }
        }
}

1;
