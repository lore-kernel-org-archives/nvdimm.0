Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v5 6/6] nvdimm: Add IOCTL pass thru functions
Date: Wed,  6 Jan 2016 16:03:43 -0700
Message-Id: <1500cd8cc5fa706dbf622541f89ad1d47d318fa3.1452121277.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1452121277.git.jerry.hoemann@hpe.com>
References: <cover.1452121277.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1452121277.git.jerry.hoemann@hpe.com>
References: <cover.1452121277.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: robert.moore@intel.com, lv.zheng@intel.com, rafael.j.wysocki@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
allow kernel to call a nvdimm's _DSM as a passthru without using the
marshaling code of the nd_cmd_desc.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c  | 52 +++++++++++++++++++++++++++++++++++++++-------------
 drivers/nvdimm/bus.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 83 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index aa45d48..015fc8e 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -85,6 +85,10 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	const u8 *uuid;
 	u32 offset;
 	int rc, i;
+	__u64 rev = 1, func = cmd;
+
+	struct nd_cmd_dsmcall_pkg *pkg = buf;
+	int dsm_call = (cmd == ND_CMD_CALL_DSM);
 
 	if (nvdimm) {
 		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
@@ -108,6 +112,8 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		handle = adev->handle;
 		dimm_name = "bus";
 	}
+	if (dsm_call)
+		dsm_mask = ~0UL;
 
 	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
 		return -ENOTTY;
@@ -127,15 +133,25 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
 				i, buf);
 
+	if (dsm_call) {
+		/* must skip over package wrapper */
+		in_buf.buffer.pointer = (void *) &pkg->dsm_buf;
+		in_buf.buffer.length = pkg->h.dsm_in;
+		/* for pass thru must use value sent in from user space. */
+		uuid = pkg->h.dsm_uuid;
+		rev  = pkg->h.dsm_rev;
+		func = pkg->h.dsm_fun_idx;
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
 	}
 
-	out_obj = acpi_evaluate_dsm(handle, uuid, 1, cmd, &in_obj);
+	out_obj = acpi_evaluate_dsm(handle, uuid, rev, func, &in_obj);
 	if (!out_obj) {
 		dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
 				cmd_name);
@@ -143,18 +159,28 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	}
 
 	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
-		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
-				__func__, dimm_name, cmd_name, out_obj->type);
+		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s %llu, type: %d\n",
+			__func__, dimm_name, cmd_name, func, out_obj->type);
 		rc = -EINVAL;
 		goto out;
 	}
 
 	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
-		dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__,
-				dimm_name, cmd_name, out_obj->buffer.length);
-		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
-				4, out_obj->buffer.pointer, min_t(u32, 128,
-					out_obj->buffer.length), true);
+		dev_dbg(dev, "%s:%s cmd %d: %llu output length %d\n", __func__,
+				dimm_name, cmd, func, out_obj->buffer.length);
+		print_hex_dump_debug("nvdimm out ", DUMP_PREFIX_OFFSET, 4, 4,
+			out_obj->buffer.pointer,
+			min_t(u32, 256, out_obj->buffer.length), true);
+	}
+
+	if (dsm_call) {
+		pkg->h.dsm_size = out_obj->buffer.length;
+		memcpy(pkg->dsm_buf + pkg->h.dsm_in,
+			out_obj->buffer.pointer,
+			min(pkg->h.dsm_size, pkg->h.dsm_out));
+
+		ACPI_FREE(out_obj);
+		return 0;
 	}
 
 	for (i = 0, offset = 0; i < desc->out_num; i++) {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 87fe545..8d3a64b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -367,6 +367,12 @@ static const struct nd_cmd_desc __nd_cmd_dimm_descs[] = {
 		.out_num = 3,
 		.out_sizes = { 4, 4, UINT_MAX, },
 	},
+	[ND_CMD_CALL_DSM] = {
+		.in_num = 2,
+		.in_sizes = {sizeof(struct nd_cmd_dsmcall_pkg), UINT_MAX, },
+		.out_num = 1,
+		.out_sizes = { UINT_MAX, },
+	},
 };
 
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd)
@@ -395,6 +401,12 @@ static const struct nd_cmd_desc __nd_cmd_bus_descs[] = {
 		.out_num = 2,
 		.out_sizes = { 4, UINT_MAX, },
 	},
+	[ND_CMD_CALL_DSM] = {
+		.in_num = 2,
+		.in_sizes = {sizeof(struct nd_cmd_dsmcall_pkg), UINT_MAX, },
+		.out_num = 1,
+		.out_sizes = { UINT_MAX, },
+	},
 };
 
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd)
@@ -422,6 +434,10 @@ u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
 		struct nd_cmd_vendor_hdr *hdr = buf;
 
 		return hdr->in_length;
+	} else if (cmd == ND_CMD_CALL_DSM) {
+		struct nd_cmd_dsmcall_pkg *pkg = buf;
+
+		return pkg->h.dsm_in;
 	}
 
 	return UINT_MAX;
@@ -444,6 +460,12 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
 		return out_field[1];
 	else if (!nvdimm && cmd == ND_CMD_ARS_STATUS && idx == 1)
 		return ND_CMD_ARS_STATUS_MAX;
+	else if (cmd == ND_CMD_CALL_DSM) {
+		struct nd_cmd_dsmcall_pkg *pkg =
+				(struct nd_cmd_dsmcall_pkg *) in_field;
+		return pkg->h.dsm_out;
+	}
+
 
 	return UINT_MAX;
 }
@@ -491,19 +513,24 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	void __user *p = (void __user *) arg;
 	struct device *dev = &nvdimm_bus->dev;
 	const char *cmd_name, *dimm_name;
-	unsigned long dsm_mask;
+	unsigned long dsm_mask = ~0UL;
 	void *buf;
 	int rc, i;
 
+	struct nd_cmd_dsmcall_pkg *pkg;
+	int dsm_call = (cmd == ND_CMD_CALL_DSM);
+
 	if (nvdimm) {
 		desc = nd_cmd_dimm_desc(cmd);
 		cmd_name = nvdimm_cmd_name(cmd);
-		dsm_mask = nvdimm->dsm_mask ? *(nvdimm->dsm_mask) : 0;
+		if (!dsm_call)
+			dsm_mask = nvdimm->dsm_mask ? *(nvdimm->dsm_mask) : 0;
 		dimm_name = dev_name(&nvdimm->dev);
 	} else {
 		desc = nd_cmd_bus_desc(cmd);
 		cmd_name = nvdimm_bus_cmd_name(cmd);
-		dsm_mask = nd_desc->dsm_mask;
+		if (!dsm_call)
+			dsm_mask = nd_desc->dsm_mask;
 		dimm_name = "bus";
 	}
 
@@ -517,6 +544,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		case ND_CMD_VENDOR:
 		case ND_CMD_SET_CONFIG_DATA:
 		case ND_CMD_ARS_START:
+		case ND_CMD_CALL_DSM:
 			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
 					nvdimm ? nvdimm_cmd_name(cmd)
 					: nvdimm_bus_cmd_name(cmd));
@@ -544,6 +572,19 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		in_len += in_size;
 	}
 
+	if (dsm_call) {
+		pkg = (struct nd_cmd_dsmcall_pkg *) in_env;
+
+		dev_dbg(dev, "%s:%s rev: %llu, idx: %llu, in: %zu, out: %zu, len %zu\n",
+			__func__, dimm_name,
+			pkg->h.dsm_rev, pkg->h.dsm_fun_idx,
+			in_len, out_len, buf_len);
+
+		for (i = 0; i < ARRAY_SIZE(pkg->h.reserved2); i++)
+			if (pkg->h.reserved2[i])
+				return -EINVAL;
+	}
+
 	/* process an output envelope */
 	for (i = 0; i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
-- 
1.7.11.3

