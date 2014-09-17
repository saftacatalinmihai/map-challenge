use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'app.pl',
  VERSION      => '1.0',
  AUTHOR       => 'Safta Catalin Mihai <saftacatalinmihai@gmail.com>',
  EXE_FILES    => ['app.pl'],
  PREREQ_PM    => { 
  					'Mojolicious' => '2.0', 
  					'Bread::Board' => '0.32',
  					'Search::Elasticsearch' => '1.14',
  					'Data::Printer' => '0.35',
  					'MongoDB' => 'v0.705.0.0',
  					'Log::Log4perl' => '1.44',
  					},
  test         => {TESTS => 't/*.t'}
);