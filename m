Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8224D20081A87
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:27 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:18 -0600
Message-Id: <1492121135-4437-6-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 05/22] drm/i915: Make use of the new sg_map helper function
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
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

This is a single straightforward conversion from kmap to sg_map.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 67b1fc5..1b1b91a 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2188,6 +2188,15 @@ static void __i915_gem_object_reset_page_iter(struct drm_i915_gem_object *obj)
 		radix_tree_delete(&obj->mm.get_page.radix, iter.index);
 }
 
+static void i915_gem_object_unmap(const struct drm_i915_gem_object *obj,
+				  void *ptr)
+{
+	if (is_vmalloc_addr(ptr))
+		vunmap(ptr);
+	else
+		sg_unmap(obj->mm.pages->sgl, ptr, SG_KMAP);
+}
+
 void __i915_gem_object_put_pages(struct drm_i915_gem_object *obj,
 				 enum i915_mm_subclass subclass)
 {
@@ -2215,10 +2224,7 @@ void __i915_gem_object_put_pages(struct drm_i915_gem_object *obj,
 		void *ptr;
 
 		ptr = ptr_mask_bits(obj->mm.mapping);
-		if (is_vmalloc_addr(ptr))
-			vunmap(ptr);
-		else
-			kunmap(kmap_to_page(ptr));
+		i915_gem_object_unmap(obj, ptr);
 
 		obj->mm.mapping = NULL;
 	}
@@ -2475,8 +2481,11 @@ static void *i915_gem_object_map(const struct drm_i915_gem_object *obj,
 	void *addr;
 
 	/* A single page can always be kmapped */
-	if (n_pages == 1 && type == I915_MAP_WB)
-		return kmap(sg_page(sgt->sgl));
+	if (n_pages == 1 && type == I915_MAP_WB) {
+		addr = sg_map(sgt->sgl, SG_KMAP);
+		if (IS_ERR(addr))
+			return NULL;
+	}
 
 	if (n_pages > ARRAY_SIZE(stack_pages)) {
 		/* Too big for stack -- allocate temporary array instead */
@@ -2543,11 +2552,7 @@ void *i915_gem_object_pin_map(struct drm_i915_gem_object *obj,
 			goto err_unpin;
 		}
 
-		if (is_vmalloc_addr(ptr))
-			vunmap(ptr);
-		else
-			kunmap(kmap_to_page(ptr));
-
+		i915_gem_object_unmap(obj, ptr);
 		ptr = obj->mm.mapping = NULL;
 	}
 
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
