Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1864A1E1F
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791309692; cv=none; b=NYyCxT8ATl0hsJIY50kI2gfXX0h7qnp9teD9F3Q2ancM/+AWLSQxn0CiXEebUASBZZGeb8gfesYDKb74hUDfg/4EJCivM9O1zc2U6pXkD/yQxJ50wYc4UWDVMDFLeewnpIBrqBoXIZyOdi9MhJN2NaHcgXd9rKbkhrawh7nrHdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791309692; c=relaxed/simple;
	bh=YFk2FdU53n8yGNypKqQC8q9TwgACbOPYBnswpawC9QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=T1Rbm0EN3PGFn+RW6XJUE92addfw3R+pgTLyfCcEKZ1aucOYQYbVnKBgro3gIFFeMFiAIr2w/cFmq72NRQ7lDY7LkUg42FPst04pNa/SpXHarKNZGoEO+6GvAIkL5irZFX7Bpoc1vnjpktw6oGcUfgZGJLo4EnOgSyiHVBZ+BwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JEoBc0rO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JEoBc0rO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791309689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9J47ghvIEANGG3pvfOhMVihYJupd63H8mER0lCDnD5M=;
	b=JEoBc0rOyTIDI69ajud+KK1dGFv+Y7lFC0rAFfptDsbqTDmvYMmErArRK6le5JU5y47fr1
	DGU8NJyQuGpcMnakMGa8CHUDJykKGwp63rRDhpw50feGctAAH1O6Oe7yXvXw3fdvVaNeZf
	UeWBkHd9nlIbRJaNEhpIHcpciSUoJNg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-A4tvB6CBMMCCx1lJtOrbpA-1; Tue, 06 Oct 2026 14:01:27 -0400
X-MC-Unique: A4tvB6CBMMCCx1lJtOrbpA-1
X-Mimecast-MFC-AGG-ID: A4tvB6CBMMCCx1lJtOrbpA_1791309687
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6aa47eed2c3so4453405a12.2
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 11:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791309687; x=1791914487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9J47ghvIEANGG3pvfOhMVihYJupd63H8mER0lCDnD5M=;
        b=S5IjsPu0WXe6j6HvgTvn1FYvDRpynSCfU1x9lDKzClLAiddgLoM36u2OU8JSFbH8b3
         g0YeIccazqSRwtkWGvBOV3p8NZ25fre5PW1EqfIcQ1ewsWashmdFECT2AFd7cLtPQtB5
         +B9nu/uT3hIiXS9mvD9M4nHnc9yXpxjn8r2r4cFMYW6b8ebLXe7e5q59W3grjEE1ZYb4
         6Y983H2Ztel3FvvjIjorKhBHrHDPDFX1RhxJWQ136BHFzATElJ0hVI8/GVqB5jWb1hdY
         9hmOw4FZ/F/LeWakU08u+JFSuCdUc0l4eCckxGFjJaMzX8BXZ8tjIBazN7BrpuV/XErp
         J0HA==
X-Forwarded-Encrypted: i=1; AKwUvBzVydVsYB+JStgtN5A1occDmRaiPGt7TksTH6Ih4srJ4Hd/5zmpwunuI5zm7IVb1LcNTBoR9Wc=@lists.linux.dev
X-Gm-Message-State: AFq9FYK+rFMn22SCcLljCNX4teXX9zytA3BmwEcb+H4konwpKj/NK9wA
	9PJuv9v+0EhzwSfVfjQaZUFk9bkcaFMysWi5vXDiNh+JnejHx/j790TMMyo9YMWigW0GwDFcdUs
	zk5GgJQjSHs6FOl6uuiDdZ/6KXdYZDxUWYnjHaYDP4MZ1fhWKnb9vcAnzYQ==
X-Gm-Gg: AYBFou1pfIqh4VbARuLx9wuDzaaVddScO0RZsswBIMLSPqg3uNgAjYd2rG98R90ekdC
	qXxMTqT+34r0dE7eDsznXTluGso7J7wL9j4GsMYUyggYX0GjAgd7QcpZxap9Afj0LIIlvPcdkJl
	40L94jGsJpX9rCmVeS/H+IFb4GNXQRzlo9/RttBS1UXFVkYo8Q9SyhS0g6w5O9KLrjmtygn2am8
	nHLHNXROp2xxlyW1qw64JxlylJyYAGtjLjB/fYuc8lDnIXNjcuY+yyNZ9QmtgorFvJrNXI5xjr0
	oStDV980+1frC0h2bPpqBpJnWjM+OLXsXO2CudoidAdcZKFisVQs+hs1bzJar6ZcfCPM9i8J3/O
	5Rj7l/5sX6S7zAVeF82ycr/xu+pQP+7Z8JbVmVyw4om+P+Qc92+fDYD3E
X-Received: by 2002:a05:6402:23d3:b0:6aa:665:830 with SMTP id 4fb4d7f45d1cf-6afe2978889mr1872429a12.15.1791309686443;
        Tue, 06 Oct 2026 11:01:26 -0700 (PDT)
X-Received: by 2002:a05:6402:23d3:b0:6aa:665:830 with SMTP id 4fb4d7f45d1cf-6afe2978889mr1872407a12.15.1791309685983;
        Tue, 06 Oct 2026 11:01:25 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb01e5942sm5056684a12.9.2026.10.06.11.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 11:01:25 -0700 (PDT)
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
Subject: [PATCH v3 3/9] fuse: add helpers for EIO return value with kernel message
Date: Tue,  6 Oct 2026 20:01:08 +0200
Message-ID: <20261006180115.1425232-4-mszeredi@redhat.com>
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
X-Mimecast-MFC-PROC-ID: -WLKBNqzFFiH0TP9pC7-YhBqG1KUMJmfFEQsXB24keE_1791309687
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

Additionally change the return value of fuse_file_cached_io_open() from an
error value to a bool (true on success) as the error value is translated
anyway.

Currently these use the pr_notice_once() variant.  Possibly should be
changed to a ratelimit of e.g. once per minute.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/file.c        |  6 ++--
 fs/fuse/fuse_i.h      |  4 ++-
 fs/fuse/iomode.c      | 75 ++++++++++++++++++-------------------------
 fs/fuse/passthrough.c | 19 ++++-------
 4 files changed, 43 insertions(+), 61 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6d707f2b3bff..bde07948d1f0 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
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
index 8546855386b5..d9ec88028d7b 100644
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
@@ -1251,7 +1253,7 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
 		      struct dentry *dentry, struct file_kattr *fa);
 
 /* iomode.c */
-int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff);
+bool fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff);
 int fuse_inode_uncached_io_start(struct fuse_inode *fi,
 				 struct fuse_backing *fb);
 void fuse_inode_uncached_io_end(struct fuse_inode *fi);
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index 79637c09e883..1b8b267d0c0d 100644
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
@@ -85,19 +83,16 @@ static void fuse_file_cached_io_release(struct fuse_file *ff,
 int fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_backing *fb)
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
+		return -EBUSY;
+
+	if (fi->iocachectr > 0)
+		return -ETXTBSY;
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
+	return 0;
 }
 
 /* Takes uncached_io inode mode reference to be dropped on file release */
@@ -121,8 +114,11 @@ static int fuse_file_uncached_io_open(struct inode *inode,
 	int err;
 
 	err = fuse_inode_uncached_io_start(fi, fb);
-	if (err)
-		return err;
+	if (err) {
+		if (err == -EBUSY)
+			return fuse_EIO("mismatched backing");
+		return fuse_EIO("conflicting caching mode");
+	}
 
 	WARN_ON(ff->iomode != IOM_NONE);
 	ff->iomode = IOM_UNCACHED;
@@ -173,9 +169,11 @@ static int fuse_file_passthrough_open(struct inode *inode, struct file *file)
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
@@ -197,7 +195,6 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	int err;
 
 	/*
 	 * io modes are not relevant with virtiofs DAX and with server that does not
@@ -208,11 +205,12 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 
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
@@ -233,23 +231,12 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 		return 0;
 
 	if (ff->open_flags & FOPEN_PASSTHROUGH)
-		err = fuse_file_passthrough_open(inode, file);
-	else
-		err = fuse_file_cached_io_open(inode, ff);
-	if (err)
-		goto fail;
+		return fuse_file_passthrough_open(inode, file);
 
-	return 0;
+	if (!fuse_file_cached_io_open(inode, ff))
+		return fuse_EIO("conflicting passthrough open");
 
-fail:
-	pr_debug("failed to open file in requested io mode (open_flags=0x%x, err=%i).\n",
-		 ff->open_flags, err);
-	/*
-	 * The file open mode determines the inode io mode.
-	 * Using incorrect open mode is a server mistake, which results in
-	 * user visible failure of open() with EIO error.
-	 */
-	return -EIO;
+	return 0;
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

