use utf8;
package Sphere::Schema::SphereAppDB::Result::Doctor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Sphere::Schema::SphereAppDB::Result::Doctor

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

=head1 TABLE: C<doctors>

=cut

__PACKAGE__->table("doctors");

=head1 ACCESSORS

=head2 pk

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'doctors_pk_seq'

=head2 first_name

  data_type: 'text'
  is_nullable: 0

=head2 middle_name

  data_type: 'text'
  is_nullable: 0

=head2 last_name

  data_type: 'text'
  is_nullable: 1

=head2 post_fk

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 cabinet

  data_type: 'text'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 status_fk

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "pk",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "doctors_pk_seq",
  },
  "first_name",
  { data_type => "text", is_nullable => 0 },
  "middle_name",
  { data_type => "text", is_nullable => 0 },
  "last_name",
  { data_type => "text", is_nullable => 1 },
  "post_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "cabinet",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "status_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk>

=back

=cut

__PACKAGE__->set_primary_key("pk");

=head1 RELATIONS

=head2 post_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "post_fk",
  "Sphere::Schema::SphereAppDB::Result::Post",
  { pk => "post_fk" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 quotas

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Quota>

=cut

__PACKAGE__->has_many(
  "quotas",
  "Sphere::Schema::SphereAppDB::Result::Quota",
  { "foreign.doctor_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 schedules

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Schedule>

=cut

__PACKAGE__->has_many(
  "schedules",
  "Sphere::Schema::SphereAppDB::Result::Schedule",
  { "foreign.doctor_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 status_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Status>

=cut

__PACKAGE__->belongs_to(
  "status_fk",
  "Sphere::Schema::SphereAppDB::Result::Status",
  { pk => "status_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-08 15:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0iipMs+zqgeMpnYZ99UVYQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
