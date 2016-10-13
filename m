Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F41A1A1EC3
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 08:56:00 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] pmem: report error on clear poison failure
Date: Thu, 13 Oct 2016 09:54:21 -0600
Message-Id: <1476374061-9080-1-git-send-email-toshi.kani@hpe.com>
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

ACPI Clear Uncorrectable Error DSM function may fail or may be
unsupported on a platform.  pmem_clear_poison() returns without
clearing badblocks in such cases, which leads to a silent data
corruption.

Change pmem_do_bvec() and pmem_clear_poison() to return -EIO
so that filesystem can log an error message.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/pmem.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 42b3a82..2461843 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -47,7 +47,7 @@ static struct nd_region *to_region(struct pmem_device *pmem)
 	return to_nd_region(to_dev(pmem)->parent);
 }
 
-static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
+static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
 	struct device *dev = to_dev(pmem);
@@ -62,8 +62,12 @@ static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 				__func__, (unsigned long long) sector,
 				cleared / 512, cleared / 512 > 1 ? "s" : "");
 		badblocks_clear(&pmem->bb, sector, cleared / 512);
+	} else {
+		return -EIO;
 	}
+
 	invalidate_pmem(pmem->virt_addr + offset, len);
+	return 0;
 }
 
 static void write_pmem(void *pmem_addr, struct page *page,
@@ -123,7 +127,7 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 		flush_dcache_page(page);
 		write_pmem(pmem_addr, page, off, len);
 		if (unlikely(bad_pmem)) {
-			pmem_clear_poison(pmem, pmem_off, len);
+			rc = pmem_clear_poison(pmem, pmem_off, len);
 			write_pmem(pmem_addr, page, off, len);
 		}
 	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
