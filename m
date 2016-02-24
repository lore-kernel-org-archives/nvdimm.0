Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 7/8] nfit: disable userspace initiated ars during scrub
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Feb 2016 18:17:35 -0800
Message-ID: <20160224021735.22776.23957.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

While the nfit driver is issuing address range scrub commands and
reaping the results do not permit an ars_start command issued from
userspace.  The scrub thread assumes that all ars completions are for
scrubs initiated by platform firmware at boot, or by the nfit driver.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c       |   23 +++++++++++++++++++++++
 drivers/nvdimm/bus.c      |   18 +++++++++++++-----
 include/linux/libnvdimm.h |    2 ++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 8e6a82e7a87f..2be263e1dc92 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -2186,6 +2186,28 @@ static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 	return wait_for_completion_interruptible(&flush.cmp);
 }
 
+static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
+		struct nvdimm *nvdimm, unsigned int cmd)
+{
+	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+
+	if (nvdimm)
+		return 0;
+	if (cmd != ND_CMD_ARS_START)
+		return 0;
+
+	/*
+	 * The kernel and userspace may race to initiate a scrub, but
+	 * the scrub thread is prepared to lose that initial race.  It
+	 * just needs guarantees that any ars it initiates are not
+	 * interrupted by any intervening start reqeusts from userspace.
+	 */
+	if (work_busy(&acpi_desc->work))
+		return -EBUSY;
+
+	return 0;
+}
+
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 {
 	struct nvdimm_bus_descriptor *nd_desc;
@@ -2197,6 +2219,7 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 	nd_desc->provider_name = "ACPI.NFIT";
 	nd_desc->ndctl = acpi_nfit_ctl;
 	nd_desc->flush_probe = acpi_nfit_flush_probe;
+	nd_desc->clear_to_send = acpi_nfit_clear_to_send;
 	nd_desc->attr_groups = acpi_nfit_attribute_groups;
 
 	INIT_LIST_HEAD(&acpi_desc->spa_maps);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 2508251439e7..228c0e9f430e 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -490,16 +490,24 @@ void wait_nvdimm_bus_probe_idle(struct device *dev)
 }
 
 /* set_config requires an idle interleave set */
-static int nd_cmd_clear_to_send(struct nvdimm *nvdimm, unsigned int cmd)
+static int nd_cmd_clear_to_send(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, unsigned int cmd)
 {
-	struct nvdimm_bus *nvdimm_bus;
+	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
+
+	/* ask the bus provider if it would like to block this request */
+	if (nd_desc->clear_to_send) {
+		int rc = nd_desc->clear_to_send(nd_desc, nvdimm, cmd);
+
+		if (rc)
+			return rc;
+	}
 
 	if (!nvdimm || cmd != ND_CMD_SET_CONFIG_DATA)
 		return 0;
 
-	nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
+	/* prevent label manipulation while the kernel owns label updates */
 	wait_nvdimm_bus_probe_idle(&nvdimm_bus->dev);
-
 	if (atomic_read(&nvdimm->busy))
 		return -EBUSY;
 	return 0;
@@ -609,7 +617,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	}
 
 	nvdimm_bus_lock(&nvdimm_bus->dev);
-	rc = nd_cmd_clear_to_send(nvdimm, cmd);
+	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, cmd);
 	if (rc)
 		goto out_unlock;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 2299f8742f7f..833867b9ddc2 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -72,6 +72,8 @@ struct nvdimm_bus_descriptor {
 	char *provider_name;
 	ndctl_fn ndctl;
 	int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
+	int (*clear_to_send)(struct nvdimm_bus_descriptor *nd_desc,
+			struct nvdimm *nvdimm, unsigned int cmd);
 };
 
 struct nd_cmd_desc {
