Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 93FB121D49194
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 12:27:34 -0700 (PDT)
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 25/30] fuse: Maintain a list of busy elements
Date: Wed, 15 May 2019 15:27:10 -0400
Message-Id: <20190515192715.18000-26-vgoyal@redhat.com>
In-Reply-To: <20190515192715.18000-1-vgoyal@redhat.com>
References: <20190515192715.18000-1-vgoyal@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: swhiteho@redhat.com, dgilbert@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
List-ID: <linux-nvdimm@lists.01.org>

This list will be used selecting fuse_dax_mapping to free when number of
free mappings drops below a threshold.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c   | 8 ++++++++
 fs/fuse/fuse_i.h | 7 +++++++
 fs/fuse/inode.c  | 4 ++++
 3 files changed, 19 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e536a04aaa06..3f0f7a387341 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -273,6 +273,10 @@ static int fuse_setup_one_mapping(struct inode *inode,
 	/* Protected by fi->i_dmap_sem */
 	fuse_dax_interval_tree_insert(dmap, &fi->dmap_tree);
 	fi->nr_dmaps++;
+	spin_lock(&fc->lock);
+	list_add_tail(&dmap->busy_list, &fc->busy_ranges);
+	fc->nr_busy_ranges++;
+	spin_unlock(&fc->lock);
 	return 0;
 }
 
@@ -317,6 +321,10 @@ void fuse_removemapping(struct inode *inode)
 		if (dmap) {
 			fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
 			fi->nr_dmaps--;
+			spin_lock(&fc->lock);
+			list_del_init(&dmap->busy_list);
+			fc->nr_busy_ranges--;
+			spin_unlock(&fc->lock);
 		}
 
 		if (!dmap)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a234cf30538d..c93e9155b723 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -114,6 +114,9 @@ struct fuse_dax_mapping {
 	__u64 end;
 	__u64 __subtree_last;
 
+	/* Will connect in fc->busy_ranges to keep track busy memory */
+	struct list_head busy_list;
+
        /** Position in DAX window */
        u64 window_offset;
 
@@ -873,6 +876,10 @@ struct fuse_conn {
 	/** DAX device, non-NULL if DAX is supported */
 	struct dax_device *dax_dev;
 
+	/* List of memory ranges which are busy */
+	unsigned long nr_busy_ranges;
+	struct list_head busy_ranges;
+
 	/*
 	 * DAX Window Free Ranges. TODO: This might not be best place to store
 	 * this free list
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 713c5f32ab35..f57f7ce02acc 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -626,6 +626,8 @@ static void fuse_free_dax_mem_ranges(struct list_head *mem_list)
 	/* Free All allocated elements */
 	list_for_each_entry_safe(range, temp, mem_list, list) {
 		list_del(&range->list);
+		if (!list_empty(&range->busy_list))
+			list_del(&range->busy_list);
 		kfree(range);
 	}
 }
@@ -670,6 +672,7 @@ static int fuse_dax_mem_range_init(struct fuse_conn *fc,
 		 */
 		range->window_offset = i * FUSE_DAX_MEM_RANGE_SZ;
 		range->length = FUSE_DAX_MEM_RANGE_SZ;
+		INIT_LIST_HEAD(&range->busy_list);
 		list_add_tail(&range->list, &mem_ranges);
 	}
 
@@ -720,6 +723,7 @@ void fuse_conn_init(struct fuse_conn *fc, struct user_namespace *user_ns,
 	fc->user_ns = get_user_ns(user_ns);
 	fc->max_pages = FUSE_DEFAULT_MAX_PAGES_PER_REQ;
 	INIT_LIST_HEAD(&fc->free_ranges);
+	INIT_LIST_HEAD(&fc->busy_ranges);
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
