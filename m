Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B58349CFF
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 05:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788413775; cv=none; b=JB4izRzwTPpSSj0U3EF3c6OcIikpUEAxjcR4tqvF41kO8tLpsAPZ1RGttfvv3mt2pbeEeP3UZ7nTMNZWz+SmPNPCWxPYDN3xTTIsn60vaxT/wacWD/YHLwlTO568TcOZjTYDlUSFJkhFzcSEQxEE5tItsoDcKTch0RdWGDjYVRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788413775; c=relaxed/simple;
	bh=XsehUQBu1zymeRNt1s6Ov24fTjL0E26lmzfvGaBn2R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUq+2GJHlyc/5dcI+AoUJryH3zzNapZ/8PXKRSTAMVoKDWuqBHo5ATRztdJ1QhGO9Vgv+DdueKsggzWfX+w5JdoAGvgl0BlQng9eOhnDYcfjCojKsyDT1oIX9Rw2D9M742AH1I0jChltvuMH2VEaceGe0YbYjPpqOUGwwVK2V/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I0HKlWnz; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I0HKlWnz"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XsehUQBu1zymeRNt1s6Ov24fTjL0E26lmzfvGaBn2R0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788413770; v=1; x=1789018570;
 b=I0HKlWnzNX441OhTwD8TwdHY8Hzs5uinU2xuBh2aBiefDqtxQjjTcoixnKyinf4VC6IutfzC
 Z2g/Id1k7kIz2/jlsGbKn6MjEmOgj0N69U1BcgyCZ01gaqd1iiyJiPpp9TJZmHp0jQKgcRvFumu
 0qbZKUcTEYKi8UEU47tZ1oQU=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 78007f4d4477b093;
	Thu, 03 Sep 2026 05:36:10 +0000
X-Mizu-Trace-ID: 78007f4d4477b093
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
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
Date: Thu,  3 Sep 2026 13:35:35 +0800
Message-ID: <20260903053535.17611-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260903053535.17611-1-kaitao.cheng@linux.dev>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaitao Cheng <chengkaitao@kylinos.cn>

TestClearPageHWPoison() is now defined regardless of whether
CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
handling is unavailable.

The test_and_clear_pmem_poison() wrapper duplicates this configuration
handling and has no other pmem-specific behavior.

Call TestClearPageHWPoison() directly and remove the redundant wrapper.
This also removes the need to include page-flags.h from pmem.h.

No functional change is intended.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 drivers/nvdimm/pmem.c |  2 +-
 drivers/nvdimm/pmem.h | 12 ------------
 2 files changed, 1 insertion(+), 13 deletions(-)

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
-- 
2.50.1 (Apple Git-155)

