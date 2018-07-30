Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9702A210C4DC9
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 00:16:40 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v3 1/6] libnvdimm,
 pmem: kaddr and pfn can be NULL to ->direct_access()
Date: Mon, 30 Jul 2018 15:15:43 +0800
Message-Id: <20180730071548.9172-2-yehs2007@zoho.com>
In-Reply-To: <20180730071548.9172-1-yehs2007@zoho.com>
References: <20180730071548.9172-1-yehs2007@zoho.com>
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
Cc: jack@suse.cz, snitzer@redhat.com, heiko.carstens@de.ibm.com, dm-devel@redhat.com, agk@redhat.com, linux-s390@vger.kernel.org, willy@infradead.org, bart.vanassche@wdc.com, keescook@chromium.org, chengnt@lenovo.com, colyli@suse.de, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

pmem_direct_access() needs to check the validity of pointers kaddr
and pfn for NULL assignment. If anyone equals to NULL, it doesn't need
to calculate the value.

If pointer equals to NULL, that is to say callers may have no need for
kaddr or pfn, so this patch is prepared for allowing them to pass in
NULL instead of having to pass in a pointer or local variable that
they then just throw away.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/nvdimm/pmem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 8b1fd7f..ecf9024 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -227,8 +227,11 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
 					PFN_PHYS(nr_pages))))
 		return -EIO;
-	*kaddr = pmem->virt_addr + offset;
-	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
+
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
