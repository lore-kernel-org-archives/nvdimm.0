Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v2 3/3] nvdimm: Add IOCTL pass thru functions
Date: Mon, 16 Nov 2015 11:38:19 -0700
Message-Id: <e847390b826b48fcc87b2e81a4ff84ae5381a92d.1447698598.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1447698598.git.jerry.hoemann@hpe.com>
References: <cover.1447698598.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1447698598.git.jerry.hoemann@hpe.com>
References: <cover.1447698598.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add functions acpi_nfit_ctl_passthru and __nd_ioctl_passthru which allow
kernel to call a nvdimm's _DSM as a passthru without the marshaling code
of the nd_cmd_desc.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c  | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/bus.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 180 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index c1b8d03..88844af 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -62,7 +62,7 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
 	return to_acpi_device(acpi_desc->dev);
 }
 
-static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
+static int acpi_nfit_ctl_intel(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len)
 {
@@ -190,6 +190,97 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	return rc;
 }
 
+
+static int acpi_nfit_ctl_passthru(struct nvdimm_bus_descriptor *nd_desc,
+		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
+		unsigned int buf_len)
+{
+	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	union acpi_object in_obj, in_buf, *out_obj;
+	struct device *dev = acpi_desc->dev;
+	const char *dimm_name;
+	acpi_handle handle;
+	const u8 *uuid;
+	int rc = 0;
+	__u64 rev = 0, func = 0;
+
+	struct nd_passthru_pkg *pkg = buf;
+
+	if (nvdimm) {
+		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+		struct acpi_device *adev = nfit_mem->adev;
+
+		if (!adev)
+			return -ENOTTY;
+		dimm_name = nvdimm_name(nvdimm);
+		handle = adev->handle;
+	} else {
+		struct acpi_device *adev = to_acpi_dev(acpi_desc);
+
+		handle = adev->handle;
+		dimm_name = "bus";
+	}
+	uuid = pkg->h.dsm_uuid;
+	rev  = pkg->h.dsm_rev;
+	func = pkg->h.dsm_fun_idx;
+
+	in_obj.type = ACPI_TYPE_PACKAGE;
+	in_obj.package.count = 1;
+	in_obj.package.elements = &in_buf;
+	in_buf.type = ACPI_TYPE_BUFFER;
+	in_buf.buffer.pointer = (void *) &pkg->buf;
+
+	in_buf.buffer.length = pkg->h.dsm_in;
+
+	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG))
+		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
+			in_buf.buffer.pointer,
+			min_t(u32, 256, in_buf.buffer.length), true);
+
+	out_obj = acpi_evaluate_dsm(handle, uuid, rev, func, &in_obj);
+	if (!out_obj) {
+		dev_dbg(dev, "%s:%s _DSM failed idx: %llu\n", __func__,
+				dimm_name, func);
+		return -EINVAL;
+	}
+
+	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
+		dev_dbg(dev, "%s:%s unexpected object type: %d type: %d\n",
+				__func__, dimm_name, cmd, out_obj->type);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG))
+		print_hex_dump_debug("nvdimm out ", DUMP_PREFIX_OFFSET, 4, 4,
+			out_obj->buffer.pointer,
+			min_t(u32, 256, out_obj->buffer.length), true);
+
+	pkg->h.dsm_size = out_obj->buffer.length;
+	memcpy(pkg->buf + pkg->h.dsm_in,
+			out_obj->buffer.pointer,
+			min(pkg->h.dsm_size, pkg->h.dsm_out));
+
+
+ out:
+	ACPI_FREE(out_obj);
+
+	return rc;
+}
+
+static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
+		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
+		unsigned int len)
+{
+	switch (cmd) {
+	case ND_CMD_PASSTHRU:
+		return acpi_nfit_ctl_passthru(nd_desc, nvdimm, cmd, buf, len);
+	default:
+		return acpi_nfit_ctl_intel(nd_desc, nvdimm, cmd, buf, len);
+	}
+}
+
+
 static const char *spa_type_name(u16 type)
 {
 	static const char *to_name[] = {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 1c81203..ca7f89c 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -479,7 +479,7 @@ static int nd_cmd_clear_to_send(struct nvdimm *nvdimm, unsigned int cmd)
 	return 0;
 }
 
-static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
+static int __nd_ioctl_intel(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		int read_only, unsigned int ioctl_cmd, unsigned long arg)
 {
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
@@ -599,6 +599,93 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	return rc;
 }
 
+
+static int __nd_ioctl_passthru(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, int read_only, unsigned
+		int ioctl_cmd, unsigned long arg)
+{
+	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
+	size_t buf_len = 0, in_len = 0, out_len = 0;
+	unsigned int cmd = _IOC_NR(ioctl_cmd);
+	void __user *p = (void __user *) arg;
+	struct device *dev = &nvdimm_bus->dev;
+	const char *dimm_name = "";
+	void *buf = NULL;
+	int i, rc;
+	struct nd_passthru_pkg pkg;
+
+	if (nvdimm)
+		dimm_name = dev_name(&nvdimm->dev);
+	else
+		dimm_name = "bus";
+
+	if (copy_from_user(&pkg, p, sizeof(pkg))) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	/* Caller must tell us size of input to _DSM. */
+	/* This may be bigger that the fixed portion of the pakcage */
+	in_len  = pkg.h.dsm_in;
+	out_len = pkg.h.dsm_out;
+	buf_len = sizeof(pkg.h) + in_len + out_len;
+
+	dev_dbg(dev, "%s:%s rev: %llu, idx: %llu, in: %zu, out: %zu, len %zu\n",
+		__func__, dimm_name,
+		pkg.h.dsm_rev, pkg.h.dsm_fun_idx,
+		in_len, out_len, buf_len);
+
+	for (i = 0; i < ARRAY_SIZE(pkg.h.reserved); i++)
+		if (pkg.h.reserved[i])
+			return -EINVAL;
+
+	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
+		dev_dbg(dev, "%s:%s cmd: %d, idx: %llu buf_len: %zu > %d\n",
+			__func__, dimm_name, cmd, pkg.h.dsm_fun_idx,
+			buf_len, ND_IOCTL_MAX_BUFLEN);
+		return -EINVAL;
+	}
+
+	buf = vmalloc(buf_len);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, p, buf_len)) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	rc = nd_cmd_clear_to_send(nvdimm, cmd);
+	if (rc)
+		goto out_unlock;
+
+	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len);
+	if (rc < 0)
+		goto out_unlock;
+	if (copy_to_user(p, buf, buf_len))
+		rc = -EFAULT;
+ out_unlock:
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+ out:
+	vfree(buf);
+	return rc;
+}
+
+static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
+		int ro, unsigned int ioctl_cmd, unsigned long arg)
+
+{
+	unsigned int cmd = _IOC_NR(ioctl_cmd);
+
+	switch (cmd) {
+	case ND_CMD_PASSTHRU:
+		return __nd_ioctl_passthru(nvdimm_bus, nvdimm, ro, ioctl_cmd, arg);
+	default:
+		return __nd_ioctl_intel(nvdimm_bus, nvdimm, ro, ioctl_cmd, arg);
+	}
+}
+
 static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long id = (long) file->private_data;
-- 
1.7.11.3

