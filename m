Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43B120EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299316; x=1694835316;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TFsjnfnCv3qQkchX3Q8w6OPDWs44NJ34NXLtENxpehE=;
  b=lCoFo6LBdLCbxOktV/voBXwOw90yV85nxXczPXkSpPWscsABf9AN+kmv
   M8pGlBuWod5FhhZVdHcPNj0eWVkmM6HvgYKnAq2FHqRDJVXjVXfaz33b4
   zXt5Oq5lf2U9gNZPx33GB9NZxMnTSgUEXx6gNJOtDG6LIR0Uuf5MN0mP2
   +QxnDekbCFJycwJqmhF9h7Ru+rJmc5j1cmxZvXeCqcLfenZO7LSpLdRzr
   wKkXZa3giuw/eWBlR5EgkgO5B0+RIuS5LiXBndU9b3vmL0gcwBpn1zlXf
   yThvOuS6jYfk8JzJyI0fuQcZZueMtkHn5mfa7mwlJDDY5JkdXqSyITG3U
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="299726045"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="299726045"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="679809163"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:15 -0700
Subject: [PATCH v2 01/18] fsdax: Wait on @page not @page->_refcount
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:35:15 -0700
Message-ID: <166329931529.2786261.12375427940949385300.stgit@dwillia2-xfh.jf.intel.com>
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

The __wait_var_event facility calculates a wait queue from a hash of the
address of the variable being passed. Use the @page argument directly as
it is less to type and is the object that is being waited upon.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
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
index 58b20c3c300b..95f6ffe9cb0f 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -520,7 +520,7 @@ bool __put_devmap_managed_page_refs(struct page *page, int refs)
 	 * stable because nobody holds a reference on the page.
 	 */
 	if (page_ref_sub_return(page, refs) == 1)
-		wake_up_var(&page->_refcount);
+		wake_up_var(page);
 	return true;
 }
 EXPORT_SYMBOL(__put_devmap_managed_page_refs);

