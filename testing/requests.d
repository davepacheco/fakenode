#!/usr/sbin/dtrace -s

#pragma D option quiet

BEGIN
{
	printf("%7s %2s %5s %20s (%5s) %8s %s (%s)\n",
	    "WHO", "FD", "RPORT", "REMOTE", "BUFFR", "METHOD", "URL", "FWDFOR");
}

node$1:::http-server-request
{
	printf("+SERVER %2d %5d %20s (%5d) %8s %s (%s)\n",
	    args[1]->fd, args[1]->remotePort, args[1]->remoteAddress,
	    args[1]->bufferSize,
	    args[0]->method, args[0]->url, args[0]->forwardedFor);
}

node$1:::http-server-response
{
	printf("-SERVER %2d %5d %20s (%5d)\n",
	    args[0]->fd, args[0]->remotePort, args[0]->remoteAddress,
	    args[0]->bufferSize);
}

node$1:::http-client-request
{
	printf("+CLIENT %2d %5d %20s (%5d) %8s %s\n",
	    args[1]->fd, args[1]->remotePort, args[1]->remoteAddress,
	    args[1]->bufferSize,
	    args[0]->method, args[0]->url);
}

node$1:::http-client-response
{
	printf("-CLIENT %2d %5d %20s (%5d)\n",
	    args[0]->fd, args[0]->remotePort, args[0]->remoteAddress,
	    args[0]->bufferSize);
}
