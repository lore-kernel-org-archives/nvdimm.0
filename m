Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15D9521FD73D5
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 23:20:54 -0800 (PST)
Subject: [PATCH v2 2/5] dax: fix dax_mapping() definition in the FS_DAX=n +
 DEV_DAX=y case
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Feb 2018 23:17:51 -0800
Message-ID: <151937027102.18973.18360014199243139223.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151937026001.18973.12034171121582300402.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151937026001.18973.12034171121582300402.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, kbuild test robot <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

An address_space will only have dax exceptional entries when FS_DAX is
enabled. The current reliance on S_DAX causes compile failures when
S_DAX is defined for DEV_DAX, but FS_DAX is disabled. Make dax_mapping()
always return false so that mm/truncate.c drops its link time
dependencies on fs/dax.c.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/dax.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0185ecdae135..62e8cf7eb566 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -107,6 +107,10 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
 		unsigned int offset, unsigned int length);
+static inline bool dax_mapping(struct address_space *mapping)
+{
+	return mapping->host && IS_DAX(mapping->host);
+}
 #else
 static inline int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
@@ -114,12 +118,11 @@ static inline int __dax_zero_page_range(struct block_device *bdev,
 {
 	return -ENXIO;
 }
-#endif
-
 static inline bool dax_mapping(struct address_space *mapping)
 {
-	return mapping->host && IS_DAX(mapping->host);
+	return false;
 }
+#endif
 
 struct writeback_control;
 int dax_writeback_mapping_range(struct address_space *mapping,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
