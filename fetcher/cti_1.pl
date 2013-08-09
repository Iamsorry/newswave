#!/usr/bin/perl
use LWP::UserAgent;

my $URL = 'http://www.ctitv.com.tw/news_video.html';

my $ua = LWP::UserAgent->new;
my $response = $ua->get($URL);
die $response->status_line unless $response->is_success;

my @lines = split(/\n/, $response->decoded_content);

my ($uri, $desc) = ("", "");
foreach my $line (@lines)
{
	if($line =~ /<a href='(news_video_[^>]+\.html)'>/)
	{
		$uri = $1;
	}
	elsif($line =~ /<li>(.*)<\/li>/)
	{
		$desc = $1;
	}
	elsif($line =~ /<\/ul>/)
	{
		if($uri ne "" & $desc ne "")
		{
			printf "http://www.ctitv.com.tw/%s\t%s\n", $uri, $desc;
			$uri = "";
			$desc = "";
		}
	}
}
