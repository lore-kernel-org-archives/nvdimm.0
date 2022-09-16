Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF9520EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299328; x=1694835328;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=09smizwI4GSJLiX2SQxDnF1gC8wYEWwvB8zT8M3pE8M=;
  b=O27eKmInqWpykYZ5y5IYQdYBNdsKV/2k3DZfklvub9KXRi87ElL1FJYS
   ZGUlBwbMzk/ZZJbMKbcKCVw3tEvhGTnnApMgzs5hTLhVpHq/tAPqiCtS8
   +qtAGffVK7VlbbVYS2zgyiIKesZsl7bbNwlepITAyXwCSKOiwVOdsy+ak
   t2mrED49qf5P77pqpvfGz3Cjx6ojOHpUrxlMH8fQWljnwKg8iV0DvdFut
   vkKGXACG67vt0QstIQKZdSxK+q8KNOA7MWr3WJRJhm1lPFz2rN65TiR5s
   oMHFmTV65hYk7xYNC+ieWZ0Pz2zQGufsg/zXN5YXjdji0YK6jUSP8U0mN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="279283771"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="279283771"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="792961772"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:21 -0700
Subject: [PATCH v2 02/18] fsdax: Use dax_page_idle() to document DAX busy
 page checking
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:35:21 -0700
Message-ID: <166329932151.2786261.15762187070104795379.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In advance of converting DAX pages to be 0-based, use a new
dax_page_idle() helper to both simplify that future conversion, but also
document all the kernel locations that are watching for DAX page idle
events.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c            |    4 ++--
 fs/ext4/inode.c     |    3 +--
 fs/fuse/dax.c       |    5 ++---
 fs/xfs/xfs_file.c   |    5 ++---
 include/linux/dax.h |    9 +++++++++
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c440dcef4b1b..e762b9c04fb4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -395,7 +395,7 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
+		WARN_ON_ONCE(trunc && !dax_page_idle(page));
 		if (dax_mapping_is_cow(page->mapping)) {
 			/* keep the CoW flag if this page is still shared */
 			if (page->index-- > 0)
@@ -414,7 +414,7 @@ static struct page *dax_busy_page(void *entry)
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		if (page_ref_count(page) > 1)
+		if (!dax_page_idle(page))
 			return page;
 	}
 	return NULL;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b028a4413bea..478ec6bc0935 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3961,8 +3961,7 @@ int ext4_break_layouts(struct inode *inode)
 		if (!page)
 			return 0;
 
-		error = ___wait_var_event(page,
-					  atomic_read(&page->_refcount) == 1,
+		error = ___wait_var_event(page, dax_page_idle(page),
 					  TASK_INTERRUPTIBLE, 0, 0,
 					  ext4_wait_dax_page(inode));
 	} while (error == 0);
diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 4e12108c68af..ae52ef7dbabe 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -676,9 +676,8 @@ static int __fuse_dax_break_layouts(struct inode *inode, bool *retry,
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(page, atomic_read(&page->_refcount) == 1,
-				 TASK_INTERRUPTIBLE, 0, 0,
-				 fuse_wait_dax_page(inode));
+	return ___wait_var_event(page, dax_page_idle(page), TASK_INTERRUPTIBLE,
+				 0, 0, fuse_wait_dax_page(inode));
 }
 
 /* dmap_end == 0 leads to unmapping of whole file */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 73e7b7ec0a4c..556e28d06788 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -827,9 +827,8 @@ xfs_break_dax_layouts(
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(page, atomic_read(&page->_refcount) == 1,
-				 TASK_INTERRUPTIBLE, 0, 0,
-				 xfs_wait_dax_page(inode));
+	return ___wait_var_event(page, dax_page_idle(page), TASK_INTERRUPTIBLE,
+				 0, 0, xfs_wait_dax_page(inode));
 }
 
 int
diff --git a/include/linux/dax.h b/include/linux/dax.h
index ba985333e26b..04987d14d7e0 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -210,6 +210,15 @@ int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		const struct iomap_ops *ops);
 
+/*
+ * Document all the code locations that want know when a dax page is
+ * unreferenced.
+ */
+static inline bool dax_page_idle(struct page *page)
+{
+	return page_ref_count(page) == 1;
+}
+
 #if IS_ENABLED(CONFIG_DAX)
 int dax_read_lock(void);
 void dax_read_unlock(int id);

