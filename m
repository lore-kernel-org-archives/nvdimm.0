Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6019F211B6C23
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 14:53:51 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/3] ndctl, inject-smart: switch to ndctl_cmd_submit_xlat
Date: Fri, 11 Jan 2019 15:53:38 -0700
Message-Id: <20190111225339.6939-3-vishal.l.verma@intel.com>
In-Reply-To: <20190111225339.6939-1-vishal.l.verma@intel.com>
References: <20190111225339.6939-1-vishal.l.verma@intel.com>
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
Cc: Ami Pathak <ami.g.pathak@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The ndctl inject-smart command was neglecting to check the
'firmware_status' field that is set by the platform firmware to indicate
failure. Use the new ndctl_cmd_submit_xlat facility to include the
firmware_status check as part of the command submission.

Reported-by: Ami Pathak <ami.g.pathak@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-smart.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index eaa137a..12f3474 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -280,7 +280,7 @@ static int smart_set_thresh(struct ndctl_dimm *dimm)
 		goto out;
 	}
 
-	rc = ndctl_cmd_submit(st_cmd);
+	rc = ndctl_cmd_submit_xlat(st_cmd);
 	if (rc) {
 		error("%s: smart threshold command failed: %s (%d)\n",
 			name, strerror(abs(rc)), rc);
@@ -320,7 +320,7 @@ static int smart_set_thresh(struct ndctl_dimm *dimm)
 		ndctl_cmd_smart_threshold_set_alarm_control(sst_cmd, alarm);
 	}
 
-	rc = ndctl_cmd_submit(sst_cmd);
+	rc = ndctl_cmd_submit_xlat(sst_cmd);
 	if (rc)
 		error("%s: smart set threshold command failed: %s (%d)\n",
 			name, strerror(abs(rc)), rc);
@@ -351,7 +351,7 @@ out:
 			if (sctx.err_continue == false) \
 				goto out; \
 		} \
-		rc = ndctl_cmd_submit(si_cmd); \
+		rc = ndctl_cmd_submit_xlat(si_cmd); \
 		if (rc) { \
 			error("%s: smart inject %s command failed: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
@@ -382,7 +382,7 @@ out:
 			if (sctx.err_continue == false) \
 				goto out; \
 		} \
-		rc = ndctl_cmd_submit(si_cmd); \
+		rc = ndctl_cmd_submit_xlat(si_cmd); \
 		if (rc) { \
 			error("%s: smart inject %s command failed: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
