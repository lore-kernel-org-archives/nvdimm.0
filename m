Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 024CE225501D9
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 16:12:05 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/3] ndctl, inject-smart: fix usage of strerror(errno)
Date: Thu, 29 Mar 2018 17:18:35 -0600
Message-Id: <20180329231836.29453-2-vishal.l.verma@intel.com>
In-Reply-To: <20180329231836.29453-1-vishal.l.verma@intel.com>
References: <20180329231836.29453-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We were incorrectly using strerror(errno) for a number of libndctl
calls, which is incorrect, as libndctl doesn't set errno.
Instead, use the return code from the API to print the error.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-smart.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 45dbc8d..60de9fe 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -232,8 +232,8 @@ static int smart_set_thresh(struct ndctl_dimm *dimm)
 
 	rc = ndctl_cmd_submit(st_cmd);
 	if (rc) {
-		error("%s: smart threshold command failed: %s\n",
-			name, strerror(errno));
+		error("%s: smart threshold command failed: %s (%d)\n",
+			name, strerror(abs(rc)), rc);
 		goto out;
 	}
 
@@ -272,8 +272,8 @@ static int smart_set_thresh(struct ndctl_dimm *dimm)
 
 	rc = ndctl_cmd_submit(sst_cmd);
 	if (rc)
-		error("%s: smart set threshold command failed: %s\n",
-			name, strerror(errno));
+		error("%s: smart set threshold command failed: %s (%d)\n",
+			name, strerror(abs(rc)), rc);
 
 out:
 	ndctl_cmd_unref(sst_cmd);
@@ -291,14 +291,14 @@ out:
 		} \
 		rc = ndctl_cmd_smart_inject_##arg(si_cmd, true, sctx.arg); \
 		if (rc) { \
-			error("%s: smart inject %s cmd invalid: %s\n", \
-				name, #arg, strerror(errno)); \
+			error("%s: smart inject %s cmd invalid: %s (%d)\n", \
+				name, #arg, strerror(abs(rc)), rc); \
 			goto out; \
 		} \
 		rc = ndctl_cmd_submit(si_cmd); \
 		if (rc) { \
-			error("%s: smart inject %s command failed: %s\n", \
-				name, #arg, strerror(errno)); \
+			error("%s: smart inject %s command failed: %s (%d)\n", \
+				name, #arg, strerror(abs(rc)), rc); \
 			goto out; \
 		} \
 		ndctl_cmd_unref(si_cmd); \
@@ -315,14 +315,14 @@ out:
 		} \
 		rc = ndctl_cmd_smart_inject_##arg(si_cmd, true); \
 		if (rc) { \
-			error("%s: smart inject %s cmd invalid: %s\n", \
-				name, #arg, strerror(errno)); \
+			error("%s: smart inject %s cmd invalid: %s (%d)\n", \
+				name, #arg, strerror(abs(rc)), rc); \
 			goto out; \
 		} \
 		rc = ndctl_cmd_submit(si_cmd); \
 		if (rc) { \
-			error("%s: smart inject %s command failed: %s\n", \
-				name, #arg, strerror(errno)); \
+			error("%s: smart inject %s command failed: %s (%d)\n", \
+				name, #arg, strerror(abs(rc)), rc); \
 			goto out; \
 		} \
 		ndctl_cmd_unref(si_cmd); \
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
