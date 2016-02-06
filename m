Return-Path: <owner-linux-mm@kvack.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] devm_memremap: Fix error value when memremap failed
Date: Fri,  5 Feb 2016 18:40:27 -0700
Message-Id: <1454722827-15744-1-git-send-email-toshi.kani@hpe.com>
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

devm_memremap() returns an ERR_PTR() value in case of error.
However, it returns NULL when memremap() failed.  This causes
the caller, such as the pmem driver, to proceed and oops later.

Change devm_memremap() to return ERR_PTR(-ENXIO) when memremap()
failed.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/memremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 70ee377..3427cca 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -136,8 +136,10 @@ void *devm_memremap(struct device *dev, resource_size_t offset,
 	if (addr) {
 		*ptr = addr;
 		devres_add(dev, ptr);
-	} else
+	} else {
 		devres_free(ptr);
+		return ERR_PTR(-ENXIO);
+	}
 
 	return addr;
 }

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
