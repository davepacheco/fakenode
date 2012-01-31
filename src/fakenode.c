/*
 * fakenode.c: fake node for testing the fix for node#2667
 */

#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <unistd.h>

#include "node_dtrace.h"
#include <node_provider.h>

int
main(int argc, char *argv[])
{
	node_dtrace_connection_t conn;
	node_dtrace_http_client_request_t crq;
	node_dtrace_http_server_request_t *srqp;

	bzero(&conn, sizeof (conn));
	conn.fd = 10;
	conn.port = 42357;
	conn.remote = "test_address";
	conn.buffered = 12;

	bzero(&crq, sizeof (crq));
	crq.url = "/client/springfield";
	crq.method = "POST";

	/*
	 * We page-align this allocation to test how this works with 64-bit
	 * processes.
	 */
	srqp = valloc(sizeof (*srqp));
	bzero(srqp, sizeof (srqp));
	srqp->url = "/server/power";
	srqp->method = "DELETE";
	srqp->forwardedFor = "homer";

	(void) printf("pid = %d\n", (int)getpid());

	for (;;) {
		NODE_HTTP_CLIENT_REQUEST(&crq, &conn);
		NODE_HTTP_CLIENT_RESPONSE(&conn);
		(void) sleep(1);
		NODE_HTTP_SERVER_REQUEST(srqp, &conn);
		NODE_HTTP_SERVER_RESPONSE(&conn);
		(void) sleep(1);
	}

	return (0);
}
