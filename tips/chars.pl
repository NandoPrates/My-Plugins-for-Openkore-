#!/usr/bin/env/perl

package charInfo;

use strict;
use warnings;
use Log qw (message);
use Globals;
use Utils;
use Plugins;

#Check if npc exists (by name)
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

#Returns your char race
sub _check_class {
return $jobs_lut{$char->{'jobID'}};
}

#Returns zeny
sub _zeny {
return formatNumber($char->{'zeny'}) if (defined($char->{'zeny'}));
}

#Returns weight
sub _weight {
return eval($char->{'weight'}/$char->{'weight_max'} * 100);
}

#Force to move to map
sub _pos {
return "$char->{pos}{x} $char->{pos}{y}" and return 1;
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
#$config{'attackAuto'} = 0;
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
