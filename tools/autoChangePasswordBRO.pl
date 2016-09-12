#!/usr/bin/env/perl

use strict;
use warnings;

my $url;

#Example:
#
#Identity hash % :  
#my level up account of website : RagnarokUsernameWebsite and my token is rAndOmToK3N%3D
#
#User_pass hash % : 
#my level up account of game : RagnarokUsernameGame and my current RagnarokPasswordGame
#
#Email_pass hash % :
#my gmail account and password to get the current link to change of password
#

my %identity = qw(
RRagnarokUsernameWebsite Token
);

my %user_pass = qw(
RagnarokUsernameGame RagnarokPasswordGame
);

my @email_pass = qw(
Email1Example
);

#Email1Example password = $unique (UniquePasswordAssuming)

my $unique = 'UniquePasswordAssuming';
main();

sub main {
	do {
		print ("(1/3 steps) - Deleting all emails...\nEstimated time : " . (keys %user_pass) * 0.1 . " minute\n\n");
		delete_gmail();
		#system("cls");
	}while (0);
	do {
		print ("(2/3 steps) - Changing account passwords...\nEstimated time : " . (keys %user_pass) * 0.3 . " minute\n\n");
		web_account_login();
		#system("pause");
		system("cls");
	} while (0);
	do {
		print ("(3/3 steps) - Reading password's url changer in all e-mails\nEstimated time : " . (scalar (@email_pass)) * 0.2 . " minute\n\n");
		read_gmail();
		#system("pause");
		return 1;
	} while (0);
}

sub web_account_login {
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
my $bool;
my $ls;
	foreach my $account (sort { $a cmp $b} keys %user_pass) {
	goto tryagain;
	tryagain:
		$url = 'https://minhaconta.levelupgames.com.br/web';
		$mech->get( $url );
		my $text = $mech->content();
			$mech->submit_form (fields => {
				Username => $account,
				Password => $user_pass{$account},
			});
		if ($mech->content() =~ /.*?Verifica..o obrigat.ria.*?/ig) {
			print "Antibot-on\n";
			system("pause");
			exit(64);
		} if ($mech->content() =~ /.*?Excedeu.*?/ig) {
			print "Antispam-on\nExiting. . .\n\n";
			$ls = `ipconfig\release`;
			$ls = `ipconfig\flushdns`;
			$ls = `ipconfig\renew`;
			$ls = `ipconfig\registerdns`;
			goto tryagain;
			system("pause");
			#exit(64);
		}
		$url = $url . "/esqueci-senha-jogo?identity=" . $identity{$account};
		$mech->get( $url );
		$bool = $mech->submit();
		sleep(2);
		print "Sucess in $account\n" if ($bool);
		print "Failure in $account\n" if (!$bool);
	}
}

sub read_gmail {
use Net::IMAP::Simple;
use Email::Simple;
use IO::Socket::SSL;
	foreach my $emailid (@email_pass) {
		# fill in your details here
		print "Trying $emailid\n";
		my $username = $emailid . '@gmail.com';
		#my $password = $email_pass{$emailid};
		my $password = $unique;
		my $mailhost = 'pop.gmail.com';
		# Connect
		my $imap = Net::IMAP::Simple->new(
			$mailhost,
			port    => 993,
			use_ssl => 1,
		) || die "Unable to connect to IMAP: $Net::IMAP::Simple::errstr\n";
	
		# Log in
		if ( !$imap->login( $username, $password ) ) {
			print (STDERR "Login failed: $username and $password :  " . $imap->errstr . "\n");
			exit(64);
		}
		# Look in the the INBOX
		my $nm = $imap->select('INBOX');
		# How many messages are there?
		my ($unseen, $recent, $num_messages) = $imap->status();
		print ("unseen: $unseen, recent: $recent, total: $num_messages\n");
		my $subject;
		my $link;
		my $accname;
		## Iterate through unseen messages
		#
		for ( my $i = 1 ; $i <= $nm ; $i++ ) {
			if ( $imap->seen($i) ) {
			next;
			} 
				elsif ($imap->unseen($i)) {
				my $es = Email::Simple->new( join '', @{ $imap->get($i) } ); #changed top for get
				$subject = $es->header('Subject');
					if ($subject =~ /Ragnarok/ig) {
						if ($es->body =~ /(\?RequestId=3D((.*)(=\n+)?(.*)(\')?(?)(\n?).+))\s+?target=3D/ig) {
						mkdir 'tokens' if (!-d "tokens");
						$link = $1;
						$link =~ s/=|3d|'//ig;
							if ($es->body =~ /c?onta (.*),/ig) {
							$accname = $1;
							$accname =~ s/aa/a/ig;
							$link =~ s/RequestId/RequestId=/ig;
							$link =~ s/\R//ig;
							open F, ">tokens/$accname.txt";
							print F ('https://minhaconta.levelupgames.com.br/web/nova-senha-jogo' . $link);
							close F;
							print "$username was found !...\n\n";
							next;
							}
							undef $accname;
							undef $link;
						}
					}
				undef $subject;
				}
		}
			# Disconnect
			$imap->quit;
	}
}

sub delete_gmail {
use Net::IMAP::Simple;
use Email::Simple;
use IO::Socket::SSL;
# fill in your details here
	foreach my $emailid (@email_pass) {
	my $username = $emailid;
	my $password = $unique;
	my $mailhost = 'pop.gmail.com';
	# Connect
	my $imap = Net::IMAP::Simple->new(
		$mailhost,
		port    => 993,
		use_ssl => 1,
	) || die "Unable to connect to IMAP: $Net::IMAP::Simple::errstr\n";

	# Log in
	if ( !$imap->login( $username, $password ) ) {
		print (STDERR "Login failed: " . $imap->errstr . "\n");
		exit(64);
	}
	# Look in the the INBOX
	my $nm = $imap->select('INBOX');
	# How many messages are there?
	my ($unseen, $recent, $num_messages) = $imap->status();
	my $c = 0;
	#print ("unseen: $unseen, recent: $recent, total: $num_messages\n\n");
	## Iterate through unseen messages
		for ( my $i = 1 ; $i <= $nm ; $i++ ) {
		$c += 1;
		$imap->delete($i);
		}
	# Disconnect
	print "($c) e-mails deleted from $username\n" if ($c >= 1);
	print "Jumping $username\n" if ($c < 1);
	$imap->quit;
	}
}
