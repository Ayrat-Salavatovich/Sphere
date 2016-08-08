use utf8;
package Sphere::Schema::SphereAppDB::Result::Status;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Sphere::Schema::SphereAppDB::Result::Status

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<statuses>

=cut

__PACKAGE__->table("statuses");

=head1 ACCESSORS

=head2 pk

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'statuses_pk_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pk",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "statuses_pk_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk>

=back

=cut

__PACKAGE__->set_primary_key("pk");

=head1 UNIQUE CONSTRAINTS

=head2 C<statuses_name_key>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("statuses_name_key", ["name"]);

=head1 RELATIONS

=head2 accounts

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Account>

=cut

__PACKAGE__->has_many(
  "accounts",
  "Sphere::Schema::SphereAppDB::Result::Account",
  { "foreign.status_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 doctors

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Doctor>

=cut

__PACKAGE__->has_many(
  "doctors",
  "Sphere::Schema::SphereAppDB::Result::Doctor",
  { "foreign.status_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 events

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Event>

=cut

__PACKAGE__->has_many(
  "events",
  "Sphere::Schema::SphereAppDB::Result::Event",
  { "foreign.status_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 flags

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Flag>

=cut

__PACKAGE__->has_many(
  "flags",
  "Sphere::Schema::SphereAppDB::Result::Flag",
  { "foreign.status_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 posts

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "Sphere::Schema::SphereAppDB::Result::Post",
  { "foreign.status_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 quotas

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Quota>

=cut

__PACKAGE__->has_many(
  "quotas",
  "Sphere::Schema::SphereAppDB::Result::Quota",
  { "foreign.status_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Role>

=cut

__PACKAGE__->has_many(
  "roles",
  "Sphere::Schema::SphereAppDB::Result::Role",
  { "foreign.status_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tables

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Table>

=cut

__PACKAGE__->has_many(
  "tables",
  "Sphere::Schema::SphereAppDB::Result::Table",
  { "foreign.status_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-08 15:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EWb2+gUum5IOjC+jlazrsQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
