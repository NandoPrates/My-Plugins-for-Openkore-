#!/usr/bin/env/perl
use strict;
use warnings;
use File::Copy;
use File::Path qw(remove_tree);
use Switch;

*principal = *main;
principal();
system("pause");

sub main {
	system("cls");
	printf("1 for src/tables\n2 for another file\n3 for macros\n4 for config\n5 for pickup\n6 for portals\n\nR: ");
	"1 - for src/tables 
	2 for another file  
	3 for macros
	4 for config
	5 for pickup
	6 for portals";chomp (my $response = <STDIN>);
	switch ($response) { case 1 { main1(); } case 2 { main2(); } case 3 { main2("macros"); } case 4 { main2("config"); } case 5 { main2("pickup"); }  case 6 { main2("portals");  } case "exit" { exit (0); } else  { system"cls";print "Try again\n";sleep(1);main(); } }
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
	my @files = <*>;
	my $counter = 0;
	foreach my $files (@files) {
	my ( $receive_from,  $receive_to,  $send_from,  $send_to,  $packets_from,  $packets_to , $x, $y, $z);
		if (-d "src" && -d "tables") {
			next if ($files =~ /^.+\.pl$/ig);
			$receive_from = "src/Network/Receive/bro.pm";	
			$receive_to = "$files/$receive_from";
			$send_from = "src/Network/Send/bro.pm";
			$send_to = "$files/$send_from";
			$packets_from = "tables/bro/recvpackets.txt";
			$packets_to = "$files/$packets_from";
			#
			$receive_to =~ s/bro/bRO/i;
			$send_to =~ s/bro/bRO/i;
			$packets_to =~ s/bro/bRO/i;
			#
			$x = copy("$receive_from", "$receive_to");
			$y = copy("$send_from", "$send_to");
			$z = copy("$packets_from", "$packets_to");
				if ($x == $y && $x == $z) {
				#print "$files = $x\n"  unless ($files =~ /src|tables/ig);
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
	my @files = <*>;
	print "File : ";
	my ($file, $destin, $sys_from, $sys_to) = 0;
	$file = shift if (defined($_[0]));
	chomp ($file=<STDIN>) if (!$file);
	################################################CONTROL################################################
	if ($file =~ /macros.txt|macros/ig) {
		$sys_from = "macros.txt";
		goto controlfiles;
	} 	elsif ($file =~ /config.txt|config/ig) {
		$sys_from = "config.txt";
		goto controlfiles;
	} 	elsif ($file =~ /pickupitems.txt|pickupitems|pickup/ig) {
		$sys_from = "pickupitems.txt";
		goto controlfiles;
	} 	elsif ($file =~ /portals.txt|portals/ig) {
		$sys_from = "portals.txt";
		goto tablesfiles;
	}
		else {	
		print "Destin : ";
		chomp ($destin =<STDIN>);
		system("cls");
			if ($file eq "" || $destin eq "") {
			print "Empty file or/and destin (empty input stdin)\n";
			} 
				else {
				$sys_from = $file;
				$sys_to = "$destin/$sys_from";
				movefiles($sys_from, $sys_to , @files);
				return 1;
				}
		}
	controlfiles:
	movefiles($sys_from, "control/$sys_from", @files);
	tablesfiles:
	movefiles($sys_from, "tables/bRO", @files);
}

sub movefiles {
my ( $sys_from, $sys_to, @files) = @_;
my ($exception, $counter) = 0;
$exception = "FoldersToNotUpdate";
		foreach my $files (@files) {
			if (-f "$sys_from") {
				if (-d $files && $files !~ /$exception/ig) {
					$counter += copy ("$sys_from", "$files/$sys_to");
					#print "$sys_from => $files/$sys_to\n";
					}
				else {
				$exception += 1;
				}
			}
		}
			system("cls");
			if ($counter) {
			print "Sucess in \@bRO all folders\n\n";
			} else {
			print "Failed in update. Check if the \'$sys_from\' file exists.\n\n";
			}
}
