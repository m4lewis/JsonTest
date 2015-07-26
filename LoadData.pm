package LoadData;

use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(LoadTeachers LoadTeacherClasses LoadStudentRoster);

##################################
#SUB#
#LoadTeachers(filename, idorder, fnameorder, lnameorder)
#Purpose: Sub used to import given filename and arrange content into returned hash table
#Arguments:
# filename = filename to import from
# idorder = the order the id field is present within the data (split upon commas)
# fnameorder = the order the first_name field is present within the data
# lnameorder = the order the last_name field is present within the data
#END SUB#
##################################
sub LoadTeachers {
	my $filename = shift;

	open my $file, '<', $filename or die "Could not open $filename: $!";
	my %hash = ();

	while (my $row = <$file>) {
		my @objects = split /,/, $row;
		my @id = split /:/, $objects[0];
		my @fname = split /:/, $objects[1];
		my @lname = split /:/, $objects[2];
		my $id_num = $id[1];
		my $first_name = $fname[1];
		my $last_name = $lname[1];
		chomp($last_name);
		chop($last_name);
		chop($first_name);
		chop($last_name);
		substr($first_name, 0, 1, '');
		substr($last_name, 0, 1, '');
		$hash{$id_num}->{'firstname'} = $first_name;
		$hash{$id_num}->{'lastname'} = $last_name;
	}
	close($file);
	return %hash;	
}

sub LoadStudentRoster {
	my $filename = shift;
	open my $file, '<', $filename or die "Could not open $filename: $!";
	my %hash = ();

	while (my $row = <$file>) {
		my @objects = split /,/, $row;
		my @sid = split /:/, $objects[0];
		my @cid = split /:/, $objects[1];
		my $student_id = $sid[1];
		my $class_id = $cid[1];
		chomp($class_id);
		chop($class_id);

		push @{ $hash{$student_id} }, $class_id;
	}
	
	close($file);
	return %hash;
	
}

sub LoadTeacherClasses {
	my $filename = shift;
	open my $file, '<', $filename or die "Could not open $filename: $!";
	my %hash = ();

	while (my $row = <$file>) {
		my @objects = split /,/, $row;
		my @tid = split /:/, $objects[0];
		my @cid = split /:/, $objects[1];
		my $teacher_id = $tid[1];
		my $class_id = $cid[1];
		chomp($class_id);
		chop($class_id);

		##push @{ $hash{$object_id} }, $class_id;
		
		#Multiple teachers listed for this class
		if($hash{$class_id}) {
			if(ref $hash{$class_id} ne 'ARRAY') {
				#Store original teacher temporarily
				my $temp = $hash{$class_id};
				#Set to empty array to hold more than one teacher
				$hash{$class_id} = [];
				push @{ $hash{$class_id} }, $temp;	
				push @{ $hash{$class_id} }, $teacher_id;	
			}
			else {
				#MORE THAN TWO TEACHERS LISTED FOR THIS CLASS
				push @{ $hash{$class_id} }, $teacher_id;	
			}
		}
		else {
			#Only one teacher listed for this class so far
			$hash{$class_id} = $teacher_id;
		}
	}
	
	close($file);
	return %hash;
	
}

1;

__END__
