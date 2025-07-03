Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F69C2F362F
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568682; cv=none; b=kPASPU3Y97Wl1/2T+xQpzqsWjK1OZ66g8y7Ayyzp/dsll8Wzk+TvM1i8Xjui1RM4v4pFVPaGqf/N1KMXlG6cTjhtUXw5HltjzUR63YNYBu44dD/hRZQx6A5Z41WvzjEMGXts5uwfmHgvdMIWhTz8U9nt3+/a8/vWyfXikxzEgm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568682; c=relaxed/simple;
	bh=W6SSJ5n4WkmPzzWxMdPih1XAcuC59u2vCqd3I2mEN/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hw/Zkrpy/uXSQJzI/58Mws0qdgFkkkldQVL3X4rUJOsE87aM56/HLewqYSMpHNnUTK2cNjRoMEbPilgy8PpJ8bN4mXGPk7vBxC7ObXw71fKcneSGCKC2Fvir9NKPWRWTzuk/+xvaSdKQMspVnRBu9svTZVOr/O8H+qjFsjX/Ygg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xhi86v9X; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xhi86v9X"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2f75f1c7206so121806fac.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568680; x=1752173480; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJKfVlCAjxcUIymiAHgKO7vuVphUoIXt4cecFTyUAAA=;
        b=Xhi86v9XEWtcPpPm7+gEtM47937scGvdmjqTSerjTVAyx7ZFEYMChTpXCpyvNXPNlf
         lz6lZyuHLXxHdzAkji4tsRITADTg4sdiS9STE16eppC/S28CjYe4w1Auhyr59ri5j1c4
         Fv0zUmnJ2OPrIl2SUuXbTru6yQKcmnGDz1lPik1HylLQmRJ6YWrYu27b9MYnWdLZcFSa
         Anh06P+eU3ZVa4OnL5PIFYxBKXn84PoOnTryD0eluD4K/800zYzrV6TlHlsa6/PbXKSf
         xGq3ubH5ASXzCsP/EqqLpIB/49r3tOwRvUI5d+R/GtUJsdqStRjQ5YJbWMhqPOdvpLJ7
         +4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568680; x=1752173480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vJKfVlCAjxcUIymiAHgKO7vuVphUoIXt4cecFTyUAAA=;
        b=PC+vTe8Ciyox3GFqagzL2vxjIOVliibPuiw+fiaUZc25AdT2xhkiuCx9PrXNxlOX7x
         gx9UHOnvakku+vpG7b18NfVAugXh+mWbzp8xxESZIlB3OeVLbbL7AvxFbDRGPxIcVHe0
         b3bNMfac55NfP8wBu8n9F3gmbBKoRgjYb5NsJIl0fC/fv2V9n2nSxoIOvemtycsORcwk
         KaJ+pcysK/SFPRL50CNQV2nVkqNzgyn9SL1Ao2TOvcS4J9UGgvuDT+3I2ekqnW9L+t4a
         PSu+C/dR0PUtpm3CqqyEQLHUwiRMEbvkUZo0FcFk4B9lNSIVJ0eosmzYqjTVX0B37wdg
         AewA==
X-Forwarded-Encrypted: i=1; AJvYcCVEUxFPKz7ayLXsaCoIq2rabk87y5Gao0mVQ7KZ6xEW7KjM50lc2EieHMKrA+Pt7dBaZbnfK1k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRSLu+qCEQbYKbkJxI+3CpdDMhH/LvGd020pz8pZtAqaFt52gj
	+bH4eq1VwFl11xVD4GGw/74Vh+OytaCnNRR/Ai+zEhnuymc6L+oAQA45
X-Gm-Gg: ASbGncsmQlXcU2YvV+fU8oL4UdZEzNYY14frAkVjRUj0De81TTgL36CpM2vV+U/jyDE
	skvHTI1YhiwNsAw6IzFPjaXeeUZlefXoOpD5bUpOP7vzfryMKI2TviaynV/I495zDdjATGp7g9l
	DAojcVzpqah7j1LQGtEyKTgqylJH9VZXnlNDcd+iJeS5cNZkHvON1rXAU3gdkB9l53YyAZzITrz
	fdzYyA6ytCOwPrqNah4wOQC6HiYuiloPB2gzp2nZ7wh9NMmY9f/UTMoAowJ66fUJzaGa4kK9ZB6
	uhdM3O6JjcGqGtHXLPHEMwkvgC/sGI8RBC2b+4G115hTx8v2giFHQP55G6q8DZxnFTuBNMlo4HN
	RkUlllOTQRxuNRQ==
X-Google-Smtp-Source: AGHT+IHFvVcUbFzxb95rdveSXgYGAH77wTve8JwIh+zgeFvLOJRWZQ+6TNPtIGSAG50EJt081mp86g==
X-Received: by 2002:a05:6871:314b:b0:2d5:2955:aa6c with SMTP id 586e51a60fabf-2f76c9ed2cbmr3501437fac.31.1751568680025;
        Thu, 03 Jul 2025 11:51:20 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.51.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:51:19 -0700 (PDT)
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
Subject: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
Date: Thu,  3 Jul 2025 13:50:26 -0500
Message-Id: <20250703185032.46568-13-john@groves.net>
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

Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP to
retrieve and cache up the file-to-dax map in the kernel. If this
succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.

GET_FMAP has a variable-size response payload, and the allocated size
is sent in the in_args[0].size field. If the fmap would overflow the
message, the fuse server sends a reply of size 'sizeof(uint32_t)' which
specifies the size of the fmap message. Then the kernel can realloc a
large enough buffer and try again.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/file.c            | 84 +++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h          | 36 ++++++++++++++++-
 fs/fuse/inode.c           | 19 +++++++--
 fs/fuse/iomode.c          |  2 +-
 include/uapi/linux/fuse.h | 18 +++++++++
 5 files changed, 154 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 93b82660f0c8..8616fb0a6d61 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -230,6 +230,77 @@ static void fuse_truncate_update_attr(struct inode *inode, struct file *file)
 	fuse_invalidate_attr_mask(inode, FUSE_STATX_MODSIZE);
 }
 
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+
+#define FMAP_BUFSIZE 4096
+
+static int
+fuse_get_fmap(struct fuse_mount *fm, struct inode *inode, u64 nodeid)
+{
+	struct fuse_get_fmap_in inarg = { 0 };
+	size_t fmap_bufsize = FMAP_BUFSIZE;
+	ssize_t fmap_size;
+	int retries = 1;
+	void *fmap_buf;
+	int rc;
+
+	FUSE_ARGS(args);
+
+	fmap_buf = kcalloc(1, FMAP_BUFSIZE, GFP_KERNEL);
+	if (!fmap_buf)
+		return -EIO;
+
+ retry_once:
+	inarg.size = fmap_bufsize;
+
+	args.opcode = FUSE_GET_FMAP;
+	args.nodeid = nodeid;
+
+	args.in_numargs = 1;
+	args.in_args[0].size = sizeof(inarg);
+	args.in_args[0].value = &inarg;
+
+	/* Variable-sized output buffer
+	 * this causes fuse_simple_request() to return the size of the
+	 * output payload
+	 */
+	args.out_argvar = true;
+	args.out_numargs = 1;
+	args.out_args[0].size = fmap_bufsize;
+	args.out_args[0].value = fmap_buf;
+
+	/* Send GET_FMAP command */
+	rc = fuse_simple_request(fm, &args);
+	if (rc < 0) {
+		pr_err("%s: err=%d from fuse_simple_request()\n",
+		       __func__, rc);
+		return rc;
+	}
+	fmap_size = rc;
+
+	if (retries && fmap_size == sizeof(uint32_t)) {
+		/* fmap size exceeded fmap_bufsize;
+		 * actual fmap size returned in fmap_buf;
+		 * realloc and retry once
+		 */
+		fmap_bufsize = *((uint32_t *)fmap_buf);
+
+		--retries;
+		kfree(fmap_buf);
+		fmap_buf = kcalloc(1, fmap_bufsize, GFP_KERNEL);
+		if (!fmap_buf)
+			return -EIO;
+
+		goto retry_once;
+	}
+
+	/* Will call famfs_file_init_dax() when that gets added */
+
+	kfree(fmap_buf);
+	return 0;
+}
+#endif
+
 static int fuse_open(struct inode *inode, struct file *file)
 {
 	struct fuse_mount *fm = get_fuse_mount(inode);
@@ -263,6 +334,19 @@ static int fuse_open(struct inode *inode, struct file *file)
 
 	err = fuse_do_open(fm, get_node_id(inode), file, false);
 	if (!err) {
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+		if (fm->fc->famfs_iomap) {
+			if (S_ISREG(inode->i_mode)) {
+				int rc;
+				/* Get the famfs fmap */
+				rc = fuse_get_fmap(fm, inode,
+						   get_node_id(inode));
+				if (rc)
+					pr_err("%s: fuse_get_fmap err=%d\n",
+					       __func__, rc);
+			}
+		}
+#endif
 		ff = file->private_data;
 		err = fuse_finish_open(inode, file);
 		if (err)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f4ee61046578..e01d6e5c6e93 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -193,6 +193,10 @@ struct fuse_inode {
 	/** Reference to backing file in passthrough mode */
 	struct fuse_backing *fb;
 #endif
+
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	void *famfs_meta;
+#endif
 };
 
 /** FUSE inode state bits */
@@ -945,6 +949,8 @@ struct fuse_conn {
 #endif
 
 #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	struct rw_semaphore famfs_devlist_sem;
+	struct famfs_dax_devlist *dax_devlist;
 	char *shadow;
 #endif
 };
@@ -1435,11 +1441,14 @@ void fuse_free_conn(struct fuse_conn *fc);
 
 /* dax.c */
 
+static inline int fuse_file_famfs(struct fuse_inode *fi); /* forward */
+
 /* This macro is used by virtio_fs, but now it also needs to filter for
  * "not famfs"
  */
 #define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)	\
-					&& IS_DAX(&fuse_inode->inode))
+					&& IS_DAX(&fuse_inode->inode)	\
+					&& !fuse_file_famfs(fuse_inode))
 
 ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to);
 ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
@@ -1550,4 +1559,29 @@ extern void fuse_sysctl_unregister(void);
 #define fuse_sysctl_unregister()	do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
+/* famfs.c */
+static inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,
+						       void *meta)
+{
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	return xchg(&fi->famfs_meta, meta);
+#else
+	return NULL;
+#endif
+}
+
+static inline void famfs_meta_free(struct fuse_inode *fi)
+{
+	/* Stub wil be connected in a subsequent commit */
+}
+
+static inline int fuse_file_famfs(struct fuse_inode *fi)
+{
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	return (READ_ONCE(fi->famfs_meta) != NULL);
+#else
+	return 0;
+#endif
+}
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index a7e1cf8257b0..b071d16f7d04 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -117,6 +117,9 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		fuse_inode_backing_set(fi, NULL);
 
+	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
+		famfs_meta_set(fi, NULL);
+
 	return &fi->inode;
 
 out_free_forget:
@@ -138,6 +141,13 @@ static void fuse_free_inode(struct inode *inode)
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		fuse_backing_put(fuse_inode_backing(fi));
 
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	if (S_ISREG(inode->i_mode) && fi->famfs_meta) {
+		famfs_meta_free(fi);
+		famfs_meta_set(fi, NULL);
+	}
+#endif
+
 	kmem_cache_free(fuse_inode_cachep, fi);
 }
 
@@ -1002,6 +1012,9 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		fuse_backing_files_init(fc);
 
+	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
+		pr_notice("%s: Kernel is FUSE_FAMFS_DAX capable\n", __func__);
+
 	INIT_LIST_HEAD(&fc->mounts);
 	list_add(&fm->fc_entry, &fc->mounts);
 	fm->fc = fc;
@@ -1036,9 +1049,8 @@ void fuse_conn_put(struct fuse_conn *fc)
 		}
 		if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 			fuse_backing_files_free(fc);
-#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
-		kfree(fc->shadow);
-#endif
+		if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
+			kfree(fc->shadow);
 		call_rcu(&fc->rcu, delayed_release);
 	}
 }
@@ -1425,6 +1437,7 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 				 * those capabilities, they are held here).
 				 */
 				fc->famfs_iomap = 1;
+				init_rwsem(&fc->famfs_devlist_sem);
 			}
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index aec4aecb5d79..443b337b0c05 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -204,7 +204,7 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 	 * io modes are not relevant with DAX and with server that does not
 	 * implement open.
 	 */
-	if (FUSE_IS_VIRTIO_DAX(fi) || !ff->args)
+	if (FUSE_IS_VIRTIO_DAX(fi) || fuse_file_famfs(fi) || !ff->args)
 		return 0;
 
 	/*
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 6c384640c79b..dff5aa62543e 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -654,6 +654,10 @@ enum fuse_opcode {
 	FUSE_TMPFILE		= 51,
 	FUSE_STATX		= 52,
 
+	/* Famfs / devdax opcodes */
+	FUSE_GET_FMAP           = 53,
+	FUSE_GET_DAXDEV         = 54,
+
 	/* CUSE specific operations */
 	CUSE_INIT		= 4096,
 
@@ -888,6 +892,16 @@ struct fuse_access_in {
 	uint32_t	padding;
 };
 
+struct fuse_get_fmap_in {
+	uint32_t	size;
+	uint32_t	padding;
+};
+
+struct fuse_get_fmap_out {
+	uint32_t	size;
+	uint32_t	padding;
+};
+
 struct fuse_init_in {
 	uint32_t	major;
 	uint32_t	minor;
@@ -1284,4 +1298,8 @@ struct fuse_uring_cmd_req {
 	uint8_t padding[6];
 };
 
+/* Famfs fmap message components */
+
+#define FAMFS_FMAP_MAX 32768 /* Largest supported fmap message */
+
 #endif /* _LINUX_FUSE_H */
-- 
2.49.0

