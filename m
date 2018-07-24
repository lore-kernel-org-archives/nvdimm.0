Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D95F121B02845
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 01:45:58 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 1/5] libnvdimm, pmem: Allow a NULL-kaddr to ->direct_access()
Date: Tue, 24 Jul 2018 16:45:06 +0800
Message-Id: <20180724084510.6104-2-yehs2007@zoho.com>
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

pmem_direct_access() needs to check the validity of second rank
pointer kaddr for NULL assignment. If kaddr equals to NULL, it
doesn't need to calculate the value.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/nvdimm/pmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9d71492..b1d121a 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -232,7 +232,9 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
 					PFN_PHYS(nr_pages))))
 		return -EIO;
-	*kaddr = pmem->virt_addr + offset;
+
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
