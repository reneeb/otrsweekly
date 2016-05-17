#!/usr/bin/perl

use v5.10;

use strict;
use warnings;

use Mojo::UserAgent;
use Time::Piece;

my $ua       = Mojo::UserAgent->new;
my $base_url = 'http://forums.otterhub.org/viewforum.php?f=';
my @forums   = qw(53);# 62 60 34 35 36);

my $now = localtime;

my @days;
for my $diff_days ( 0 .. 7 ) {
    my $day = $now - $diff_days * 24 * 60 * 60;

    push @days, sprintf "%02d %s %04d", $day->mday, $day->month(qw/undef Jan Feb Apr Mai Jun Jul Aug Sep Okt Nov Dez/), $day->year;
}

use Data::Dumper;
print Dumper \@days;

for my $forum ( @forums ) {
    my $url = $base_url . $forum;

    $ua->get(
        $url =>  sub {
            my ($ua, $tx) = @_;

say $tx->res->body;
say $tx->res->headers->to_string;

            my $dom = $tx->res->dom;
say "$url => DOM: $dom";

            for my $topics_list ( $dom->find('ul.topics')->each ) {
                for my $topic ( $topics_list->find('li.row')->each ) {
                    my $title = $topic->find('.topictitle');
                    say $title->text, ': ', $title->{href};
                }
            }
        }
    );

    #last;
}
