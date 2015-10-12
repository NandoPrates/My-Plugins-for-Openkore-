use strict;
use warnings;
use Plugins;
use Log qw (warning message debug error);
#-----------------
# Plugin: settings
#-----------------
Plugins::register("shopSold", "shopSold", \&on_unload, \&on_reload);
# Log hook
my $logHook = Log::addHook(\&on_Log, "shopsold");
#---------------
# Plugin: on_unload
#---------------
sub on_unload {
Log::delHook($logHook);
}
sub on_reload {
&on_unload;
}
#-------------
# Log: handler
#-------------
sub on_Log {
my ($type, $domain, $level, $globalVerbosity, $message, $user_data) = @_;
	if ( $type eq "message" ){
		if ($message =~ /(sold|vendido): (\d+) - (.*) (\d+)z/ig) {
		Utils::Win32::playSound("C:\\coin.wav");
		}		
	}
}
