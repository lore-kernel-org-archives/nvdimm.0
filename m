Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53E1020359E99
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 10:09:25 -0800 (PST)
Subject: [PATCH v3 1/4] mm: introduce get_user_pages_longterm
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Nov 2017 10:05:35 -0800
Message-ID: <151197873499.26211.11687422577653326365.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Until there is a solution to the dma-to-dax vs truncate problem it is
not safe to allow long standing memory registrations against
filesytem-dax vmas. Device-dax vmas do not have this problem and are
explicitly allowed.

This is temporary until a "memory registration with layout-lease"
mechanism can be implemented for the affected sub-systems (RDMA and
V4L2).

Cc: <stable@vger.kernel.org>
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/fs.h |   14 +++++++++++
 include/linux/mm.h |   13 +++++++++++
 mm/gup.c           |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2995a271ec46..8a9f6d048487 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3194,6 +3194,20 @@ static inline bool vma_is_dax(struct vm_area_struct *vma)
 	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
 }
 
+static inline bool vma_is_fsdax(struct vm_area_struct *vma)
+{
+	struct inode *inode;
+
+	if (!vma->vm_file)
+		return false;
+	if (!vma_is_dax(vma))
+		return false;
+	inode = file_inode(vma->vm_file);
+	if (inode->i_mode == S_IFCHR)
+		return false; /* device-dax */
+	return true;
+}
+
 static inline int iocb_flags(struct file *file)
 {
 	int res = 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b3b6a7e313e9..ea818ff739cd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1380,6 +1380,19 @@ long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
+#ifdef CONFIG_FS_DAX
+long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
+			    unsigned int gup_flags, struct page **pages,
+			    struct vm_area_struct **vmas);
+#else
+static inline long get_user_pages_longterm(unsigned long start,
+		unsigned long nr_pages, unsigned int gup_flags,
+		struct page **pages, struct vm_area_struct **vmas)
+{
+	return get_user_pages(start, nr_pages, gup_flags, pages, vmas);
+}
+#endif /* CONFIG_FS_DAX */
+
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 
diff --git a/mm/gup.c b/mm/gup.c
index 85cc822fd403..3dc8a7807ea0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1095,6 +1095,70 @@ long get_user_pages(unsigned long start, unsigned long nr_pages,
 }
 EXPORT_SYMBOL(get_user_pages);
 
+#ifdef CONFIG_FS_DAX
+/*
+ * This is the same as get_user_pages() in that it assumes we are
+ * operating on the current task's mm, but it goes further to validate
+ * that the vmas associated with the address range are suitable for
+ * longterm elevated page reference counts. For example, filesystem-dax
+ * mappings are subject to the lifetime enforced by the filesystem and
+ * we need guarantees that longterm users like RDMA and V4L2 only
+ * establish mappings that have a kernel enforced revocation mechanism.
+ *
+ * "longterm" == userspace controlled elevated page count lifetime.
+ * Contrast this to iov_iter_get_pages() usages which are transient.
+ */
+long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
+		unsigned int gup_flags, struct page **pages,
+		struct vm_area_struct **vmas_arg)
+{
+	struct vm_area_struct **vmas = vmas_arg;
+	struct vm_area_struct *vma_prev = NULL;
+	long rc, i;
+
+	if (!pages)
+		return -EINVAL;
+
+	if (!vmas) {
+		vmas = kzalloc(sizeof(struct vm_area_struct *) * nr_pages,
+				GFP_KERNEL);
+		if (!vmas)
+			return -ENOMEM;
+	}
+
+	rc = get_user_pages(start, nr_pages, gup_flags, pages, vmas);
+
+	for (i = 0; i < rc; i++) {
+		struct vm_area_struct *vma = vmas[i];
+
+		if (vma == vma_prev)
+			continue;
+
+		vma_prev = vma;
+
+		if (vma_is_fsdax(vma))
+			break;
+	}
+
+	/*
+	 * Either get_user_pages() failed, or the vma validation
+	 * succeeded, in either case we don't need to put_page() before
+	 * returning.
+	 */
+	if (i >= rc)
+		goto out;
+
+	for (i = 0; i < rc; i++)
+		put_page(pages[i]);
+	rc = -EOPNOTSUPP;
+out:
+	if (vmas != vmas_arg)
+		kfree(vmas);
+	return rc;
+}
+EXPORT_SYMBOL(get_user_pages_longterm);
+#endif /* CONFIG_FS_DAX */
+
 /**
  * populate_vma_page_range() -  populate a range of pages in the vma.
  * @vma:   target vma

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
