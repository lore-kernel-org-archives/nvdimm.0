Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9ADC62020F956
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 13:04:12 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl RFC PATCH] ndctl/namespace: create namespaces greedily
Date: Wed, 28 Aug 2019 14:02:04 -0600
Message-Id: <20190828200204.21750-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Steve Scargal <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

When a --region=all option is supplied to ndctl-create-namespace, it
happily ignores it, since create-namespace has historically only created
one namespace per invocation.

This can be cumbersome, so change create-namespace to create namespaces
greedily. When --region=all is specified, or if a --region option is
absent (same as 'all' from a filtering standpoint), create namespaces on
all regions.

Note that this does has two important implications:

1. The user-facing behavior of create-namespace changes in a potentially
surprising way. It may be undesirable for an unadorned 'ndctl
create-namespace' command to suddenly start creating lots of namespaces.

2. Error handling becomes a bit inconsistent. As with all commands
accepting an 'all' option, error reporting becomes a bit tenuous. With
this change, we will continue to create namespaces so long as we don't
hit an error, but if we do, we bail and exit. Because of the special
ENOSPC detection and handling around this, it can be easy to construct a
scenario where en existing namespace on the last region in the scan list
happens to report an error exit, but if the existing namespace was in a
region at the start of the scan list, it gets passed over as a "just try
the next region"

RFC comment: Maybe the solution is to keep the create-namespace
semantics unchanged, and introduce a new command - 'create-namespaces'
or 'create-names-ace-greedy' with the new behavior. I'm not sure if
users will care deeply about either of the two points above, hence
sending this as an RFC.

Link: https://github.com/pmem/ndctl/issues/106
Reported-by: Steve Scargal <steve.scargall@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/namespace.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index af20a42..856ad82 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1365,9 +1365,12 @@ static int do_xaction_namespace(const char *namespace,
 				rc = namespace_create(region);
 				if (rc == -EAGAIN)
 					continue;
-				if (rc == 0)
-					*processed = 1;
-				return rc;
+				if (rc == 0) {
+					(*processed)++;
+					continue;
+				} else {
+					return rc;
+				}
 			}
 			ndctl_namespace_foreach_safe(region, ndns, _n) {
 				ndns_name = ndctl_namespace_get_devname(ndns);
@@ -1487,6 +1490,8 @@ int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 		rc = do_xaction_namespace(NULL, ACTION_CREATE, ctx, &created);
 	}
 
+	fprintf(stderr, "created %d namespace%s\n", created,
+			created == 1 ? "" : "s");
 	if (rc < 0 || (!namespace && created < 1)) {
 		fprintf(stderr, "failed to %s namespace: %s\n", namespace
 				? "reconfigure" : "create", strerror(-rc));
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
