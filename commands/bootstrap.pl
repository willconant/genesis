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
	system("ssh-keygen -t rsa -C genesis-deployment");
	print "\nStep 1) Add the following key to github:\n\n";
	system("cat /root/.ssh/id_rsa.pub");
	print "\nStep 2) Run bootstrap again like this: ./bootstrap <git-repo-url>\n";
	exit;
}

# WE DO HAVE A KEY, LET'S GET THE REPO
my ($git_repo) = @ARGV;
if ($git_repo eq '') {
	print STDERR "usage: ./bootstrap <git-repo-url>\n";
	exit(1);
}

print "-- INSTALLING GIT\n";
system("apt-get install -y git-core");

print "-- CLONING GIT REPO\n";
system("git clone $git_repo repo");

print "\nnext, do: ./repo/commands/install <admin-username> <environment>\n";
