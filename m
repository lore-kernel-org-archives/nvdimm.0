Return-Path: <owner-linux-mm@kvack.org>
Subject: [PATCH 06/15] devm_memunmap: use devres_release()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Sep 2015 00:41:44 -0400
Message-ID: <20150923044144.36490.28268.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150923043737.36490.70547.stgit@dwillia2-desk3.jf.intel.com>
References: <20150923043737.36490.70547.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Remove open coded call to memunmap.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/memremap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 72b0c66628b6..0756273437e0 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -131,9 +131,8 @@ EXPORT_SYMBOL(devm_memremap);
 
 void devm_memunmap(struct device *dev, void *addr)
 {
-	WARN_ON(devres_destroy(dev, devm_memremap_release, devm_memremap_match,
-			       addr));
-	memunmap(addr);
+	WARN_ON(devres_release(dev, devm_memremap_release,
+				devm_memremap_match, addr));
 }
 EXPORT_SYMBOL(devm_memunmap);
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
