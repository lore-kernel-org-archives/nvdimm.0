Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE17437858
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 11:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458429; cv=none; b=jX71o+xceNRI/QPcZTIVaBY4ltzCOYsm0TMnS2qFQBm1doSLdyyRYVc49WpFuejNP2OQJm2AWq82qkmUp1JM8iaXg0Di5Lcez2ugdT6OorVeUAiDxINnS4U+Af3w98p+DAdraVlf5uje/4cNnzZZbovC7gC/Cp2Hti+DlGXN/JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458429; c=relaxed/simple;
	bh=kBFiAOngMuisIFJtG/+rJ6/KXxVroARNhTGvQmW76J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=jV2u6bPFCwB0Xj9a3eTFYCjLiYR4nCUdTPIZlibn/ut44B40kHMWjV+WNhGhV3+OxNqP+7KYn3ol1De8DOjKHyx3YZltJLPZXPJgi0uvWZlDVORW+gcaaUYMpMu9ryGE0gJXTp544hivqDwz0lUY34FajYoiUTD+qaKRjb4PHjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Udz1dOTz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Udz1dOTz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791458427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+u+04A0++0m4OYIZHHmu8JAx/2lXPt7ybaLXKzhKEOY=;
	b=Udz1dOTzHm5l95Yy9hvpGaTmQYo5uf/gFzTqUxsv0t/9/87BvlQ0aLgbzwYKQgEnz6hMXK
	HWpL8/ZxcfLA5mQ7DE9sNUBeKdAxT/hplmtyl4sMKJfRR8Lt87+B3DhDb7FI8CiXpzn5mI
	SBbM9YVRFMuGjw+C7g0wSLzDx0m8x+U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-BknxZuNjPOaBo3nI_P8aQg-1; Thu, 08 Oct 2026 07:20:26 -0400
X-MC-Unique: BknxZuNjPOaBo3nI_P8aQg-1
X-Mimecast-MFC-AGG-ID: BknxZuNjPOaBo3nI_P8aQg_1791458425
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c2e47a584edso555263166b.3
        for <nvdimm@lists.linux.dev>; Thu, 08 Oct 2026 04:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791458425; x=1792063225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+u+04A0++0m4OYIZHHmu8JAx/2lXPt7ybaLXKzhKEOY=;
        b=czhuZCMo+5iCjctOPHNLFPuuObRduOUgWPthIb1waW6cWD6lTuUgPMFPOVZTJ7Guxb
         3QckHhky7VX++b5gUXCyZO9qldIqEpUqRGSLy43yDBp9UvbmxQ8FozPjgZI4I3buDePe
         4gLRIjAFiyGsNLQG4LtjNYC84mKeyTHkKF9i5m1HM2YZjeFRDPqp7/Gkdj7NsmEds6DY
         93xeAw6YuUTQOROBVqlobZQ91qxdJ2EMmsIfAGre2oB8tgxnLWOXcIijgCPhOzGKCk0S
         89mcDnnH2M2ojiCp3RadezZ4b/yJSe0CFxQDlEEp7qro4dRXsojrvNdT2/h5KIDRzUlR
         QNVA==
X-Forwarded-Encrypted: i=1; AKwUvBxPp/XRpuywqwSCyQ7Gye7Bc6baziETGveDJSg7EGr2abXAq+k9EwDWQi+IIyYm8P8KPnCxaZs=@lists.linux.dev
X-Gm-Message-State: AFuF++ln2jTMV+BuT0VQHDpun2o7aJVBX3cFaUzloSt6ZAE/eYmgrHGm
	0KvqPDFXezHf1TuqKs/FTYMwdW6Qjyry++2fRvvY/a+fN8gbkzepEfaV6w2ywuPpFv7MvesX+a0
	wJSfWEfNm0yEAAvJo7LJypmwnT/giYOFt4YkGNMuMdwI6+j6pICMIqIMNag==
X-Gm-Gg: AYBFou3PfR0kYsZ61umzwGnWK0Pu/90T3F1XSAc5+eoAPl7SNAELgr86Kt1K+C0/2pi
	B548J3jNzfnPWUHkTPmFdUoa6GbOVf+rR6fC+ZSuDulAh0JcOP3InW6KtbFSdw0FHw0/tyI2N6/
	ir7g/tgE5STX1xP/Hr2U/dUW3qpPij90w1IEgCcTd0b+btDtgp3nkKX0Sn+g7w8qrrcPKmd7v0j
	hflKm4H/z7hNRH8pg23rh2LOC8YTf/kjJxUyEWeiXBlXwsWvf/csfSHq4NnIP2wqXDXG7lfxAt8
	LDSV+9vSqH0e/0hjgfPEiDpgk4jX3aJ9Spa8d6fPk2LcdZbM8EYnPZFAPACaTQ0bOngfuM+Np+O
	EQSf96irrRsoKdsB1Ydj2m8dNbFBDGcpDW5HuTnkYCLcB3YVTWEfgJAhf
X-Received: by 2002:a17:906:c142:b0:c29:6191:44ea with SMTP id a640c23a62f3a-c317bd56242mr492257666b.12.1791458424634;
        Thu, 08 Oct 2026 04:20:24 -0700 (PDT)
X-Received: by 2002:a17:906:c142:b0:c29:6191:44ea with SMTP id a640c23a62f3a-c317bd56242mr492254166b.12.1791458424262;
        Thu, 08 Oct 2026 04:20:24 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c317c2fae53sm204251866b.49.2026.10.08.04.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:20:22 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: fuse-devel@lists.linux.dev
Cc: John Groves <john@groves.net>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v4 8/9] fuse: add extent map I/O support
Date: Thu,  8 Oct 2026 13:19:59 +0200
Message-ID: <20261008112004.1899560-9-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261008112004.1899560-1-mszeredi@redhat.com>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LWi4feZ2i-OazYDvyvY3BmYVK47gD93G3QpG8jV46lw_1791458425
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Wire up read, write, splice and mmap operations for extent-mapped
files through the iomap/DAX infrastructure.

When a passthrough file is opened with an EXTMAP backing, I/O is
dispatched to the dax devices referenced by the extent map.

If an address is not mapped, EIO is returned on the I/O operation.

Originally-by: John Groves <john@groves.net>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/backing.c     |  15 ++++
 fs/fuse/ext_map.c     | 164 ++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c        |  11 +++
 fs/fuse/fuse_i.h      |   4 ++
 fs/fuse/passthrough.c |  29 ++++++--
 5 files changed, 217 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 660d3e36a6e0..c93e4a45dd6f 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -288,6 +288,21 @@ int fuse_backing_close(struct fuse_conn *fc, int backing_id)
 	return err;
 }
 
+bool fuse_backing_is_dax(struct fuse_backing *fb)
+{
+	switch (fb->type) {
+	case FUSE_BACKING_PATH:
+		return false;
+	case FUSE_BACKING_DAXDEV:
+		return true;
+	case FUSE_BACKING_EXTMAP:
+		return fuse_ext_map_is_dax(fb);
+	default:
+		WARN_ON(1);
+		return false;
+	}
+}
+
 struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backing_id)
 {
 	struct fuse_backing *fb;
diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
index afac5de51c80..744940cbf36e 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -3,6 +3,8 @@
 #include "fuse_i.h"
 #include <linux/rbtree.h>
 #include <linux/pagemap.h>
+#include <linux/iomap.h>
+#include <linux/dax.h>
 
 struct fuse_iext {
 	struct rb_node rb;
@@ -22,6 +24,24 @@ void fuse_ext_map_destroy(struct rb_root *extents)
 	}
 }
 
+static struct fuse_iext *fuse_find_extent(struct rb_root *extents, u64 offset)
+{
+	struct rb_node *node = extents->rb_node;
+
+	while (node) {
+		struct fuse_iext *fie = rb_entry(node, typeof(*fie), rb);
+
+		if (offset < fie->start)
+			node = node->rb_left;
+		else if (offset >= fie->end)
+			node = node->rb_right;
+		else
+			return fie;
+	}
+
+	return NULL;
+}
+
 static int fuse_add_extent(struct fuse_conn *fc, struct rb_root *extents,
 			   struct fuse_extent *ext)
 {
@@ -78,6 +98,150 @@ static int fuse_add_extent(struct fuse_conn *fc, struct rb_root *extents,
 	return 0;
 }
 
+static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+				    unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	struct fuse_backing *fb = fuse_inode_backing(get_fuse_inode(inode));
+	struct fuse_iext *fie;
+	loff_t ext_len;
+
+	if (!fb || fb->type != FUSE_BACKING_EXTMAP)
+		return fuse_EIO("missing or wrong type backing");
+
+	fie = fuse_find_extent(&fb->extents, offset);
+	if (!fie)
+		return fuse_EIO("missing mapping");
+
+	if (WARN_ON(fie->backing->type != FUSE_BACKING_DAXDEV))
+		return fuse_EIO("wrong type backing for extent");
+
+	if (fie->backing->dax_error) {
+		fuse_make_bad(inode);
+		return fuse_EIO("dax error");
+	}
+
+	ext_len = fie->end - fie->start;
+
+	iomap->offset = fie->start;
+	iomap->addr = fie->backing_offset;
+	iomap->length = ext_len;
+	iomap->dax_dev = fie->backing->dax_dev;
+	iomap->type = IOMAP_MAPPED;
+	iomap->flags = 0;
+
+	return 0;
+}
+
+static const struct iomap_ops fuse_ext_map_iomap_ops = {
+	.iomap_begin		= fuse_ext_map_iomap_begin,
+};
+
+static vm_fault_t fuse_ext_map_huge_fault(struct vm_fault *vmf, unsigned int order)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	bool write_fault = (vmf->flags & FAULT_FLAG_WRITE) && (vmf->vma->vm_flags & VM_SHARED);
+	vm_fault_t ret;
+	unsigned long pfn;
+
+	if (!IS_ENABLED(CONFIG_FS_DAX))
+		return VM_FAULT_SIGBUS;
+
+	if (WARN_ON_ONCE(!IS_DAX(inode)))
+		return VM_FAULT_SIGBUS;
+
+	if (write_fault) {
+		sb_start_pagefault(inode->i_sb);
+		file_update_time(vmf->vma->vm_file);
+	}
+
+	filemap_invalidate_lock_shared(inode->i_mapping);
+
+	ret = dax_iomap_fault(vmf, order, &pfn, NULL, &fuse_ext_map_iomap_ops);
+	if (ret & VM_FAULT_NEEDDSYNC)
+		ret = dax_finish_sync_fault(vmf, order, pfn);
+
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+
+	if (write_fault)
+		sb_end_pagefault(inode->i_sb);
+
+	return ret;
+}
+
+static vm_fault_t fuse_ext_map_fault(struct vm_fault *vmf)
+{
+	return fuse_ext_map_huge_fault(vmf, 0);
+}
+
+static const struct vm_operations_struct fuse_ext_map_vm_ops = {
+	.fault		= fuse_ext_map_fault,
+	.huge_fault	= fuse_ext_map_huge_fault,
+	.page_mkwrite	= fuse_ext_map_fault,
+	.pfn_mkwrite	= fuse_ext_map_fault,
+};
+
+static void fuse_rw_clamp(struct kiocb *iocb, struct iov_iter *ubuf)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	loff_t i_size = i_size_read(inode);
+	loff_t max_count = iocb->ki_pos >= i_size ? 0 : i_size - iocb->ki_pos;
+
+	if (iov_iter_count(ubuf) > max_count)
+		iov_iter_truncate(ubuf, max_count);
+}
+
+ssize_t fuse_ext_map_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	ssize_t res;
+
+	guard(rwsem_read)(&inode->i_rwsem);
+
+	fuse_rw_clamp(iocb, to);
+
+	if (!iov_iter_count(to))
+		return 0;
+
+	if (!IS_ENABLED(CONFIG_FS_DAX))
+		return -EIO;
+
+	res = dax_iomap_rw(iocb, to, &fuse_ext_map_iomap_ops);
+
+	file_accessed(iocb->ki_filp);
+	return res;
+}
+
+ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	ssize_t res;
+
+	res = generic_write_checks(iocb, from);
+	if (res <= 0)
+		return res;
+
+	fuse_rw_clamp(iocb, from);
+
+	if (!iov_iter_count(from))
+		return -ENOSPC;
+
+	res = kiocb_modified(iocb);
+	if (res)
+		return res;
+
+	if (!IS_ENABLED(CONFIG_FS_DAX))
+		return -EIO;
+
+	return dax_iomap_rw(iocb, from, &fuse_ext_map_iomap_ops);
+}
+
+int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	file_accessed(file);
+	vma->vm_ops = &fuse_ext_map_vm_ops;
+	vm_flags_set(vma, VM_HUGEPAGE);
+	return 0;
+}
+
 bool fuse_ext_map_is_dax(struct fuse_backing *fb)
 {
 	struct fuse_iext *fie;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e0d72b9d3c4a..48d01868e7a7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -551,6 +551,17 @@ static int fuse_fsync(struct file *file, loff_t start, loff_t end,
 	if (fuse_is_bad(inode))
 		return -EIO;
 
+	if (IS_DAX(inode) && !fuse_inode_vdax(inode)) {
+		/*
+		 * Note: the DAX fault path calls this via dax_finish_sync_fault()
+		 * and taking inode lock in that context is prohibited.
+		 *
+		 * FIXME: need to flush CPU caches for the DAX memory range
+		 * FIXME: need to sync metadata to the server
+		 */
+		return 0;
+	}
+
 	inode_lock(inode);
 
 	/*
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 512beacd4a44..8a9961c4c924 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1321,6 +1321,7 @@ static inline void fuse_backing_put(struct fuse_backing *fb)
 
 struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backing_id);
 int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb);
+bool fuse_backing_is_dax(struct fuse_backing *fb);
 void fuse_backing_files_init(struct fuse_conn *fc);
 void fuse_backing_files_init_64(struct fuse_conn *fc);
 void fuse_backing_files_free(struct fuse_conn *fc);
@@ -1374,6 +1375,9 @@ extern void fuse_sysctl_unregister(void);
 /* ext_map.c */
 
 void fuse_ext_map_destroy(struct rb_root *extents);
+ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *from);
+ssize_t fuse_ext_map_read_iter(struct kiocb *iocb, struct iov_iter *to);
+int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma);
 bool fuse_ext_map_is_dax(struct fuse_backing *fb);
 int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_out *arg,
 			  struct fuse_extent *ext);
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index e9ab1aea34e2..040817ad76e9 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -35,7 +35,6 @@ ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct fuse_file *ff = file->private_data;
 	struct file *backing_file = fuse_file_passthrough(ff);
 	size_t count = iov_iter_count(iter);
-	ssize_t ret;
 	struct backing_file_ctx ctx = {
 		.cred = ff->cred,
 		.accessed = fuse_file_accessed,
@@ -48,10 +47,10 @@ ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (!count)
 		return 0;
 
-	ret = backing_file_read_iter(backing_file, iter, iocb, iocb->ki_flags,
-				     &ctx);
+	if (!backing_file)
+		return fuse_ext_map_read_iter(iocb, iter);
 
-	return ret;
+	return backing_file_read_iter(backing_file, iter, iocb, iocb->ki_flags, &ctx);
 }
 
 ssize_t fuse_passthrough_write_iter(struct kiocb *iocb,
@@ -74,10 +73,13 @@ ssize_t fuse_passthrough_write_iter(struct kiocb *iocb,
 	if (!count)
 		return 0;
 
-	inode_lock(inode);
+	guard(rwsem_write)(&inode->i_rwsem);
+
+	if (!backing_file)
+		return fuse_ext_map_write_iter(iocb, iter);
+
 	ret = backing_file_write_iter(backing_file, iter, iocb, iocb->ki_flags,
 				      &ctx);
-	inode_unlock(inode);
 
 	return ret;
 }
@@ -98,6 +100,9 @@ ssize_t fuse_passthrough_splice_read(struct file *in, loff_t *ppos,
 	pr_debug("%s: backing_file=0x%p, pos=%lld, len=%zu, flags=0x%x\n", __func__,
 		 backing_file, *ppos, len, flags);
 
+	if (!backing_file)
+		return copy_splice_read(in, ppos, pipe, len, flags);
+
 	init_sync_kiocb(&iocb, in);
 	iocb.ki_pos = *ppos;
 	ret = backing_file_splice_read(backing_file, &iocb, pipe, len, flags, &ctx);
@@ -123,6 +128,9 @@ ssize_t fuse_passthrough_splice_write(struct pipe_inode_info *pipe,
 	pr_debug("%s: backing_file=0x%p, pos=%lld, len=%zu, flags=0x%x\n", __func__,
 		 backing_file, *ppos, len, flags);
 
+	if (!backing_file)
+		return iter_file_splice_write(pipe, out, ppos, len, flags);
+
 	inode_lock(inode);
 	init_sync_kiocb(&iocb, out);
 	iocb.ki_pos = *ppos;
@@ -145,6 +153,9 @@ ssize_t fuse_passthrough_mmap(struct file *file, struct vm_area_struct *vma)
 	pr_debug("%s: backing_file=0x%p, start=%lu, end=%lu\n", __func__,
 		 backing_file, vma->vm_start, vma->vm_end);
 
+	if (!backing_file)
+		return fuse_ext_map_mmap(file, vma);
+
 	return backing_file_mmap(backing_file, vma, &ctx);
 }
 
@@ -156,6 +167,12 @@ int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
 	struct fuse_file *ff = file->private_data;
 	struct file *backing_file;
 
+	if (fb->type == FUSE_BACKING_EXTMAP) {
+		if (fuse_backing_is_dax(fb) != !!IS_DAX(file_inode(file)))
+			return fuse_EIO("dax mode mismatch");
+		return 0;
+	}
+
 	if (fb->type != FUSE_BACKING_PATH)
 		return fuse_EIO("invalid backing type");
 
-- 
2.54.0

