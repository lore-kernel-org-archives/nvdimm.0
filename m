Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C3F81A1EE5
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 14:43:46 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with ACPI 6.1
Date: Mon, 25 Apr 2016 15:34:58 -0600
Message-Id: <1461620099-11933-2-git-send-email-toshi.kani@hpe.com>
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

ACPI 6.1, Table 5-133, updates NVDIMM Control Region Structure
as follows.
 - Valid Fields, Manufacturing Location, and Manufacturing Date
   are added from reserved range.  No change in the structure size.
 - IDs (SPD values) are stored as arrays of bytes (i.e. big-endian
   format).  The spec clarifies that they need to be represented
   as arrays of bytes as well.

This patch makes the following changes to support this update.
 - Change the NFIT driver to show SPD ID values in big-endian
   format.
 - Change sprintf format to use "0x" instead of "#" since "%#02x"
   does not prepend '0'.

link: http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Robert Elliott <elliott@hpe.com>
---
 drivers/acpi/nfit.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d0f35e6..5dc243c 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -816,7 +816,7 @@ static ssize_t vendor_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->vendor_id);
+	return sprintf(buf, "0x%04x\n", be16_to_cpu(dcr->vendor_id));
 }
 static DEVICE_ATTR_RO(vendor);
 
@@ -825,7 +825,7 @@ static ssize_t rev_id_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->revision_id);
+	return sprintf(buf, "0x%04x\n", be16_to_cpu(dcr->revision_id));
 }
 static DEVICE_ATTR_RO(rev_id);
 
@@ -834,7 +834,7 @@ static ssize_t device_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->device_id);
+	return sprintf(buf, "0x%04x\n", be16_to_cpu(dcr->device_id));
 }
 static DEVICE_ATTR_RO(device);
 
@@ -843,7 +843,7 @@ static ssize_t format_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->code);
+	return sprintf(buf, "0x%04x\n", be16_to_cpu(dcr->code));
 }
 static DEVICE_ATTR_RO(format);
 
@@ -852,7 +852,7 @@ static ssize_t serial_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->serial_number);
+	return sprintf(buf, "0x%08x\n", be32_to_cpu(dcr->serial_number));
 }
 static DEVICE_ATTR_RO(serial);
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
