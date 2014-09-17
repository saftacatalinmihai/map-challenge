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

	# Add to Mongo
	my $collection = $self->app->places;
	$collection->insert(
		{
			name=> $self->req()->param('name'), 
			geo_location => $self->req()->param('geo_location'),
		}
	);

	# my $inserted = $collection->find_one({
	# 	name => $self->req()->param('name'),
	# 	geo_location => $self->req()->param('geo_location')
	# 	});

	# Add to ElasticSearch
	# my $e = $self->app->search_engine();
	# $e->index(
	#     index   => 'mapchallenge',
	#     type    => 'places',
	#     id      => $inserted->{_id}->to_string(),
	#     body    => {
	#         name    	 => $inserted->{name},
	#         geo_location => $inserted->{geo_location},
	#     }
	# );

	$self->render(text => "Place added");
}

sub get_places {
	my $self = shift;

	# Get from Mongo
	my @places = $self->app->places->find()->all;
	my @places_json_array = map {{name => $_->{name}, geo_location => $_->{geo_location}}} @places;

	# Get from ES
	# my $e = $self->app->search_engine();
	# my $results = $e->search(
	#     index => 'mapchallenge',
	#     body  => {
	#     	from => 0,
	#     	size => 10,
	#         query => {
	#             query_string => { query => '*' }
	#         }
	#     }
	# );

	$self->render(json => {places => \@places_json_array});
}

1;