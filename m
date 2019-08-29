Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47D522021B6F9
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 17:19:41 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/3] ndctl/namespace: add a --continue option to create
 namespaces greedily
Date: Wed, 28 Aug 2019 18:17:35 -0600
Message-Id: <20190829001735.30289-4-vishal.l.verma@intel.com>
In-Reply-To: <20190829001735.30289-1-vishal.l.verma@intel.com>
References: <20190829001735.30289-1-vishal.l.verma@intel.com>
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
Cc: Steve Scargall <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a --continue option to ndctl-create-namespaces to allow the creation
of as many namespaces as possible, that meet the given filter
restrictions.

The creation loop will be aborted if a failure is encountered at any
point.

Link: https://github.com/pmem/ndctl/issues/106
Reported-by: Steve Scargal <steve.scargall@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .../ndctl/ndctl-create-namespace.txt          |  7 ++++++
 ndctl/namespace.c                             | 25 +++++++++++++++----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index c9ae27c..55a8581 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -215,6 +215,13 @@ include::xable-region-options.txt[]
 --bus=::
 include::xable-bus-options.txt[]
 
+-c::
+--continue::
+	Do not stop after creating one namespace. Instead, greedily create as
+	many namespaces as possible within the given --bus and --region filter
+	restrictions. This will abort if any creation attempt results in an
+	error.
+
 include::../copyright.txt[]
 
 SEE ALSO
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index af20a42..8d6b249 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -41,6 +41,7 @@ static struct parameters {
 	bool do_scan;
 	bool mode_default;
 	bool autolabel;
+	bool greedy;
 	const char *bus;
 	const char *map;
 	const char *type;
@@ -114,7 +115,9 @@ OPT_STRING('t', "type", &param.type, "type", \
 OPT_STRING('a', "align", &param.align, "align", \
 	"specify the namespace alignment in bytes (default: 2M)"), \
 OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active"), \
-OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels")
+OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels"), \
+OPT_BOOLEAN('c', "continue", &param.greedy, \
+	"continue creating namespaces as long as the filter criteria are met")
 
 #define CHECK_OPTIONS() \
 OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
@@ -1365,8 +1368,11 @@ static int do_xaction_namespace(const char *namespace,
 				rc = namespace_create(region);
 				if (rc == -EAGAIN)
 					continue;
-				if (rc == 0)
-					*processed = 1;
+				if (rc == 0) {
+					(*processed)++;
+					if (param.greedy)
+						continue;
+				}
 				return rc;
 			}
 			ndctl_namespace_foreach_safe(region, ndns, _n) {
@@ -1427,9 +1433,15 @@ static int do_xaction_namespace(const char *namespace,
 		/*
 		 * Namespace creation searched through all candidate
 		 * regions and all of them said "nope, I don't have
-		 * enough capacity", so report -ENOSPC
+		 * enough capacity", so report -ENOSPC. Except during
+		 * greedy namespace creation using --continue as we
+		 * may have created some namespaces already, and the
+		 * last one in the region search may preexist.
 		 */
-		rc = -ENOSPC;
+		if (param.greedy && (*processed) > 0)
+			rc = 0;
+		else
+			rc = -ENOSPC;
 	}
 
 	return rc;
@@ -1487,6 +1499,9 @@ int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
 		rc = do_xaction_namespace(NULL, ACTION_CREATE, ctx, &created);
 	}
 
+	if (param.greedy)
+		fprintf(stderr, "created %d namespace%s\n", created,
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
