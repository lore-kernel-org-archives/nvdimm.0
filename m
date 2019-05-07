Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E952521253307
 for <linux-nvdimm@lists.01.org>; Mon,  6 May 2019 22:36:18 -0700 (PDT)
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 17/81] libnvdimm/pmem: fix a possible OOB access
 when read and write pmem
Date: Tue,  7 May 2019 01:34:48 -0400
Message-Id: <20190507053554.30848-17-sashal@kernel.org>
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org, Liang ZhiCheng <liangzhicheng@baidu.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9dc6488e84b0f64df17672271664752488cd6a25 ]

If offset is not zero and length is bigger than PAGE_SIZE,
this will cause to out of boundary access to a page memory

Fixes: 98cc093cba1e ("block, THP: make block_device_operations.rw_page support THP")
Co-developed-by: Liang ZhiCheng <liangzhicheng@baidu.com>
Signed-off-by: Liang ZhiCheng <liangzhicheng@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/pmem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 1d432c5ed275..cff027fc2676 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -113,13 +113,13 @@ static void write_pmem(void *pmem_addr, struct page *page,
 
 	while (len) {
 		mem = kmap_atomic(page);
-		chunk = min_t(unsigned int, len, PAGE_SIZE);
+		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
 		memcpy_flushcache(pmem_addr, mem + off, chunk);
 		kunmap_atomic(mem);
 		len -= chunk;
 		off = 0;
 		page++;
-		pmem_addr += PAGE_SIZE;
+		pmem_addr += chunk;
 	}
 }
 
@@ -132,7 +132,7 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 
 	while (len) {
 		mem = kmap_atomic(page);
-		chunk = min_t(unsigned int, len, PAGE_SIZE);
+		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
 		rem = memcpy_mcsafe(mem + off, pmem_addr, chunk);
 		kunmap_atomic(mem);
 		if (rem)
@@ -140,7 +140,7 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 		len -= chunk;
 		off = 0;
 		page++;
-		pmem_addr += PAGE_SIZE;
+		pmem_addr += chunk;
 	}
 	return BLK_STS_OK;
 }
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
