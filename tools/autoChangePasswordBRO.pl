#!/usr/bin/env/perl

use strict;
use warnings;

my $url;

#Example:
#
#Identity hash % :  
#my level up account of website : RagnarokUsernameWebsite and my token is MtMNoPrqx7%3D
#
#User_pass hash % : 
#my level up account of game : RagnarokUsernameGame and my current RagnarokPasswordGame
#
#Email_pass hash % :
#my gmail account and password to get the current link to change of password

my %identity = qw(
RagnarokUsernameWebsite AccountToken
);

my %user_pass = qw(
RagnarokUsernameGame RagnarokPasswordGame
);

my %email_pass = qw(
MailGmail MailPassword
);

main();

sub main {
	do {
		print ("(1/3 steps) - Deleting all emails...\nEstimated time : " . (keys %user_pass) * 0.1 . " minute\n\n");
		delete_gmail();
		system("cls");

		print ("(2/3 steps) - Changing account passwords...\nEstimated time : " . (keys %user_pass) * 0.3 . " minute\n\n");
		web_account_login();
		system("cls");
		
		print ("(3/3 steps) - Reading password's url changer in all e-mails\nEstimated time : " . (keys %email_pass) * 0.2 . " minute\n\n");
		read_gmail();
		system("pause");
		
		return 1;
		
	} while (0);
}

sub web_account_login {
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();
my $bool;
	foreach my $account (sort { $a cmp $b} keys %user_pass) {
		$url = 'https://minhaconta.levelupgames.com.br/web';
		$mech->get( $url );
		my $text = $mech->content();
			$mech->submit_form (fields => {
				Username => $account,
				Password => $user_pass{$account},
			});
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
	foreach my $emailid (sort { $a cmp $b } keys %email_pass) {
		# fill in your details here
		my $username = $emailid . '@gmail.com';
		my $password = $email_pass{$emailid};
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
		#print ("unseen: $unseen, recent: $recent, total: $num_messages\n\n");
		my $subject;
		my $link;
		my $accname;
		## Iterate through unseen messages
		#
		for ( my $i = 1 ; $i <= $nm ; $i++ ) {
			if ( $imap->unseen($i) ) {
			next;
			}
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
						}
						undef $accname;
						undef $link;
					}
				} else {
				print ("No lvlup e-mail found\n");
				}
			undef $subject;
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
	foreach my $emailid (sort { $a cmp $b } keys %email_pass) {
	my $username = $emailid;
	my $password = $email_pass{$emailid};
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
