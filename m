Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5370A1A1F20
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 14:43:47 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 2/2] acpi/nfit: Add sysfs "id" for NVDIMM ID
Date: Mon, 25 Apr 2016 15:34:59 -0600
Message-Id: <1461620099-11933-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
References: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
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
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, robert.moore@intel.com, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1, section 5.2.25.9, defines an identifier for an NVDIMM.

Change the NFIT driver to add a new sysfs file "id" under nfit
directory.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Robert Elliott <elliott@hpe.com>
---
 drivers/acpi/nfit.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 5dc243c..5a7199d 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -870,6 +870,24 @@ static ssize_t flags_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(flags);
 
+static ssize_t id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
+		return sprintf(buf, "%04x-%02x-%04x-%08x\n",
+				be16_to_cpu(dcr->vendor_id),
+				dcr->manufacturing_location,
+				be16_to_cpu(dcr->manufacturing_date),
+				be32_to_cpu(dcr->serial_number));
+	else
+		return sprintf(buf, "%04x-%08x\n",
+				be16_to_cpu(dcr->vendor_id),
+				be32_to_cpu(dcr->serial_number));
+}
+static DEVICE_ATTR_RO(id);
+
 static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_handle.attr,
 	&dev_attr_phys_id.attr,
@@ -879,6 +897,7 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_serial.attr,
 	&dev_attr_rev_id.attr,
 	&dev_attr_flags.attr,
+	&dev_attr_id.attr,
 	NULL,
 };
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
