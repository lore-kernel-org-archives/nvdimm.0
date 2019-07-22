Return-Path: <owner-linux-mm@kvack.org>
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] memremap: move from kernel/ to mm/
Date: Mon, 22 Jul 2019 11:41:43 +0200
Message-Id: <20190722094143.18387-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

memremap.c implements MM functionality for ZONE_DEVICE, so it really
should be in the mm/ directory, not the kernel/ one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Sending for applying just after -rc1 preferably to avoid conflicts
later in the merge window

 kernel/Makefile           | 1 -
 mm/Makefile               | 1 +
 {kernel => mm}/memremap.c | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename {kernel => mm}/memremap.c (100%)

diff --git a/kernel/Makefile b/kernel/Makefile
index a8d923b5481b..ef0d95a190b4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -111,7 +111,6 @@ obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
 
 obj-$(CONFIG_HAS_IOMEM) += iomem.o
-obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_RSEQ) += rseq.o
 
 obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
diff --git a/mm/Makefile b/mm/Makefile
index 338e528ad436..d0b295c3b764 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -102,5 +102,6 @@ obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
 obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
 obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
+obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
diff --git a/kernel/memremap.c b/mm/memremap.c
similarity index 100%
rename from kernel/memremap.c
rename to mm/memremap.c
-- 
2.20.1
