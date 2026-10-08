Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4456C437858
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 11:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458426; cv=none; b=iviGKF4zB8YLe95g0e2KcUPq6CmeVFvxL/YplVA9LIYlfUqa2FxPGq0k6s1qekGjB61rq/1FXHGkFzrkYTBHi5tA8ej5Wt1ogjXcsN066kDO4KbVFo5GEL9l2jWI8oFCeIi/VKpTS7V2ZGl+ECdUc5hsdtRTyZLw86Vg5tX+sN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458426; c=relaxed/simple;
	bh=ELJlR37gWA1iz5b9zmyHewlNhrP3Gr5e5D61XWWGiic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=t1IThBPuGCYGQg3E8YVSOx69AWeP6y8r2iA0pctDlDeNnU/R2MGArFmGEfuB/Sh5SnhXEBoXsMG4pQ+uSdLQuwBQzsyZk5+nF8hyoJ3W+cROI6DwvMijViQjj7n49nnvfxtTXaHmGubxgZI4gJ0jgo2aDM1Kv9B07/cbA490ppQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O7RHo4jJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O7RHo4jJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791458423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9AC1EEVoGxd3otOvFToQXoZcmSwlJuWzN3Lg8glwBIY=;
	b=O7RHo4jJT2iumh9CTpPhaCWtPRBthKfYIqn57mYwVQZeCPR9//APgJDiEDdHyLDnA/uo74
	s4uy5JVZH7dGCucxvxW5IlW5K6BVAWxaNAelye3UP8cqd5MeVXkFrCOi5TcuNpszumQTRo
	SwcoPAjdwDJquxqO9HSQ7E8bGY1jp4I=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-yHm3-_mtMrSrrVWuUtEAvA-1; Thu, 08 Oct 2026 07:20:22 -0400
X-MC-Unique: yHm3-_mtMrSrrVWuUtEAvA-1
X-Mimecast-MFC-AGG-ID: yHm3-_mtMrSrrVWuUtEAvA_1791458421
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c25501f4aa2so82340866b.1
        for <nvdimm@lists.linux.dev>; Thu, 08 Oct 2026 04:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791458421; x=1792063221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9AC1EEVoGxd3otOvFToQXoZcmSwlJuWzN3Lg8glwBIY=;
        b=k+VH5yQFykJO/T3jQVoyRKYN21DFgYWiNLyHFHj3dFAvs5BWdAQvn7gx5MOIntWazL
         jgy1yvDSK/euElwkb+WCl8DVyjHvDvrpaGOpNABqKu4FvqWK48Soz6fmzNTS8JlHUiXK
         dY8w4AhlO7DJGdlAjK05YNN+ZFtupme9bmea/YQ9GHI1qxt50sNkfJ6QefO+bPb1GBGZ
         9u8yY1cIxtw2Nxcsqg+MauIpCIXhplwbGrzaIQredaRbXo/YcrrpdT8tJ4heaT033N9l
         g90YqapkiEnOQhfgYxgJ5415mjjZnSrM3lOA9CATZRZ3G0AesKMJSl2DWuRIzXuI1z8W
         SxAQ==
X-Forwarded-Encrypted: i=1; AKwUvBxEEyZC6d518HPh6PJwxMFhSQHcn+PUP94RNjqwP8AzEB7dZuWGhuG4C4w4ry7E3mK4wAEqng4=@lists.linux.dev
X-Gm-Message-State: AFuF++mUxXS1MGRC85r/ySKkfIERxApZOqYoktCuilHmh8H/2TiGVmhB
	+3Ho/dVx8icR09/s3HiE1jwBfhwp6uWEe4ejb0F9eT5mXigrbfLoxz2hDRBftb9ydj4FaYH0FRs
	JuyEzy4ppN7dRJ0ApZ2FLlI5DgMYaH9JHo3roq3HvaEOob0eJx/nembA9EQ==
X-Gm-Gg: AYBFou32pbwMFpSy37VKREUX8RpC8H+9jqPopObNFoDrfDEzU3RMb9dui/jwr1jImKK
	FhoMIc3kKyfzcGofT8t2pfOBmgcuWDjZFyz3vMmZxWAeo+aDrri3bQX3Ha66sdf91xf/1paCPb6
	2fwBchwnmgMA34nOhzRK7geQyIvzENRiGdRy3JoiJbYd1r9wiftrA92OZQQSyoXy7O6Us3yAXGa
	0q7Uk8q79/DtrVdMoWxDd2C4uwmOUYC6gLmdcm6He28ODpJ9hnJtGNbsdKZ8rUm2svNdCnRetcW
	/Bzv69NUGmZUTURTMfqAgcw+1IhvtA/GodrYZmHRqyKj68EZ+laA3pnE9HT/trHCFzMHaabL7kY
	ZhKIrz2HtjJ31daEqo9SfOxAbo3bHsh6dYaIlQhISO3rZhp3ZFsgJWkdC
X-Received: by 2002:a17:907:1c98:b0:c2e:7fc:ef51 with SMTP id a640c23a62f3a-c3191d8a07emr188490066b.20.1791458420719;
        Thu, 08 Oct 2026 04:20:20 -0700 (PDT)
X-Received: by 2002:a17:907:1c98:b0:c2e:7fc:ef51 with SMTP id a640c23a62f3a-c3191d8a07emr188487466b.20.1791458420282;
        Thu, 08 Oct 2026 04:20:20 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c317c2fae53sm204251866b.49.2026.10.08.04.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:20:18 -0700 (PDT)
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
Subject: [PATCH v4 6/9] fuse: add support for opening dax device as backing
Date: Thu,  8 Oct 2026 13:19:57 +0200
Message-ID: <20261008112004.1899560-7-mszeredi@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 7Sk4BCwVqxOsTXyiOE3MoB9AUtlcxYi6rE8IhP2AUks_1791458421
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This is only possible with FUSE_PASSTHROUGH_V2 enabled.

Mark the inode with S_DAX if FUSE_LOOKUP returns with FUSE_ATTR_DAX set.

This patch does not yet provide a way actually use the dax dev backing:
when such a backing ID is provided in reply to FUSE_OPEN with
FOPEN_PASSTHROUGH flag set, an error will be returned.

Move fuse_backing_put() from fuse_free_inode() to fuse_evict_inode() to
avoid sleeping in atomic context.

Originally-by: John Groves <john@groves.net>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/backing.c     | 108 +++++++++++++++++++++++++++++++++---------
 fs/fuse/file.c        |   2 +-
 fs/fuse/fuse_i.h      |  33 +++++++++++--
 fs/fuse/inode.c       |  17 +++++--
 fs/fuse/iomode.c      |  10 ++--
 fs/fuse/passthrough.c |   6 ++-
 6 files changed, 140 insertions(+), 36 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 15132150535a..9ded41a94fcc 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -9,6 +9,7 @@
 #include "fuse_i.h"
 
 #include <linux/file.h>
+#include <linux/dax.h>
 #include <linux/rhashtable.h>
 
 static struct fuse_backing *fuse_backing_get(struct fuse_backing *fb)
@@ -22,9 +23,16 @@ static void fuse_backing_free(struct fuse_backing *fb)
 {
 	pr_debug("%s: fb=0x%p\n", __func__, fb);
 
-	if (fb->file)
-		fput(fb->file);
-	put_cred(fb->cred);
+	switch (fb->type) {
+	case FUSE_BACKING_PATH:
+		path_put(&fb->path);
+		put_cred(fb->cred);
+		break;
+
+	case FUSE_BACKING_DAXDEV:
+		fs_put_dax(fb->dax_dev, fb);
+		break;
+	}
 	kfree_rcu(fb, rcu);
 }
 
@@ -103,39 +111,93 @@ int fuse_backing_close_64(struct fuse_conn *fc, u64 backing_id)
 	return 0;
 }
 
-static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int fd)
+static int fuse_dax_notify_failure(struct dax_device *daxdev, u64 offset, u64 len, int mf_flags)
 {
 	struct fuse_backing *fb;
-	struct super_block *backing_sb;
-	struct file *file;
 
-	/* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
-	if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
-		return ERR_PTR(-EPERM);
+	guard(rcu)();
 
-	CLASS(fd_raw, f)(fd);
-	if (fd_empty(f))
-		return ERR_PTR(-EBADF);
+	fb = dax_holder(daxdev);
+	if (fb)
+		fb->dax_error = true;
+
+	return 0;
+}
+
+static const struct dax_holder_operations fuse_dax_holder_ops = {
+	.notify_failure		= fuse_dax_notify_failure,
+};
+
+static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb, struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	struct dax_device *daxdev;
+	int err;
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFREG:
+		/* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
+		if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
+			return -ELOOP;
+
+		fb->type = FUSE_BACKING_PATH;
+		fb->path = file->f_path;
+		path_get(&fb->path);
+		fb->cred = get_current_cred();
+		return 0;
+
+	case S_IFCHR:
+		if (!fc->passthrough || !fc->backing_id_64)
+			return -EINVAL;
+
+		if (!IS_ENABLED(CONFIG_DEV_DAX_FSDEV))
+			return -EINVAL;
+
+		daxdev = fsdev_dax_from_file(file);
+		if (!daxdev)
+			return -EINVAL;
+
+		err = -EPERM;
+		if (capable(CAP_SYS_RAWIO)) {
+			err = fs_dax_get(daxdev, fb, &fuse_dax_holder_ops);
+			if (!err) {
+				fb->type = FUSE_BACKING_DAXDEV;
+				fb->dax_dev = daxdev;
+			}
+		}
+		put_dax(daxdev);
+		return err;
 
-	file = fd_file(f);
+	case S_IFDIR:
+		return -EISDIR;
 
-	/* read/write/splice/mmap passthrough only relevant for regular files */
-	if (!d_is_reg(file->f_path.dentry))
-		return d_is_dir(file->f_path.dentry) ? ERR_PTR(-EISDIR) : ERR_PTR(-EINVAL);
+	default:
+		return -EINVAL;
+	}
+}
 
-	backing_sb = file_inode(file)->i_sb;
-	if (backing_sb->s_stack_depth >= fc->max_stack_depth)
-		return ERR_PTR(-ELOOP);
+static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int fd)
+{
+	struct fuse_backing *fb __free(kfree) = kzalloc_obj(*fb);
+	int err;
 
-	fb = kmalloc_obj(struct fuse_backing);
 	if (!fb)
 		return ERR_PTR(-ENOMEM);
 
-	fb->file = get_file(file);
-	fb->cred = get_current_cred();
+	CLASS(fd_raw, f)(fd);
+	if (fd_empty(f))
+		return ERR_PTR(-EBADF);
+
+	err = fuse_backing_open_file(fc, fb, fd_file(f));
+	if (err)
+		return ERR_PTR(err);
+
 	refcount_set(&fb->count, 1);
 
-	return fb;
+	return_ptr(fb);
 }
 
 int fuse_backing_open_64(struct fuse_conn *fc, struct fuse_backing_create_in *map)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5273957f0399..e0d72b9d3c4a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -297,7 +297,7 @@ static int fuse_open(struct inode *inode, struct file *file)
 	if (!err) {
 		if (is_truncate)
 			truncate_pagecache(inode, 0);
-		else if (!(ff->open_flags & FOPEN_KEEP_CACHE))
+		else if (!(ff->open_flags & FOPEN_KEEP_CACHE) && !IS_DAX(inode))
 			invalidate_inode_pages2(inode->i_mapping);
 	}
 out_unlock:
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 89dedcb54ba7..8c65b6b8c840 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -89,10 +89,25 @@ struct fuse_submount_lookup {
 	struct fuse_forget_link *forget;
 };
 
+enum fuse_backing_type {
+	FUSE_BACKING_PATH,
+	FUSE_BACKING_DAXDEV,
+};
+
 /* Container for data related to mapping to backing file */
 struct fuse_backing {
-	struct file *file;
-	const struct cred *cred;
+	enum fuse_backing_type type;
+
+	union {
+		struct {
+			struct path path;
+			const struct cred *cred;
+		};
+		struct {
+			struct dax_device *dax_dev;
+			bool dax_error;
+		};
+	};
 	u64 backing_id;
 	struct rhash_head hash_node;
 	/* refcount */
@@ -1239,7 +1254,19 @@ void fuse_free_conn(struct fuse_conn *fc);
 
 /* dax.c */
 
-#define FUSE_IS_VDAX(inode) (IS_ENABLED(CONFIG_FUSE_VDAX) && IS_DAX(inode))
+static inline bool fuse_inode_vdax(struct inode *inode)
+{
+#ifdef CONFIG_FUSE_VDAX
+	return get_fuse_inode(inode)->vdax;
+#else
+	return false;
+#endif
+}
+
+static inline bool FUSE_IS_VDAX(struct inode *inode)
+{
+	return fuse_inode_vdax(inode) && IS_DAX(inode);
+}
 
 ssize_t fuse_vdax_read_iter(struct kiocb *iocb, struct iov_iter *to);
 ssize_t fuse_vdax_write_iter(struct kiocb *iocb, struct iov_iter *from);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b69c95ebb1ad..330655af3bd0 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -124,9 +124,6 @@ static void fuse_free_inode(struct inode *inode)
 #ifdef CONFIG_FUSE_VDAX
 	kfree(fi->vdax);
 #endif
-	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
-		fuse_backing_put(fuse_inode_backing(fi));
-
 	kmem_cache_free(fuse_inode_cachep, fi);
 }
 
@@ -148,7 +145,7 @@ static void fuse_evict_inode(struct inode *inode)
 	/* Will write inode on close/munmap and in all other dirtiers */
 	WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);
 
-	if (FUSE_IS_VDAX(inode))
+	if (IS_DAX(inode))
 		dax_break_layout_final(inode);
 
 	truncate_inode_pages_final(&inode->i_data);
@@ -177,6 +174,9 @@ static void fuse_evict_inode(struct inode *inode)
 		if (inode->i_nlink > 0)
 			atomic64_inc(&fc->evict_ctr);
 	}
+	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
+		fuse_backing_put(fuse_inode_backing(fi));
+
 	if (S_ISREG(inode->i_mode) && !fuse_is_bad(inode)) {
 		WARN_ON(fi->iocachectr != 0);
 		WARN_ON(!list_empty(&fi->write_files));
@@ -403,6 +403,10 @@ static void fuse_init_submount_lookup(struct fuse_submount_lookup *sl,
 	refcount_set(&sl->count, 1);
 }
 
+static const struct address_space_operations fuse_dax_aops = {
+	.dirty_folio	= noop_dirty_folio,
+};
+
 static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr,
 			    struct fuse_conn *fc)
 {
@@ -413,6 +417,11 @@ static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr,
 	if (S_ISREG(inode->i_mode)) {
 		fuse_init_common(inode);
 		fuse_init_file_inode(inode, attr->flags);
+
+		if ((attr->flags & FUSE_ATTR_DAX) && !fuse_inode_vdax(inode)) {
+			inode->i_flags |= S_DAX;
+			inode->i_data.a_ops = &fuse_dax_aops;
+		}
 	} else if (S_ISDIR(inode->i_mode))
 		fuse_init_dir(inode);
 	else if (S_ISLNK(inode->i_mode))
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index 8b4774c80b11..38afe1f238ef 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -230,10 +230,14 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 	 * Server is expected to use FOPEN_PASSTHROUGH for all opens of an inode
 	 * which is already open for passthrough.  Using incorrect open mode is
 	 * a server mistake, which results in user visible failure of open()
-	 * with EIO error.
+	 * with EIO error.  Same with DAX inodes.
 	 */
-	if (fuse_inode_backing(fi) && !(ff->open_flags & FOPEN_PASSTHROUGH))
-		return fuse_EIO("FOPEN_PASSTHROUGH expected");
+	if (!(ff->open_flags & FOPEN_PASSTHROUGH)) {
+		if (fuse_inode_backing(fi))
+			return fuse_EIO("FOPEN_PASSTHROUGH expected");
+		if (IS_DAX(inode))
+			return fuse_EIO("DAX inode without FOPEN_PASSTHROUGH");
+	}
 
 	/*
 	 * FOPEN_PARALLEL_DIRECT_WRITES requires FOPEN_DIRECT_IO.
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 4894842ad6d0..e9ab1aea34e2 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -156,9 +156,11 @@ int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
 	struct fuse_file *ff = file->private_data;
 	struct file *backing_file;
 
+	if (fb->type != FUSE_BACKING_PATH)
+		return fuse_EIO("invalid backing type");
+
 	/* Allocate backing file per fuse file to store fuse path */
-	backing_file = backing_file_open(file, file->f_flags,
-					 &fb->file->f_path, fb->cred);
+	backing_file = backing_file_open(file, file->f_flags, &fb->path, fb->cred);
 	if (IS_ERR(backing_file))
 		return fuse_EIO("failed to open backing file (%ld)", PTR_ERR(backing_file));
 
-- 
2.54.0

