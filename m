Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH 4/4] nvdimm: rename functions that aren't IOCTL passthru
Date: Fri,  6 Nov 2015 15:27:31 -0700
Message-Id: <05df97cb6646ebcf5111d5bbf09bfe73370ea782.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1446684001.git.jerry.hoemann@hpe.com>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1446684001.git.jerry.hoemann@hpe.com>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

rename functions acpi_nfit_ctl, __nd_ioctl, ndctl, to *_intel to denote
that the functions implement the Intel example _DSM.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c        |  6 +++---
 drivers/nvdimm/bus.c       | 15 ++++++++-------
 drivers/nvdimm/dimm_devs.c |  6 +++---
 include/linux/libnvdimm.h  |  2 +-
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index a6b458a..f85200d 100644
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
@@ -1352,7 +1352,7 @@ static int acpi_nfit_blk_get_flags(struct nvdimm_bus_descriptor *nd_desc,
 	int rc;
 
 	memset(&flags, 0, sizeof(flags));
-	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_DIMM_FLAGS, &flags,
+	rc = nd_desc->ndctl_intel(nd_desc, nvdimm, ND_CMD_DIMM_FLAGS, &flags,
 			sizeof(flags));
 
 	if (rc >= 0 && flags.status == 0)
@@ -1697,7 +1697,7 @@ static int acpi_nfit_add(struct acpi_device *adev)
 	acpi_desc->blk_do_io = acpi_nfit_blk_region_do_io;
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = "ACPI.NFIT";
-	nd_desc->ndctl = acpi_nfit_ctl;
+	nd_desc->ndctl_intel = acpi_nfit_ctl_intel;
 	nd_desc->ndctl_passthru = acpi_nfit_ctl_passthru;
 	nd_desc->attr_groups = acpi_nfit_attribute_groups;
 
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index cfb10eb..4587d30 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -479,8 +479,9 @@ static int nd_cmd_clear_to_send(struct nvdimm *nvdimm, unsigned int cmd)
 	return 0;
 }
 
-static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
-		int read_only, unsigned int ioctl_cmd, unsigned long arg)
+static int __nd_ioctl_intel(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, int read_only, unsigned int ioctl_cmd,
+		unsigned long arg)
 {
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 	size_t buf_len = 0, in_len = 0, out_len = 0;
@@ -587,7 +588,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	if (rc)
 		goto out_unlock;
 
-	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len);
+	rc = nd_desc->ndctl_intel(nd_desc, nvdimm, cmd, buf, buf_len);
 	if (rc < 0)
 		goto out_unlock;
 	if (copy_to_user(p, buf, buf_len))
@@ -677,11 +678,11 @@ static int __nd_ioctl_passthru(struct nvdimm_bus *nvdimm_bus,
 static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long id = (long) file->private_data;
-	int rc = -ENXIO, read_only;
+	int rc = -ENXIO, ro;
 	struct nvdimm_bus *nvdimm_bus;
 	unsigned int type = _IOC_TYPE(cmd);
 
-	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
+	ro = (O_RDWR != (file->f_flags & O_ACCMODE));
 	mutex_lock(&nvdimm_bus_list_mutex);
 	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
 		if (nvdimm_bus->id != id)
@@ -689,7 +690,7 @@ static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		switch (type) {
 		case NVDIMM_TYPE_INTEL:
-			rc = __nd_ioctl(nvdimm_bus, NULL, read_only, cmd, arg);
+			rc = __nd_ioctl_intel(nvdimm_bus, NULL, ro, cmd, arg);
 			break;
 		case NVDIMM_TYPE_PASSTHRU:
 			rc = __nd_ioctl_passthru(nvdimm_bus, NULL, 0, cmd, arg);
@@ -736,7 +737,7 @@ static long nvdimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		switch (type) {
 		case NVDIMM_TYPE_INTEL:
-			rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
+			rc = __nd_ioctl_intel(nvdimm_bus, nvdimm, ro, cmd, arg);
 			break;
 		case NVDIMM_TYPE_PASSTHRU:
 			rc = __nd_ioctl_passthru(nvdimm_bus, nvdimm, ro, cmd, arg);
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 651b8d1..9c0cc23 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -74,7 +74,7 @@ int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd)
 
 	memset(cmd, 0, sizeof(*cmd));
 	nd_desc = nvdimm_bus->nd_desc;
-	return nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
+	return nd_desc->ndctl_intel(nd_desc, to_nvdimm(ndd->dev),
 			ND_CMD_GET_CONFIG_SIZE, cmd, sizeof(*cmd));
 }
 
@@ -118,7 +118,7 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 			offset += cmd->in_length) {
 		cmd->in_length = min(config_size, max_cmd_size);
 		cmd->in_offset = offset;
-		rc = nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
+		rc = nd_desc->ndctl_intel(nd_desc, to_nvdimm(ndd->dev),
 				ND_CMD_GET_CONFIG_DATA, cmd,
 				cmd->in_length + sizeof(*cmd));
 		if (rc || cmd->status) {
@@ -170,7 +170,7 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 		cmd_size = sizeof(*cmd) + cmd->in_length + sizeof(u32);
 		status = ((void *) cmd) + cmd_size - sizeof(u32);
 
-		rc = nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
+		rc = nd_desc->ndctl_intel(nd_desc, to_nvdimm(ndd->dev),
 				ND_CMD_SET_CONFIG_DATA, cmd, cmd_size);
 		if (rc || *status) {
 			rc = rc ? rc : -ENXIO;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 01117e1..594a772 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -71,7 +71,7 @@ struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long dsm_mask;
 	char *provider_name;
-	ndctl_fn ndctl;
+	ndctl_fn ndctl_intel;
 	ndctl_fn ndctl_passthru;
 };
 
-- 
1.7.11.3

