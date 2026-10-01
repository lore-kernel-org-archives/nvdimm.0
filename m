Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C787937B025
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867394; cv=none; b=Pr+NvLPd/AMaHaww9hjKp+DLhSFnOOXPSWdcVRSkOPmxHamK9G8graQdAN2BckJRl0uHeJaxOZ2tscxjLEy+1KCuaRhusTj10OwHMn5HKcKSEGErdVGf1on1vz2W3inR0TbWH6/sT7r8ehMp7qgvjplf1ccbo+R6660vTR7pwqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867394; c=relaxed/simple;
	bh=4t+dzNrtjemQGlMoDAOQMGwhr0/nPe0u34D53vlue/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=j/spnRmp5sKn1PxzYyYq5ylYR8y0HcAsgPf7p+1/lWqcvS807ySpI5GDCpinbYS76Vuoe155XzT7ca5tEr8tcNZR5UGMeQNuTiWjksiyqU4NKRrT6QvpjhxVF8Pg3KkVa+PNG8mR+9E4hu7p5haX/KYnCjAt1z/qJLvl5HXudj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h/aa51sQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h/aa51sQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790867391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4UTi131uedzHFa6VgoW5E2PrCq8nqSEd2jZ2PJZfVoM=;
	b=h/aa51sQSdB9+jsvfa5GvQMqwYmBcq5DJOn7U1eSq3hW5UtC+bVCpneXLwqmBNzDSE140x
	utenMmXODY6KjVcOdqA2ggw/CM6Mc7bOtKYVY2O7GPYoHoumJbmRCuelgtbmnJoEC+LnE6
	bpe9eZkJEWimVLMZUXIaQrrAhdWmDTI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-DR0W_GVmNx2wztH6_4mSFQ-1; Thu, 01 Oct 2026 11:09:50 -0400
X-MC-Unique: DR0W_GVmNx2wztH6_4mSFQ-1
X-Mimecast-MFC-AGG-ID: DR0W_GVmNx2wztH6_4mSFQ_1790867389
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c2dc14de1c1so470445566b.0
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 08:09:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790867389; x=1791472189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4UTi131uedzHFa6VgoW5E2PrCq8nqSEd2jZ2PJZfVoM=;
        b=w8qEz4ASVmzr24PxTlmBR3LX64vX0hnfT3vzHhj2JT7KgsNbgXryLthsKLBzu//MYH
         c6qFTrhw9sr3g6p4o2z9aCbnV1noFeQJZDWprerbpm5a+hk1xQyy1zV1jn2Ci+hSoPtP
         Q/W/NW5ZyvcC6h4AgjwBqRiUSap1uCFFY39fqOI170KY6QPr1d4FSkcR56VuyQcbMtsu
         KRMhVQQHt6y5BjVvyql9WQUop7htM1euVKXDzWVDqy9IQ9VdVIQiBfeOfHgrOqNuLxSs
         5VZn7KZw+inarGtoQAffNXJhUDr6+hR2R6kqWdc1ooKyKbXKsOLWmtzxG7AhDfBR7Yiu
         Ndsw==
X-Forwarded-Encrypted: i=1; AKwUvBw4Dngk9V/LXg3wgeiE1lXxH8LvUlVZVWIe4Rz/XF91sFv/ODF7erlGm53IcxvjmJWfnVG5kVs=@lists.linux.dev
X-Gm-Message-State: AFuF++mczPnZZ9GluUlmNhF2q+tVQQbKpkEHOQZzQ5TuolE2nDrcGsCj
	Moo6jAz8HN5W7gBELS5oFZlF2ClDQBOYM235UWm+wBE2sNYDv9pR0L6BiSchTNfZcJbeSEJfebZ
	NYCq5X3mXT9+C+52XmyYeIDxDENuFZneKd+ubx5lKsAvmCTeLT88N6gbJEg==
X-Gm-Gg: AYBFou1cznwxcWKpqQYAATbsu8bHJLdfAgVn4OR8qAk+JoSXxGe9huxPTOjbPZ9+INN
	sNCPowTKLEyaDsfAMccZJt5JUENw4GTqsg4H6CZjwaZ8xoOreyQcCo9aZuApSgw+xSffYf4OO/J
	KRU9Qfb73NjArl2cUAR6xw6xGVqx5JwEGZ0YbQXQEXCY+9Uhf89y+XSQYxOjJ+3yTlMXR/UEvgw
	wuhdvMp/R5uQWZt/STiwwkuFl2CDB7PIAu1XyTH5Eb9yTvEeqokjyel/w1BOP+SBslz78Q30LU3
	04lNd2iHEXfkh0A5R3jr2n1skZoCNgpYLk4zYEwb2ucUzR+MjO4AclFbEzLZfmvb+WmXfn4KL5i
	ZGrt8T2s7mp+Y5IM2qj7/4bZI486y2j8RGo2fLFwrm6MN2m94Q7HkOxaAFck=
X-Received: by 2002:a17:906:7308:b0:c29:566f:531c with SMTP id a640c23a62f3a-c2e23d64e23mr453729966b.31.1790867389282;
        Thu, 01 Oct 2026 08:09:49 -0700 (PDT)
X-Received: by 2002:a17:906:7308:b0:c29:566f:531c with SMTP id a640c23a62f3a-c2e23d64e23mr453725966b.31.1790867388725;
        Thu, 01 Oct 2026 08:09:48 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-245-188.pool.digikabel.hu. [193.226.245.188])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d86372sm177735166b.56.2026.10.01.08.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:09:47 -0700 (PDT)
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
Subject: [PATCH v2 5/8] fuse: add support for opening dax device as backing
Date: Thu,  1 Oct 2026 17:07:23 +0200
Message-ID: <20261001150935.655979-6-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261001150935.655979-1-mszeredi@redhat.com>
References: <20261001150935.655979-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jmK063GDSnxG0QkB6mtxp6Hb4_zCSP0Kzbd2ZQs5smE_1790867389
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This is only possible with FUSE_PASSTHROUGH_V2 enabled.

Mark the inode with S_DAX if FUSE_LOOKUP returns with FUSE_ATTR_DAX set.

This patch does not yet provide a way actually use the dax dev backing:
when such a backing ID is provided in reply to FUSE_OPEN with
FOPEN_PASSTHROUGH flag set, an error will be returned.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/backing.c     | 121 ++++++++++++++++++++++++++++++------------
 fs/fuse/file.c        |   2 +-
 fs/fuse/fuse_i.h      |  28 ++++++++--
 fs/fuse/inode.c       |  11 +++-
 fs/fuse/passthrough.c |   6 ++-
 5 files changed, 126 insertions(+), 42 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 3c879df7989c..c852f0498961 100644
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
 
@@ -103,39 +111,83 @@ int fuse_backing_close_64(struct fuse_conn *fc, u64 backing_id)
 	return 0;
 }
 
-static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int fd)
+static int fuse_dax_notify_failure(struct dax_device *daxdev, u64 offset, u64 len, int mf_flags)
 {
-	struct fuse_backing *fb;
-	struct super_block *backing_sb;
-	struct file *file;
+	struct fuse_backing *fb = dax_holder(daxdev);
 
-	/* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
-	if (!fc->passthrough || !capable(CAP_SYS_ADMIN))
-		return ERR_PTR(-EPERM);
+	fb->dax_error = true;
 
-	CLASS(fd_raw, f)(fd);
-	if (fd_empty(f))
-		return ERR_PTR(-EBADF);
+	return 0;
+}
 
-	file = fd_file(f);
+static const struct dax_holder_operations fuse_dax_holder_ops = {
+	.notify_failure		= fuse_dax_notify_failure,
+};
+
+static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb, struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	struct dax_device *daxdev;
+	int err;
 
-	/* read/write/splice/mmap passthrough only relevant for regular files */
-	if (!d_is_reg(file->f_path.dentry))
-		return d_is_dir(file->f_path.dentry) ? ERR_PTR(-EISDIR) : ERR_PTR(-EINVAL);
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
+		daxdev = dax_dev_find(inode->i_rdev);
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
 
-	backing_sb = file_inode(file)->i_sb;
-	if (backing_sb->s_stack_depth >= fc->max_stack_depth)
-		return ERR_PTR(-ELOOP);
+	case S_IFDIR:
+		return -EISDIR;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static struct fuse_backing *fuse_backing_new(struct fuse_conn *fc, int fd)
+{
+	struct fuse_backing *fb __free(kfree) = kmalloc_obj(*fb);
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
@@ -143,22 +195,21 @@ int fuse_backing_open_64(struct fuse_conn *fc, struct fuse_backing_create_in *ma
 	struct fuse_backing *fb;
 	int res;
 
-	res = -EINVAL;
 	if (map->padding || map->spare[0] || map->spare[1])
-		goto out;
+		return -EINVAL;
 
 	if (!fc->backing_id_64)
-		goto out;
+		return -EINVAL;
 
 	fb = fuse_backing_new(fc, map->fd);
-	res = PTR_ERR(fb);
-	if (!IS_ERR(fb)) {
-		fb->backing_id = map->backing_id;
-		res = fuse_backing_add_64(fc, fb);
-		if (res < 0)
-			fuse_backing_free(fb);
-	}
-out:
+	if (IS_ERR(fb))
+		return PTR_ERR(fb);
+
+	fb->backing_id = map->backing_id;
+	res = fuse_backing_add_64(fc, fb);
+	if (res < 0)
+		fuse_backing_free(fb);
+
 	return res;
 }
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 1036c06fe35a..fb8e0a9fa4f6 100644
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
index 59afebc3dd2b..3e7ffb9bb2c3 100644
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
@@ -1239,7 +1254,14 @@ void fuse_free_conn(struct fuse_conn *fc);
 
 /* dax.c */
 
-#define FUSE_IS_VDAX(inode) (IS_ENABLED(CONFIG_FUSE_VDAX) && IS_DAX(inode))
+static inline bool FUSE_IS_VDAX(struct inode *inode)
+{
+#ifdef CONFIG_FUSE_VDAX
+	return get_fuse_inode(inode)->vdax && IS_DAX(inode);
+#else
+	return false;
+#endif
+}
 
 ssize_t fuse_vdax_read_iter(struct kiocb *iocb, struct iov_iter *to);
 ssize_t fuse_vdax_write_iter(struct kiocb *iocb, struct iov_iter *from);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index bb76bddfc241..d42c824fd6af 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -148,7 +148,7 @@ static void fuse_evict_inode(struct inode *inode)
 	/* Will write inode on close/munmap and in all other dirtiers */
 	WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);
 
-	if (FUSE_IS_VDAX(inode))
+	if (IS_DAX(inode))
 		dax_break_layout_final(inode);
 
 	truncate_inode_pages_final(&inode->i_data);
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
@@ -430,6 +434,11 @@ static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr,
 	 */
 	if (!fc->posix_acl)
 		inode->i_acl = inode->i_default_acl = ACL_DONT_CACHE;
+
+	if ((attr->flags & FUSE_ATTR_DAX) && !fc->vdax) {
+		inode->i_flags |= S_DAX;
+		inode->i_data.a_ops = &fuse_dax_aops;
+	}
 }
 
 static int fuse_inode_eq(struct inode *inode, void *_nodeidp)
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

