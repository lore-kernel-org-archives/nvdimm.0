Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8CFA212108E9
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:42:16 -0700 (PDT)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 04/18] dax: Introduce IOMAP_DAX_COW to CoW edges during writes
Date: Tue, 16 Apr 2019 11:41:40 -0500
Message-Id: <20190416164154.30390-5-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
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
To: linux-btrfs@vger.kernel.org
Cc: kilobyte@angband.pl, jack@suse.cz, darrick.wong@oracle.com, nborisov@suse.com, linux-nvdimm@lists.01.org, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

The IOMAP_DAX_COW is a iomap type which performs copy of
edges of data while performing a write if start/end are
not page aligned. The source address is expected in
iomap->inline_data.

dax_copy_edges() is a helper functions performs a copy from
one part of the device to another for data not page aligned.
If iomap->inline_data is NULL, it memset's the area to zero.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c              | 41 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/iomap.h |  1 +
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index ca0671d55aa6..4b4ac51fbd16 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1083,6 +1083,40 @@ int __dax_zero_page_range(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
+/*
+ * dax_copy_edges - Copies the part of the pages not included in
+ * 		    the write, but required for CoW because
+ * 		    offset/offset+length are not page aligned.
+ */
+static void dax_copy_edges(struct inode *inode, loff_t pos, loff_t length,
+			   struct iomap *iomap, void *daddr)
+{
+	unsigned offset = pos & (PAGE_SIZE - 1);
+	loff_t end = pos + length;
+	loff_t pg_end = round_up(end, PAGE_SIZE);
+	void *saddr = iomap->inline_data;
+	/*
+	 * Copy the first part of the page
+	 * Note: we pass offset as length
+	 */
+	if (offset) {
+		if (saddr)
+			memcpy(daddr, saddr, offset);
+		else
+			memset(daddr, 0, offset);
+	}
+
+	/* Copy the last part of the range */
+	if (end < pg_end) {
+		if (saddr)
+			memcpy(daddr + offset + length,
+			       saddr + offset + length,	pg_end - end);
+		else
+			memset(daddr + offset + length, 0,
+					pg_end - end);
+	}
+}
+
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
@@ -1104,9 +1138,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			return iov_iter_zero(min(length, end - pos), iter);
 	}
 
-	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
+	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED
+			 && iomap->type != IOMAP_DAX_COW))
 		return -EIO;
 
+
 	/*
 	 * Write can allocate block for an area which has a hole page mapped
 	 * into page tables. We have to tear down these mappings so that data
@@ -1143,6 +1179,9 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			break;
 		}
 
+		if (iomap->type == IOMAP_DAX_COW)
+			dax_copy_edges(inode, pos, length, iomap, kaddr);
+
 		map_len = PFN_PHYS(map_len);
 		kaddr += offset;
 		map_len -= offset;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0fefb5455bda..6e885c5a38a3 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -25,6 +25,7 @@ struct vm_fault;
 #define IOMAP_MAPPED	0x03	/* blocks allocated at @addr */
 #define IOMAP_UNWRITTEN	0x04	/* blocks allocated at @addr in unwritten state */
 #define IOMAP_INLINE	0x05	/* data inline in the inode */
+#define IOMAP_DAX_COW	0x06	/* Copy data pointed by inline_data before write*/
 
 /*
  * Flags for all iomap mappings:
-- 
2.16.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
