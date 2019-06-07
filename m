Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E8B7421290DF8
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 12:42:17 -0700 (PDT)
Subject: [PATCH v3 09/10] acpi/numa/hmat: Register HMAT at device_initcall
 level
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Jun 2019 12:28:01 -0700
Message-ID: <155993568120.3036719.6635543389090509374.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, ard.biesheuvel@linaro.org, peterz@infradead.org, dave.hansen@linux.intel.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-nvdimm@lists.01.org, linux-efi@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for registering device-dax instances for accessing EFI
specific-purpose memory, arrange for the HMAT registration to occur
later in the init process. Critically HMAT initialization needs to occur
after e820__reserve_resources_late() which is the point at which the
iomem resource tree is populated with "Application Reserved"
(IORES_DESC_APPLICATION_RESERVED). e820__reserve_resources_late()
happens at subsys_initcall time.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/numa/hmat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 2c220cb7b620..1d329c4af3bf 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -671,4 +671,4 @@ static __init int hmat_init(void)
 	acpi_put_table(tbl);
 	return 0;
 }
-subsys_initcall(hmat_init);
+device_initcall(hmat_init);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
