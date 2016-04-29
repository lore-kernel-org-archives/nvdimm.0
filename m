Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 4EE211A1E42
 for <linux-nvdimm@lists.01.org>; Thu, 28 Apr 2016 19:12:08 -0700 (PDT)
Subject: [PATCH] nfit: fix format interface code byte order per ACPI6.1
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Apr 2016 19:11:13 -0700
Message-ID: <146189587309.28821.2994135280775533869.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

ACPI6.1 clarifies that DCR fields are stored as an array of bytes,
update the format interface code constants to match.

Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index c75576b2d50e..92ea5d06c7fe 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -41,11 +41,13 @@ enum nfit_uuids {
 	NFIT_UUID_MAX,
 };
 
-enum nfit_fic {
-	NFIT_FIC_BYTE = 0x101, /* byte-addressable energy backed */
-	NFIT_FIC_BLK = 0x201, /* block-addressable non-energy backed */
-	NFIT_FIC_BYTEN = 0x301, /* byte-addressable non-energy backed */
-};
+/*
+ * Region format interface codes are stored as an array of bytes in the
+ * NFIT DIMM Control Region structure
+ */
+#define NFIT_FIC_BYTE cpu_to_be16(0x101) /* byte-addressable energy */
+#define NFIT_FIC_BLK cpu_to_be16(0x201) /* block-addressable non-energy backed */
+#define NFIT_FIC_BYTEN cpu_to_be16(0x301) /* byte-addressable non-energy backed */
 
 enum {
 	NFIT_BLK_READ_FLUSH = 1,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
