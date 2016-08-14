use utf8;
package Sphere::Schema::SphereAppDB::Result::Patient;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Sphere::Schema::SphereAppDB::Result::Patient

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

=head1 TABLE: C<patients>

=cut

__PACKAGE__->table("patients");

=head1 ACCESSORS

=head2 pk

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'patients_pk_seq'

=head2 account_fk

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 first_name

  data_type: 'text'
  is_nullable: 0

=head2 middle_name

  data_type: 'text'
  is_nullable: 0

=head2 last_name

  data_type: 'text'
  is_nullable: 1

=head2 card

  data_type: 'text'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 is_valid_policy_number

  data_type: 'boolean'
  default_value: false
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pk",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "patients_pk_seq",
  },
  "account_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "first_name",
  { data_type => "text", is_nullable => 0 },
  "middle_name",
  { data_type => "text", is_nullable => 0 },
  "last_name",
  { data_type => "text", is_nullable => 1 },
  "card",
  { data_type => "text", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "is_valid_policy_number",
  { data_type => "boolean", default_value => \"false", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk>

=back

=cut

__PACKAGE__->set_primary_key("pk");

=head1 RELATIONS

=head2 account_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Account>

=cut

__PACKAGE__->belongs_to(
  "account",
  "Sphere::Schema::SphereAppDB::Result::Account",
  { pk => "account_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 schedules

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Schedule>

=cut

__PACKAGE__->has_many(
  "schedules",
  "Sphere::Schema::SphereAppDB::Result::Schedule",
  { "foreign.patient_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-08 15:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Zgh06mX1Jwhi64AWedF31Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
