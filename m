Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C476520945549
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 09:08:24 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v4 4/6] acpi, nfit: Show bus_dsm_mask in sysfs
Date: Fri, 30 Jun 2017 10:09:37 -0600
Message-Id: <198c0eaf15bda1fb48dea29ccee1b437206c1635.1498810220.git.jerry.hoemann@hpe.com>
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

Display bus_dsm_mask in sysfs as /sys/bus/nd/devices/ndbusX/nfit/dsm_mask.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5e4c137..4e24d69 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -929,6 +929,17 @@ static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
 	return 0;
 }
 
+static ssize_t bus_dsm_mask_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+
+	return sprintf(buf, "%#lx\n", nd_desc->bus_dsm_mask);
+}
+static struct device_attribute dev_attr_bus_dsm_mask =
+		__ATTR(dsm_mask, 0444, bus_dsm_mask_show, NULL);
+
 static ssize_t revision_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1065,6 +1076,7 @@ static umode_t nfit_visible(struct kobject *kobj, struct attribute *a, int n)
 	&dev_attr_revision.attr,
 	&dev_attr_scrub.attr,
 	&dev_attr_hw_error_scrub.attr,
+	&dev_attr_bus_dsm_mask.attr,
 	NULL,
 };
 
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
