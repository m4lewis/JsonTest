use strict;
use warnings;
use LoadData;
use Data::Dumper;
use feature qw(say);


#Holds hash table of a smaller hash table of teachers where the keys 
# are the teacher_ids and the subkeys 'firstname' and 'lastname' hold the first and last names
# respectively
my %teachers = LoadTeachers('teachers.txt');

#Holds hash table key/values  where the key is the class_id and the value is the teacher_id
my %teacher_classes = LoadTeacherClasses('teacherRoster.txt');

#Holds hash table of arrays where the key is the student_id and the array holds the list of
# class_ids
my %student_roster = LoadStudentRoster('studentRoster.txt');


my $student_filename = 'students.txt';
my $csv_filename = 'students_and_teachers.csv';

open my $file, '<', $student_filename or die "Could not open $student_filename: $!";
open my $csv, '>', $csv_filename or die "Could not open $csv_filename: $!";

while (my $row = <$file>) {
	my @objects = split /,/, $row;
	my @id = split /:/, $objects[2];
        my @fname = split /:/, $objects[0];
        my @lname = split /:/, $objects[1];
        my $id_num = $id[1];
        my $first_name = $fname[1];
        my $last_name = $lname[1];
        chomp($id_num);
        chop($id_num);
        chop($first_name);
        chop($last_name);
        substr($first_name, 0, 1, '');
        substr($last_name, 0, 1, '');

	my @class_list = ();

	if ($student_roster{$id_num}) {
		@class_list = @{$student_roster{$id_num}};
	}
	else {
		print "Student $id_num is not enrolled in any classes\n";
		next;
	}
	my %current_teachers = ();

	foreach my $class (@class_list) {
		my @teacher_ids = ();
		my $teacher_id = 'NO_TEACHER_ASSIGNED';
		if (!$teacher_classes{$class}) {
			print "NO TEACHER ASSIGNED FOR CLASS WITH ID = $class\n";	
			next;
		}
		elsif (ref $teacher_classes{$class} eq 'ARRAY') {
			@teacher_ids = @{$teacher_classes{$class}};
		}
		else {
			push @teacher_ids, $teacher_classes{$class};
		}

		foreach my $tid (@teacher_ids) {

			if ($current_teachers{$tid}) {
				#Teacher already added to CSV, skip to next class_id
				next;
			}
			else {
				#Add teacher to %current_teachers so lookup will skip next time if
				# same teacher has a different class with this student
				$current_teachers{$tid} = 1;

				my $teacher_first_name = $teachers{$tid}->{'firstname'};
				my $teacher_last_name = $teachers{$tid}->{'lastname'};
				my $student_csv = "$id_num, $first_name, $last_name";
				my $teacher_csv = "$tid, $teacher_first_name, $teacher_last_name"; 
			
				print $csv "$student_csv, $teacher_csv\n";
			}
		}
	}
}
close($csv);
close($file);
