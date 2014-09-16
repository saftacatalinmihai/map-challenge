#!/usr/bin/env perl
use lib 'lib';
use Bread::Board;
use Data::Printer;

my $c = container 'MapChallange' => as {

	service 'MapChallangeApp' => (
		class => 'MapChallange',
		lifecycle => 'Singleton',
		dependencies => {
			database => '/Database/dbh',
			places   => '/Collections/places',
			search_engine => '/Search/search_engine',
		}
	);

	container "Collections" => as {
		service 'places' => (
			block => sub {
				my $s = shift;
				my $database   = $s->param('dbh');
				my $collection = $database->get_collection('places');
			},
			dependencies => { 
				dbh =>'/Database/dbh', 
			}
		),
	};

	container 'Database' => as {
		service 'host' => 'localhost';
		service 'port' => '27017';
		service 'heroku_host' => 'mongodb://admin:a@ds035250.mongolab.com:35250/mapchallenge';
		service 'heroku_port' => '35250';
		service 'database' => 'mapchallenge';
		service 'dbh' => (
			block => sub {
				my $s = shift;
				require MongoDB;
				my $client = MongoDB::MongoClient->new(
					host => $s->param('heroku_host'), port => $s->param('heroku_port'));
				my $db = $client->get_database($s->param('database'));
			},
			dependencies => ['heroku_host', 'heroku_port', 'database']
		);
	};

	container 'Search' => as {
		service 'host' => 'localhost';
		service 'port' => '9200';
		service 'search_engine' => (
			block => sub {
				my $s = shift;
				require  Search::Elasticsearch;
				my $es = Search::Elasticsearch->new(
				    nodes => $s->param('host').":".$s->param('port'),
				    cxn_pool => 'Sniff',
				); 
			},
			dependencies => ['host', 'port']
		);
	};
};

my $MapChallange = $c->resolve(service => 'MapChallangeApp');
$MapChallange->start();