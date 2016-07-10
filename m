Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 21C711A1E36
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:27:29 -0700 (PDT)
Subject: [PATCH v2 01/17] nfit: always associate flush hints
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:24:34 -0700
Message-ID: <146812107483.32932.3652950504167218008.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Before enabling use of flush hints for pmem regions, we need to make
sure they are always associated.  Move the initialization of nfit_flush
out of the block-window specific init path to the general init path.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 3e54157f02cc..d79837b9d07e 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -614,7 +614,6 @@ static void nfit_mem_init_bdw(struct acpi_nfit_desc *acpi_desc,
 {
 	u16 dcr = __to_nfit_memdev(nfit_mem)->region_index;
 	struct nfit_memdev *nfit_memdev;
-	struct nfit_flush *nfit_flush;
 	struct nfit_bdw *nfit_bdw;
 	struct nfit_idt *nfit_idt;
 	u16 idt_idx, range_index;
@@ -647,14 +646,6 @@ static void nfit_mem_init_bdw(struct acpi_nfit_desc *acpi_desc,
 			nfit_mem->idt_bdw = nfit_idt->idt;
 			break;
 		}
-
-		list_for_each_entry(nfit_flush, &acpi_desc->flushes, list) {
-			if (nfit_flush->flush->device_handle !=
-					nfit_memdev->memdev->device_handle)
-				continue;
-			nfit_mem->nfit_flush = nfit_flush;
-			break;
-		}
 		break;
 	}
 }
@@ -675,6 +666,7 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
 	}
 
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+		struct nfit_flush *nfit_flush;
 		struct nfit_dcr *nfit_dcr;
 		u32 device_handle;
 		u16 dcr;
@@ -721,6 +713,13 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
 			break;
 		}
 
+		list_for_each_entry(nfit_flush, &acpi_desc->flushes, list) {
+			if (nfit_flush->flush->device_handle != device_handle)
+				continue;
+			nfit_mem->nfit_flush = nfit_flush;
+			break;
+		}
+
 		if (dcr && !nfit_mem->dcr) {
 			dev_err(acpi_desc->dev, "SPA %d missing DCR %d\n",
 					spa->range_index, dcr);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
