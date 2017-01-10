Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B9C0481B01
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:11:47 -0800 (PST)
Subject: [PATCH 3/9] ndctl, create-namespace: improve failure message
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:07:41 -0800
Message-ID: <148401046131.16217.2955532341615686599.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Distinguish failure to find suitable capacity with failures due to
missing capabilities in the kernel.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index b0dd341db829..e260a87e9b1a 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -752,10 +752,8 @@ static int do_xaction_namespace(const char *namespace,
 
 			if (action == ACTION_CREATE && !namespace) {
 				rc = namespace_create(region);
-				if (rc == -EAGAIN) {
-					rc = 0;
+				if (rc == -EAGAIN)
 					continue;
-				}
 				if (rc == 0)
 					rc = 1;
 				return rc;
@@ -788,7 +786,8 @@ static int do_xaction_namespace(const char *namespace,
 		}
 	}
 
-	rc = success;
+	if (success)
+		return success;
 	return rc;
 }
 
@@ -853,8 +852,17 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 	}
 
 	if (created < 0 || (!namespace && created < 1)) {
-		fprintf(stderr, "failed to %s namespace\n", namespace
-				? "reconfigure" : "create");
+		char *reason = "";
+
+		if (created == -EAGAIN)
+			reason = ": no suitable capacity found";
+		else if (created == -ENXIO)
+			reason = ": unsupported configuration";
+		else if (created == -EINVAL)
+			reason = ": invalid argument";
+
+		fprintf(stderr, "failed to %s namespace%s\n", namespace
+				? "reconfigure" : "create", reason);
 		if (!namespace)
 			created = -ENODEV;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
