#!/usr/bin/env/perl

#Utilidade : Ao relogar, recolocar sempre os itens na loja novamente.
#Exemplo : 
#vendorAi Erva Branca {
#	cart_minAmount 0
#	cart_maxAmount 250
#	storage_get 0
#	cart_add 1
#	straight 1
#	disabled 0
#} 
#
#storage_get = Get the maxAmount from storage to add in your cart (1) or don't open your storage, if there's no item in your shop
#if storage_get is 1, set your storageAuto_npc and MUST use getAuto block, its required! 
#It will trigger when there's no item in your inventory and when there isn't in your cart and if is enabled to get from store.
#straight = if you open your storage, set if you will send from your storage to cart (1) or from storage to inventory(0)
#If we dont have slot or we're overweight, it will send to cart if possible,if not it will close!
#maxAmount of item on your cart 
#minAmount of item to open your storage or reopen your shop with a new amount
#cart_add = if you want add your item to cart or maintain in your inventory

use strict;
no warnings qw(redefine uninitialized);
use Time::HiRes qw(time);
use encoding 'utf8';
use Plugins;
use Utils qw( timeOut );
use Log qw (warning message debug error);
use Commands;
use Settings;
use Plugins;
use Skill;
use Utils;
use Utils::Exceptions;
use AI;
use Misc qw(itemNameSimple);

#Hash para colocar os pesos dos itens que você vai recolocar para vender!
my %items_weight = (
"Erva Branca" => 7,
);

my $total;
my $end;
my ($startTime, $refresh);

#-----------------
# Plugin: settings
#-----------------
Plugins::register("Merchant AI", "AI for Vendor", \&on_unload, \&on_reload);
my $hook = Plugins::addHooks(
["AI_pre", \&mainOut],
);

#---------------
# Plugin: on_unload
#---------------
sub on_unload {
Plugins::delHooks($hook);
}

sub on_reload {
&on_unload;
}

sub mainOut {
my $timeout = 400;
	if (timeOut($startTime, $timeout)) {
		my $list_len = check_param();
		warning ("[mercAi] - Plugin is now working\n");
		AI::clear("move", "route", "autoBuy", "autoStorage");
		$startTime = time;
		$refresh = time;
	}
}

#---------------
# Plugin: Main Code
#---------------

sub check_param {
my $retn = check_config_enabled();
return $retn;
}

sub check_config_enabled {
my ($item, $minamount, $maxamount, $storage_get, $cartadd, $straight, $limit, $end, $amount, $inventcheck, $storcheck, @items);
$minamount= 0;
	for (my $i = 0;exists $config{"vendorAi_$i"}; $i++) {
		if ($config{"vendorAi_$i\disabled"} eq 1) {$total += 1;next;}
			$item = $config{"vendorAi_$i"} if ($config{"vendorAi_$i"});
			$minamount = $config{"vendorAi_$i\_cart_minAmount"} if ($config{"vendorAi_$i\_cart_minAmount"});
			$amount = cart_check($item, $minamount, $maxamount, $storage_get, $cartadd, $straight);
			$maxamount = $config{"vendorAi_$i\_cart_maxAmount"} if ($config{"vendorAi_$i\_cart_maxAmount"});
			$storage_get = $config{"vendorAi_$i\_storage_get"} if ($config{"vendorAi_$i\_storage_get"});
			$cartadd = $config{"vendorAi_$i\_cart\_add"} if ($config{"vendorAi_$i\_cart_add"});
			$straight = $config{"vendorAi_$i\_straight"} if ($config{"vendorAi_$i\_straight"});
			$limit = $config{"vendorAi_$i\_limit"} if ($config{"vendorAi_$i\_limit"});
			$inventcheck = inventory_check($item, $minamount, $amount, $maxamount, $config{'vendorAi_$i'}, $cartadd) if (!$limit);
			$inventcheck = inventory_check($item, $minamount, $limit, $maxamount, $config{'vendorAi_$i'}, $cartadd) if ($limit);
			$storcheck = storage_get($item, $amount, $straight) if ($amount <= $minamount & $inventcheck && $storage_get eq 1 );
			$end = $i;
		close_session();
	}
return eval($end - $total);
}

#---------------
#Plugin : Subs
#---------------

sub cart_check {
my ($item, $minamount, $maxamount, $storage_get, $cartadd, $straight) = @_;
my ($limit, $char_weight, $name, $amount, $char_weight_max);
$char_weight = $cart{'weight'};
$char_weight_max = 8000;
	for (my $i = 0; $i < @{$cart{'inventory'}}; $i++) {
		next if (!$cart{'inventory'}[$i] || !%{$cart{'inventory'}[$i]});
		$name = $cart{'inventory'}[$i]{'name'};
		if ($item eq $name) {
			$limit = int(eval(($char_weight_max - $char_weight) / $items_weight{$item}));
			return $limit;
		}
	}
return -1;
}

sub inventory_check {
my ($needed, $minamount, $limit, $maxamount, $perm, $cartadd) = @_;
my ($limited, $char_weight, $name, $amount, $char_weight_max);
my $startTime = time;
next unless ($limit >= 0);
$char_weight_max = $char->{'weight_max'};
$char_weight = $char->{'weight'};
$limited = int(eval(($char_weight_max - $char_weight) / $items_weight{$needed}));
	foreach my $item (@{$char->inventory->getItems()}) {
		if ($item->{name} eq $needed && $limit <= $minamount) {
			cart_add($item, $amount) if ($amount <= $maxamount && $cartadd eq 1);
			cart_add($item, $maxamount) if ($amount >= $maxamount && $cartadd eq 1);
			return $item->{amount};
		}
	}
}

sub close_session {
	if ($total eq $end && $total != 0 && $end != 0) {
	  #warning "Fechando o plugin mercAi\n";
		on_unload();
	}
}

sub gotoProntera {
my ($prontera, $tourx, $toury, $savepoint);
		$savepoint = "prontera 151 29";
		$savepoint =~ /(\w+) (\d+) (\d+)/ig;
		$prontera = $1;
		$tourx = $2 - int(rand(5));
		$toury = $3 - int(rand(5));
		if ("$char->{pos}{x} $char->{pos}{y}" ne "$tourx $toury") {	
			Commands::run("move $prontera $tourx $toury");
			$refresh = time;
			return 0;
		}
	return 1;
}

sub storage_get {
my ($name, $amount, $straight) = @_;
AI::queue("storageAuto");
	for (my $i = 0; $i < @storageID; $i++) {
		next if (!$storageID[$i]);
		my $item = $storage{$storageID[$i]};
			if ($item->{name} eq $name) {
				if ($straight eq 1) {
					Commands::run("storage gettocart $name $amount");
				} else {
					Commands::run("storage get $name $amount");
					cart_add($name, $amount);
					return 1;
				}
			} else {
				return 2;
			}
		return 0;
	}
} 

sub cart_add {
my ($name, $amount) = @_;
my $item = Match::inventoryItem($name);
my $index = $item->{invIndex};
Commands::run("cart add $index $amount");
}
