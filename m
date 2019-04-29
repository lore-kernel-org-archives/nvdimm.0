From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 18/18] btrfs: trace functions for btrfs_iomap_begin/end
Date: Mon, 29 Apr 2019 12:26:49 -0500
Message-ID: <20190429172649.8288-19-rgoldwyn@suse.de>
References: <20190429172649.8288-1-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190429172649.8288-1-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nborisov-IBi9RG/b67k@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, dsterba-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>

This is for debug purposes only and can be skipped.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
---
 fs/btrfs/dax.c               |  3 +++
 include/trace/events/btrfs.h | 56 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index 20ec2ec49c68..3fee28f5a199 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -104,6 +104,8 @@ static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
 	u64 srcblk = 0;
 	loff_t diff;
 
+	trace_btrfs_iomap_begin(inode, pos, length, flags);
+
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, length, 0);
 
 	iomap->type = IOMAP_MAPPED;
@@ -164,6 +166,7 @@ static int btrfs_iomap_end(struct inode *inode, loff_t pos,
 {
 	struct btrfs_iomap *bi = iomap->private;
 	u64 wend;
+	trace_btrfs_iomap_end(inode, pos, length, written, flags);
 
 	if (!bi)
 		return 0;
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ab1cc33adbac..8779e5789a7c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1850,6 +1850,62 @@ DEFINE_EVENT(btrfs__block_group, btrfs_skip_unused_block_group,
 	TP_ARGS(bg_cache)
 );
 
+TRACE_EVENT(btrfs_iomap_begin,
+
+	TP_PROTO(const struct inode *inode, loff_t pos, loff_t length, int flags),
+
+	TP_ARGS(inode, pos, length, flags),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	ino		)
+		__field(	u64,	pos		)
+		__field(	u64,	length		)
+		__field(	int,    flags		)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->ino		= btrfs_ino(BTRFS_I(inode));
+		__entry->pos		= pos;
+		__entry->length		= length;
+		__entry->flags		= flags;
+	),
+
+	TP_printk_btrfs("ino=%llu pos=%llu len=%llu flags=0x%x",
+		  __entry->ino,
+		  __entry->pos,
+		  __entry->length,
+		  __entry->flags)
+);
+
+TRACE_EVENT(btrfs_iomap_end,
+
+	TP_PROTO(const struct inode *inode, loff_t pos, loff_t length, loff_t written, int flags),
+
+	TP_ARGS(inode, pos, length, written, flags),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	ino		)
+		__field(	u64,	pos		)
+		__field(	u64,	length		)
+		__field(	u64,	written		)
+		__field(	int,    flags		)
+	),
+
+	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
+		__entry->ino		= btrfs_ino(BTRFS_I(inode));
+		__entry->pos		= pos;
+		__entry->length		= length;
+		__entry->written		= written;
+		__entry->flags		= flags;
+	),
+
+	TP_printk_btrfs("ino=%llu pos=%llu len=%llu written=%llu flags=0x%x",
+		  __entry->ino,
+		  __entry->pos,
+		  __entry->length,
+		  __entry->written,
+		  __entry->flags)
+);
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.16.4
