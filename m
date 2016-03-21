Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4623.austin.hp.com (g2t4623.austin.hp.com [15.73.212.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B8921A1FEB
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 12:37:57 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v8 09/10] nvdimm: sysfs shows which dsm support full command
 ioctl.
Date: Mon, 21 Mar 2016 13:37:09 -0600
Message-Id: <a016b07e1705c6b37ae9aa4d0a1896e6b7eb6f75.1458583367.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
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

NVDIMM DSMs whose functions map to the Intel Example DSM, can
be called with the ND_IOCTL_.* ioctl interface.  Those that
don't map, can only be called with the pass thru command.

Save this indication in struct nvdimm to be passed to
the sysfs interface.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c        | 25 +++++++++++++++----------
 drivers/nvdimm/core.c      |  1 +
 drivers/nvdimm/dimm_devs.c | 12 ++++++++----
 include/linux/libnvdimm.h  |  2 +-
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 8d933b3..a35b939 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -61,14 +61,15 @@ struct cmd_family_tbl {
 	int		key_type;	/* Exported handle		*/
 	int		rev;		/* _DSM rev			*/
 	u64		mask;		/* 0 bit excludes underlying func.*/
+	int		cmd_ioctl;	/* supports full cmd ioctl interface */
 };
 
 struct cmd_family_tbl nfit_cmd_family_tbl[] = {
-	{ NFIT_DEV_BUS,		ND_TYPE_BUS,		1, ~0UL},
-	{ NFIT_DEV_DIMM,	ND_TYPE_DIMM_INTEL1,	1, ~0UL},
-	{ NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,	1, ~0UL},
-	{ NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,	1, ~0UL},
-	{ -1, -1, -1, 0},
+	{ NFIT_DEV_BUS,		ND_TYPE_BUS,		1, ~0UL, 1},
+	{ NFIT_DEV_DIMM,	ND_TYPE_DIMM_INTEL1,	1, ~0UL, 1},
+	{ NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,	1, ~0UL, 0},
+	{ NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,	1, ~0UL, 0},
+	{ -1, -1, -1, -1, 0},
 };
 
 static u8 nfit_uuid[NFIT_UUID_MAX][16];
@@ -264,8 +265,8 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		in_buf.buffer.length = call_dsm->nd_size_in;
 		uuid = family_to_uuid(call_dsm->nd_family);
 		if (!uuid) {
-			dev_dbg(dev, "%s:%s unsupported uuid\n", dimm_name,
-					cmd_name);
+			dev_dbg(dev, "%s unsupported cmd family: %lld\n",
+					dimm_name, call_dsm->nd_family);
 			return -EINVAL;
 		}
 	}
@@ -1009,7 +1010,8 @@ static int acpi_nfit_sup_func(acpi_handle handle, const u8 *uuid,
 
 static inline void
 to_nfit_uuid_msk(acpi_handle handle, struct cmd_family_tbl *tbl,
-		u8 const **cmd_uuid, unsigned long *cmd_mask)
+		u8 const **cmd_uuid, unsigned long *cmd_mask,
+		int *cmd_ioctl)
 {
 	unsigned long mask = 0;
 	int i;
@@ -1021,6 +1023,7 @@ to_nfit_uuid_msk(acpi_handle handle, struct cmd_family_tbl *tbl,
 		if (acpi_nfit_sup_func(handle, uuid, rev, &mask)) {
 			*cmd_mask = mask & tbl[i].mask;
 			*cmd_uuid = uuid;
+			*cmd_ioctl = tbl[i].cmd_ioctl;
 			break;
 		}
 	}
@@ -1046,7 +1049,8 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	}
 
 	to_nfit_uuid_msk(adev_dimm->handle, nfit_cmd_family_tbl,
-			&nfit_mem->dsm_uuid, &nfit_mem->dsm_mask);
+			&nfit_mem->dsm_uuid, &nfit_mem->dsm_mask,
+			&nfit_mem->cmd_ioctl);
 
 	return 0;
 }
@@ -1083,7 +1087,8 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
-				flags, &nfit_mem->dsm_mask);
+				flags, &nfit_mem->dsm_mask,
+				nfit_mem->cmd_ioctl);
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index ce80767..24da865 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -253,6 +253,7 @@ static ssize_t commands_show(struct device *dev,
 
 	for_each_set_bit(cmd, &nd_desc->cmd_mask, BITS_PER_LONG)
 		len += sprintf(buf + len, "%s ", nvdimm_bus_cmd_name(cmd));
+	len += sprintf(buf + len, "%s ", nvdimm_cmd_name(ND_CMD_CALL));
 	len += sprintf(buf + len, "\n");
 	return len;
 }
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c56f882..65614b2 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -274,14 +274,17 @@ EXPORT_SYMBOL_GPL(nvdimm_provider_data);
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 	int cmd, len = 0;
 
-	if (!nvdimm->dsm_mask)
+	if (!nvdimm->dsm_mask || !nvdimm_bus)
 		return sprintf(buf, "\n");
 
-	for_each_set_bit(cmd, nvdimm->dsm_mask, BITS_PER_LONG)
-		len += sprintf(buf + len, "%s ", nvdimm_cmd_name(cmd));
+	if (nvdimm->cmd_ioctl)
+		for_each_set_bit(cmd, nvdimm->dsm_mask, BITS_PER_LONG)
+			len += sprintf(buf + len, "%s ", nvdimm_cmd_name(cmd));
+	len += sprintf(buf + len, "%s ", nvdimm_cmd_name(ND_CMD_CALL));
 	len += sprintf(buf + len, "\n");
 	return len;
 }
@@ -340,7 +343,7 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long *dsm_mask)
+		unsigned long *dsm_mask, int cmd_ioctl)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -356,6 +359,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->dsm_mask = dsm_mask;
+	nvdimm->cmd_ioctl = cmd_ioctl;
 	atomic_set(&nvdimm->busy, 0);
 	dev = &nvdimm->dev;
 	dev_set_name(dev, "nmem%d", nvdimm->id);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 67a1ba0..154986a 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -133,7 +133,7 @@ const char *nvdimm_name(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long *dsm_mask);
+		unsigned long *dsm_mask, int cmd_ioctl);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
