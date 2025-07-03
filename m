Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB692F531F
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568668; cv=none; b=FLZ3ze4adiYBeD6W/r8WA5/j4m4KuOjX68TSoTnnIBtyLOwifU2TnhsJmVw5zwR99QLFyDDDNtY309S7Zpv+Fh0ZBI73RU7nhiYAYMtcf035jLR00rQXmSh85kCETsyTipeN8OiY7T7n3mq03I3RzOdbB5ieVIbDbXjv39eb3kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568668; c=relaxed/simple;
	bh=FwBWWFE2JodQotEAZ09YSPxNok+WslGJ0gzN2M0oH74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A+5BejKtFoZvnILbCPq6v6fB44kXAGjX8dnv5uB5cXQqitmL1L4EuEex3gH5s31q6EPZYTqM6ttmuyWYc0S5RcrrUbZZ7N41RaRqqFSbYLivEZ6KSLCDY9BFXNVGZ99AE9/SjSmti3VE84MRjYgkHxuQtaOysfA0Jes7ZzeBALs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YoGpVqQG; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YoGpVqQG"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2e95f0b6cb7so121529fac.3
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568666; x=1752173466; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evCDkhJIR08sNUN0+XWT7gI7+J9O9q1SPYxnVNyV/TY=;
        b=YoGpVqQGGhnfpry8K9FMBQodZJQHoaosODay90u5mLLpIyHJFC4de6GYhLMPTE94wX
         mbHbjDSrk2qHAS0AxYUwIgy53qD9yBQobY3OS4RBLH5KDGT8nwfx20U4WnQLdDhus+rd
         gowqmSunzPdSi45idLk43CyWO1yYAqbIW19shH4/JgT5xPUTKnNyKNqyhWFkHSNo9hG1
         wiUExwskCFC0URLys2lb9E9bHFaYudHHWZKw0Q0Ek+0X8U6s7iWyVX64sPps5p4NPnuH
         PInW/ACsoe/yKDDKX3TO9cXv5tK+IACnnpzPAdQdJ4GRXS7Ca+U5HMPFQK76gDK/3BAH
         ROwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568666; x=1752173466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=evCDkhJIR08sNUN0+XWT7gI7+J9O9q1SPYxnVNyV/TY=;
        b=j9Hhfn5EPP9BUq76MHkMWhFmgW2tDJRyOXy28qN5mmKzTQTYc3wzYZLt1+srN6fDtW
         jD/Wgg9ZqMtqMBXdYeWpOWTQxlUstJoZ/GQHY859zKWmyckVU4HBzr1t22dLGsVWb+93
         0TNohPSh5GMNdiv/0xQ2eamzJZKjvGNExThTdonoQTMVVNepZldc+5mHdk3vHz/zNmcO
         mMp2su2Shwyv8RTeJdY0W+AXqsRMZ6dykk2vqrJEzsxhUGfypED7Fix4Xu5T4/H1v3ea
         NcEUUFqrft0a2sVVuNLTEIU3pRXz3Joc+K4Aqa1lg6If02AWq9ktwP+PSpUOfbS5bWhS
         qMgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvDInTilUcz+UUFi1dQW5PHMlMAL9709+avDHA52JMxdGfUpJKhBwYTkIgI/ejFF4+hIluZok=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0+xqNTqlbr/MOybdTK6s/4USGu+l5IGH3UTqBp56yaHSOketT
	WTZjrguGqvrgMtoHpl8t+I7Lu3NP72uKjrKVIR0UHm/1Ab3F/7MeCm9w
X-Gm-Gg: ASbGncuD7ttalWFLYeIqyn4FOJHLMJ6LlrDRGfOyVsEpps/vfQKV5ws7w5StwSaAgr4
	15lN04KsERiA+QBWhlN0RM/qDtiepaJZSxGSryHiq2JcmdvfcBCBxkARmFZ0WFzCIZd34zPcUfk
	0P5kg2nltUMQQ0lLWMTWNumBdtHC6UcZsoO7O02+OjiuPjtf09ezUiuJyDS0mJNxvzMXjxnPPdr
	ryf0PtvpQQJZkaIihEMGdHge6iqF1aDSDIIKSV2XGEeZ2CzQDiUfZWq62RmZxnGTxdjzBAlPj2W
	QmdrRyqEofvw50BFu3ICD2OwU0+n4vn2ds0OCFLOJ+VSRoPZoXObcnAQolYZA1PzFV/Op0nTBKV
	3nFlVzg1ZkW31qQ==
X-Google-Smtp-Source: AGHT+IHyOroDuVjL8bFbm4j8Va1txfDJ2jVi74kI/xcjqq2IUD/Ra3Bu/QoyyOKZVocj62ILUhcOoA==
X-Received: by 2002:a05:6870:479b:b0:2ef:de7e:544d with SMTP id 586e51a60fabf-2f5a8cf7e46mr6599486fac.27.1751568666156;
        Thu, 03 Jul 2025 11:51:06 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.51.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:51:05 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [RFC V2 09/18] famfs_fuse: Update macro s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
Date: Thu,  3 Jul 2025 13:50:23 -0500
Message-Id: <20250703185032.46568-10-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250703185032.46568-1-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Virtio_fs now needs to determine if an inode is DAX && not famfs.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/dir.c    |  2 +-
 fs/fuse/file.c   | 13 ++++++++-----
 fs/fuse/fuse_i.h |  6 +++++-
 fs/fuse/inode.c  |  2 +-
 fs/fuse/iomode.c |  2 +-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8f699c67561f..ad8cdf7b864a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1939,7 +1939,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		is_truncate = true;
 	}
 
-	if (FUSE_IS_DAX(inode) && is_truncate) {
+	if (FUSE_IS_VIRTIO_DAX(fi) && is_truncate) {
 		filemap_invalidate_lock(mapping);
 		fault_blocked = true;
 		err = fuse_dax_break_layouts(inode, 0, -1);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 754378dd9f71..93b82660f0c8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -239,7 +239,7 @@ static int fuse_open(struct inode *inode, struct file *file)
 	int err;
 	bool is_truncate = (file->f_flags & O_TRUNC) && fc->atomic_o_trunc;
 	bool is_wb_truncate = is_truncate && fc->writeback_cache;
-	bool dax_truncate = is_truncate && FUSE_IS_DAX(inode);
+	bool dax_truncate = is_truncate && FUSE_IS_VIRTIO_DAX(fi);
 
 	if (fuse_is_bad(inode))
 		return -EIO;
@@ -1770,11 +1770,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
 	struct inode *inode = file_inode(file);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	if (fuse_is_bad(inode))
 		return -EIO;
 
-	if (FUSE_IS_DAX(inode))
+	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_read_iter(iocb, to);
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
@@ -1791,11 +1792,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
 	struct inode *inode = file_inode(file);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	if (fuse_is_bad(inode))
 		return -EIO;
 
-	if (FUSE_IS_DAX(inode))
+	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_write_iter(iocb, from);
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
@@ -2627,10 +2629,11 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = ff->fm->fc;
 	struct inode *inode = file_inode(file);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	int rc;
 
 	/* DAX mmap is superior to direct_io mmap */
-	if (FUSE_IS_DAX(inode))
+	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_mmap(file, vma);
 
 	/*
@@ -3191,7 +3194,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		.mode = mode
 	};
 	int err;
-	bool block_faults = FUSE_IS_DAX(inode) &&
+	bool block_faults = FUSE_IS_VIRTIO_DAX(fi) &&
 		(!(mode & FALLOC_FL_KEEP_SIZE) ||
 		 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 2086dac7243b..9d87ac48d724 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1426,7 +1426,11 @@ void fuse_free_conn(struct fuse_conn *fc);
 
 /* dax.c */
 
-#define FUSE_IS_DAX(inode) (IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode))
+/* This macro is used by virtio_fs, but now it also needs to filter for
+ * "not famfs"
+ */
+#define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)	\
+					&& IS_DAX(&fuse_inode->inode))
 
 ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to);
 ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index e9db2cb8c150..29147657a99f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -164,7 +164,7 @@ static void fuse_evict_inode(struct inode *inode)
 	if (inode->i_sb->s_flags & SB_ACTIVE) {
 		struct fuse_conn *fc = get_fuse_conn(inode);
 
-		if (FUSE_IS_DAX(inode))
+		if (FUSE_IS_VIRTIO_DAX(fi))
 			fuse_dax_inode_cleanup(inode);
 		if (fi->nlookup) {
 			fuse_queue_forget(fc, fi->forget, fi->nodeid,
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index c99e285f3183..aec4aecb5d79 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -204,7 +204,7 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 	 * io modes are not relevant with DAX and with server that does not
 	 * implement open.
 	 */
-	if (FUSE_IS_DAX(inode) || !ff->args)
+	if (FUSE_IS_VIRTIO_DAX(fi) || !ff->args)
 		return 0;
 
 	/*
-- 
2.49.0

