package MapChallange::Controller::Base;
use Mojo::Base 'Mojolicious::Controller';
use Data::Printer;
use DateTime;
use JSON::XS;

sub welcome {
    my $self = shift;
    $self->render( 'text' => "Hello World" );
}

sub index {
    my $self = shift;
    $self->render( template => 'index', format => 'html' );
}

sub add_place {
    my $self = shift;

    my $now        = DateTime->now;

    # Add to Mongo
    my $collection = $self->app->places;
    my $json_entry = $self->req->json;

    $json_entry->{timeStamp} = $now;
    my $id = $collection->insert($json_entry);

    # Add to ElasticSearch
    my $e = $self->app->search_engine();
    $json_entry->{timeStamp} = $now->datetime();
    $e->index(
        index => 'mapchallenge',
        type  => 'places',
        id    => $id->to_string(),
        body  => $json_entry,
    );

    $self->render( json => {response => "Place added"} );
}

sub get_places {
    my $self = shift;

    # Get from Mongo
    my @places = $self->app->places->find()->all;
    my @places_json_array
        = map { { name => $_->{name}, geo_location => $_->{geo_location} } }
        @places;

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

    $self->render( json => { places => \@places_json_array } );
}

1;
