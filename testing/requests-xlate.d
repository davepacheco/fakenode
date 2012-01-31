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
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg1))->fd,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg1))->remotePort,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg1))->remoteAddress,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg1))->bufferSize,
	    (xlate <node_http_request_t*>((node_dtrace_http_server_request_t *)arg0))->method,
	    (xlate <node_http_request_t*>((node_dtrace_http_server_request_t *)arg0))->url,
	    (xlate <node_http_request_t*>((node_dtrace_http_server_request_t *)arg0))->forwardedFor);
}

node$1:::http-server-response
{
	printf("-SERVER %2d %5d %20s (%5d)\n",
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg0))->fd,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg0))->remotePort,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg0))->remoteAddress,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg0))->bufferSize);
}

node$1:::http-client-request
{
	printf("+CLIENT %2d %5d %20s (%5d) %8s %s\n",
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg1))->fd,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg1))->remotePort,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg1))->remoteAddress,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg1))->bufferSize,
	    (xlate <node_http_request_t*>((node_dtrace_http_client_request_t *)arg0))->method,
	    (xlate <node_http_request_t*>((node_dtrace_http_client_request_t *)arg0))->url);
}

node$1:::http-client-response
{
	printf("-CLIENT %2d %5d %20s (%5d)\n",
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg0))->fd,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg0))->remotePort,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg0))->remoteAddress,
	    (xlate <node_connection_t*>((node_dtrace_connection_t *)arg0))->bufferSize);
}
