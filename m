Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4623.austin.hp.com (g2t4623.austin.hp.com [15.73.212.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFDB11A2169
 for <linux-nvdimm@lists.01.org>; Sun, 17 Apr 2016 16:38:56 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC v9 1/5] nvdimm: Add IOCTL pass thru functions
Date: Sun, 17 Apr 2016 17:38:43 -0600
Message-Id: <3e5bf78e359a066ae18debe3921d2f585060785e.1460936121.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1460936121.git.jerry.hoemann@hpe.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1460936121.git.jerry.hoemann@hpe.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
allow kernel to call a nvdimm's _DSM as a passthru without using the
marshaling code of the nd_cmd_desc.

This supports DSM as defined in:

    http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
    https://github.com/HewlettPackard/hpe-nvm/tree/master/Documentation

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c  | 108 +++++++++++++++++++++++++++++++++++++++++++++------
 drivers/nvdimm/bus.c |  43 +++++++++++++++++++-
 2 files changed, 139 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d0f35e6..7dffcb5 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -56,6 +56,24 @@ struct nfit_table_prev {
 	struct list_head flushes;
 };
 
+struct cmd_family_tbl {
+	enum nfit_uuids	key_uuid;	/* Internal handle		*/
+	int		key_type;	/* Exported handle		*/
+	int		rev;		/* _DSM rev			*/
+};
+
+/*
+ * If adding new cmd family, determine maximum function index
+ */
+#define ND_MAX_CMD	20
+
+struct cmd_family_tbl nfit_cmd_family_tbl[] = {
+	{ NFIT_DEV_DIMM,	ND_TYPE_DIMM_INTEL1,	1},
+	{ NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,	1},
+	{ NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,	1},
+	{ -1, -1, -1},
+};
+
 static u8 nfit_uuid[NFIT_UUID_MAX][16];
 
 const u8 *to_nfit_uuid(enum nfit_uuids id)
@@ -64,6 +82,19 @@ const u8 *to_nfit_uuid(enum nfit_uuids id)
 }
 EXPORT_SYMBOL(to_nfit_uuid);
 
+static const u8 *
+family_to_uuid(int type)
+{
+	struct cmd_family_tbl *tbl = nfit_cmd_family_tbl;
+	int i;
+
+	for (i = 0;  tbl[i].key_type >= 0 ; i++) {
+		if (tbl[i].key_type == type)
+			return to_nfit_uuid(tbl[i].key_uuid);
+	}
+	return 0;
+}
+
 static struct acpi_nfit_desc *to_acpi_nfit_desc(
 		struct nvdimm_bus_descriptor *nd_desc)
 {
@@ -171,8 +202,9 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		unsigned int buf_len, int *cmd_rc)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
-	const struct nd_cmd_desc *desc = NULL;
 	union acpi_object in_obj, in_buf, *out_obj;
+	struct nd_cmd_pkg *call_dsm = NULL;
+	const struct nd_cmd_desc *desc = NULL;
 	struct device *dev = acpi_desc->dev;
 	const char *cmd_name, *dimm_name;
 	unsigned long dsm_mask;
@@ -180,6 +212,12 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	const u8 *uuid;
 	u32 offset;
 	int rc, i;
+	__u64 rev = 1, func = cmd;
+
+	if (cmd == ND_CMD_CALL) {
+		call_dsm = buf;
+		func = call_dsm->nd_command;
+	}
 
 	if (nvdimm) {
 		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
@@ -207,7 +245,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
 		return -ENOTTY;
 
-	if (!test_bit(cmd, &dsm_mask))
+	if (!test_bit(func, &dsm_mask))
 		return -ENOTTY;
 
 	in_obj.type = ACPI_TYPE_PACKAGE;
@@ -222,21 +260,44 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
 				i, buf);
 
+	if (call_dsm) {
+		/* must skip over package wrapper */
+		in_buf.buffer.pointer = (void *) &call_dsm->nd_payload;
+		in_buf.buffer.length = call_dsm->nd_size_in;
+		uuid = family_to_uuid(call_dsm->nd_family);
+		if (!uuid) {
+			dev_dbg(dev, "%s:%s unsupported uuid\n", dimm_name,
+					cmd_name);
+			return -EINVAL;
+		}
+	}
+
 	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
-		dev_dbg(dev, "%s:%s cmd: %s input length: %d\n", __func__,
-				dimm_name, cmd_name, in_buf.buffer.length);
-		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
-				4, in_buf.buffer.pointer, min_t(u32, 128,
-					in_buf.buffer.length), true);
+		dev_dbg(dev, "%s:%s cmd: %d: %llu input length: %d\n", __func__,
+				dimm_name, cmd, func, in_buf.buffer.length);
+		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
+			in_buf.buffer.pointer,
+			min_t(u32, 256, in_buf.buffer.length), true);
+
 	}
 
-	out_obj = acpi_evaluate_dsm(handle, uuid, 1, cmd, &in_obj);
+	out_obj = acpi_evaluate_dsm(handle, uuid, rev, func, &in_obj);
 	if (!out_obj) {
 		dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
 				cmd_name);
 		return -EINVAL;
 	}
 
+	if (call_dsm) {
+		call_dsm->nd_fw_size = out_obj->buffer.length;
+		memcpy(call_dsm->nd_payload + call_dsm->nd_size_in,
+			out_obj->buffer.pointer,
+			min(call_dsm->nd_fw_size, call_dsm->nd_size_out));
+
+		ACPI_FREE(out_obj);
+		return 0;
+	}
+
 	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
 		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
 				__func__, dimm_name, cmd_name, out_obj->type);
@@ -918,12 +979,30 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
 	return NULL;
 }
 
+static int determine_uuid(acpi_handle handle, struct cmd_family_tbl *tbl,
+						u8 const **cmd_uuid)
+{
+	int i;
+
+	for (i = 0;  tbl[i].key_uuid >= 0 ; i++) {
+		const u8 *uuid = to_nfit_uuid(tbl[i].key_uuid);
+		int rev = tbl[i].rev;
+
+		if (acpi_check_dsm(handle, uuid, rev, 1ULL)) {
+			*cmd_uuid = uuid;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
 {
 	struct acpi_device *adev, *adev_dimm;
 	struct device *dev = acpi_desc->dev;
-	const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
+	const u8 *uuid;
 	int i;
 
 	nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
@@ -939,7 +1018,12 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		return force_enable_dimms ? 0 : -ENODEV;
 	}
 
-	for (i = ND_CMD_SMART; i <= ND_CMD_VENDOR; i++)
+	if (!determine_uuid(adev_dimm->handle, nfit_cmd_family_tbl,
+							&nfit_mem->dsm_uuid))
+		return force_enable_dimms ? 0 : -ENODEV;
+
+	uuid = nfit_mem->dsm_uuid;
+	for (i = 0; i <= ND_MAX_CMD; i++)
 		if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nfit_mem->dsm_mask);
 
@@ -1012,7 +1096,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	if (!adev)
 		return;
 
-	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_CLEAR_ERROR; i++)
+	for (i = 0; i <= ND_CMD_CLEAR_ERROR; i++)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->dsm_mask);
 }
@@ -2463,6 +2547,8 @@ static __init int nfit_init(void)
 	acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_CD, nfit_uuid[NFIT_SPA_PCD]);
 	acpi_str_to_uuid(UUID_NFIT_BUS, nfit_uuid[NFIT_DEV_BUS]);
 	acpi_str_to_uuid(UUID_NFIT_DIMM, nfit_uuid[NFIT_DEV_DIMM]);
+	acpi_str_to_uuid(UUID_NFIT_DIMM_N_HPE1, nfit_uuid[NFIT_DEV_DIMM_N_HPE1]);
+	acpi_str_to_uuid(UUID_NFIT_DIMM_N_HPE2, nfit_uuid[NFIT_DEV_DIMM_N_HPE2]);
 
 	nfit_wq = create_singlethread_workqueue("nfit");
 	if (!nfit_wq)
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 19f822d..0c1c4ab 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -439,6 +439,12 @@ static const struct nd_cmd_desc __nd_cmd_dimm_descs[] = {
 		.out_num = 3,
 		.out_sizes = { 4, 4, UINT_MAX, },
 	},
+	[ND_CMD_CALL] = {
+		.in_num = 2,
+		.in_sizes = {sizeof(struct nd_cmd_pkg), UINT_MAX, },
+		.out_num = 1,
+		.out_sizes = { UINT_MAX, },
+	},
 };
 
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd)
@@ -473,6 +479,12 @@ static const struct nd_cmd_desc __nd_cmd_bus_descs[] = {
 		.out_num = 3,
 		.out_sizes = { 4, 4, 8, },
 	},
+	[ND_CMD_CALL] = {
+		.in_num = 2,
+		.in_sizes = {sizeof(struct nd_cmd_pkg), UINT_MAX, },
+		.out_num = 1,
+		.out_sizes = { UINT_MAX, },
+	},
 };
 
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd)
@@ -500,6 +512,10 @@ u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
 		struct nd_cmd_vendor_hdr *hdr = buf;
 
 		return hdr->in_length;
+	} else if (cmd == ND_CMD_CALL) {
+		struct nd_cmd_pkg *pkg = buf;
+
+		return pkg->nd_size_in;
 	}
 
 	return UINT_MAX;
@@ -522,6 +538,12 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 		return out_field[1];
 	else if (!nvdimm && cmd == ND_CMD_ARS_STATUS && idx == 2)
 		return out_field[1] - 8;
+	else if (cmd == ND_CMD_CALL) {
+		struct nd_cmd_pkg *pkg =
+				(struct nd_cmd_pkg *) in_field;
+		return pkg->nd_size_out;
+	}
+
 
 	return UINT_MAX;
 }
@@ -588,7 +610,9 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	unsigned int cmd = _IOC_NR(ioctl_cmd);
 	void __user *p = (void __user *) arg;
 	struct device *dev = &nvdimm_bus->dev;
+	struct nd_cmd_pkg call_dsm;
 	const char *cmd_name, *dimm_name;
+	unsigned int func = cmd;
 	unsigned long dsm_mask;
 	void *buf;
 	int rc, i;
@@ -605,8 +629,14 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		dimm_name = "bus";
 	}
 
+	if (cmd == ND_CMD_CALL) {
+		if (copy_from_user(&call_dsm, p, sizeof(call_dsm)))
+			return -EFAULT;
+		func = call_dsm.nd_command;
+	}
+
 	if (!desc || (desc->out_num + desc->in_num == 0) ||
-			!test_bit(cmd, &dsm_mask))
+			!test_bit(func, &dsm_mask))
 		return -ENOTTY;
 
 	/* fail write commands (when read-only) */
@@ -616,6 +646,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		case ND_CMD_SET_CONFIG_DATA:
 		case ND_CMD_ARS_START:
 		case ND_CMD_CLEAR_ERROR:
+		case ND_CMD_CALL:
 			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
 					nvdimm ? nvdimm_cmd_name(cmd)
 					: nvdimm_bus_cmd_name(cmd));
@@ -643,6 +674,16 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		in_len += in_size;
 	}
 
+	if (cmd == ND_CMD_CALL) {
+		dev_dbg(dev, "%s:%s, idx: %llu, in: %zu, out: %zu, len %zu\n",
+				__func__, dimm_name, call_dsm.nd_command,
+				in_len, out_len, buf_len);
+
+		for (i = 0; i < ARRAY_SIZE(call_dsm.nd_reserved2); i++)
+			if (call_dsm.nd_reserved2[i])
+				return -EINVAL;
+	}
+
 	/* process an output envelope */
 	for (i = 0; i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
