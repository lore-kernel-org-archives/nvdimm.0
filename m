Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com
 [IPv6:2607:f8b0:4864:20::742])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E2D7211E9FA3
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:38 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id y5so2444933qkc.11
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:38 -0700 (PDT)
From: Dexuan Cui <dexuan.cui@gmail.com>
Subject: [ndctl PATCH v3 2/5] libndctl: Implement the smart_get_shutdown_count
 dimm-op for Hyper-V
Date: Sat, 23 Mar 2019 04:20:26 +0000
Message-Id: <20190323042028.4310-3-decui@microsoft.com>
In-Reply-To: <20190323042028.4310-1-decui@microsoft.com>
References: <20190323042028.4310-1-decui@microsoft.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com, linux-nvdimm@lists.01.org, mikelley@microsoft.com
Cc: qi.fuli@fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

The "smart_get_shutdown_count" dimm-op is expected to return a shutdown
count, but for the Hyper-V family this is only available from a separate
DSM. Perform a command submission in the "hyperv_cmd_get_shutdown_count"
dimm-op and the "hyperv_cmd_get_flags" dimm-op to retrieve this info, so
that a smart health listing can display this info.

Now "ndctl list --dimms --health" can show a line of "shutdown_count"
for Hyper-V NVDIMM, e.g.

{
    "dev":"nmem0",
    "id":"04d5-01-1701-00000000",
    "handle":0,
    "phys_id":0,
    "health":{
      "health_state":"ok",
      "shutdown_count":2
    }
}

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 ndctl/lib/hyperv.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/hyperv.h |  8 ++++++++
 2 files changed, 51 insertions(+)

diff --git a/ndctl/lib/hyperv.c b/ndctl/lib/hyperv.c
index 6ed2125..efd8b03 100644
--- a/ndctl/lib/hyperv.c
+++ b/ndctl/lib/hyperv.c
@@ -72,9 +72,33 @@ static int hyperv_valid_health_info(struct ndctl_cmd *cmd)
 	return hyperv_cmd_valid(cmd, ND_HYPERV_CMD_GET_HEALTH_INFO);
 }
 
+static int hyperv_get_shutdown_count(struct ndctl_cmd *cmd, unsigned int *count)
+{
+	unsigned int command = ND_HYPERV_CMD_GET_SHUTDOWN_INFO;
+	struct ndctl_cmd *cmd_get_shutdown_info;
+	int rc;
+
+	cmd_get_shutdown_info = alloc_hyperv_cmd(cmd->dimm, command);
+	if (!cmd_get_shutdown_info)
+		return -EINVAL;
+
+	if (ndctl_cmd_submit_xlat(cmd_get_shutdown_info) < 0 ||
+	    hyperv_cmd_valid(cmd_get_shutdown_info, command) < 0) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	*count = cmd_get_shutdown_info->hyperv->u.shutdown_info.count;
+	rc = 0;
+out:
+	ndctl_cmd_unref(cmd_get_shutdown_info);
+	return rc;
+}
+
 static unsigned int hyperv_cmd_get_flags(struct ndctl_cmd *cmd)
 {
 	unsigned int flags = 0;
+	unsigned int count;
 	int rc;
 
 	rc = hyperv_valid_health_info(cmd);
@@ -84,6 +108,9 @@ static unsigned int hyperv_cmd_get_flags(struct ndctl_cmd *cmd)
 	}
 	flags |= ND_SMART_HEALTH_VALID;
 
+	if (hyperv_get_shutdown_count(cmd, &count) == 0)
+		flags |= ND_SMART_SHUTDOWN_COUNT_VALID;
+
 	return flags;
 }
 
@@ -113,6 +140,21 @@ static unsigned int hyperv_cmd_get_health(struct ndctl_cmd *cmd)
 	return health;
 }
 
+static unsigned int hyperv_cmd_get_shutdown_count(struct ndctl_cmd *cmd)
+{
+	unsigned int count;
+	int rc;;
+
+	rc = hyperv_get_shutdown_count(cmd, &count);
+
+	if (rc < 0) {
+		errno = -rc;
+		return UINT_MAX;
+	}
+
+	return count;
+}
+
 static int hyperv_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
 {
 	return cmd->hyperv->u.status == 0 ? 0 : -EINVAL;
@@ -122,5 +164,6 @@ struct ndctl_dimm_ops * const hyperv_dimm_ops = &(struct ndctl_dimm_ops) {
 	.new_smart = hyperv_dimm_cmd_new_smart,
 	.smart_get_flags = hyperv_cmd_get_flags,
 	.smart_get_health = hyperv_cmd_get_health,
+	.smart_get_shutdown_count = hyperv_cmd_get_shutdown_count,
 	.xlat_firmware_status = hyperv_cmd_xlat_firmware_status,
 };
diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
index 45bbc12..0c1677f 100644
--- a/ndctl/lib/hyperv.h
+++ b/ndctl/lib/hyperv.h
@@ -9,6 +9,7 @@
 enum {
 	ND_HYPERV_CMD_QUERY_SUPPORTED_FUNCTIONS	= 0,
 	ND_HYPERV_CMD_GET_HEALTH_INFO		= 1,
+	ND_HYPERV_CMD_GET_SHUTDOWN_INFO		= 2,
 };
 
 /* Get Health Information (Function Index 1) */
@@ -17,9 +18,16 @@ struct nd_hyperv_health_info {
 	__u32	health;
 } __attribute__((packed));
 
+/* Get Unsafe Shutdown Count (Function Index 2) */
+struct nd_hyperv_shutdown_info {
+	 __u32   status;
+	 __u32   count;
+} __attribute__((packed));
+
 union nd_hyperv_cmd {
 	__u32				status;
 	struct nd_hyperv_health_info	health_info;
+	struct nd_hyperv_shutdown_info	shutdown_info;
 } __attribute__((packed));
 
 struct nd_pkg_hyperv {
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
