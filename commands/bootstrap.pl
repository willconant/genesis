#!/usr/bin/perl

use strict;
use Cwd;

if (cwd() ne '/root') {
	print STDERR "bootstrap.pl must be run in /root\n";
	exit(1);
}

# IF WE DON'T HAVE A KEY YET, MAKE IT
if (! -e "/root/.ssh/id_rsa.pub") {
	print "-- GENERATING RSA KEY FOR USE WITH REMOTE GIT REPO\n";
	safesys("ssh-keygen -t rsa -C genesis-deployment");
	
	print "\n-- FINISHED. NEXT STEPS:\n";
	print "1) Add the following key to github:\n\n";
	safesys("cat /root/.ssh/id_rsa.pub");
	print "\n2) \$ perl bootstrap.pl <git-repo-url>\n";
	exit;
}

# WE DO HAVE A KEY, LET'S GET THE REPO
my ($git_repo) = @ARGV;
if ($git_repo eq '') {
	print STDERR "usage: perl bootstrap.pl <git-repo-url>\n";
	exit(1);
}

print "-- INSTALLING GIT\n";
safesys("apt-get install -y git-core");

print "-- CLONING GIT REPO\n";
safesys("git clone $git_repo repo");

print "-- FINISHED. NEXT STEP:\n";
print "\$ ./repo/commands/install -e [development|production] -a <your-username>\n";

sub safesys {
	print '> ', join(' ', @_), "\n";
	my $exit_code = system(@_);
	if ($exit_code != 0) {
		die "exit code: $exit_code\n$!";
	}
	return undef;
}
