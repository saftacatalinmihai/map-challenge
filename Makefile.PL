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
  					},
  test         => {TESTS => 't/*.t'}
);