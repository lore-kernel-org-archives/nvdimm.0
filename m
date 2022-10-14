Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3ED2F3F
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791824; x=1697327824;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1QVmMXmTNKFM/iXiTwxmy31zTJO5VhS550m6cgY6v88=;
  b=f4fqHf+UZ2i3b8wIgVpsFJ5lJkVkNypBRnh4CUJB/fA+vdUp6RBWDDOf
   1a9kTgJxAp8ajMaU54/tDJEyFhlCvfvznffOdmbdtiNpmT0/TDc25zpLY
   1KYNa4NI9wqKytbixpX0FSG1CeLbUhswACw/5luXGmCdkbu8F+VIHgCPK
   uIyF37FV4kLl3IqfnxsU8zXRyE9SjbAmEMY6b1RseZlVe8xHo9ku3AwMK
   n86USK05DVWfib6XZwWHMFy++HYN3kPMTTjn3sWs7Ie/9DX5QaNOEdUO1
   2ZJJ/PcRtFi8dlj3cjd5xSDT5X0h3bDcPw1pIBCoWHh7gv/OVlqd0dPnT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="303112270"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="303112270"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:03 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="658759494"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="658759494"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:03 -0700
Subject: [PATCH v3 01/25] fsdax: Wait on @page not @page->_refcount
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:57:02 -0700
Message-ID: <166579182271.2236710.15120970389485390592.stgit@dwillia2-xfh.jf.intel.com>
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

The __wait_var_event facility calculates a wait queue from a hash of the
address of the variable being passed. Use the @page argument directly as
it is less to type and is the object that is being waited upon.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext4/inode.c   |    8 ++++----
 fs/fuse/dax.c     |    6 +++---
 fs/xfs/xfs_file.c |    6 +++---
 mm/memremap.c     |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 601214453c3a..b028a4413bea 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3961,10 +3961,10 @@ int ext4_break_layouts(struct inode *inode)
 		if (!page)
 			return 0;
 
-		error = ___wait_var_event(&page->_refcount,
-				atomic_read(&page->_refcount) == 1,
-				TASK_INTERRUPTIBLE, 0, 0,
-				ext4_wait_dax_page(inode));
+		error = ___wait_var_event(page,
+					  atomic_read(&page->_refcount) == 1,
+					  TASK_INTERRUPTIBLE, 0, 0,
+					  ext4_wait_dax_page(inode));
 	} while (error == 0);
 
 	return error;
diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index e23e802a8013..4e12108c68af 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -676,9 +676,9 @@ static int __fuse_dax_break_layouts(struct inode *inode, bool *retry,
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(&page->_refcount,
-			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
-			0, 0, fuse_wait_dax_page(inode));
+	return ___wait_var_event(page, atomic_read(&page->_refcount) == 1,
+				 TASK_INTERRUPTIBLE, 0, 0,
+				 fuse_wait_dax_page(inode));
 }
 
 /* dmap_end == 0 leads to unmapping of whole file */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c6c80265c0b2..73e7b7ec0a4c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -827,9 +827,9 @@ xfs_break_dax_layouts(
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(&page->_refcount,
-			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
-			0, 0, xfs_wait_dax_page(inode));
+	return ___wait_var_event(page, atomic_read(&page->_refcount) == 1,
+				 TASK_INTERRUPTIBLE, 0, 0,
+				 xfs_wait_dax_page(inode));
 }
 
 int
diff --git a/mm/memremap.c b/mm/memremap.c
index 421bec3a29ee..f9287babb3ce 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -542,7 +542,7 @@ bool __put_devmap_managed_page_refs(struct page *page, int refs)
 	 * stable because nobody holds a reference on the page.
 	 */
 	if (page_ref_sub_return(page, refs) == 1)
-		wake_up_var(&page->_refcount);
+		wake_up_var(page);
 	return true;
 }
 EXPORT_SYMBOL(__put_devmap_managed_page_refs);

