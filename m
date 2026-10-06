Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B595A37C0EC
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791309703; cv=none; b=t7gX0S42Wzk+RgVsDIwB4q4AahPMPqK/N9nz4OuGPhWdpKlIcsFtd7NUWreVSJ5Zt9nXf73HCSwaLk5HstH566ZX4D400HNJSb6qx1OItDEctjemnZv5+p/iKLpqIwc7BSruz7HCCnEBWd1m4waIPxQCYITIsSUjCb8Y8Jlv0cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791309703; c=relaxed/simple;
	bh=i7mT7pXewCXM235y8KXQzQ1MN4xioTNU2w3uqNNS+1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=pQ7yLxneturgO0tktpspkfdkk/1Y2c6nzIhnKMIuLyi3kQQ/poDhQPnXBLVMS2NRQ+/Wtb06c7RCdOMEk1NPtdw5mFazM6fEVfh/WEMlslSj/TxQK0up96TyAH8lQr6J4A2ok0FbxOWaiEdRLT4U+oQq6V/S0F+CWqRDXXUheOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EaEChas7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EaEChas7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791309700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZnS/KbxuQ9CYdcjb2BQBcgSshyIqB8n4a77KuFPKRm8=;
	b=EaEChas7CPQqfJa4Zku5vB86271i+QiNxzXVX6GVXQMccpTf/mOh5cKfvm8U3tcPpvvalM
	XO0P/eKQEk5U1ZmAx8JDsZ1V21MtdCRCclUi6DZ45NmyG09+XcE7W6X4fLdvKv19zitszf
	ozcq00YYPWS7JGC0WgllmzirZV6H4Uc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-t1HMV8NpOb2o1MPJG1r-Cw-1; Tue, 06 Oct 2026 14:01:38 -0400
X-MC-Unique: t1HMV8NpOb2o1MPJG1r-Cw-1
X-Mimecast-MFC-AGG-ID: t1HMV8NpOb2o1MPJG1r-Cw_1791309696
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2939083cefso384902966b.1
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 11:01:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791309696; x=1791914496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZnS/KbxuQ9CYdcjb2BQBcgSshyIqB8n4a77KuFPKRm8=;
        b=DsULmPk855CV3UAU6U9BG/aSlvW6JW4BBsTk0HUIUg989pN91NZ/0olAl3eSjnnA37
         rFrSmBczJNoDKu1DXYLVeUdBu2w5ILNJBDsQEiX1eVP9BXO2i7ycg0yPxxAkHombZg9S
         EthvGGXpgPP9QNitVr+fotd13tUDK4J7EzjFwj+RzOhtUfrnMiglYfzSz1+HyNmzvK3b
         8RY3cV3cH75zus/xUoCLLkB+cF4arzLb78HH+ojasT3HiBGyvKEEOgF5jJilAmijMJKU
         S/2atpRRRz3PZa0Z+3WmQaIgGEUYa9gVOHHkc4dlhIpQu9QuecwFttj5GHDFpWtlLbHA
         5h7w==
X-Forwarded-Encrypted: i=1; AKwUvBx68zax3u98F0lYDx7PtPdukVqM18NhCzLLgVlxGhZWni5CEEMGj26bcAq0t/MlGugQTuv49rQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYIjzKsrYjvGLMYxziSbVg7daXpCg2JQKUUlQOC07OwxhP9hmUSH
	ZBnFzgA+dpFnzELLhqPAFLRz2Os7r4rkejqV4POa4NM3cYPvB2751sSYVzsuGZfz07oFjmjPzd4
	+riiZ8F21jFMCneL/YxpWjGuTekvnlpHroTGdDo37VJtrJsflXJjXzg+fdA==
X-Gm-Gg: AYBFou24WrYybMdxtdezwtneeeodsZQ7A4eSooEVYE91P1IoNCZfyCzwfzrdXlCWKJM
	qroDo1BiRO85/tyPMOVSZRjVkqQehBW8KDFUPBfZIY6oZYp/GRof+AkvXutPez+qrktfhc2IYv4
	PuFmpDQoUQBI9AlAdCQpoMVej+St68TdOM6BHac6TRWv+NURQbLHu1aBGZqvvCXfn0cQ/eT7JmU
	Vls0kLVapnHOSvKd0Ml2E7IPwPIxb7xBwRQYcIMN7qmPxuEKTf1QLmZPOrtvKf73x3vaxXPa9YQ
	GXO2t8+jKyw+uOXj0c8rOA22cUcZdmYVDZlpKLiuzJkft/DhZWi0tbUnl0uxtQPzeHR/KxT0YI2
	l2yexGFJlGJ44mOtgeAI6voyAFCIKg6NWCOP5h3EuBqf4GCj8UHtOiu2N
X-Received: by 2002:a05:6402:4541:b0:6aa:e589:87d6 with SMTP id 4fb4d7f45d1cf-6afe2977ddbmr1805432a12.9.1791309695911;
        Tue, 06 Oct 2026 11:01:35 -0700 (PDT)
X-Received: by 2002:a05:6402:4541:b0:6aa:e589:87d6 with SMTP id 4fb4d7f45d1cf-6afe2977ddbmr1805411a12.9.1791309695439;
        Tue, 06 Oct 2026 11:01:35 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb01e5942sm5056684a12.9.2026.10.06.11.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 11:01:33 -0700 (PDT)
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
Subject: [PATCH v3 8/9] fuse: add extent map I/O support
Date: Tue,  6 Oct 2026 20:01:13 +0200
Message-ID: <20261006180115.1425232-9-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261006180115.1425232-1-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f5W_lpaEFbQgzgf9nvYi7aTxoL3dW8jzOfH87P6Kjzg_1791309696
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
 fs/fuse/ext_map.c     | 161 ++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c        |   4 ++
 fs/fuse/fuse_i.h      |   4 ++
 fs/fuse/notify.c      |   3 +
 fs/fuse/passthrough.c |  29 ++++++--
 6 files changed, 210 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index b7ebc951dc31..c53538448dfb 100644
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
index 39d7bb521873..4f418185c0b7 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -3,6 +3,14 @@
 #include "fuse_i.h"
 #include <linux/rbtree.h>
 #include <linux/pagemap.h>
+#include <linux/iomap.h>
+#include <linux/dax.h>
+
+#ifndef CONFIG_FS_DAX
+#define dax_iomap_rw(...) (-EIO)
+#define dax_iomap_fault(...) (-EIO)
+#define dax_finish_sync_fault(...) (-EIO)
+#endif
 
 struct fuse_iext {
 	struct rb_node rb;
@@ -22,6 +30,24 @@ void fuse_ext_map_destroy(struct rb_root *extents)
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
@@ -78,6 +104,141 @@ static int fuse_add_extent(struct fuse_conn *fc, struct rb_root *extents,
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
+		return -EFBIG;
+
+	res = kiocb_modified(iocb);
+	if (res)
+		return res;
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
index e0d72b9d3c4a..8d12d6162424 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -551,6 +551,10 @@ static int fuse_fsync(struct file *file, loff_t start, loff_t end,
 	if (fuse_is_bad(inode))
 		return -EIO;
 
+	/* Skip sync for DAX inodes */
+	if (IS_DAX(inode) && !fuse_inode_vdax(inode))
+		return 0;
+
 	inode_lock(inode);
 
 	/*
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 75eec5c17985..5d38dc1b6f0c 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1324,6 +1324,7 @@ static inline void fuse_backing_put(struct fuse_backing *fb)
 
 struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backing_id);
 int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb);
+bool fuse_backing_is_dax(struct fuse_backing *fb);
 void fuse_backing_files_init(struct fuse_conn *fc);
 void fuse_backing_files_init_64(struct fuse_conn *fc);
 void fuse_backing_files_free(struct fuse_conn *fc);
@@ -1377,6 +1378,9 @@ extern void fuse_sysctl_unregister(void);
 /* ext_map.c */
 
 void fuse_ext_map_destroy(struct rb_root *extents);
+ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *from);
+ssize_t fuse_ext_map_read_iter(struct kiocb *iocb, struct iov_iter *to);
+int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma);
 bool fuse_ext_map_is_dax(struct fuse_backing *fb);
 int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_out *arg,
 			  struct fuse_extent *ext);
diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
index 7c427f88bbc5..3bfedd0cdbdd 100644
--- a/fs/fuse/notify.c
+++ b/fs/fuse/notify.c
@@ -448,6 +448,9 @@ static int fuse_notify_map(struct fuse_conn *fc, unsigned int size,
 	if (err)
 		return err;
 
+	if (!fc->backing_id_64)
+		return -EINVAL;
+
 	if (outarg.num_extents > FUSE_MAX_EXTENTS)
 		return -EINVAL;
 
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

