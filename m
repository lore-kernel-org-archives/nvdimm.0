Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 490561A1F53
 for <linux-nvdimm@lists.01.org>; Thu, 28 Apr 2016 14:17:28 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v4 7/7] dax: fix a comment in dax_zero_page_range and
 dax_truncate_page
Date: Thu, 28 Apr 2016 15:16:58 -0600
Message-Id: <1461878218-3844-8-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The distinction between PAGE_SIZE and PAGE_CACHE_SIZE was removed in

09cbfea mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release}
macros

The comments for the above functions described a distinction between
those, that is now redundant, so remove those paragraphs

Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 fs/dax.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d8c974e..b8fa85a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1221,12 +1221,6 @@ static bool dax_range_is_aligned(struct block_device *bdev,
  * page in a DAX file.  This is intended for hole-punch operations.  If
  * you are truncating a file, the helper function dax_truncate_page() may be
  * more convenient.
- *
- * We work in terms of PAGE_SIZE here for commonality with
- * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
- * took care of disposing of the unnecessary blocks.  Even if the filesystem
- * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmapped.
  */
 int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 							get_block_t get_block)
@@ -1279,12 +1273,6 @@ EXPORT_SYMBOL_GPL(dax_zero_page_range);
  *
  * Similar to block_truncate_page(), this function can be called by a
  * filesystem when it is truncating a DAX file to handle the partial page.
- *
- * We work in terms of PAGE_SIZE here for commonality with
- * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
- * took care of disposing of the unnecessary blocks.  Even if the filesystem
- * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmapped.
  */
 int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 {
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
