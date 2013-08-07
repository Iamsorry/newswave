#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://www.nownews.com/editor_news.php';

my $ua = LWP::UserAgent->new;
my $response = $ua->get($URL);
die $response->status_line unless $response->is_success;

my @lines = split(/\n/, $response->decoded_content);

foreach my $line (@lines)
{
	next unless $line =~ /<a href="(\/\d{4}\/\d{2}\/\d{2}\/[0-9\-]+\.htm)">$/;
	my $uri = $1;
	my $url = sprintf "http://www.nownews.com%s", $uri;
	my $title = get_title($url);
	printf "%s\t%s\n", $url, $title;
}

exit;

sub get_title
{
	my $url = shift;
	my $ua = LWP::UserAgent->new;
	my $response = $ua->get($url);
	return "" unless $response->is_success;
	if($response->decoded_content =~ /<title>(.*)<\/title>/)
	{
		my $title = $1;
		if($title =~ /^(.*)\| \S+ \| NOWnews/)
		{
			$title = $1;
		}
		if($title =~ /^(.*) \(.+\d+.+\/.+\d+.+\)/)
		{
			$title = $1;
		}
		return $title;
	}
	return "";
}
