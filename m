Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6F14DD3C7
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163861; cv=none; b=BzwOXPADrBkmfwiLmllrLk9cWenPzErUVKkqG0A3JzmvWcEKzAz4H0M6YCIj4oPI3JErs1a5TwE7OfPIle7l+wDh60+dtqRylPo20fc8ZLWgohYYN1yMXrKwStllSBxipp83V5Etzmvppmruog1mxNlZ7A56TF8uibZrZjhbi10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163861; c=relaxed/simple;
	bh=/GhdWRo334j+OwMupnxYTkRgenAl3fpRiG6jY1gx7Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DPRgzZOTZXjZf2dIVE9WlQcmgz8BYTg9EQjYbDRg5EI69MlfEGtGLSfeopnkmvIedlCpWO5FSANlBH+d57gQCOm9vBu+syM8R8B5RYpYq2bOMKIAlAaOcRo6AdYpbk3syoa0O2L5K25YNshSTRfsBJNVTNtBUjmn5U6to++mKx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gqhnT2SP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gqhnT2SP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792163855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqkDPfv9kjR2G9bpgWIaOp4BxK1ARYcdnmvP88XzcCU=;
	b=gqhnT2SPqi9gnxzxSSbRQwvN1BnJrPKCGbFXRQxj41ZRz7y7xyRryk3eYckIKamaLXhXSk
	u96KbIxDzX/W3CCXTpZELXqjsiaaHERhPBvP+wngS3YhKIadp7adol0yXRZdrdZqPs1NFa
	CQQs8G5CCDcno/eegsFeDxOK6bgIanQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-J-TT62eXMjaiiy3F3FK_gQ-1; Fri, 16 Oct 2026 15:17:34 +0000
X-MC-Unique: J-TT62eXMjaiiy3F3FK_gQ-1
X-Mimecast-MFC-AGG-ID: J-TT62eXMjaiiy3F3FK_gQ_1792163853
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1895ffc83so356295e9.3
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 08:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163853; x=1792768653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VqkDPfv9kjR2G9bpgWIaOp4BxK1ARYcdnmvP88XzcCU=;
        b=zJAZJJ/KIc11jG0oE2KdoL7/ukQt4VJIZmIH3Sir0/YGXW4wBPyYA8knVBlP1lyk+A
         fo2yVbsJ8iw6yEOOxgWygJcVmS8wFGVy47ne1iRuYJF4ligRDPcCShh4+fYRoKE2N9QG
         iPgZwLgDvKEOOEHp4aFBN4bzKDUYMU8c2W61tS0j9ilTTvnuC2/wMo6Hrn2KFaECEFSK
         zPabbPnliwm0AOIz4GTyznLeNINBQNT6d2+bTAWVHly+r73F+9FuvlKSWgA037cew6Em
         +b6ZtV1iQDDdyR4HOZWPjCRr89Gc1GHrlsds1IBL5GJeHBUqcqhn6aJF8r3GZIAZO7yk
         OL2w==
X-Forwarded-Encrypted: i=1; AKwUvBxVK5LrM5iVoi0kdLQw8EAOhuKpuatNLOpOu1+3MJyI6mCFQB4Le1ME0sizbne569x2XGA+pl8=@lists.linux.dev
X-Gm-Message-State: AFq9FYLorIWIHUv7E49vQPveGYWjiwJ54ozizBQLDtXmdixNmYPg0oiE
	f4PHGIW9fMi6kbjHpmjDRllAHZt2xZfFUskXVfiU71HmbBAN1Bre7aqvhFiQyfTIjrm0gmnh+eB
	rpixwyh7UAxConzDv0G28+ls/7IuBg39G1NMqg4hVMLzW719CbdV83zTn8A==
X-Gm-Gg: AYBFou2GC7vLqRcP7Z7XYTBHKE3wLgtBOUj2m23gXiCaZiJiD+MC34LPiZIYb+C8Pm9
	XG9lFSs4baOBFUQxHIixSdoGk4EBdM0+QzH8Z1npq7PZ5J/PYAmoIx1n3MLQj6g4h/R5xFodTXS
	UK2QjIohWzfCrSmLiDgzTOGBuQexR+3kjBWqSNYEl4u9R968HQkUsyWArNk3WOfCPXy7Y9LWRds
	r0OH7oJWfCfC298XhAPMC/XCgy4WPryZxO07ODS/sDyW8/kJj1qHTG8wPYSYuARVwk1OwIu5BTl
	GDl7rmPtGAkUKu6P/VwP7byqo00Trs1PanuDOTrpI+ltzmf6fFkMDTdTyACzvmp+Rm+qjEkRieT
	yYnJfbBlyWexNx1Ev9idRkA==
X-Received: by 2002:a05:600d:82c9:b0:4a0:1e87:910 with SMTP id 5b1f17b1804b1-4a1d762886bmr2473545e9.20.1792163852902;
        Fri, 16 Oct 2026 08:17:32 -0700 (PDT)
X-Received: by 2002:a05:600d:82c9:b0:4a0:1e87:910 with SMTP id 5b1f17b1804b1-4a1d762886bmr2472865e9.20.1792163852533;
        Fri, 16 Oct 2026 08:17:32 -0700 (PDT)
Received: from maszat.com (85-67-2-18.pool.digikabel.hu. [85.67.2.18])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8de7230sm64621665e9.14.2026.10.16.08.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:17:31 -0700 (PDT)
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
Subject: [PATCH v5 08/10] fuse: add extent map I/O support
Date: Fri, 16 Oct 2026 17:16:35 +0200
Message-ID: <20261016151638.2962413-9-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261016151638.2962413-1-mszeredi@redhat.com>
References: <20261016151638.2962413-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V_Gd2YGt92q29vpMUYUOPy99VOrbrGIH5_LllWUnpFA_1792163853
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
index bb756f4e3b86..390668157de3 100644
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
index 76c134e5aa48..da73d1e183c4 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -555,6 +555,17 @@ static int fuse_fsync(struct file *file, loff_t start, loff_t end,
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
index 79078e58d4d9..8419a4d3451b 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1321,6 +1321,7 @@ static inline void fuse_backing_put(struct fuse_backing *fb)
 
 struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backing_id);
 int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb);
+bool fuse_backing_is_dax(struct fuse_backing *fb);
 void fuse_backing_files_init(struct fuse_conn *fc);
 void fuse_backing_files_init_64(struct fuse_conn *fc);
 void fuse_backing_files_free(struct fuse_conn *fc);
@@ -1375,6 +1376,9 @@ extern void fuse_sysctl_unregister(void);
 /* ext_map.c */
 
 void fuse_ext_map_destroy(struct rb_root *extents);
+ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *from);
+ssize_t fuse_ext_map_read_iter(struct kiocb *iocb, struct iov_iter *to);
+int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma);
 bool fuse_ext_map_is_dax(struct fuse_backing *fb);
 int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_out *arg,
 			  struct fuse_extent *ext);
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 2c87c0ef8a25..1c1cf1085c9c 100644
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
 
@@ -169,6 +180,12 @@ int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
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

