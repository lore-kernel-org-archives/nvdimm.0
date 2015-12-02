Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 3/3] nvdimm: Add IOCTL pass thru functions
Date: Wed,  2 Dec 2015 14:05:21 -0700
Message-Id: <f8e838fb666b7d05e5e1f7527d643181c6f6ba4d.1449089647.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1449089647.git.jerry.hoemann@hpe.com>
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1449089647.git.jerry.hoemann@hpe.com>
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
allow kernel to call a nvdimm's _DSM as a passthru without using the
marshaling code of the nd_cmd_desc.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c  | 109 ++++++++++++++++++++++++++++++++-------------------
 drivers/nvdimm/bus.c |  61 +++++++++++++++++++++-------
 2 files changed, 115 insertions(+), 55 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index c1b8d03..e509145 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -75,7 +75,11 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	acpi_handle handle;
 	const u8 *uuid;
 	u32 offset;
-	int rc, i;
+	int rc = 0, i;
+	__u64 rev = 1, func = cmd;
+
+	struct nd_cmd_dsmcall_pkg *pkg = buf;
+	int dsm_call = (cmd == ND_CMD_CALL_DSM);
 
 	if (nvdimm) {
 		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
@@ -85,48 +89,62 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			return -ENOTTY;
 		dimm_name = nvdimm_name(nvdimm);
 		cmd_name = nvdimm_cmd_name(cmd);
-		dsm_mask = nfit_mem->dsm_mask;
+		if (!dsm_call)
+			dsm_mask = nfit_mem->dsm_mask;
 		desc = nd_cmd_dimm_desc(cmd);
-		uuid = to_nfit_uuid(NFIT_DEV_DIMM);
+		if (!dsm_call)
+			uuid = to_nfit_uuid(NFIT_DEV_DIMM);
 		handle = adev->handle;
 	} else {
 		struct acpi_device *adev = to_acpi_dev(acpi_desc);
 
 		cmd_name = nvdimm_bus_cmd_name(cmd);
-		dsm_mask = nd_desc->dsm_mask;
+		if (!dsm_call)
+			dsm_mask = nd_desc->dsm_mask;
 		desc = nd_cmd_bus_desc(cmd);
-		uuid = to_nfit_uuid(NFIT_DEV_BUS);
+		if (!dsm_call)
+			uuid = to_nfit_uuid(NFIT_DEV_BUS);
 		handle = adev->handle;
 		dimm_name = "bus";
 	}
 
-	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
-		return -ENOTTY;
+	if (!dsm_call) {
+		if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
+			return -ENOTTY;
 
-	if (!test_bit(cmd, &dsm_mask))
-		return -ENOTTY;
+		if (!test_bit(cmd, &dsm_mask))
+			return -ENOTTY;
+	}
 
 	in_obj.type = ACPI_TYPE_PACKAGE;
 	in_obj.package.count = 1;
 	in_obj.package.elements = &in_buf;
 	in_buf.type = ACPI_TYPE_BUFFER;
-	in_buf.buffer.pointer = buf;
 	in_buf.buffer.length = 0;
 
-	/* libnvdimm has already validated the input envelope */
-	for (i = 0; i < desc->in_num; i++)
-		in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
+	if (dsm_call) {
+		in_buf.buffer.pointer = (void *) &pkg->dsm_buf;
+		in_buf.buffer.length = pkg->h.dsm_in;
+		uuid = pkg->h.dsm_uuid;
+		rev  = pkg->h.dsm_rev;
+		func = pkg->h.dsm_fun_idx;
+	} else {
+		/* libnvdimm has already validated the input envelope */
+		in_buf.buffer.pointer = buf;
+		for (i = 0; i < desc->in_num; i++)
+			in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
 				i, buf);
+	}
 
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
@@ -134,21 +152,28 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	}
 
 	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
-		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
-				__func__, dimm_name, cmd_name, out_obj->type);
+		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s %llu, type: %d\n",
+				__func__, dimm_name, cmd_name, func, out_obj->type);
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
 	}
 
-	for (i = 0, offset = 0; i < desc->out_num; i++) {
+	if (dsm_call) {
+		pkg->h.dsm_size = out_obj->buffer.length;
+		memcpy(pkg->dsm_buf + pkg->h.dsm_in,
+			out_obj->buffer.pointer,
+			min(pkg->h.dsm_size, pkg->h.dsm_out));
+
+	} else {
+		for (i = 0, offset = 0; i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i, buf,
 				(u32 *) out_obj->buffer.pointer);
 
@@ -167,22 +192,23 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		memcpy(buf + in_buf.buffer.length + offset,
 				out_obj->buffer.pointer + offset, out_size);
 		offset += out_size;
-	}
-	if (offset + in_buf.buffer.length < buf_len) {
-		if (i >= 1) {
-			/*
-			 * status valid, return the number of bytes left
-			 * unfilled in the output buffer
-			 */
-			rc = buf_len - offset - in_buf.buffer.length;
-		} else {
-			dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
+		}
+		if (offset + in_buf.buffer.length < buf_len) {
+			if (i >= 1) {
+				/*
+				 * status valid, return the number of bytes left
+				 * unfilled in the output buffer
+				 */
+				rc = buf_len - offset - in_buf.buffer.length;
+			} else {
+				dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
 					__func__, dimm_name, cmd_name, buf_len,
 					offset);
-			rc = -ENXIO;
-		}
-	} else
-		rc = 0;
+				rc = -ENXIO;
+			}
+		} else
+			rc = 0;
+	}
 
  out:
 	ACPI_FREE(out_obj);
@@ -190,6 +216,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	return rc;
 }
 
+
 static const char *spa_type_name(u16 type)
 {
 	static const char *to_name[] = {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 1c81203..83900d50 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -492,31 +492,38 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	struct device *dev = &nvdimm_bus->dev;
 	const char *cmd_name, *dimm_name;
 	unsigned long dsm_mask;
-	void *buf;
+	void *buf = NULL;
 	int rc, i;
 
+	struct nd_cmd_dsmcall_pkg pkg;
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
 
-	if (!desc || (desc->out_num + desc->in_num == 0) ||
-			!test_bit(cmd, &dsm_mask))
-		return -ENOTTY;
+	if (!dsm_call)
+		if (!desc || (desc->out_num + desc->in_num == 0) ||
+				!test_bit(cmd, &dsm_mask))
+			return -ENOTTY;
 
 	/* fail write commands (when read-only) */
 	if (read_only)
-		switch (ioctl_cmd) {
-		case ND_IOCTL_VENDOR:
-		case ND_IOCTL_SET_CONFIG_DATA:
-		case ND_IOCTL_ARS_START:
+		switch (cmd) {
+		case ND_CMD_VENDOR:
+		case ND_CMD_SET_CONFIG_DATA:
+		case ND_CMD_ARS_START:
+		case ND_CMD_CALL_DSM:
 			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
 					nvdimm ? nvdimm_cmd_name(cmd)
 					: nvdimm_bus_cmd_name(cmd));
@@ -526,7 +533,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		}
 
 	/* process an input envelope */
-	for (i = 0; i < desc->in_num; i++) {
+	for (i = 0; !dsm_call && i < desc->in_num; i++) {
 		u32 in_size, copy;
 
 		in_size = nd_cmd_in_size(nvdimm, cmd, desc, i, in_env);
@@ -544,8 +551,31 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		in_len += in_size;
 	}
 
+	if (dsm_call) {
+		/* Caller must tell us size of input to _DSM. */
+		/* This may be bigger that the fixed portion of the pakcage */
+
+		if (copy_from_user(&pkg, p, sizeof(pkg))) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		in_len  = pkg.h.dsm_in;
+		out_len = pkg.h.dsm_out;
+		buf_len = sizeof(pkg.h) + in_len + out_len;
+
+		dev_dbg(dev, "%s:%s rev: %llu, idx: %llu, in: %zu, out: %zu, len %zu\n",
+			__func__, dimm_name,
+			pkg.h.dsm_rev, pkg.h.dsm_fun_idx,
+			in_len, out_len, buf_len);
+
+		for (i = 0; i < ARRAY_SIZE(pkg.h.reserved); i++)
+			if (pkg.h.reserved[i])
+				return -EINVAL;
+	}
+
 	/* process an output envelope */
-	for (i = 0; i < desc->out_num; i++) {
+	for (i = 0; !dsm_call && i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
 				(u32 *) in_env, (u32 *) out_env);
 		u32 copy;
@@ -565,7 +595,9 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		out_len += out_size;
 	}
 
-	buf_len = out_len + in_len;
+	if (!dsm_call)
+		buf_len = out_len + in_len;
+
 	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
 		dev_dbg(dev, "%s:%s cmd: %s buf_len: %zu > %d\n", __func__,
 				dimm_name, cmd_name, buf_len,
@@ -595,7 +627,8 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
  out_unlock:
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
  out:
-	vfree(buf);
+	if (buf)
+		vfree(buf);
 	return rc;
 }
 
-- 
1.7.11.3

