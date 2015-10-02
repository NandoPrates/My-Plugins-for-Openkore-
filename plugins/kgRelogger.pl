# kgrelogger by Setzer
#
#
# This source code is licensed under the
# GNU General Public License, Version 2.

package kgrelogger;

use strict;

use Plugins;
use Commands;
use Log qw( warning message error );
use Settings;
use Globals;
use Utils qw( timeOut );
use Misc qw ( configModify );

#-----------------
# Plugin: settings
#-----------------
Plugins::register("kgrelogger", "relogs on koreguard error", \&unload);

# Log hook
my $logHook = Log::addHook(\&on_Log, "kgrelogger");
# Event hook
my $evnHooks = Plugins::addHooks(
["mainLoop_pre", \&on_MainLoop, undef]
);
my $logonAttempt = 0;
my %logonTimeout = ( time => time(), timeout => 10 );

#---------------
# Plugin: unload
#---------------
sub unload {
Log::delHook($logHook);
Plugins::delHooks($evnHooks);
undef $logHook;
undef $evnHooks;
}

#-------------
# Log: handler
#-------------
sub on_Log {
my ($type, $domain, $level, $globalVerbosity, $message, $user_data) = @_;
if( $type eq "error" ){
# Kore Guard errors
if( ($message =~ /Your\ Ragnarok\ Online\ server\ uses\ GameGuard/) ||
($message =~ /The\ Poseidon\ server\ closed\ the\ connection/) ||
($message =~ /The\ Poseidon\ server\ sent\ a\ wrong\ reply\ ID/) ||
($message =~ /Timeout\ on\ Character\ Select\ Server/) ||
($message =~ /Tempo\ esgotado\ no\ Servidor\ de\ Sele(.*)\ de\ Personagens/) ||
($message =~ /Timeout\ on\ Character\ Server/) ||
($message =~ /Tempo\ esgotado\ no\ Servidor\ de\ Personagens/) ||
($message =~ /couldn't\ connect:/) ||
($message =~ /n(.*)\ foi\ possível\ se\ conectar:/) ||
($message =~ /GameGuard\ packets\ where\ not\ replied/) ||
($message =~ /pacotes\ do\ GameGuard\ n(.*)\ foram\ respondidos/) ){
warning "[kgrelogger] connect error, relogging\n";
kgRelog();
}
} elsif( ($type eq "message") && ($domain eq "console") ){
# Logon attempt
if( ($message =~ /Requesting\ permission\ to\ logon\ on\ account\ server/) ||
($message =~ /Pedindo\ permiss(.*)o\ para\ se\ logar\ no\ servidor\ de\ contas/) ){
warning "[kgrelogger] attempting to connect through [$config{'poseidonServer'}] and...\n";

$logonAttempt = 1;
$logonTimeout{time} = time();
}
} elsif( ($type eq "message") && ($domain eq "connection") ){
# Logon success (account info received)
if( ($message =~ /-Account Info-/) ||
($message =~ /-Informa(.*)s da Conta-/) ){
$logonAttempt = 0;
warning "[kgrelogger] ...connected!\n";
}
}
}

#-----------------
# Event: Main loop
#-----------------
sub on_MainLoop {
return if !$logonAttempt;
if( timeOut(\%logonTimeout) ){
warning "[kgrelogger] ...connection timed out, relogging\n";
kgRelog();
}
}

#---------------
# Command: relog
#---------------
my $i = -1;
sub kgRelog {
$logonAttempt = 0;
my @xperiod  = (7,8,9,10,11,12,13,14,15);
my @yperiod  = (7,8,9,10,11,12,13,14,15);
my $x = rand @xperiod;
my $y = rand @yperiod;
my $t = ($xperiod[$x] * 10) + $yperiod[$y];
$logonAttempt = 0;
Commands::run("relog ".$t);   
}

1;
