package MapChallange::Controller::Base;
use Mojo::Base 'Mojolicious::Controller';
use Data::Printer;

sub welcome {
	my $self = shift;
	$self->render('text' => "Hello World");
}

sub index {
	my $self = shift;
	$self->render(template => 'index', format => 'html');
}

sub add_place {
	my $self = shift;
	my $collection = $self->app->places;
	$collection->insert(
		{
			name=> $self->req()->param('name'), 
			geo_location => $self->req()->param('geo_location'),
		}
	);
	$self->render(text => "Place added");
}

sub get_places {
	my $self = shift;
	my $collection = $self->app->places;
	my @places = $collection->find()->all;
	my @json_array = map {{name => $_->{name}, geo_location => $_->{geo_location}}} @places;

	$self->render(json => {places => \@json_array});
}

1;