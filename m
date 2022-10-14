Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7F22F3F
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791830; x=1697327830;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6sp/aip8YX3p0mDPRXhTTeKlVhlMlg1fVCnBOk4kgao=;
  b=Q+DNsdKqNuv3iqYYzthmU1OOIGvjCALOTpuLEa4n/BjYpEAYt2odnnCJ
   ejggDuWgFXGmiuOiiMtC+u7eR00L9BOqC8LsSq1EtThklzrxGY+dS+A+F
   DBvrxQ5RLHoMJ0pT8l2ROS/FQIRGgBx6991tIwPjYPdj7LF9faKS2qcRZ
   eGk3cYtFkhsOVF3tlWIv8tYGlR3JGQtkv0qkfflMIPblBVmDcqYIIGAyy
   s0vm3ftkgSpQR2r74KFHDdVtZJ05N1HTlekUB2V0/uwY3zg7ANptL4X3z
   JdcHnAO2QbJEv2l8ASD8GXi9biZepshCHMJI+UsS33lMCCyLhYVY3p5Zh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="391802288"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="391802288"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="658759517"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="658759517"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:08 -0700
Subject: [PATCH v3 02/25] fsdax: Use dax_page_idle() to document DAX busy
 page checking
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:57:08 -0700
Message-ID: <166579182839.2236710.16461867548859813784.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
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
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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

