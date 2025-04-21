Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E2A19F116
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199273; cv=none; b=OHb2Crd4DwIlZDe1/VeaJN+6Qo+4R+2zcX81FUuu4uy+ZMcyVtq+eZGEtWlzW8S97Lw6scUBbn4BcLNT9VJjDdbHAblGg29jsRBSUskscHXgUzOv8r9Z6/v8RobSBYAuauvyfVhmdd13V5hhHQ1WB9KynOtum0iwtJPa75MJ+Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199273; c=relaxed/simple;
	bh=Jht53ChYFHgs9fVdkHxX2GDuBPGNdx3JRH/1uFqn5+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TqGiCP4T9dhjPfdN4ebMzYE5hcg4oJnxiacBu0rDcfJ25bioXxnkpW+axNTzNzqrI/s4Td4mysdgn9EWhavVfx9Ajee6NpGcd7UOiG0rlGbipnmgq/Eye/xyeu4rEC5PbZcSBN5DQTfJZ9Va23mxldt3ketuUtr+5ngpnyqron8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lcm87FbA; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lcm87FbA"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-72bbead793dso2707114a34.1
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199271; x=1745804071; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87hDz9VklLiiv0z6ZzoGmsWmujXBj1aSDF9l5QzufPk=;
        b=Lcm87FbAqDAApu8DXR29f//0JrDe/Uvqts7RybihbmT5csuDMprOREw3EwYgL7LfFF
         IJ1FxrtAQAFFrEwXZIoBmGc5EIeMTedCfJsE8ThNYWRP1Bb5zJS34SOpwxnY4KVkCDGP
         Ve8l8TcARq1B3YDuppgwdqYuRUCLNXyzOmOWjAyvBDfGjqur41NgCTgzH8gWCZGbtAHH
         Ot8QwYCiGRGuwoGeYOWACex8cvtUYotw8i8Wl1Pp0rLmwG8yA+GQu4pd9quZiKg3BuYv
         2NhNk2y3LWbLzQaP1pQLTgtwqpZRpsj9vviQkY1UUyD5TOvOTeCTERHUeVg2kE7T0LXM
         bEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199271; x=1745804071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=87hDz9VklLiiv0z6ZzoGmsWmujXBj1aSDF9l5QzufPk=;
        b=QzazNAdqxFrZfE3nvPzyGRfqDW8XN/JfCTy7M/enIAMkXJ1K4DHAZATwnODPLLVXox
         gWRHEa6glXtudsPfA01hSlPm4/Y3xeDOPmU0VU9KrOxLmRdAzkcHRQcevvXVJVeK9a8F
         9PEasQgvFJIsawgSTZZ9jdtA48y0WCLqTRSsnTS2ZCDBkIiumeHXsgTnz4FDQuy7B41r
         YEEvyhWycnwRmA1rH3cuJxA7DpFW5Mrw3NITUPr7xUFWN5iWGdRAYW5oxTz9XUZ8D1hs
         l148DWjZTegmLqx0P8pnFXfukUHesiXbIk451Q0GlM/ydjp/DCtUnxTLViFrbCfAp0xS
         4PAw==
X-Forwarded-Encrypted: i=1; AJvYcCVOveVDPsYla3x3XiEfE0puILQtV959UVRnEEh3VFChoxmvmDxB15cUkTZJFvfgXh3EmYdWy+Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+3s8kHkwZy1YirVQ9dHZ8fIaFo0uO+CXyzQKRNu+nh++sKPFH
	sy29FCXvfVSzbznVTR5gRX24taFKpNC/MfmaEaYpCxBTcx3A3DIA
X-Gm-Gg: ASbGncvCNkUuYFe5j/a8vk5nzE2dD50ogFPMUYhi7wAZsHjljrGk9U8frcdCFwHnF/V
	FbL/uP/uS41ok6btDqVUfIc6SjUpbGCFTtZG/qOlrU0j6MBhhLwhblXW8WLXRuYnBSgxB4i2Av2
	TVzeMbw/SvF/vDvIavpSvRuhHVo6UPAhaIA7BAabEuFNs04SZhLg22xZ/J2hr5BuuThTlPGvrY8
	6ziWchQoAoEp6C6PMNHpH3J3orBNaAoVxApG7c7SBmLvLWi01KBn+rJyPLfrPm/kOsWftE0sz7+
	4FmWEkmDy4EWDWVIylTsb5yDvFYtOAK5CU5mNCb4XdGERoREPh5uEl9UcZmq04El4Hzg5g==
X-Google-Smtp-Source: AGHT+IGp4vZtteKLozsEBPtZC1nWHMzjwcz0JoCBKnIYiH3inoL0umeX/iB+Kt+6JBcOpEy/kE2pLg==
X-Received: by 2002:a05:6830:6203:b0:72a:47ec:12da with SMTP id 46e09a7af769-7300621892cmr6947779a34.10.1745199270715;
        Sun, 20 Apr 2025 18:34:30 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:30 -0700 (PDT)
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
	Luis Henriques <luis@igalia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Vorel <pvorel@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
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
Subject: [RFC PATCH 12/19] famfs_fuse: Plumb the GET_FMAP message/response
Date: Sun, 20 Apr 2025 20:33:39 -0500
Message-Id: <20250421013346.32530-13-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250421013346.32530-1-john@groves.net>
References: <20250421013346.32530-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upon completion of a LOOKUP, if we're in famfs-mode we do a GET_FMAP to
retrieve and cache up the file-to-dax map in the kernel. If this
succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/dir.c             | 69 +++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h          | 36 +++++++++++++++++++-
 fs/fuse/inode.c           | 15 +++++++++
 include/uapi/linux/fuse.h |  4 +++
 4 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index bc29db0117f4..ae135c55b9f6 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -359,6 +359,56 @@ bool fuse_invalid_attr(struct fuse_attr *attr)
 	return !fuse_valid_type(attr->mode) || !fuse_valid_size(attr->size);
 }
 
+#define FMAP_BUFSIZE 4096
+
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+static void
+fuse_get_fmap_init(
+	struct fuse_conn *fc,
+	struct fuse_args *args,
+	u64 nodeid,
+	void *outbuf,
+	size_t outbuf_size)
+{
+	memset(outbuf, 0, outbuf_size);
+	args->opcode = FUSE_GET_FMAP;
+	args->nodeid = nodeid;
+
+	args->in_numargs = 0;
+
+	args->out_numargs = 1;
+	args->out_args[0].size = FMAP_BUFSIZE;
+	args->out_args[0].value = outbuf;
+}
+
+static int
+fuse_get_fmap(struct fuse_mount *fm, struct inode *inode, u64 nodeid)
+{
+	size_t fmap_size;
+	void *fmap_buf;
+	int err;
+
+	pr_notice("%s: nodeid=%lld, inode=%llx\n", __func__,
+		  nodeid, (u64)inode);
+	fmap_buf = kcalloc(1, FMAP_BUFSIZE, GFP_KERNEL);
+	FUSE_ARGS(args);
+	fuse_get_fmap_init(fm->fc, &args, nodeid, fmap_buf, FMAP_BUFSIZE);
+
+	/* Send GET_FMAP command */
+	err = fuse_simple_request(fm, &args);
+	if (err) {
+		pr_err("%s: err=%d from fuse_simple_request()\n",
+		       __func__, err);
+		return err;
+	}
+
+	fmap_size = args.out_args[0].size;
+	pr_notice("%s: nodei=%lld fmap_size=%ld\n", __func__, nodeid, fmap_size);
+
+	return 0;
+}
+#endif
+
 int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name,
 		     struct fuse_entry_out *outarg, struct inode **inode)
 {
@@ -404,6 +454,25 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 		fuse_queue_forget(fm->fc, forget, outarg->nodeid, 1);
 		goto out;
 	}
+
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	if (fm->fc->famfs_iomap) {
+		if (S_ISREG((*inode)->i_mode)) {
+			/* Note Lookup returns the looked-up inode in the attr
+			 * struct, but not in outarg->nodeid !
+			 */
+			pr_notice("%s: outarg: size=%d nodeid=%lld attr.ino=%lld\n",
+				 __func__, args.out_args[0].size, outarg->nodeid,
+				 outarg->attr.ino);
+			/* Get the famfs fmap */
+			fuse_get_fmap(fm, *inode, outarg->attr.ino);
+		} else
+			pr_notice("%s: no get_fmap for non-regular file\n",
+				 __func__);
+	} else
+		pr_notice("%s: fc->dax_iomap is not set\n", __func__);
+#endif
+
 	err = 0;
 
  out_put_forget:
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 931613102d32..437177c2f092 100644
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
@@ -942,6 +946,8 @@ struct fuse_conn {
 #endif
 
 #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	struct rw_semaphore famfs_devlist_sem;
+	struct famfs_dax_devlist *dax_devlist;
 	char *shadow;
 #endif
 };
@@ -1432,11 +1438,14 @@ void fuse_free_conn(struct fuse_conn *fc);
 
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
@@ -1547,4 +1556,29 @@ extern void fuse_sysctl_unregister(void);
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
+	return (fi->famfs_meta != NULL);
+#else
+	return 0;
+#endif
+}
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 7f4b73e739cb..848c8818e6f7 100644
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
 
@@ -1002,6 +1012,11 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		fuse_backing_files_init(fc);
 
+	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)) {
+		pr_notice("%s: Kernel is FUSE_FAMFS_DAX capable\n", __func__);
+		init_rwsem(&fc->famfs_devlist_sem);
+	}
+
 	INIT_LIST_HEAD(&fc->mounts);
 	list_add(&fm->fc_entry, &fc->mounts);
 	fm->fc = fc;
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index f9e14180367a..d85fb692cf3b 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -652,6 +652,10 @@ enum fuse_opcode {
 	FUSE_TMPFILE		= 51,
 	FUSE_STATX		= 52,
 
+	/* Famfs / devdax opcodes */
+	FUSE_GET_FMAP           = 53,
+	FUSE_GET_DAXDEV         = 54,
+
 	/* CUSE specific operations */
 	CUSE_INIT		= 4096,
 
-- 
2.49.0

