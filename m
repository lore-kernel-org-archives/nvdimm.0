Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6213.austin.hp.com (g1t6213.austin.hp.com [15.73.96.121])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A8721A2189
 for <linux-nvdimm@lists.01.org>; Sun, 17 Apr 2016 16:38:57 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC v9 4/5] nvdimm: Add concept of cmd mask
Date: Sun, 17 Apr 2016 17:38:46 -0600
Message-Id: <f94e58ce44103ee3990e611ddb4e63269e278de3.1460936121.git.jerry.hoemann@hpe.com>
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

DSMs have a mask of commands implemented on the DSM.

The current IOCTL interface exported for the NVDIMM DSM maps directly
onto the underlying DSM.

With the addition of the pass thru mechanism, the IOCTL doesn't map
directly onto the underlying DSM functions as the Pass thru isn't itself
a DSM function and some DSM can use only the pass thru.

These changes separate out the concept of a command mask that applies
to function that are supported by the IOCTL and a dsm mask that apply
to the underlying firmware.

There is one noticiable exception, the cmd_mask == the dsm_mask
for root functions.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c        | 26 ++++++++++++++++++++++----
 drivers/acpi/nfit.h        |  1 +
 drivers/nvdimm/bus.c       | 10 ++++------
 drivers/nvdimm/dimm_devs.c | 12 ++++++------
 drivers/nvdimm/nd-core.h   |  2 +-
 include/linux/libnvdimm.h  |  2 +-
 6 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index e3ff10b..fc3e7d9 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -60,6 +60,7 @@ struct cmd_family_tbl {
 	enum nfit_uuids	key_uuid;	/* Internal handle		*/
 	int		key_type;	/* Exported handle		*/
 	int		rev;		/* _DSM rev			*/
+	int		does_ioctls;	/* Family supports all commands? */
 };
 
 /*
@@ -68,9 +69,9 @@ struct cmd_family_tbl {
 #define ND_MAX_CMD	20
 
 struct cmd_family_tbl nfit_cmd_family_tbl[] = {
-	{ NFIT_DEV_DIMM,	ND_TYPE_DIMM_INTEL1,	1},
-	{ NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,	1},
-	{ NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,	1},
+	{ NFIT_DEV_DIMM,	ND_TYPE_DIMM_INTEL1,	1, 1},
+	{ NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,	1, 0},
+	{ NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,	1, 0},
 	{ -1, -1, -1},
 };
 
@@ -996,6 +997,19 @@ static int determine_uuid(acpi_handle handle, struct cmd_family_tbl *tbl,
 	return 0;
 }
 
+static int determine_cmd_mask(struct cmd_family_tbl *tbl, u8 const *cmd_uuid)
+{
+	int i;
+
+	for (i = 0;  tbl[i].key_uuid >= 0 ; i++) {
+		const u8 *uuid = to_nfit_uuid(tbl[i].key_uuid);
+
+		if (memcmp(uuid, cmd_uuid, 16) == 0)
+			return tbl[i].does_ioctls;
+	}
+	return 0;
+}
+
 
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
@@ -1027,6 +1041,10 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nfit_mem->dsm_mask);
 
+	nfit_mem->cmd_mask = (1 << ND_CMD_CALL);
+	if (determine_cmd_mask(nfit_cmd_family_tbl, uuid))
+		nfit_mem->cmd_mask |= nfit_mem->dsm_mask;
+
 	return 0;
 }
 
@@ -1062,7 +1080,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
-				flags, &nfit_mem->dsm_mask);
+				flags, nfit_mem->cmd_mask);
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 7179ea6..e2fcab3 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -114,6 +114,7 @@ struct nfit_mem {
 	struct list_head list;
 	struct acpi_device *adev;
 	unsigned long dsm_mask;
+	unsigned long cmd_mask;
 	const u8 *dsm_uuid;
 };
 
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 5d63ad5..b133301 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -612,31 +612,29 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	struct device *dev = &nvdimm_bus->dev;
 	struct nd_cmd_pkg call_dsm;
 	const char *cmd_name, *dimm_name;
-	unsigned int func = cmd;
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
-		dsm_mask = nd_desc->cmd_mask;
+		cmd_mask = nd_desc->cmd_mask;
 		dimm_name = "bus";
 	}
 
 	if (cmd == ND_CMD_CALL) {
 		if (copy_from_user(&call_dsm, p, sizeof(call_dsm)))
 			return -EFAULT;
-		func = call_dsm.nd_command;
 	}
 
 	if (!desc || (desc->out_num + desc->in_num == 0) ||
-			!test_bit(func, &dsm_mask))
+			!test_bit(cmd, &cmd_mask))
 		return -ENOTTY;
 
 	/* fail write commands (when read-only) */
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c56f882..b86b45a 100644
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
@@ -277,10 +277,10 @@ static ssize_t commands_show(struct device *dev,
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
@@ -340,7 +340,7 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long *dsm_mask)
+		unsigned long cmd_mask)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -355,7 +355,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	}
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
-	nvdimm->dsm_mask = dsm_mask;
+	nvdimm->cmd_mask = cmd_mask;
 	atomic_set(&nvdimm->busy, 0);
 	dev = &nvdimm->dev;
 	dev_set_name(dev, "nmem%d", nvdimm->id);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 1d1500f..da0d322 100644
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
index 67a1ba0..41c975a 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -133,7 +133,7 @@ const char *nvdimm_name(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long *dsm_mask);
+		unsigned long cmd_mask);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
