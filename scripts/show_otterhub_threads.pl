#!/usr/bin/perl

use v5.10;

use strict;
use warnings;

use Data::Dumper;
use Mojo::UserAgent;
use Mojo::IOLoop;
use Time::Piece;

my $ua       = Mojo::UserAgent->new;
my $base_url = 'http://forums.otterhub.org/';
my @forums   = qw(53 62 60 34 35 36);

my $now = localtime;

my @days;
for my $diff_days ( 0 .. 7 ) {
    my $day = $now - $diff_days * 24 * 60 * 60;

    push @days, sprintf "%02d %s %04d", $day->mday, $day->month, $day->year;
}

my @threads;

Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
 
# Concurrent non-blocking requests (synchronized with a delay)
Mojo::IOLoop->delay(
    sub {
        my $delay = shift;

        for my $forum ( @forums ) {
            my $url = $base_url . 'viewforum.php?f=' . $forum;
            $ua->get( $url => $delay->begin);
        }
    },
    sub {
        my ($delay, @txs) = @_;

        for my $tx ( @txs ) {
            my $dom = $tx->res->dom;
            my $url = $tx->req->url->to_string;

            TOPICLIST:
            for my $topics_list ( $dom->find('ul.topics')->each ) {
                for my $topic ( $topics_list->find('li.row')->each ) {
                    my $title = $topic->at('.topictitle');

                    my $last_action = $topic->at('.lastpost > span');
                    my $last_action_text = $last_action->text;
                    my ($last_action_date) = $last_action_text =~ m{(\d+ \s+ [A-Za-z]+ \s+ \d+), \s+ [0-9:]+\z}xms;

                    if( !grep{ $last_action_date eq $_ }@days ) {
                        next TOPICLIST;
                    }

                    my $href = $title->{href};
                    $href =~ s{\A\./}{$base_url};

                    push @threads, {
                        title       => $title->text,
                        href        => $href,
                        last_action => $last_action_date,
                    }
                }
            }
        }
    }
)->wait;

$Data::Dumper::Sortkeys = 1;
say Dumper \@threads;
