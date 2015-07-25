use strict;
use warnings;
use Data::Dumper;
use feature qw(say);

#Holds hash table of a smaller hash table of teachers where the keys 
# are the teacher_ids and the subkeys 'firstname' and 'lastname' hold the first and last names
# respectively
my %teachers = LoadStudentsOrTeachers('teachers.txt', 0, 1, 2);

#Holds hash table of a smaller hash table of students where the keys 
# are the student_ids and the subkeys 'firstname' and 'lastname' hold the first and last names
# respectively
my %students = LoadStudentsOrTeachers('students.txt', 2, 0, 1);

#Holds hash table of arrays where the key is the teacher_id and the array holds the list of
# class_ids
my %teacherRoster = LoadStudentOrTeacherRoster('teacherRoster.txt');

#Holds hash table of arrays where the key is the student_id and the array holds the list of
# class_ids
my %studentRoster = LoadStudentOrTeacherRoster('studentRoster.txt');
print Dumper \%teacherRoster;

##################################
#SUB#
#LoadStudentsOrTeachers(filename, idorder, fnameorder, lnameorder)
#Purpose: Sub used to import given filename and arrange content into returned hash table
#Arguments:
# filename = filename to import from
# idorder = the order the id field is present within the data (split upon commas)
# fnameorder = the order the first_name field is present within the data
# lnameorder = the order the last_name field is present within the data
sub LoadStudentsOrTeachers {
	my $filename = shift;
	my $idorder = shift;
	my $fnameorder = shift;
	my $lnameorder = shift;

	open my $file, '<', $filename or die "Could not open $filename: $!";
	my %hash = ();

	while (my $row = <$file>) {
		my @objects = split /,/, $row;
		my @id = split /:/, $objects[$idorder];
		my @fname = split /:/, $objects[$fnameorder];
		my @lname = split /:/, $objects[$lnameorder];
		my $id_num = $id[1];
		my $first_name = $fname[1];
		my $last_name = $lname[1];

		if ($lnameorder == 2) {
			chomp($last_name);
			chop($last_name);
		}
		else {
			chomp($id_num);
			chop($id_num);
		}

		chop($first_name);
		chop($last_name);
		substr($first_name, 0, 1, '');
		substr($last_name, 0, 1, '');
		$hash{$id_num}->{'firstname'} = $first_name;
		$hash{$id_num}->{'lastname'} = $last_name;
	}
	return %hash;	
}

sub LoadStudentOrTeacherRoster {
	my $filename = shift;
	open my $file, '<', $filename or die "Could not open $filename: $!";
	my %hash = ();

	while (my $row = <$file>) {
		my @objects = split /,/, $row;
		my @oid = split /:/, $objects[0];
		my @cid = split /:/, $objects[1];
		my $object_id = $oid[1];
		my $class_id = $cid[1];
		chomp($class_id);
		chop($class_id);

		push @{ $hash{$object_id} }, $class_id;
	}
	
	return %hash;
	
}


