#!/usr/bin/env perl
package MapChallange;
use Mojo::Base 'Mojolicious';
use Data::Printer;
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';
use FindBin qw($Bin);

has 'database' => ( is => 'ro' );
has 'places' => (is => 'ro');
has 'search_engine' => ( is => 'ro' );

# Routes
sub startup {
	my $self = shift;
	$self->routes->get('/')->to('base#welcome');
	$self->routes->get('/index')->to('base#index');
	$self->routes->get('/get_places')->to('base#get_places');
	$self->routes->post('/add_place')->to('base#add_place');

	# Add static paths to javascript and css files
	push @{$self->static->paths}, "$Bin/templates/js";
	push @{$self->static->paths}, "$Bin/templates/bower_components";

};

1;