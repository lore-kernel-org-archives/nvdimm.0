Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 79C211A1DFB
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 11:49:33 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] acpi, nfit: fix acpi event notifications for nfit
Date: Thu, 18 Aug 2016 12:48:24 -0600
Message-Id: <1471546104-28520-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The nfit driver had an acpi event notification handler, but it never
would've worked because we weren't setting the
ACPI_DRIVER_ALL_NOTIFY_EVENTS flag in acpi_driver.

Cc: <stable@vger.kernel.org>
Cc: <linux-acpi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 80cc7c0..5d33d81 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2731,6 +2731,7 @@ MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
 static struct acpi_driver acpi_nfit_driver = {
 	.name = KBUILD_MODNAME,
 	.ids = acpi_nfit_ids,
+	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
 		.add = acpi_nfit_add,
 		.remove = acpi_nfit_remove,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
