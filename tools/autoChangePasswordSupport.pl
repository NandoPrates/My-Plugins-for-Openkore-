use Win32::IEAutomation;
use Win32::Clipboard;

# Creating new instance of Internet Explorer
my %game_pass = qw(
RagnarokAccount RagnarokPassword
);

my %readers;

if (-d "tokens") {
	readfolders();
	main();
	system("pause");
}	else {
	print "Erro : Pasta tokens nao encontrada\n";
	system("pause");
	exit();
}

sub main {
my $url = 'https://minhaconta.levelupgames.com.br/web';
my $wanted = 8;
my $id;
my $response;
	for (my $i = 4;$i < keys %readers;$i++) {
	my $ie = Win32::IEAutomation->new( visible => 1, maximize => 1);
		foreach my $keys (sort { $a cmp $b } keys %game_pass) {
		system("cls");
		print "Username : $keys\n";
		$url = $readers{$i};
		$ie->gotoURL("$url");
		$ie->getTextBox('id:', "Username")->SetValue("$keys");
		$ie->getTextBox('id:', "Password")->SetValue("$game_pass{$keys}");
		ClipBoard($game_pass{$keys});
			if ($ie->Content() =~ m/recaptcha\/api\/image\?c=(.+)\"\>\<\/div\>/ig) {
			print "Captcha found...Fill the captcha and press enter...\nWaiting for any key...\n";
			$id = $1;
			$response = checkIfCaptchaExists($id);
			if ($response eq 1) {
			print "This captcha already exists with a response\n";
			$ie->getTextBox('name:', "recaptcha_response_field")->SetValue($response);
			$ie->getTextBox('name:', "recaptcha_response_field")->Click();
			next;
			} else {
			open F, ">>Captcha.txt";
			print F "$id = " . $ie->getTextBox('name:', "recaptcha_response_field")->GetValue() . "\n";
			close F;
			system("cls");
			}
			print "Waiting for finish...\n";
			<>;
				if ($ie->Content() =~ m/recaptcha\/api\/image\?c=(.+)\"\>\<\/div\>/ig) {
				$id = $1;
				open F, ">>Captcha.txt";
				print F "$id = " . $ie->getTextBox('name:', "recaptcha_response_field")->GetValue() . "\n";
				close F;
				}
			$i += 1;
			sleep(5);
			$ie->gotoURL("https://minhaconta.levelupgames.com.br/web/login");
			}
		}
	}
}

sub checkIfCaptchaExists {
open F, "<Captcha.txt";
my $temp;
	while (<F>) {
		if ($line =~ /^(.*) = (.*)$/ig) {
		$temp = $2;
			if ($1 ~~ $_[0]) {
				close F;
				return 1
			}
		}
	}
	
return 0;
close F;
}

sub readfolders {
chdir "tokens";
my $filename;
my @file = glob('*');
my @files = sort {$a cmp $b} @file;
	for (my $i = 0;$i < scalar @files;$i++) {
		if ($files[$i] !~ /\.pl/ig) {
			$filename = $files[$i];
			open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
			my $row = <$fh>;
			$readers{$i} = "$row";
			chomp $row;
			close ($fh);
		}
	}
chdir '..';
}

sub ClipBoard {
my $CLIP = Win32::Clipboard();
$CLIP->Set($_[0]);
}

