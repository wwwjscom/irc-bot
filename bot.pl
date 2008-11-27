# Framework taken from someone else
use Irssi;
use strict;
use vars qw($VERSION %IRSSI);

use LWP::Simple;

$VERSION='0.1';

%IRSSI=(
	authors     =>  'IR Lab',
	name        =>  'IRC Bot',
	description =>  'Execute perl scripts through signal binds.',
	license     =>  'GPL',
	url         =>  'http://jk0.org/projects/irssi-scripts/'
);


sub public {
	my ($server,$msg,$nick,$address,$target)=@_;

	if($msg=~/^\.h[elp]?/) {
		$server->command('/MSG '.$target.' Owner: I serve the lab. List of commands: .help, .topic, .weather');
		$server->command('/MSG '.$target.' Help develop me @ http://github.com/wwwjscom/irc-bot/tree/master');
	}
	elsif ($msg =~ /^\.topic (.+)/i)
	{
		my $date = `date +"%k:%m %x"`;
		$server->command('/topic '.$target.' "'. $1 . '" by ' . $nick . ' on ' . $date . '. Set the topic with ".topic"');
	}

	#if($msg =~ /sex/) {
	#	$server->command('/MSG '.$target.' Oh yeah, talk dirty to me baby.  They dont call me squirt for no reason!');
	#	$server->command('/action '.$target.' puts on the slow music and starts undressing '.$nick);
	#}

	#if($msg =~ /fuck [you|off]/) {
	#	$server->command('/MSG '.$target.' No, f*ck you!  Bend over and touch your toes '.$nick.', Im gonna show you where the wild goose goes!');
	#	$server->command('/action '.$target.' puts on the slow music and starts undressing '.$nick);
	#}

	#elsif($msg=~/^\.kernel/) {
	#	$_=get('http://www.kernel.org/kdist/finger_banner');
	#	my ($stable)=/.* stable version .* (2\.6\..+)/i;
	#	my ($old)=/2\.4 version .* (2\.4\..+)/i;
	#	$server->command('/MSG '.$target.' Linux: '.$stable.' ('.$old.')');
	#}
	#/elsif($msg=~/^.c[heck]?/) {
	#elsif($msg=~/^\.XXXXXXX$/) {

	#	my ($server,$msg,$nick,$address)=@_;
	#	$server->command('/MSG '.$target.' Checking ChicagoLug.org, please wait ');

	#	`rm /tmp/chiglug_diff`;
	#	`mv /tmp/chiglug_new /tmp/chiglug_old`;
	#	`wget http://feeds.feedburner.com/PlanetChicagoGLUG -O /tmp/chiglug_new`;
	#	`diff /tmp/chiglug_new /tmp/chiglug_old > /tmp/chiglug_diff`;

	#	open(DIFF,"/tmp/chiglug_diff");
	#	my $update;
	#	my $i=0;

	#	while(my $line = <DIFF>)
	#	{
	#		$i++;
	#		if($line =~ /<title type=/) {
	#			$update = $update." ".substr($line,23,-10);
	#		}
	#		elsif($line =~ /<name>/) {
	#			$update = $update." by ".substr($line,11,-9)."...";
	#		}
	#	}

	#	if($i == 0)
	#	{
	#		$server->command('/MSG '.$target.' There have been no updates since the last check.');
	#	} else {
	#		$server->command('/MSG '.$target.' They are:'.$update);
	#	}
	#}

	#if($msg=~/\.yo/ || $msg=~/fuck [you|off]/)
	#{
	#	open(YO,"/home/wwwjscom/bots/yo_momma");
	#	my $num = 0;
	#	$num = int(rand(205));
	#	while($num % 2 == 0)
	#	{
	#		$num = int(rand(205));
	#	}

	#	my $i=1;
	#	my $joke="";

	#	while(my $line = <YO>)
	#	{
	#		if($i < $num)
	#		{
	#			$i++;
	#			$i++;
	#		} else {
	#			$joke = $line;
	#			last;
	#		}
	#	}
	#	$server->command('/MSG '.$target.' '.$joke);
	#}

	#if($msg=~/\.say/) {
	#	if($nick=~/^wwwjscom$/) {
	#		$server->command('/MSG #irlab '.substr($msg,5));
	#	} else {
	#		$server->command('/MSG '.$target.' '.$nick.' loves cocks!  roflcopters!!');
	#	}
	#}

	#if($msg =~/\.msg/) {
	#}

	##if($msg =~/.*/) {
	##	if($nick=~/^djkthx$/) {
	##		#		$server->command('/MSG '.$target.' If only I had ops...');
	##	}
	##}

	if($msg =~/^\.weather/) {
		$server->command('/MSG '.$target.' Good Morning!  Lets take a look at the weather');
		$_=get('http://rss.weather.com/weather/rss/local/60707?cm_ven=LWO&cm_cat=rss&par=LWO_rss');
		my @array = split(/Tonight/);
		$server->command('/MSG '.$target.' Tonight' . substr($array[1],0,-92));
	}
}

sub private {
	my ($server,$msg,$nick,$address)=@_;
	public($server,$msg,$nick,$address,$nick);
}

sub own_public {
	my ($server,$msg,$target)=@_;
	public($server,$msg,$server->{nick},0,$target);
}

sub own_private {
	my ($server,$msg,$target,$otarget)=@_;
	public($server,$msg,$server->{nick},0,$target);
}

Irssi::signal_add_last('message public','public');
Irssi::signal_add_last('message private','private');
Irssi::signal_add_last('message own_public','own_public');
Irssi::signal_add_last('message own_Private','own_private');
