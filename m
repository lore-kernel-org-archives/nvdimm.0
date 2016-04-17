Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6216.austin.hp.com (g1t6216.austin.hp.com [15.73.96.123])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F03B01A219F
 for <linux-nvdimm@lists.01.org>; Sun, 17 Apr 2016 16:38:56 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC v9 2/5] libnvdimm: nvdimm_bus_descriptor field name change
Date: Sun, 17 Apr 2016 17:38:44 -0600
Message-Id: <a5d2d13d5e68ab1bb7b24a5b52dd945845e43dcb.1460936121.git.jerry.hoemann@hpe.com>
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

Change the the name of:

        nvdimm_bus_descriptor.dsm_mask
to
        nvdimm_bus_descriptor.cmd_mask

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.c              | 6 +++---
 drivers/nvdimm/bus.c             | 2 +-
 drivers/nvdimm/core.c            | 2 +-
 include/linux/libnvdimm.h        | 2 +-
 tools/testing/nvdimm/test/nfit.c | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 7dffcb5..e3ff10b 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -235,7 +235,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		struct acpi_device *adev = to_acpi_dev(acpi_desc);
 
 		cmd_name = nvdimm_bus_cmd_name(cmd);
-		dsm_mask = nd_desc->dsm_mask;
+		dsm_mask = nd_desc->cmd_mask;
 		desc = nd_cmd_bus_desc(cmd);
 		uuid = to_nfit_uuid(NFIT_DEV_BUS);
 		handle = adev->handle;
@@ -1091,14 +1091,14 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 	struct acpi_device *adev;
 	int i;
 
-	nd_desc->dsm_mask = acpi_desc->bus_dsm_force_en;
+	nd_desc->cmd_mask = acpi_desc->bus_dsm_force_en;
 	adev = to_acpi_dev(acpi_desc);
 	if (!adev)
 		return;
 
 	for (i = 0; i <= ND_CMD_CLEAR_ERROR; i++)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
-			set_bit(i, &nd_desc->dsm_mask);
+			set_bit(i, &nd_desc->cmd_mask);
 }
 
 static ssize_t range_index_show(struct device *dev,
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 0c1c4ab..5d63ad5 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -625,7 +625,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	} else {
 		desc = nd_cmd_bus_desc(cmd);
 		cmd_name = nvdimm_bus_cmd_name(cmd);
-		dsm_mask = nd_desc->dsm_mask;
+		dsm_mask = nd_desc->cmd_mask;
 		dimm_name = "bus";
 	}
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 182a93f..e8688a1 100644
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
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index af31d1c..67a1ba0 100644
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
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 3187322..1d3b8ce 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -374,7 +374,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	} else {
 		struct ars_state *ars_state = &t->ars_state;
 
-		if (!nd_desc || !test_bit(cmd, &nd_desc->dsm_mask))
+		if (!nd_desc || !test_bit(cmd, &nd_desc->cmd_mask))
 			return -ENOTTY;
 
 		switch (cmd) {
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
