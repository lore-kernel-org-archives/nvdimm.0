Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH 3/4] nvdimm: Add IOCTL pass thru
Date: Fri,  6 Nov 2015 15:27:30 -0700
Message-Id: <2792786733bc18d561ca352d7a642b3989a370fa.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1446684001.git.jerry.hoemann@hpe.com>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1446684001.git.jerry.hoemann@hpe.com>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add functions acpi_nfit_ctl_passthru and __nd_ioctl_passthru which allow
kernel to call a nvdimm's _DSM as a passthru without the marshaling code
of the nd_cmd_desc.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c  |  85 +++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/bus.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 186 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index c1b8d03..a6b458a 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -190,6 +190,90 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
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
+	int rev = 0;
+
+	struct ndn_pkg *pkg = buf;
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
+	rev  = pkg->h.dsm_rev ? pkg->h.dsm_rev : 1;
+
+	in_obj.type = ACPI_TYPE_PACKAGE;
+	in_obj.package.count = 1;
+	in_obj.package.elements = &in_buf;
+	in_buf.type = ACPI_TYPE_BUFFER;
+	in_buf.buffer.pointer = (void *) &pkg->buf;
+
+	in_buf.buffer.length = pkg->h.dsm_in;
+
+	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
+		dev_dbg(dev, "%s:%s cmd: %d input length: %d\n", __func__,
+				dimm_name, cmd, in_buf.buffer.length);
+		print_hex_dump_debug("cmd: ", DUMP_PREFIX_OFFSET, 4,
+				4, in_buf.buffer.pointer, min_t(u32, 128,
+					in_buf.buffer.length), true);
+	}
+
+	out_obj = acpi_evaluate_dsm(handle, uuid, rev, cmd, &in_obj);
+	if (!out_obj) {
+		dev_dbg(dev, "%s:%s _DSM failed cmd: %d\n", __func__, dimm_name,
+				cmd);
+		return -EINVAL;
+	}
+
+	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
+		dev_dbg(dev, "%s:%s unexpected output object type cmd: %d type: %d\n",
+				__func__, dimm_name, cmd, out_obj->type);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
+		dev_dbg(dev, "%s:%s cmd: %d output length: %d\n", __func__,
+				dimm_name, cmd, out_obj->buffer.length);
+		print_hex_dump_debug("cmd: ", DUMP_PREFIX_OFFSET, 4,
+				4, out_obj->buffer.pointer, min_t(u32, 128,
+					out_obj->buffer.length), true);
+	}
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
+
 static const char *spa_type_name(u16 type)
 {
 	static const char *to_name[] = {
@@ -1614,6 +1698,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = "ACPI.NFIT";
 	nd_desc->ndctl = acpi_nfit_ctl;
+	nd_desc->ndctl_passthru = acpi_nfit_ctl_passthru;
 	nd_desc->attr_groups = acpi_nfit_attribute_groups;
 
 	acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, nd_desc);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 7e2c43f..cfb10eb 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -599,18 +599,103 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
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
+	unsigned int size = _IOC_SIZE(ioctl_cmd);
+	void __user *p = (void __user *) arg;
+	struct device *dev = &nvdimm_bus->dev;
+	const char *dimm_name = "";
+	void *buf = NULL;
+	int i, rc;
+	struct ndn_pkg pkg;
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
+	for (i = 0; i < ARRAY_SIZE(pkg.h.res); i++)
+		if (pkg.h.res[i])
+			return -EINVAL;
+
+	/* Caller must tell us size of input to _DSM. */
+	/* This may be bigger that the fixed portion of the pakcage */
+	in_len  = pkg.h.dsm_in;
+	out_len = pkg.h.dsm_out;
+	buf_len = sizeof(pkg.h) + in_len + out_len;
+
+
+	dev_dbg(dev, "%s:%s cmd: %d, size: %d, in: %zu, out: %zu len: %zu\n",
+				__func__,
+				dimm_name, cmd, size,
+				in_len, out_len, buf_len);
+
+	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
+		dev_dbg(dev, "%s:%s cmd: %d buf_len: %zu > %d\n", __func__,
+				dimm_name, cmd, buf_len,
+				ND_IOCTL_MAX_BUFLEN);
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
+	rc = nd_desc->ndctl_passthru(nd_desc, nvdimm, cmd, buf, buf_len);
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
 static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long id = (long) file->private_data;
 	int rc = -ENXIO, read_only;
 	struct nvdimm_bus *nvdimm_bus;
+	unsigned int type = _IOC_TYPE(cmd);
 
 	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
 	mutex_lock(&nvdimm_bus_list_mutex);
 	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
-		if (nvdimm_bus->id == id) {
+		if (nvdimm_bus->id != id)
+			continue;
+
+		switch (type) {
+		case NVDIMM_TYPE_INTEL:
 			rc = __nd_ioctl(nvdimm_bus, NULL, read_only, cmd, arg);
 			break;
+		case NVDIMM_TYPE_PASSTHRU:
+			rc = __nd_ioctl_passthru(nvdimm_bus, NULL, 0, cmd, arg);
+			break;
+		default:
+			rc = -ENOTTY;
 		}
 	}
 	mutex_unlock(&nvdimm_bus_list_mutex);
@@ -633,10 +718,11 @@ static int match_dimm(struct device *dev, void *data)
 
 static long nvdimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	int rc = -ENXIO, read_only;
+	int rc = -ENXIO, ro;
 	struct nvdimm_bus *nvdimm_bus;
+	unsigned int type = _IOC_TYPE(cmd);
 
-	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
+	ro = (O_RDWR != (file->f_flags & O_ACCMODE));
 	mutex_lock(&nvdimm_bus_list_mutex);
 	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
 		struct device *dev = device_find_child(&nvdimm_bus->dev,
@@ -647,7 +733,18 @@ static long nvdimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			continue;
 
 		nvdimm = to_nvdimm(dev);
-		rc = __nd_ioctl(nvdimm_bus, nvdimm, read_only, cmd, arg);
+
+		switch (type) {
+		case NVDIMM_TYPE_INTEL:
+			rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
+			break;
+		case NVDIMM_TYPE_PASSTHRU:
+			rc = __nd_ioctl_passthru(nvdimm_bus, nvdimm, ro, cmd, arg);
+			break;
+		default:
+			rc = -ENOTTY;
+		}
+
 		put_device(dev);
 		break;
 	}
-- 
1.7.11.3

