package Sphere::Schema::SphereAppDB::ResultSet::Patient;

use Moose;
use namespace::autoclean;

extends 'DBIx::Class::ResultSet';
with 'Sphere::Schema::SphereAppDB::Role::InflateAsHashRef';

1;
