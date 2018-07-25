Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A39F6210C2784
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 09:30:00 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 3/6] tools/testing/nvdimm: kaddr and pfn can be NULL to
 ->direct_access()
Date: Thu, 26 Jul 2018 00:28:46 +0800
Message-Id: <20180725162849.8320-4-yehs2007@zoho.com>
In-Reply-To: <20180725162849.8320-1-yehs2007@zoho.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
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
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, snitzer@redhat.com, chengnt@lenovo.com, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, willy@infradead.org, colyli@suse.de, bart.vanassche@wdc.com, dm-devel@redhat.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, jack@suse.cz, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

The mock / test version of pmem_direct_access() needs to check the
validity of pointers kaddr and pfn for NULL assignment. If anyone
equals to NULL, it doesn't need to calculate the value.

If pointer equals to NULL, that is to say callers may have no need for
kaddr or pfn, so this patch is prepared for allowing them to pass in
NULL instead of having to pass in a local pointer or variable that
they then just throw away.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 tools/testing/nvdimm/pmem-dax.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
index b53596a..2e7fd82 100644
--- a/tools/testing/nvdimm/pmem-dax.c
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -31,17 +31,21 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	if (get_nfit_res(pmem->phys_addr + offset)) {
 		struct page *page;
 
-		*kaddr = pmem->virt_addr + offset;
+		if (kaddr)
+			*kaddr = pmem->virt_addr + offset;
 		page = vmalloc_to_page(pmem->virt_addr + offset);
-		*pfn = page_to_pfn_t(page);
+		if (pfn)
+			*pfn = page_to_pfn_t(page);
 		pr_debug_ratelimited("%s: pmem: %p pgoff: %#lx pfn: %#lx\n",
 				__func__, pmem, pgoff, page_to_pfn(page));
 
 		return 1;
 	}
 
-	*kaddr = pmem->virt_addr + offset;
-	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
+	if (kaddr)
+		*kaddr = pmem->virt_addr + offset;
+	if (pfn)
+		*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
 	/*
 	 * If badblocks are present, limit known good range to the
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
