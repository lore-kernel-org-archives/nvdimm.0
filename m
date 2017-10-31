Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE5EE2034C089
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 16:24:45 -0700 (PDT)
Subject: [PATCH 07/15] dax: stop requiring a live device for dax_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 31 Oct 2017 16:22:13 -0700
Message-ID: <150949213329.24061.13836721890938350458.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Now that dax_flush() is no longer a driver callback (commit c3ca015fab6d
"dax: remove the pmem_dax_ops->flush abstraction"), stop requiring the
dax_read_lock() to be held and the device to be alive.  This is in
preparation for switching filesystem-dax to store pfns instead of
sectors in the radix.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 66bcdf42c413..abfd4e92d669 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -283,9 +283,6 @@ EXPORT_SYMBOL_GPL(dax_copy_from_iter);
 void arch_wb_cache_pmem(void *addr, size_t size);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
 {
-	if (unlikely(!dax_alive(dax_dev)))
-		return;
-
 	if (unlikely(!test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags)))
 		return;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
