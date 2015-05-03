package test;

sub run {
	my %opt;
	GetOptions(
		\%opt;
		'a=s',
		'b=s',
		'c=s',
	);

	print $opt{'a'};

}

1;
