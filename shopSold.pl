use strict;
use warnings;
use Plugins;
use Log qw (warning message debug error);

#-----------------
# Plugin: settings
#-----------------
Plugins::register("shopsold", "shopsold", \&unload);
# Log hook
my $logHook = Log::addHook(\&on_Log, "shopsold");

#---------------
# Plugin: unload
#---------------
sub unload {
Log::delHook($logHook);
undef $logHook;
}

#-------------
# Log: handler
#-------------
sub on_Log {
my ($type, $domain, $level, $globalVerbosity, $message, $user_data) = @_;
	if ( $type eq "message" ){
		if ($message =~ /sold: (\d+) - (.*) (\d+)z/ig) {
		Utils::Win32::playSound("C:\\coin.wav");
		}		
	}
}
