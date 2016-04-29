Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 1F5141A1F68
 for <linux-nvdimm@lists.01.org>; Thu, 28 Apr 2016 19:43:31 -0700 (PDT)
Subject: [PATCH v11 1/5] nfit, libnvdimm: clarify "commands" vs "_DSMs"
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Apr 2016 19:42:28 -0700
Message-ID: <146189774794.29835.11997438198616276280.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Clarify the distinction between "commands", the ioctls userspace calls
to request the kernel take some action on a given dimm device, and
"_DSMs", the actual function numbers used in the firmware interface to
the DIMM.  _DSMs are ACPI specific whereas commands are Linux kernel
generic.

This is in preparation for breaking the 1:1 implicit relationship
between the kernel ioctl number space and the firmware specific function
numbers.

Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c              |   21 +++++++++++++--------
 drivers/acpi/nfit.h              |    4 ++--
 drivers/nvdimm/bus.c             |    8 ++++----
 drivers/nvdimm/core.c            |    2 +-
 drivers/nvdimm/dimm_devs.c       |   18 ++++++++++++------
 drivers/nvdimm/nd-core.h         |    2 +-
 include/linux/libnvdimm.h        |    5 +++--
 tools/testing/nvdimm/test/nfit.c |   27 ++++++++++++++-------------
 8 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d0f35e63640b..1b98e9dc6138 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -175,7 +175,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	union acpi_object in_obj, in_buf, *out_obj;
 	struct device *dev = acpi_desc->dev;
 	const char *cmd_name, *dimm_name;
-	unsigned long dsm_mask;
+	unsigned long cmd_mask;
 	acpi_handle handle;
 	const u8 *uuid;
 	u32 offset;
@@ -189,7 +189,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			return -ENOTTY;
 		dimm_name = nvdimm_name(nvdimm);
 		cmd_name = nvdimm_cmd_name(cmd);
-		dsm_mask = nfit_mem->dsm_mask;
+		cmd_mask = nvdimm_cmd_mask(nvdimm);
 		desc = nd_cmd_dimm_desc(cmd);
 		uuid = to_nfit_uuid(NFIT_DEV_DIMM);
 		handle = adev->handle;
@@ -197,7 +197,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		struct acpi_device *adev = to_acpi_dev(acpi_desc);
 
 		cmd_name = nvdimm_bus_cmd_name(cmd);
-		dsm_mask = nd_desc->dsm_mask;
+		cmd_mask = nd_desc->cmd_mask;
 		desc = nd_cmd_bus_desc(cmd);
 		uuid = to_nfit_uuid(NFIT_DEV_BUS);
 		handle = adev->handle;
@@ -207,7 +207,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
 		return -ENOTTY;
 
-	if (!test_bit(cmd, &dsm_mask))
+	if (!test_bit(cmd, &cmd_mask))
 		return -ENOTTY;
 
 	in_obj.type = ACPI_TYPE_PACKAGE;
@@ -926,7 +926,8 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
 	int i;
 
-	nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
+	/* nfit test assumes 1:1 relationship between commands and dsms */
+	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
 	adev = to_acpi_dev(acpi_desc);
 	if (!adev)
 		return 0;
@@ -976,9 +977,13 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (rc)
 			continue;
 
+		/*
+		 * For now there is 1:1 relationship between cmd_mask and
+		 * dsm_mask.
+		 */
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
-				flags, &nfit_mem->dsm_mask);
+				flags, nfit_mem->dsm_mask);
 		if (!nvdimm)
 			return -ENOMEM;
 
@@ -1007,14 +1012,14 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	struct acpi_device *adev;
 	int i;
 
-	nd_desc->dsm_mask = acpi_desc->bus_dsm_force_en;
+	nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
 	adev = to_acpi_dev(acpi_desc);
 	if (!adev)
 		return;
 
 	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_CLEAR_ERROR; i++)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
-			set_bit(i, &nd_desc->dsm_mask);
+			set_bit(i, &nd_desc->cmd_mask);
 }
 
 static ssize_t range_index_show(struct device *dev,
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index c75576b2d50e..332ee6f01662 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -132,8 +132,8 @@ struct acpi_nfit_desc {
 	size_t ars_status_size;
 	struct work_struct work;
 	unsigned int cancel:1;
-	unsigned long dimm_dsm_force_en;
-	unsigned long bus_dsm_force_en;
+	unsigned long dimm_cmd_force_en;
+	unsigned long bus_cmd_force_en;
 	int (*blk_do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
 			void *iobuf, u64 len, int rw);
 };
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 19f822d7f652..cb2042a12b76 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -589,24 +589,24 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	void __user *p = (void __user *) arg;
 	struct device *dev = &nvdimm_bus->dev;
 	const char *cmd_name, *dimm_name;
-	unsigned long dsm_mask;
+	unsigned long cmd_mask;
 	void *buf;
 	int rc, i;
 
 	if (nvdimm) {
 		desc = nd_cmd_dimm_desc(cmd);
 		cmd_name = nvdimm_cmd_name(cmd);
-		dsm_mask = nvdimm->dsm_mask ? *(nvdimm->dsm_mask) : 0;
+		cmd_mask = nvdimm->cmd_mask;
 		dimm_name = dev_name(&nvdimm->dev);
 	} else {
 		desc = nd_cmd_bus_desc(cmd);
 		cmd_name = nvdimm_bus_cmd_name(cmd);
-		dsm_mask = nd_desc->dsm_mask;
+		cmd_mask = nd_desc->cmd_mask;
 		dimm_name = "bus";
 	}
 
 	if (!desc || (desc->out_num + desc->in_num == 0) ||
-			!test_bit(cmd, &dsm_mask))
+			!test_bit(cmd, &cmd_mask))
 		return -ENOTTY;
 
 	/* fail write commands (when read-only) */
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 182a93fe3712..e8688a13cf4f 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -251,7 +251,7 @@ static ssize_t commands_show(struct device *dev,
 	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 
-	for_each_set_bit(cmd, &nd_desc->dsm_mask, BITS_PER_LONG)
+	for_each_set_bit(cmd, &nd_desc->cmd_mask, BITS_PER_LONG)
 		len += sprintf(buf + len, "%s ", nvdimm_bus_cmd_name(cmd));
 	len += sprintf(buf + len, "\n");
 	return len;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c56f88217924..79a35a02053c 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -37,9 +37,9 @@ static int __validate_dimm(struct nvdimm_drvdata *ndd)
 
 	nvdimm = to_nvdimm(ndd->dev);
 
-	if (!nvdimm->dsm_mask)
+	if (!nvdimm->cmd_mask)
 		return -ENXIO;
-	if (!test_bit(ND_CMD_GET_CONFIG_DATA, nvdimm->dsm_mask))
+	if (!test_bit(ND_CMD_GET_CONFIG_DATA, &nvdimm->cmd_mask))
 		return -ENXIO;
 
 	return 0;
@@ -263,6 +263,12 @@ const char *nvdimm_name(struct nvdimm *nvdimm)
 }
 EXPORT_SYMBOL_GPL(nvdimm_name);
 
+unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm)
+{
+	return nvdimm->cmd_mask;
+}
+EXPORT_SYMBOL_GPL(nvdimm_cmd_mask);
+
 void *nvdimm_provider_data(struct nvdimm *nvdimm)
 {
 	if (nvdimm)
@@ -277,10 +283,10 @@ static ssize_t commands_show(struct device *dev,
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 	int cmd, len = 0;
 
-	if (!nvdimm->dsm_mask)
+	if (!nvdimm->cmd_mask)
 		return sprintf(buf, "\n");
 
-	for_each_set_bit(cmd, nvdimm->dsm_mask, BITS_PER_LONG)
+	for_each_set_bit(cmd, &nvdimm->cmd_mask, BITS_PER_LONG)
 		len += sprintf(buf + len, "%s ", nvdimm_cmd_name(cmd));
 	len += sprintf(buf + len, "\n");
 	return len;
@@ -340,7 +346,7 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long *dsm_mask)
+		unsigned long cmd_mask)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -355,7 +361,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	}
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
-	nvdimm->dsm_mask = dsm_mask;
+	nvdimm->cmd_mask = cmd_mask;
 	atomic_set(&nvdimm->busy, 0);
 	dev = &nvdimm->dev;
 	dev_set_name(dev, "nmem%d", nvdimm->id);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 1d1500f3d8b5..da0d322ed7cb 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -37,7 +37,7 @@ struct nvdimm_bus {
 struct nvdimm {
 	unsigned long flags;
 	void *provider_data;
-	unsigned long *dsm_mask;
+	unsigned long cmd_mask;
 	struct device dev;
 	atomic_t busy;
 	int id;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index af31d1c6fdd7..0c3c30cbbea5 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -68,7 +68,7 @@ struct nd_mapping {
 
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
-	unsigned long dsm_mask;
+	unsigned long cmd_mask;
 	char *provider_name;
 	ndctl_fn ndctl;
 	int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
@@ -130,10 +130,11 @@ struct nd_region *to_nd_region(struct device *dev);
 struct nd_blk_region *to_nd_blk_region(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 const char *nvdimm_name(struct nvdimm *nvdimm);
+unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long *dsm_mask);
+		unsigned long cmd_mask);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 3187322eeed7..ed899a411c22 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -344,8 +344,9 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 
 	if (nvdimm) {
 		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+		unsigned long cmd_mask = nvdimm_cmd_mask(nvdimm);
 
-		if (!nfit_mem || !test_bit(cmd, &nfit_mem->dsm_mask))
+		if (!nfit_mem || !test_bit(cmd, &cmd_mask))
 			return -ENOTTY;
 
 		/* lookup label space for the given dimm */
@@ -374,7 +375,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	} else {
 		struct ars_state *ars_state = &t->ars_state;
 
-		if (!nd_desc || !test_bit(cmd, &nd_desc->dsm_mask))
+		if (!nd_desc || !test_bit(cmd, &nd_desc->cmd_mask))
 			return -ENOTTY;
 
 		switch (cmd) {
@@ -1251,13 +1252,13 @@ static void nfit_test0_setup(struct nfit_test *t)
 	post_ars_status(&t->ars_state, t->spa_set_dma[0], SPA0_SIZE);
 
 	acpi_desc = &t->acpi_desc;
-	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_dsm_force_en);
-	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
-	set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
-	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
-	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
-	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
-	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_dsm_force_en);
+	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_cmd_force_en);
 }
 
 static void nfit_test1_setup(struct nfit_test *t)
@@ -1315,10 +1316,10 @@ static void nfit_test1_setup(struct nfit_test *t)
 	post_ars_status(&t->ars_state, t->spa_set_dma[0], SPA2_SIZE);
 
 	acpi_desc = &t->acpi_desc;
-	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
-	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
-	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
-	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_dsm_force_en);
+	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_cmd_force_en);
 }
 
 static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
