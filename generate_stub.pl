#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Time::Piece;
use Path::Tiny;

my $week = $ARGV[0];

if ( !$week ) {
    my $now  = localtime;
    $now += 7 * 24 * 60 * 60;
    $week = sprintf "%04d-%02d", $now->year, $now->week;
}

if ( $week !~ m{\A[0-9]{4}-[0-9]{2}\z} ) {
    die "invalid week: $week!";
}

# create file in drafts directory
my $content;
{
    local $/;
    $content = <DATA>;
}

path( Path::Tiny->cwd . '/drafts/' . $week . '.md' )->spew_utf8( $content );

__DATA__
Date: # TODO
Editor: Renée Bäcker
Title: # TODO


#TODO: Intro

<hr>

# Announcements

<hr>

# Events

<hr>

# Blogposts

<hr>

# Interesting Otterhub threads

<hr>

# Addon updates

## New OPAR addons

## New commercial addons
