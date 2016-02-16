Return-Path: <owner-linux-mm@kvack.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] devm_memremap_release: fix memremap'd addr handling
Date: Tue, 16 Feb 2016 09:30:27 -0700
Message-Id: <1455640227-21459-1-git-send-email-toshi.kani@hpe.com>
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com, akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

The pmem driver calls devm_memremap() to map a persistent memory
range.  When the pmem driver is unloaded, this memremap'd range
is not released.

Fix devm_memremap_release() to handle a given memremap'd address
properly.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 2c468de..7a1b5c3 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -114,7 +114,7 @@ EXPORT_SYMBOL(memunmap);
 
 static void devm_memremap_release(struct device *dev, void *res)
 {
-	memunmap(res);
+	memunmap(*(void **)res);
 }
 
 static int devm_memremap_match(struct device *dev, void *res, void *match_data)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
