Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 287CB210C0F60
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 01:46:08 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 2/5] tools/testing/nvdimm: Allow a NULL-kaddr to
 ->direct_access()
Date: Tue, 24 Jul 2018 16:45:07 +0800
Message-Id: <20180724084510.6104-3-yehs2007@zoho.com>
In-Reply-To: <20180724084510.6104-1-yehs2007@zoho.com>
References: <20180724084510.6104-1-yehs2007@zoho.com>
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
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, chengnt@lenovo.com, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, willy@infradead.org, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, jack@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

The mock / test version of pmem_direct_access() needs to check the
validity of second rank pointer kaddr for NULL assignment. If kaddr
equals to NULL, it doesn't need to calculate the value.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 tools/testing/nvdimm/pmem-dax.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
index b53596a..c3ba159 100644
--- a/tools/testing/nvdimm/pmem-dax.c
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -31,7 +31,8 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	if (get_nfit_res(pmem->phys_addr + offset)) {
 		struct page *page;
 
-		*kaddr = pmem->virt_addr + offset;
+		if (kaddr)
+			*kaddr = pmem->virt_addr + offset;
 		page = vmalloc_to_page(pmem->virt_addr + offset);
 		*pfn = page_to_pfn_t(page);
 		pr_debug_ratelimited("%s: pmem: %p pgoff: %#lx pfn: %#lx\n",
@@ -40,7 +41,8 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		return 1;
 	}
 
-	*kaddr = pmem->virt_addr + offset;
+	if (kaddr)
+		*kaddr = pmem->virt_addr + offset;
 	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
 	/*
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
