Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DC851AED7
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 15:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867389; cv=none; b=XH6wT1wLCyUw9nzAFqR1hqHUyEFdZ4ubZEIpe7NZHcsbleuTnK22akzCrw0d/7elQgMt9H+JFl6h0stASbRq2wiayR0/mDESoIA/PqnSIcyJvxKNt5T0YNoj8UnRhxKyPnKH8coyd2Zh6iv7hjUKng9cDacoo1SX/6dcAo4Tpfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867389; c=relaxed/simple;
	bh=bl0rPBSBFKJXFFcSND+2Sx6IhW2Gei6pJ6J5QRVVPII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=SOCWth00uGFWX3w0p+yJ8UHGaCZLSs5BJRVZGwwMzFbujP2k3A/AaS9F4UljWujFMiKhtUGeu2XoildVVRo4jJ6MHmsX0f7iYtGsQak+tuJBcy7CRaa3gmjkPtqonEVUI4igoBEA7533hA7Y6HtQXc8mR3p8qNnmF6CiwzpMnLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BF5BgskN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BF5BgskN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790867386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5yZLNrSRV64eauo69wxs15T8YxD6m1PPFEn9wYcIOY=;
	b=BF5BgskNpnB+YqMZwm+vKvs0QNSyjlHiIVnDwBV/QJm37Pkp0FA2BO46jvg7bzqNXxyBQE
	LYAQhXWZLLZxypoh998+gwjTWWWaqm5QA2tu+Ntd/3BJqx7+xE2DAYzHa9hu4k/Xhqx8UX
	BZLi+QbQ5LyI0dnVdfxhXHpfpod+EoQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-z9jFHeB1MAq2PmWcFYBa-Q-1; Thu, 01 Oct 2026 11:09:44 -0400
X-MC-Unique: z9jFHeB1MAq2PmWcFYBa-Q-1
X-Mimecast-MFC-AGG-ID: z9jFHeB1MAq2PmWcFYBa-Q_1790867384
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c294ca8193eso323135866b.0
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 08:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790867384; x=1791472184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J5yZLNrSRV64eauo69wxs15T8YxD6m1PPFEn9wYcIOY=;
        b=Za1126iNOvMTj1PbsiMcR6UVJgK4HMEPn6b6UkOi1wTpy/Cf4pmOqt+RBFHi7UVy0x
         zfbrLskm+Cy11hSlpNGUdLjZ0oQprvin21vIA0XqlvcaBeS1gH7K/MKZZ7KFBJMbWwfC
         nBdVa9Ucu6yQSb0cxGbo9+vd0MdFUyNVmu7+fW0P6zXoVjU2s+bUGAk1cXGDGt1E/9P5
         cpodwNwu/ahRkaWBG3y+fq/eLpMn9EqHTuKy6JXJ0wKXbfF/WZEU6rSjyvYNONy0SGRz
         7YVOdSRozWhtzWZMqX9mX1kn5klPa0PH7XGvE2NEEsmpGj2KHzynB9i3JtlPxSrj3yHa
         RIWA==
X-Forwarded-Encrypted: i=1; AKwUvBwXxc8CTUE07WDesVdK8OkV+yKE7PnjfSK0Q0IktqaWn4vLqU9XRg+NGGqk6hizmuBPDfYFb0g=@lists.linux.dev
X-Gm-Message-State: AFuF++ksXrBkD/o0laLycs6M/DdMg21zxtpDyA1L8i1glE5n+tBoI9Nd
	sZkhiOzmlYvLYVOpii0JD0yMQHnbtdk7jJ6FOnf/kWn8nZ0xKMGQt/UGp5uG8gP2uyjDKr8x63L
	oXPa46vGhO7Mpsdtfb8T25JWO9wYKTwqTTMlJYKh/5ueyXV3mt2jhICnjWQ==
X-Gm-Gg: AYBFou02vgZStkbHapuQY5Yktpm6OtkHdqs26fggjPUrj2Jpy00qDU3FY7tWFHLTM1F
	SSM+sY/AWN9So7oFkFXjU2eZpLfvIi6MfdabMbb4IZrbtVNHXvTAKFCG6ujzyFE6ZGlW9wMnsq/
	ia+/ZxoPJRIvffAJf0NnmEXgGL06uKEgT2bjqQ6GmBTLXeQIwvi+xFsrBGzQw1OPL3pYSSIL7Zz
	hDh6vCgE2OchNM59qU2ke6R7R7Gwx+etr1kJnLTrHtKOtq5jLv9FZtnVvBBfJ9f8x9b6K5+BYWS
	K/1wRv69vOwOSJrBtW4WI3SKzd9IFPSpR7/kN+J/e8nuDQ+4ZXF8//bwdGcREseGjZP07jRdjDs
	YPFnbR0qK4vDIQG9nFGzJb8mAU/fH0fibH+xZ3SSf0X4i0VyOIeUFIawXU0U=
X-Received: by 2002:a17:906:4784:b0:c2d:ced1:4615 with SMTP id a640c23a62f3a-c2e23caa0cbmr418531166b.8.1790867383598;
        Thu, 01 Oct 2026 08:09:43 -0700 (PDT)
X-Received: by 2002:a17:906:4784:b0:c2d:ced1:4615 with SMTP id a640c23a62f3a-c2e23caa0cbmr418528466b.8.1790867383069;
        Thu, 01 Oct 2026 08:09:43 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-245-188.pool.digikabel.hu. [193.226.245.188])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d86372sm177735166b.56.2026.10.01.08.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:09:42 -0700 (PDT)
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
Subject: [PATCH v2 2/8] fuse: add helpers for EIO return value with kernel message
Date: Thu,  1 Oct 2026 17:07:20 +0200
Message-ID: <20261001150935.655979-3-mszeredi@redhat.com>
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
X-Mimecast-MFC-PROC-ID: D-3Zf5WiiDrfaEQ_6EdmaAmRSWvRWQ3nGk2LBWHRqWI_1790867384
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Conditions are triggered by a buggy fuse server will result in -EIO which
is hard to interpret without any context.

Add helpers that print a short message to the kernel log as well as
returning the error value.  This serves a dual purpose:

 - documents the error condition inside the code

 - allows the implementor of the fuse server to get the context for the
   error

Some debug messages are removed in favor of this.

This also changes the mmap return value from -ETXTBSY to -ENODEV if a
passthrough open raced with the prior check.  This makes both cases return
-ENODEV if the file is in passthrough mode.

Additionally change the return value of fuse_inode_uncached_io_start() and
fuse_file_cached_io_open() from an error value to a bool (true on success)
as the error value is translated anyway.

Currently these use the pr_notice_once() variant.  Possibly should be
changed to a ratelimit of e.g. once per minute.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/file.c        |  8 ++---
 fs/fuse/fuse_i.h      |  6 ++--
 fs/fuse/iomode.c      | 74 ++++++++++++++++---------------------------
 fs/fuse/passthrough.c | 19 ++++-------
 4 files changed, 42 insertions(+), 65 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6d707f2b3bff..92976906ab05 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1478,7 +1478,7 @@ static void fuse_dio_lock(struct kiocb *iocb, struct iov_iter *from,
 		 * have raced, so check it again.
 		 */
 		if (fuse_io_past_eof(iocb, from) ||
-		    fuse_inode_uncached_io_start(fi, NULL) != 0) {
+		    !fuse_inode_uncached_io_start(fi, NULL)) {
 			inode_unlock_shared(inode);
 			inode_lock(inode);
 			*exclusive = true;
@@ -2415,7 +2415,6 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fm->fc;
 	struct inode *inode = file_inode(file);
-	int rc;
 
 	/* DAX mmap is superior to direct_io mmap */
 	if (FUSE_IS_VDAX(inode))
@@ -2457,9 +2456,8 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 		 * After first mmap, the inode stays in caching io mode until
 		 * the direct_io file release.
 		 */
-		rc = fuse_file_cached_io_open(inode, ff);
-		if (rc)
-			return rc;
+		if (!fuse_file_cached_io_open(inode, ff))
+			return -ENODEV;
 	}
 
 	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 8546855386b5..3dd4dff24c50 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -11,6 +11,8 @@
 # define pr_fmt(fmt) "fuse: " fmt
 #endif
 
+#define fuse_EIO(fmt, ...) (pr_notice_once("%s: " fmt "\n", __func__, ##__VA_ARGS__), -EIO)
+
 #include "args.h"
 #include <linux/fuse.h>
 #include <linux/fs.h>
@@ -1251,8 +1253,8 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
 		      struct dentry *dentry, struct file_kattr *fa);
 
 /* iomode.c */
-int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff);
-int fuse_inode_uncached_io_start(struct fuse_inode *fi,
+bool fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff);
+bool fuse_inode_uncached_io_start(struct fuse_inode *fi,
 				 struct fuse_backing *fb);
 void fuse_inode_uncached_io_end(struct fuse_inode *fi);
 
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index 79637c09e883..1a10bc65fb31 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -27,15 +27,15 @@ static inline bool fuse_is_io_cache_wait(struct fuse_inode *fi)
  * Blocks new parallel dio writes and waits for the in-progress parallel dio
  * writes to complete.
  */
-int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)
+bool fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	/* There are no io modes if server does not implement open */
 	if (!ff->args)
-		return 0;
+		return true;
 
-	spin_lock(&fi->lock);
+	guard(spinlock)(&fi->lock);
 	/*
 	 * Setting the bit advises new direct-io writes to use an exclusive
 	 * lock - without it the wait below might be forever.
@@ -53,8 +53,7 @@ int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)
 	 */
 	if (fuse_inode_backing(fi)) {
 		clear_bit(FUSE_I_CACHE_IO_MODE, &fi->state);
-		spin_unlock(&fi->lock);
-		return -ETXTBSY;
+		return false;
 	}
 
 	WARN_ON(ff->iomode == IOM_UNCACHED);
@@ -64,8 +63,7 @@ int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)
 			set_bit(FUSE_I_CACHE_IO_MODE, &fi->state);
 		fi->iocachectr++;
 	}
-	spin_unlock(&fi->lock);
-	return 0;
+	return true;
 }
 
 static void fuse_file_cached_io_release(struct fuse_file *ff,
@@ -82,22 +80,19 @@ static void fuse_file_cached_io_release(struct fuse_file *ff,
 }
 
 /* Start strictly uncached io mode where cache access is not allowed */
-int fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_backing *fb)
+bool fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_backing *fb)
 {
 	struct fuse_backing *oldfb;
-	int err = 0;
 
-	spin_lock(&fi->lock);
+	guard(spinlock)(&fi->lock);
 	/* deny conflicting backing files on same fuse inode */
 	oldfb = fuse_inode_backing(fi);
-	if (fb && oldfb && oldfb != fb) {
-		err = -EBUSY;
-		goto unlock;
-	}
-	if (fi->iocachectr > 0) {
-		err = -ETXTBSY;
-		goto unlock;
-	}
+	if (fb && oldfb && oldfb != fb)
+		return false;
+
+	if (fi->iocachectr > 0)
+		return false;
+
 	fi->iocachectr--;
 
 	/* fuse inode holds a single refcount of backing file */
@@ -107,9 +102,7 @@ int fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_backing *fb)
 	} else {
 		fuse_backing_put(fb);
 	}
-unlock:
-	spin_unlock(&fi->lock);
-	return err;
+	return true;
 }
 
 /* Takes uncached_io inode mode reference to be dropped on file release */
@@ -118,11 +111,9 @@ static int fuse_file_uncached_io_open(struct inode *inode,
 				      struct fuse_backing *fb)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	int err;
 
-	err = fuse_inode_uncached_io_start(fi, fb);
-	if (err)
-		return err;
+	if (!fuse_inode_uncached_io_start(fi, fb))
+		return fuse_EIO("failed to start uncached I/O");
 
 	WARN_ON(ff->iomode != IOM_NONE);
 	ff->iomode = IOM_UNCACHED;
@@ -173,9 +164,11 @@ static int fuse_file_passthrough_open(struct inode *inode, struct file *file)
 	int err;
 
 	/* Check allowed conditions for file open in passthrough mode */
-	if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) || !fc->passthrough ||
-	    (ff->open_flags & ~FOPEN_PASSTHROUGH_MASK))
-		return -EINVAL;
+	if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH) || !fc->passthrough)
+		return fuse_EIO("passthrough not enabled");
+
+	if (ff->open_flags & ~FOPEN_PASSTHROUGH_MASK)
+		return fuse_EIO("conflicting open flags");
 
 	fb = fuse_passthrough_open(file, ff->args->open_outarg.backing_id);
 	if (IS_ERR(fb))
@@ -208,11 +201,12 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 
 	/*
 	 * Server is expected to use FOPEN_PASSTHROUGH for all opens of an inode
-	 * which is already open for passthrough.
+	 * which is already open for passthrough.  Using incorrect open mode is
+	 * a server mistake, which results in user visible failure of open()
+	 * with EIO error.
 	 */
-	err = -EINVAL;
 	if (fuse_inode_backing(fi) && !(ff->open_flags & FOPEN_PASSTHROUGH))
-		goto fail;
+		return fuse_EIO("FOPEN_PASSTHROUGH expected");
 
 	/*
 	 * FOPEN_PARALLEL_DIRECT_WRITES requires FOPEN_DIRECT_IO.
@@ -234,22 +228,10 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 
 	if (ff->open_flags & FOPEN_PASSTHROUGH)
 		err = fuse_file_passthrough_open(inode, file);
-	else
-		err = fuse_file_cached_io_open(inode, ff);
-	if (err)
-		goto fail;
+	else if (!fuse_file_cached_io_open(inode, ff))
+		err = fuse_EIO("conflicting passthrough open");
 
-	return 0;
-
-fail:
-	pr_debug("failed to open file in requested io mode (open_flags=0x%x, err=%i).\n",
-		 ff->open_flags, err);
-	/*
-	 * The file open mode determines the inode io mode.
-	 * Using incorrect open mode is a server mistake, which results in
-	 * user visible failure of open() with EIO error.
-	 */
-	return -EIO;
+	return err;
 }
 
 /* No more pending io and no new io possible to inode via open/mmapped file */
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index b43d3e0f7081..489838462d1e 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -159,34 +159,29 @@ struct fuse_backing *fuse_passthrough_open(struct file *file, int backing_id)
 	struct fuse_conn *fc = ff->fm->fc;
 	struct fuse_backing *fb = NULL;
 	struct file *backing_file;
-	int err;
 
-	err = -EINVAL;
 	if (backing_id <= 0)
-		goto out;
+		return ERR_PTR(fuse_EIO("invalid backing_id"));
 
-	err = -ENOENT;
 	fb = fuse_backing_lookup(fc, backing_id);
 	if (!fb)
-		goto out;
+		return ERR_PTR(fuse_EIO("backing not found"));
 
 	/* Allocate backing file per fuse file to store fuse path */
 	backing_file = backing_file_open(file, file->f_flags,
 					 &fb->file->f_path, fb->cred);
-	err = PTR_ERR(backing_file);
 	if (IS_ERR(backing_file)) {
 		fuse_backing_put(fb);
-		goto out;
+		return ERR_PTR(fuse_EIO("failed to open backing file (%ld)", PTR_ERR(backing_file)));
 	}
 
-	err = 0;
 	ff->passthrough = backing_file;
 	ff->cred = get_cred(fb->cred);
-out:
-	pr_debug("%s: backing_id=%d, fb=0x%p, backing_file=0x%p, err=%i\n", __func__,
-		 backing_id, fb, ff->passthrough, err);
 
-	return err ? ERR_PTR(err) : fb;
+	pr_debug("%s: backing_id=%d, fb=0x%p, backing_file=0x%p\n", __func__,
+		 backing_id, fb, ff->passthrough);
+
+	return fb;
 }
 
 void fuse_passthrough_release(struct fuse_file *ff, struct fuse_backing *fb)
-- 
2.54.0

