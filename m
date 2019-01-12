Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BB65211A1E3B
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:31:06 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 2/4] ndctl,
 inject-smart: switch to ndctl_cmd_submit_xlat
Date: Fri, 11 Jan 2019 18:30:33 -0700
Message-Id: <20190112013035.32087-3-vishal.l.verma@intel.com>
In-Reply-To: <20190112013035.32087-1-vishal.l.verma@intel.com>
References: <20190112013035.32087-1-vishal.l.verma@intel.com>
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
 ndctl/inject-smart.c    | 16 ++++++++--------
 ndctl/util/json-smart.c |  8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index eaa137a..00c81b8 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -280,8 +280,8 @@ static int smart_set_thresh(struct ndctl_dimm *dimm)
 		goto out;
 	}
 
-	rc = ndctl_cmd_submit(st_cmd);
-	if (rc) {
+	rc = ndctl_cmd_submit_xlat(st_cmd);
+	if (rc < 0) {
 		error("%s: smart threshold command failed: %s (%d)\n",
 			name, strerror(abs(rc)), rc);
 		goto out;
@@ -320,8 +320,8 @@ static int smart_set_thresh(struct ndctl_dimm *dimm)
 		ndctl_cmd_smart_threshold_set_alarm_control(sst_cmd, alarm);
 	}
 
-	rc = ndctl_cmd_submit(sst_cmd);
-	if (rc)
+	rc = ndctl_cmd_submit_xlat(sst_cmd);
+	if (rc < 0)
 		error("%s: smart set threshold command failed: %s (%d)\n",
 			name, strerror(abs(rc)), rc);
 
@@ -351,8 +351,8 @@ out:
 			if (sctx.err_continue == false) \
 				goto out; \
 		} \
-		rc = ndctl_cmd_submit(si_cmd); \
-		if (rc) { \
+		rc = ndctl_cmd_submit_xlat(si_cmd); \
+		if (rc < 0) { \
 			error("%s: smart inject %s command failed: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
 			if (sctx.err_continue == false) \
@@ -382,8 +382,8 @@ out:
 			if (sctx.err_continue == false) \
 				goto out; \
 		} \
-		rc = ndctl_cmd_submit(si_cmd); \
-		if (rc) { \
+		rc = ndctl_cmd_submit_xlat(si_cmd); \
+		if (rc < 0) { \
 			error("%s: smart inject %s command failed: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
 			if (sctx.err_continue == false) \
diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 3c1b917..92a9313 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -30,8 +30,8 @@ static void smart_threshold_to_json(struct ndctl_dimm *dimm,
 	if (!cmd)
 		return;
 
-	rc = ndctl_cmd_submit(cmd);
-	if (rc || ndctl_cmd_get_firmware_status(cmd))
+	rc = ndctl_cmd_submit_xlat(cmd);
+	if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd))
 		goto out;
 
 	alarm_control = ndctl_cmd_smart_threshold_get_alarm_control(cmd);
@@ -115,8 +115,8 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 	if (!cmd)
 		goto err;
 
-	rc = ndctl_cmd_submit(cmd);
-	if (rc || ndctl_cmd_get_firmware_status(cmd)) {
+	rc = ndctl_cmd_submit_xlat(cmd);
+	if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd)) {
 		jobj = json_object_new_string("unknown");
 		if (jobj)
 			json_object_object_add(jhealth, "health_state", jobj);
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
