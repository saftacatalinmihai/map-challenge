#!/usr/bin/env perl
use lib 'lib';
use Bread::Board;
use Data::Printer;

my $dev = container 'Dev' => as {
	container 'Mongo' => as {
		service 'host' => 'localhost';
		service 'port' => '27017';
	};
	container "ElasticSearch" => as {
		service 'host' => 'localhost';
		service 'port' => '9200';
	};
	alias "mongo_host"   => 'Mongo/host';
	alias "mongo_port"   => 'Mongo/port';
	alias "elastic_host" => 'ElasticSearch/host';
	alias "elastic_port" => 'ElasticSearch/port';
};

my $prod = container 'Prod' => as {
	container 'Mongo' => as {
		service 'host' => 'mongodb://admin:a@ds035250.mongolab.com:35250/mapchallenge';
		service 'port' => '35250';
	};
	container "ElasticSearch" => as {
		service 'host' => 'https://d85gv4pa:6vhyka1est2zmdmq@ash-4561628.eu-west-1.bonsai.io:443';
		service 'port' => '443';
	};
	alias "mongo_host"   => 'Mongo/host';
	alias "mongo_port"   => 'Mongo/port';
	alias "elastic_host" => 'ElasticSearch/host';
	alias "elastic_port" => 'ElasticSearch/port';
};


my $c = container 'MapChallange' => ['Env'] => as {

	service 'MapChallangeApp' => (
		class => 'MapChallange',
		lifecycle => 'Singleton',
		dependencies => {
			database => '/MongoDatabase/dbh',
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
				dbh =>'/MongoDatabase/dbh', 
			},
			lifecycle => 'Singleton',
		),
	};
	
	container 'MongoDatabase' => as {
		service 'database' => 'mapchallenge';
		service 'dbh' => (
			block => sub {
				my $s = shift;
				require MongoDB;
				my $client = MongoDB::MongoClient->new(
					host => $s->param('host'), port => $s->param('port'));
				my $db = $client->get_database($s->param('database'));
			},
			dependencies => {
				'database' => 'database',
				'host'     => '/Env/mongo_host',
				'port'	   => '/Env/mongo_port',
			},
			lifecycle => 'Singleton',
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
			lifecycle => 'Singleton',
			dependencies => ['host', 'port']
		);
	};
};

my $env = do {
	if (not defined $ARGV[0]){
		die "Environment not defined as first argument to app.pl ";
	}elsif ($ARGV[0] eq 'dev'){
		print "Running development environment\n";
		$dev;
	}elsif ($ARGV[0] eq 'daemon'){
		print "Running production environment\n";
		$prod;
	}else{ 
		die "Environment not recognized as first argument to app.pl ";
	}
};

my $parametrized_component = $c->create('Env' => $env);
my $MapChallange = $parametrized_component->resolve(service => 'MapChallangeApp');
$MapChallange->secrets(['The cake is a lie, no joke.']);
$MapChallange->start();