Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 88E331A1DF5
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 14:25:12 -0700 (PDT)
Subject: [PATCH] nfit: fix format interface code byte order
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Jun 2016 14:23:06 -0700
Message-ID: <146723538651.36406.6119946272192578535.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, Kristin Jacque <kristin.jacque@intel.com>, Robert Moore <robert.moore@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Per JEDEC Annex L Release 3 the SPD data is:

Bits 9~5 00 000 = Function Undefined
         00 001 = Byte addressable energy backed
         00 010 = Block addressed
         00 011 = Byte addressable, no energy backed
         All other codes reserved
Bits 4~0 0 0000 = Proprietary interface
         0 0001 = Standard interface 1
         All other codes reserved; see Definitions of Functions

...and per the ACPI 6.1 spec:

    byte0: Bits 4~0 (0 or 1)
    byte1: Bits 9~5 (1, 2, or 3)

...so a format interface code displayed as 0x301 should be stored in the
nfit as (0x1, 0x3), little-endian.

Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Robert Elliott <elliott@hpe.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=121161
Fixes: 30ec5fd464d5 ("nfit: fix format interface code byte order per ACPI6.1")
Fixes: 5ad9a7fde07a ("acpi/nfit: Update nfit driver to comply with ACPI 6.1")
Reported-by: Kristin Jacque <kristin.jacque@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |    6 +++---
 drivers/acpi/nfit.h |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 32579a7b71d5..ac6ddcc080d4 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -928,7 +928,7 @@ static ssize_t format_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "0x%04x\n", be16_to_cpu(dcr->code));
+	return sprintf(buf, "0x%04x\n", le16_to_cpu(dcr->code));
 }
 static DEVICE_ATTR_RO(format);
 
@@ -961,8 +961,8 @@ static ssize_t format1_show(struct device *dev,
 				continue;
 			if (nfit_dcr->dcr->code == dcr->code)
 				continue;
-			rc = sprintf(buf, "%#x\n",
-					be16_to_cpu(nfit_dcr->dcr->code));
+			rc = sprintf(buf, "0x%04x\n",
+					le16_to_cpu(nfit_dcr->dcr->code));
 			break;
 		}
 		if (rc != ENXIO)
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 11cb38348aef..02b9ea1e8d2e 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -53,12 +53,12 @@ enum nfit_uuids {
 };
 
 /*
- * Region format interface codes are stored as an array of bytes in the
- * NFIT DIMM Control Region structure
+ * Region format interface codes are stored with the interface as the
+ * LSB and the function as the MSB.
  */
-#define NFIT_FIC_BYTE cpu_to_be16(0x101) /* byte-addressable energy backed */
-#define NFIT_FIC_BLK cpu_to_be16(0x201) /* block-addressable non-energy backed */
-#define NFIT_FIC_BYTEN cpu_to_be16(0x301) /* byte-addressable non-energy backed */
+#define NFIT_FIC_BYTE cpu_to_le16(0x101) /* byte-addressable energy backed */
+#define NFIT_FIC_BLK cpu_to_le16(0x201) /* block-addressable non-energy backed */
+#define NFIT_FIC_BYTEN cpu_to_le16(0x301) /* byte-addressable non-energy backed */
 
 enum {
 	NFIT_BLK_READ_FLUSH = 1,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
