Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 215971A1E49
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:53:46 -0700 (PDT)
Subject: [PATCH 02/13] nfit: always associate flush hints
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:52:43 -0700
Message-ID: <146507356341.8347.17433436005261377755.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de
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
index 2215fc847fa9..4771872810ef 100644
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
