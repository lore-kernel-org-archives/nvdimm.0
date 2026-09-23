Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D014C429037
	for <nvdimm@lists.linux.dev>; Wed, 23 Sep 2026 05:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142814; cv=none; b=lyWO5pCYTdRGFWjZGP6Z9vpxKhFUrpRREMXtEkDcMB5RfS6psmISeygvsW2kdFXoTgO9mvgZfP/3Cy1TT5U3dz4ULHf2DhaKI/hYaG5l9fvu2MPqXHsi8uUFr4DZEcEk3MEIaeVPTASfHEczYjCY50Tq3UUr/Tpiv0RFVFz/iuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142814; c=relaxed/simple;
	bh=GtzyIimaRhdHKGvlttK2axmNG4AJfexvcRRfGpY2ECk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=neSb6j7FNYFiyWGsv+GEtcNkzoDOYSC+j0dpTn8sLQErukCk3oCxrwEVREpz1YNm1r2gL1xXJbajEDPvHqm4BYZ2WN41nBci2YqyEIJjOtyJPphaWTJtydz87z6Ry8PmXmbMufUlOinc8C1+27EraWXEloe5k0rNtyEW/VwexSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xcVDaIA6; arc=none smtp.client-ip=95.215.58.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xcVDaIA6"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GtzyIimaRhdHKGvlttK2axmNG4AJfexvcRRfGpY2ECk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790142810; v=1; x=1790747610;
 b=xcVDaIA6AxJGFyl59gR9e+k4n6ll3IV+Ux5WtvjeEy7Uqvr9qSjbHiEbS4u701fHPsgb4MF3
 3WqOxoxDpUxacdcTKFiA3B63AJSLpbG3pM5hg1XYuBZPCNBId9XqzuCuQ9/OGIUbZEOkcqWxbRE
 3rWw06t2Zb0ebyMbx6R0GkPU=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4e0d178c503526e4;
	Wed, 23 Sep 2026 05:53:30 +0000
X-Mizu-Trace-ID: 4e0d178c503526e4
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH v2] nvdimm/pmem: remove test_and_clear_pmem_poison()
Date: Wed, 23 Sep 2026 13:53:18 +0800
Message-ID: <20260923055318.57485-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaitao Cheng <chengkaitao@kylinos.cn>

The pmem driver provides test_and_clear_pmem_poison() only to handle
the CONFIG_MEMORY_FAILURE dependency of TestClearPageHWPoison().
The wrapper has no other pmem-specific behavior.

Define the HWPoison test-and-change helpers to return false when
CONFIG_MEMORY_FAILURE is disabled.  This allows pmem to call
TestClearPageHWPoison() directly in all configurations.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
---
Changes in v2 (David Hildenbrand, Oscar Salvador):
- squash patch#1 into patch#2.

Link to v1:
https://lore.kernel.org/all/20260903053535.17611-1-kaitao.cheng@linux.dev/
---
 drivers/nvdimm/pmem.c      |  2 +-
 drivers/nvdimm/pmem.h      | 12 ------------
 include/linux/page-flags.h |  1 +
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 30a51c365ce8..5fb86595e8bd 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
 		 * here since we're in the driver I/O path and
 		 * outstanding I/O requests pin the dev_pagemap.
 		 */
-		if (test_and_clear_pmem_poison(page))
+		if (TestClearPageHWPoison(page))
 			clear_mce_nospec(pfn);
 	}
 }
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index a48509f90196..76870505dd79 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NVDIMM_PMEM_H__
 #define __NVDIMM_PMEM_H__
-#include <linux/page-flags.h>
 #include <linux/badblocks.h>
 #include <linux/memremap.h>
 #include <linux/types.h>
@@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, enum dax_access_mode mode, void **kaddr,
 		unsigned long *pfn);
 
-#ifdef CONFIG_MEMORY_FAILURE
-static inline bool test_and_clear_pmem_poison(struct page *page)
-{
-	return TestClearPageHWPoison(page);
-}
-#else
-static inline bool test_and_clear_pmem_poison(struct page *page)
-{
-	return false;
-}
-#endif
 #endif /* __NVDIMM_PMEM_H__ */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index ae2ebaed6d4d..3dc79c0c5adf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
+TESTSCFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
-- 
2.54.0 (Apple Git-157)

