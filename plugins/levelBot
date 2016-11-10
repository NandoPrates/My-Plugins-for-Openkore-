package levelBot;

use strict;

use Commands;
use Plugins;
use Log qw (warning);
use Globals;
use Utils;

my ($saved);
my @commands;

Plugins::register("Level up Bot", "levelBot", \&on_unload, \&on_reload);
my $phook = Plugins::addHooks(
#["in_game", \&on_pre],
["AI_pre", \&onLoop]
);

my $logHook = Log::addHook(\&on_Log, "levelBot");
my $datadir = $Plugins::current_plugin_folder;
my $commands_handle = Commands::register(
	['ms', 'Prepare merchant to sell', \&on_ms]
);

my %checkTimeout = ( time => time(), timeout => 10 );

sub on_unload {
Plugins::delHook($phook);Commands::unregister($commands_handle);Log::delHook($logHook);
$config{'attackAuto'} = 2;
warning "[levelBot-plugin] - Complete\n";
warning "[levelBot-plugin] - Complete\n";
Commands::run("iconf Poção Branca 0 0 0");	#White Potion
Commands::run("iconf Poção Vermelha 0 0 0");	#Red Potion
Commands::run("iconf Poção de Aprendiz 0 0 0");	#Novice Potion
Commands::run("iconf Poção Laranja 0 0 0");	#Orange Potion
}

sub on_reload {
warning "[levelBot-plugin] - Reloaded\n";
}

sub on_Log {
my ($type, $domain, $level, $globalVerbosity, $message, $user_data) = @_;
	if( $type eq "message" ) {
		if ($message =~ /ponto de retorno/ig) {
			Commands::run("conf saveMap ". $field->baseName());
			$saved = 1;
		}
	}
}

sub onLoop {
	if ( timeOut (\%checkTimeout) ) {
	prepare("loop");
	}

}

sub on_pre {
prepare();
return 1;
}

sub run_commands {
my $x = shift;
	for (@commands) {
		Commands::run("$x$_");
	}
undef @commands;
}

sub on_ms {
_command_add("shopAuto_open 1");
_command_add("shop_useSkill 1");
run_commands();
warning "Please, set-up your items to sell and restart your bot.\n";
}

sub prepare {
my $args = shift;
goto end if ($args eq "loop");
my $char_lv = $char->{'lv'};
my $char_jb = $char->{'lv_job'};
return 2 if (_check_class() eq "Merchant");
	goto savemap;
	savemap:
	$checkTimeout{time} = time();
	if (( $config{'saveMap'} ne "geffen" || !$config{'saveMap'}) && $config{'lockMap'} =~ /gef.*06/ig) {
		if ($char_lv < 80 && $char_lv >= 65) {
						_command_add("lockMap gef_fild06");
						_command_add("storageAuto_npc geffen 203 123");
						_command_add("buyAuto_0_npc geffen_in 77 167");
						_command_add("sellAuto_npc geffen_in 77 167");
		}
run();
_save_map("geffen 203 123");
	}
	elsif (($config{'saveMap'} ne "payon" || !$config{'saveMap'}) && $config{'lockMap'} =~ /pay.*/ig) {
		if ($char_lv < 19) {
			_command_add("itemsMaxWeight_sellOrStore");
			_command_add("autoTalkCont 0");
			_command_add("useSelf_item_0 Poção Vermelha, Poção Laranja, Poção de Aprendiz, Poção Branca");
			_command_add("useSelf_item_0_hp < 70%");
				if (_check_class() == "High Novice") {
					_command_add("sellAuto 0");
					_command_add("storageAuto 0");
				} else {
					_command_add("sellAuto 1");
					_command_add("storageAuto 1");
				}
				_command_add("sellAuto_npc payon_in01 5 49");
				_command_add("storageAuto_npc payon 181 104");
					if (_zeny() >= 7500) {
						_command_add("buyAuto_0_disabled 0");
					} else {
						_command_add("buyAuto_0_disabled 1");
					}
						_command_add("buyAuto_0_npc payon_in01 5 49");
						_command_add("buyAuto_0 Poção Vermelha");
						_command_add("buyAuto_0_minAmount 0");
						_command_add("buyAuto_0_maxAmount 150");
						_command_add("lockMap pay_fild08");
		} elsif ($char_lv < 25 && $char_lv >= 19) {
						_command_add("sellAuto_npc payon_in01 5 49");
						_command_add("buyAuto_0_npc payon_in01 5 49");
						_command_add("storageAuto_npc payon 181 104");
						_command_add("lockMap pay_fild07");
		} elsif ($char_lv < 43 && $char_lv >= 25) {
						_command_add("lockMap pay_fild09");
		}
run();
_save_map("payon 181 104");
	} 
	elsif (($config{'saveMap'} ne "prontera" || !$config{'saveMap'}) && $config{'lockMap'} =~ /gef.*10/ig) {
		if ($char_lv < 50 && $char_lv >= 43) {
			_command_add("sellAuto_npc prt_in 126 76");
			_command_add("buyAuto_0_npc prt_in 126 76");
			_command_add("storageAuto_npc prontera 151 29");
			_command_add("lockMap gef_fild10");
		}
run();
_save_map("prontera 151 29");
	} 
	elsif (($config{'saveMap'} ne "yuno" || !$config{'saveMap'}) && $config{'lockMap'} =~ /yuno.*03/ig) {
		if ($char_lv >= 80 && $char_lv < 99) {
					_command_add("sellAuto_npc yuno 218 97");
					_command_add("buyAuto_0_npc yuno 218 97");
					_command_add("storageAuto_npc yuno 152 187");
					_command_add("lockMap yuno_fild03");
		run();
		_save_map("yuno 152 187");
		}		
	} elsif (($config{'saveMap'} ne "rachel" || !$config{'saveMap'}) && $config{'lockMap'} =~ /ve.*03/ig) {
		if ($char_lv >= 80 && $char_lv < 99) {
					_command_add("sellAuto_npc rachel 65 80");
					_command_add("buyAuto_0_npc ra_in01 257 269");
					_command_add("storageAuto_npc rachel 109 138");
					_command_add("lockMap ve_fild03");
		run();
		_save_map("rachel 109 138");
		}
	} elsif ($config{'saveMap'}) {
		on_unload();
	} else {
		warning "[levelBot-plugin] - Don't know what to about your up.\n";
	}
end:
return 1;
}

sub _timercheck {
my $weight = $char->{'weight'}/$char->{'weight_max'} * 100;
	if ($weight > 89 && $config{'attackAuto'} ne 0) {
	_command_add("attackAuto 0");
	_command_add("autostorage");
	_command_add("autosell");
	} elsif ($weight < 89  && $config{'attackAuto'} ne 2) {
	_command_add("attackAuto 2");
	}
}

sub run {
split(/\n/, @commands);
run_commands("conf ");
}

sub _command_add {
push @commands,  $_[0];
}

sub _save_map {
my $map = shift;
my ($aX, $aY, $aF, $talk, $currently, $unk);
if ($map =~ /(\w+) (\d+) (\d+)/ig) {$aF = $1;$aX = $2;$aY = $3;}
my $x = $aX - 2;
my $y = $aY - 3;
$config{'attackAuto'} = 0;
		if ( $field->baseName() ne "$aF") {
		_command_add("move $aF $aX $aY");
		run_commands();
		$checkTimeout{time} = time();
		goto end;
		} else {
			if ($talk && $field->baseName() eq "$aF") {
					_command_add("talknpc $aX $aY c r0 n");
					goto end;
			} elsif ($field->baseName() eq "$aF") {
					$x = eval($aX - int(rand(4)));
					$y = eval($aY - int(rand(4)));
					_command_add("move $x $y");
					goto end;
			}
		}
		end:
		run_commands() if (scalar @commands >= 1);
}

sub npc_exist {
my $name = shift;
my $msg;
my $npcs = $npcsList->getItems();
	foreach my $npc (@{$npcs}) {
		my $pos = "($npc->{pos}{x}, $npc->{pos}{y})";
				if ($npc->name =~ /.*$name/ig) {
					return 1;
				}
	}
	return 0;
}

sub _check_class {
return $jobs_lut{$char->{'jobID'}};
}

sub _zeny {
return formatNumber($char->{'zeny'}) if (defined($char->{'zeny'}));
}

sub _weight {
return eval($char->{'weight'}/$char->{'weight_max'} * 100);
}

sub _pos {
return "$char->{pos}{x} $char->{pos}{y}" and return 1;
}

1;
