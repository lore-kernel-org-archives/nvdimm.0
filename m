From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [ndctl PATCH 2/2] libndctl: NVDIMM_FAMILY_HYPERV: add
 .smart_get_shutdown_count (Function 2)
Date: Wed, 6 Feb 2019 03:15:24 +0000
Message-ID: <PU1P153MB01693C413FA650C5C39E509DBF6F0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


With the patch, "ndctl list --dimms --health --idle" can show
"shutdown_count" now, e.g.

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

The patch has to directly call ndctl_cmd_submit() in
hyperv_cmd_smart_get_flags() and hyperv_cmd_smart_get_shutdown_count() to
get the needed info, because util_dimm_health_to_json() only submits one
command, and unluckily for Hyper-V Virtual NVDIMM we need to call both
Function 1 and 2 to get the needed info.

My feeling is that it's not good to directly call ndctl_cmd_submit(), but
doing this requires no change to the common code, and I'm unsure if it's
better to change the common code just for Hyper-V.

Signed-off-by: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 ndctl/lib/hyperv.c | 62 ++++++++++++++++++++++++++++++++++++++++------
 ndctl/lib/hyperv.h |  7 ++++++
 2 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/ndctl/lib/hyperv.c b/ndctl/lib/hyperv.c
index b303d50..e8ec142 100644
--- a/ndctl/lib/hyperv.c
+++ b/ndctl/lib/hyperv.c
@@ -22,7 +22,8 @@
 #define CMD_HYPERV_STATUS(_c) (CMD_HYPERV(_c)->u.status)
 #define CMD_HYPERV_SMART_DATA(_c) (CMD_HYPERV(_c)->u.smart.data)
 
-static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+static struct ndctl_cmd *hyperv_dimm_cmd_new_cmd(struct ndctl_dimm *dimm,
+						 unsigned int command)
 {
 	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
@@ -35,8 +36,7 @@ static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 		return NULL;
 	}
 
-	if (test_dimm_dsm(dimm, ND_HYPERV_CMD_GET_HEALTH_INFO) ==
-			  DIMM_DSM_UNSUPPORTED) {
+	if (test_dimm_dsm(dimm, command) ==  DIMM_DSM_UNSUPPORTED) {
 		dbg(ctx, "unsupported function\n");
 		return NULL;
 	}
@@ -54,7 +54,7 @@ static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 
 	hyperv = CMD_HYPERV(cmd);
 	hyperv->gen.nd_family = NVDIMM_FAMILY_HYPERV;
-	hyperv->gen.nd_command = ND_HYPERV_CMD_GET_HEALTH_INFO;
+	hyperv->gen.nd_command = command;
 	hyperv->gen.nd_fw_size = 0;
 	hyperv->gen.nd_size_in = offsetof(struct nd_hyperv_smart, status);
 	hyperv->gen.nd_size_out = sizeof(hyperv->u.smart);
@@ -65,34 +65,74 @@ static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 	return cmd;
 }
 
-static int hyperv_smart_valid(struct ndctl_cmd *cmd)
+static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	return hyperv_dimm_cmd_new_cmd(dimm, ND_HYPERV_CMD_GET_HEALTH_INFO);
+}
+
+static int hyperv_cmd_valid(struct ndctl_cmd *cmd, unsigned int command)
 {
 	if (cmd->type != ND_CMD_CALL ||
 	    cmd->size != sizeof(*cmd) + sizeof(struct nd_pkg_hyperv) ||
 	    CMD_HYPERV(cmd)->gen.nd_family != NVDIMM_FAMILY_HYPERV ||
-	    CMD_HYPERV(cmd)->gen.nd_command != ND_HYPERV_CMD_GET_HEALTH_INFO ||
+	    CMD_HYPERV(cmd)->gen.nd_command != command ||
 	    cmd->status != 0 ||
 	    CMD_HYPERV_STATUS(cmd) != 0)
 		return cmd->status < 0 ? cmd->status : -EINVAL;
 	return 0;
 }
 
+static int hyperv_smart_valid(struct ndctl_cmd *cmd)
+{
+	return hyperv_cmd_valid(cmd, ND_HYPERV_CMD_GET_HEALTH_INFO);
+}
+
 static int hyperv_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
 {
 	return CMD_HYPERV_STATUS(cmd) == 0 ? 0 : -EINVAL;
 }
 
+static int hyperv_get_shutdown_count(struct ndctl_cmd *cmd,
+				     unsigned int *count)
+{
+	unsigned int command = ND_HYPERV_CMD_GET_SHUTDOWN_INFO;
+	struct ndctl_cmd *cmd_get_shutdown_info;
+	int rc;
+
+	cmd_get_shutdown_info = hyperv_dimm_cmd_new_cmd(cmd->dimm, command);
+	if (!cmd_get_shutdown_info)
+		return -EINVAL;
+
+	if (ndctl_cmd_submit(cmd_get_shutdown_info) < 0 ||
+	    hyperv_cmd_valid(cmd_get_shutdown_info, command) < 0) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	*count = CMD_HYPERV(cmd_get_shutdown_info)->u.shutdown_info.count;
+	rc = 0;
+out:
+	ndctl_cmd_unref(cmd_get_shutdown_info);
+	return rc;
+}
+
 static unsigned int hyperv_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 {
 	int rc;
+	unsigned int count;
+	unsigned int flags = 0;
 
 	rc = hyperv_smart_valid(cmd);
 	if (rc < 0) {
 		errno = -rc;
 		return 0;
 	}
+	flags |= ND_SMART_HEALTH_VALID;
 
-	return ND_SMART_HEALTH_VALID;
+	if (hyperv_get_shutdown_count(cmd, &count) == 0)
+		flags |= ND_SMART_SHUTDOWN_COUNT_VALID;
+
+	return flags;
 }
 
 static unsigned int hyperv_cmd_smart_get_health(struct ndctl_cmd *cmd)
@@ -121,9 +161,17 @@ static unsigned int hyperv_cmd_smart_get_health(struct ndctl_cmd *cmd)
 	return health;
 }
 
+static unsigned int hyperv_cmd_smart_get_shutdown_count(struct ndctl_cmd *cmd)
+{
+	unsigned int count;
+
+	return hyperv_get_shutdown_count(cmd, &count) == 0 ? count : UINT_MAX;
+}
+
 struct ndctl_dimm_ops * const hyperv_dimm_ops = &(struct ndctl_dimm_ops) {
 	.new_smart = hyperv_dimm_cmd_new_smart,
 	.smart_get_flags = hyperv_cmd_smart_get_flags,
 	.smart_get_health = hyperv_cmd_smart_get_health,
+	.smart_get_shutdown_count = hyperv_cmd_smart_get_shutdown_count,
 	.xlat_firmware_status = hyperv_cmd_xlat_firmware_status,
 };
diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
index 8e55a97..5232d60 100644
--- a/ndctl/lib/hyperv.h
+++ b/ndctl/lib/hyperv.h
@@ -19,6 +19,7 @@ enum {
 
 	/* non-root commands */
 	ND_HYPERV_CMD_GET_HEALTH_INFO = 1,
+	ND_HYPERV_CMD_GET_SHUTDOWN_INFO = 2,
 };
 
 /*
@@ -38,9 +39,15 @@ struct nd_hyperv_smart {
 	};
 } __attribute__((packed));
 
+struct nd_hyperv_shutdown_info {
+	 __u32   status;
+	 __u32   count;
+} __attribute__((packed));
+
 union nd_hyperv_cmd {
 	__u32			status;
 	struct nd_hyperv_smart	smart;
+	struct nd_hyperv_shutdown_info shutdown_info;
 } __attribute__((packed));
 
 struct nd_pkg_hyperv {
-- 
2.19.1
