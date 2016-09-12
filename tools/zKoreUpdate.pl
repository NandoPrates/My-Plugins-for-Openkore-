#!/usr/bin/env/perl
use strict;
use warnings;
use File::Copy;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
use File::Path qw(remove_tree);
use Switch;

#How it works : http://tinypic.com/view.php?pic=2cwwg14&s=8
#It will copy the selected file for all folders in our directory. 
my ($exception, $counter) = 0;
*principal = *main;
principal();

sub main {
my $delete = 0;
	system("cls");
	printf("Select a dir/file for update:\n\n1 => src/tables\n2 => control/macros.txt\n3 => control/config.txt\n4 => control/pickupitems.txt\n5 => control/items_control.txt\n6 => control/mon_control.txt\n7 => tables/bRO/portals.txt\n8 => A plugin\n9 => Another file\n10 (fld) => Delete folder\n\nR: ");chomp (my $response = <STDIN>);
	switch ($response) { 
		case 1 {main1(); } case 2 {main2("macros");} case 3 {main2("config");} 
		case 4 {main2("pickup");} case 5 {main2("itemsc");}  case 6 {main2("monc");} 
		case 7 {main2("portals");} case 8 {main2("plugins");} case 9 {main2();} 
		case "exit" { exit (0); 
	} 
	if ($response =~ /10 (.*)/ig) {$delete = $1;deltree("delete $delete");}
	elsif ($response =~ /^(\d+)?(\s+)?$/ig)  { system"cls";print "Try again\n";my $num = $1;print "Missing folder argument to delete and replace by" if ($num == "10");sleep(1);main(); }
	}
	system("pause");
}

sub main1 {
	my ($x, $y, $z, $c) = 0;
	$c = main1a();
	switch ($c) {
		case 0 {
		print "Can't found src and tables folder\n";
		}
		else {
		print "Bot was updated sucessfull\nTotal : $c folders\n";
		remove_tree('src');
		remove_tree('tables');
		}
	}
}

sub main1a {
	system("cls");
	foreach (<*>) {
	my ( $receive_from, $receive_to,  $send_from,  $send_to,  $packets_from,  $packets_to , $x, $y, $z);
		if (-d "src" && -d "tables") {
			next if ($_ =~ /^.+\.pl$/ig);
			$receive_from = "src/Network/Receive/bro.pm";	
			$receive_to = "$_/$receive_from";
			#
			$send_from = "src/Network/Send/bro.pm";
			$send_to = "$_/$send_from";
			#
			$packets_from = "tables/bro/recvpackets.txt";
			$packets_to = "$_/$packets_from";
			#translate
			$receive_to =~ s/bro/bRO/i;
			$send_to =~ s/bro/bRO/i;
			$packets_to =~ s/bro/bRO/i;
			#
			$x = copy("$receive_from", "$receive_to");
			$y = copy("$send_from", "$send_to");
			$z = copy("$packets_from", "$packets_to");
				if ($x == $y && $x == $z) {
				#print "$_ = $x\n"  unless ($_ =~ /src|tables/ig);
				$counter += 1;
				}
		} else {
		return 0;
		}
	}
return $counter;
}

sub main2 {
	system("cls");
	my ($file, $destin, $sys_from, $sys_to, $pname) = 0;
	print "Plugin name (with/out .pl extension) : " if (defined($_[0]) && $_[0] eq "plugins");
	chomp ($pname=<STDIN>) if (defined($_[0]) && $_[0] eq "plugins");
	$file = "plugins" if (defined($_[0]) && $_[0] eq "plugins");
	$file = shift if (defined($_[0]) && $_[0] ne "plugins");
	print "File : " if (!$file);
	chomp ($file=<STDIN>) if (!$file);
	#$pname .= ".pl" if ($pname !~ /(.*)\.pl/ig);
	if ($file =~ /macros.txt|macros/ig) {
		$sys_from = "macros.txt";
		goto controlfiles;
	} 	elsif ($file =~ /config.txt|config/ig) {
		$sys_from = "config.txt";
		goto controlfiles;
	} 	elsif ($file =~ /pickupitems.txt|pickupitems|pickup/ig) {
		$sys_from = "pickupitems.txt";
		goto controlfiles;
	} 	elsif ($file =~ /items_control.txt|items(_)?c(ontrol)?/ig) {
		$sys_from = "items_control.txt";
		goto controlfiles;
	} 	elsif ($file =~ /mon_control.txt|mon(_)?c(ontrol)?/ig) {
		$sys_from = "mon_control.txt";
		goto controlfiles;
	} 	elsif ($file =~ /portals.txt|portals/ig) {
		$sys_from = "portals.txt";
		goto tablesfiles;
	}	elsif ($file =~ /plugins|plugns/ig) {
		$sys_from = $pname;
		goto plugnsfolder;
	}
		else {	
		print "Destin : ";
		chomp ($destin =<STDIN>);
		system("cls");
			if (length($file) <= 1 || length($destin) <= 1) {
			print "Empty file or/and destin (empty input stdin)\n";
			return 0;
			} 
				else {
				$sys_from = $file;
				$sys_to = "$destin/$sys_from";
				movefiles($sys_from, $sys_to);
				return 1;
				}
		}
	controlfiles:
	movefiles($sys_from, "control/$sys_from");

	tablesfiles:
	movefiles($sys_from, "tables/bRO");
	
	plugnsfolder:
	movefiles($sys_from, "plugins");
}

sub movefiles {
my ( $sys_from, $sys_to) = @_;
	foreach (<*>) {
	next if ($_ =~ /zPlugins/ig);
		if (-f "$sys_from") {
			if (-d "$_") {
				$counter += copy ("$sys_from", "$_/$sys_to");
				#print "$sys_from => $_/$sys_to\n";
				}
			else {
			$exception += 1;
			}
		}
	}
		system("cls");
		if ($counter > 0) {
		print "Sucess in \@bRO all folders\n\n";
		} else {
		print "Failed in update. Check if the \'$sys_from\' file exists.\n\n";
		}
		unlink $sys_from;
	return 1;
}

sub deltree {
my $sys_from = shift;
$sys_from =~ s/delete (.*)/$1/ig;
	foreach (<*>) {
	next if ($_ =~ /(z)?Plugins|Control Panel/ig); #Hidden file or Plugin folder or any extra folder that isn't a botter folder!
		if (-d "$sys_from") {
			if (-d "$_") {
				if (-d "$_/plugins") {
				$counter += remove_tree($_.'/'.$sys_from);
				} else {
				$counter += dircopy("plugins", "$_/plugins");
				}
				#print "$sys_from => $_/$sys_to\n";
				}
			else {
			$exception += 1;
			}
		} else {
			print "$sys_from not found\n";
			return 0;
		}
	}
	if ($counter > 0) {
		print "Sucess in \@bRO all folders\n\n";
		} else {
		print "Failed in update. Check if the \'$sys_from\' file exists.\n\n";
	}
	remove_tree($sys_from);
	return 1;
}
