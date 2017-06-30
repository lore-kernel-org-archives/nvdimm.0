Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C4A921BADADA
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 09:08:24 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v4 3/6] libnvdimm, acpi,
 nfit: Add bus level dsm mask for pass thru.
Date: Fri, 30 Jun 2017 10:09:36 -0600
Message-Id: <293ee143dcabb386ca06b384a384171c256a2ecc.1498810220.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1498810220.git.jerry.hoemann@hpe.com>
References: <cover.1498810220.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1498810220.git.jerry.hoemann@hpe.com>
References: <cover.1498810220.git.jerry.hoemann@hpe.com>
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
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a bus level dsm_mask to nvdimm_bus_descriptor to allow the passthru
calling mechanism to specify a different mask from the cmd_mask.

Populate bus_dsm_mask and use it to filter dsm calls that user can
make through the pass thru interface.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit/core.c  | 8 ++++++++
 include/linux/libnvdimm.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index b46fca2..5e4c137 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -253,6 +253,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		cmd_name = nvdimm_bus_cmd_name(cmd);
 		cmd_mask = nd_desc->cmd_mask;
 		dsm_mask = cmd_mask;
+		if (cmd == ND_CMD_CALL)
+			dsm_mask = nd_desc->bus_dsm_mask;
 		desc = nd_cmd_bus_desc(cmd);
 		uuid = to_nfit_uuid(NFIT_DEV_BUS);
 		handle = adev->handle;
@@ -1613,6 +1615,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
 	const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
 	struct acpi_device *adev;
+	unsigned long dsm_mask;
 	int i;
 
 	nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
@@ -1624,6 +1627,11 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->cmd_mask);
 	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
+
+	dsm_mask = 0x3bf;
+	for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
+		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
+			set_bit(i, &nd_desc->bus_dsm_mask);
 }
 
 static ssize_t range_index_show(struct device *dev,
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 6c80701..f8b8f43 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -54,6 +54,7 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
+	unsigned long bus_dsm_mask;
 	unsigned long cmd_mask;
 	struct module *module;
 	char *provider_name;
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
