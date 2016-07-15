Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id F18891A1DF5
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 20:31:54 -0700 (PDT)
Subject: [PATCH 1/2] nfit: fix _FIT evaluation memory leak
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jul 2016 20:28:57 -0700
Message-ID: <146855333714.573.13934675433503265133.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Xiao Guangrong <guangrong.xiao@intel.com>, stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

acpi_evaluate_object() allocates memory. Free the buffer allocated
during acpi_nfit_add().

Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Xiao Guangrong <guangrong.xiao@intel.com>
Reported-by: Haozhong Zhang <haozhong.zhang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 0497175ee6cb..008dbaaa2b75 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -2414,12 +2414,15 @@ static int acpi_nfit_add(struct acpi_device *adev)
 			acpi_desc->nfit =
 				(struct acpi_nfit_header *)obj->buffer.pointer;
 			sz = obj->buffer.length;
+			rc = acpi_nfit_init(acpi_desc, sz);
 		} else
 			dev_dbg(dev, "%s invalid type %d, ignoring _FIT\n",
 				 __func__, (int) obj->type);
-	}
+		kfree(buf.pointer);
+		acpi_desc->nfit = NULL;
+	} else
+		rc = acpi_nfit_init(acpi_desc, sz);
 
-	rc = acpi_nfit_init(acpi_desc, sz);
 	if (rc) {
 		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
 		return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
