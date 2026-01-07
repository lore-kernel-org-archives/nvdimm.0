Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E550438E111
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806963; cv=none; b=Ez8449wg16njj3YjuroqX67bqT70JqZFZvAHLiEFNpOCTbE4F8m/HdJS1EpPqOpPUcrdYe1ZIQ4qVuWHROLAZk7Dnz3yg7XtOPb35g0adz9lIKoyhMhL6uxxTAsfhQ75xJGMlvOgoRgC5NlyTotwRVeqMk/7wyQgAEYehxkOp+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806963; c=relaxed/simple;
	bh=VILu4/aZEDEuDrhwIC96ZPrRjlL5TOp4r9I40ua7OBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLQy8kIGd43tKQHlbTYosqdjSGgfiYiakJu80Q/MeIGS4HOJTDa9GrCopD2AD4dPEkVl3o+EW2msfGy1yTjipihZrn7nVqF7m5ad459xaJve++MIUH/f0mRAO0qN/jqTRHhhwUv1M90C4SasV8Ng5AuEBh0xvMaUJ8krv1Hy4zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fjVbgFtq; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fjVbgFtq"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2abe15d8a4bso3634984eec.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 09:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767806956; x=1768411756; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z26pH3kxXMl+NsnFCMmTOxJmvl6Ayq/rxp+1YLnLzkg=;
        b=fjVbgFtqTmd51D7DLf1nx7sPqYCxFZTDKyEYswtgNfF5pfAk/WTUPh/l6sCK0psmXD
         sweNJERpgeuh6tpg+Mu2itCmJE1FUc/QI1EOIErxDdR1rpingzS/EZEhWQTMfqQXIuJC
         5gDBu5b+OpgEtRf6HfGJ4jxgfvTIn8LNznEk1MORLcghmCiSn8+q41UAXThrW5V/FHD8
         gVA7bWeSBzBAllHySG2wDV8ADxYVCEMOkxKwBnuKHlQOYHHuaH8//assu8Ee05clQzXe
         LwRpqMTUPmCckrJn+NbC8TK8YemFwRcOo3Hi678cW+onEQaQDCGM2BqyL0zzvF0p9/Sh
         XUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767806956; x=1768411756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z26pH3kxXMl+NsnFCMmTOxJmvl6Ayq/rxp+1YLnLzkg=;
        b=uRWupDiaU7PyAEKlqqUUHHwrsiDJy5R0g1nDf4lScNDI8yJ3Qk2rLv+rAm8OmNVgSK
         WKnSB+7Z9H0x6y4YPR13RWay+nImi5FoYgZANvQssyam6GgTl2ZecVmDY14z6B0ro1zD
         UXB4cCKvSWKq4pDoA6ZSo16HICWBK/mP4fjuG09hoaVyDWkhshslhwVN3nOQN+MaXMdH
         KBMSdPyi5WMvj0s55IkfJFhuo+aj0lE3Doco79hB+8T2dfEqCtkbh6NmkVy8oDqMZGpM
         hfMj4X53F63guHI4QGAfYGpHk6IwPbA/uy73BtrTb/5FW94F/qhtzuojG7GFHFDJZWrc
         oCBg==
X-Forwarded-Encrypted: i=1; AJvYcCV/UHzhV3U7s6D4GGzw6bzJaHVnqSMshbO0CNKOs+MYEzI9uu+Sg1CfJ/Nfi9XMGawifyA3S3M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKEFWcioF2iahgC2dlJlExwHCjpucGKKiVSWrjv5bLpv2Vn6WQ
	BSQK0uRixfoTHlboH5P5Uc8/kK/dkYEbIkvP4+iCauYxpxxgXXn1XVc0z6LhVQ==
X-Gm-Gg: AY/fxX5MpbfxSHl4/0AGZifTta9AQZMdZd7J5o2QR3HOGd1QmJopm6PtnroRSScIiHv
	2NCu4LhNziAIoOdxXqY4ubCmvY0l0KGT/ZNO7oAbXuP+u0LYv9r6gTUBkamfcsdXKM6gKk2QjkT
	+DK5oraMpNOLI1PTf+amCGp5vTXS9rdt5R7t/xJGYj+4EMgDuyDCP/01bqkp+LtwhpXdtt4nbcL
	ixOHmDkcE7CeUz4hFjlcJWgdji1W3CPJ0viNqN+N+aZM29pZoY+44FSvuZdJc5wKOw5fVeh2ekB
	bt+R/wyarcxt7u/u6qAyO6iSJs+veAVAp7DtE8qhdPEiZM9CkaiAulELzXjrA4yvKWMkCioGb2m
	j3pVnmIqWlpDCn+oFgy0mOVmCO2OvYD9XOfQFJg6xeUWlFOq81ARdhcFYkhe3C7j22gwtIMn85K
	6tTn70lFebBTtHUM55S7JaCabbfLsedtVWcyWhwSWZTtUZ
X-Google-Smtp-Source: AGHT+IG/GJazDtrV8Iv0UenI1pYkQFFjdMGheA22/FDANC++il82RbCdKOOAl/rkQAbrZ5tuK05Wfg==
X-Received: by 2002:a05:6808:2224:b0:450:d8ef:d804 with SMTP id 5614622812f47-45a6be37898mr1407082b6e.39.1767800066998;
        Wed, 07 Jan 2026 07:34:26 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:26 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V3 16/21] famfs_fuse: GET_DAXDEV message and daxdev_table
Date: Wed,  7 Jan 2026 09:33:25 -0600
Message-ID: <20260107153332.64727-17-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153332.64727-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

* The new GET_DAXDEV message/response is added
* The famfs.c:famfs_teardown() function is added as a primary teardown
  function for famfs.
* The command it triggered by the update_daxdev_table() call, if there
  are any daxdevs in the subject fmap that are not represented in the
  daxdev_table yet.
* fs/namei.c: export may_open_dev()

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs.c           | 236 ++++++++++++++++++++++++++++++++++++++
 fs/fuse/famfs_kfmap.h     |  26 +++++
 fs/fuse/fuse_i.h          |  13 ++-
 fs/fuse/inode.c           |   4 +-
 fs/namei.c                |   1 +
 include/uapi/linux/fuse.h |  20 ++++
 6 files changed, 298 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index 2aabd1d589fd..b5cd1b5c1d6c 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -20,6 +20,239 @@
 #include "famfs_kfmap.h"
 #include "fuse_i.h"
 
+/*
+ * famfs_teardown()
+ *
+ * Deallocate famfs metadata for a fuse_conn
+ */
+void
+famfs_teardown(struct fuse_conn *fc)
+{
+	struct famfs_dax_devlist *devlist = fc->dax_devlist;
+	int i;
+
+	kfree(fc->shadow);
+
+	fc->dax_devlist = NULL;
+
+	if (!devlist)
+		return;
+
+	if (!devlist->devlist)
+		goto out;
+
+	/* Close & release all the daxdevs in our table */
+	for (i = 0; i < devlist->nslots; i++) {
+		struct famfs_daxdev *dd = &devlist->devlist[i];
+
+		if (!dd->valid)
+			continue;
+
+		/* Release reference from dax_dev_get() */
+		if (dd->devp)
+			put_dax(dd->devp);
+
+		kfree(dd->name);
+	}
+	kfree(devlist->devlist);
+
+out:
+	kfree(devlist);
+}
+
+static int
+famfs_verify_daxdev(const char *pathname, dev_t *devno)
+{
+	struct inode *inode;
+	struct path path;
+	int err;
+
+	if (!pathname || !*pathname)
+		return -EINVAL;
+
+	err = kern_path(pathname, LOOKUP_FOLLOW, &path);
+	if (err)
+		return err;
+
+	inode = d_backing_inode(path.dentry);
+	if (!S_ISCHR(inode->i_mode)) {
+		err = -EINVAL;
+		goto out_path_put;
+	}
+
+	if (!may_open_dev(&path)) { /* had to export this */
+		err = -EACCES;
+		goto out_path_put;
+	}
+
+	*devno = inode->i_rdev;
+
+out_path_put:
+	path_put(&path);
+	return err;
+}
+
+/**
+ * famfs_fuse_get_daxdev() - Retrieve info for a DAX device from fuse server
+ *
+ * Send a GET_DAXDEV message to the fuse server to retrieve info on a
+ * dax device.
+ *
+ * @fm:     fuse_mount
+ * @index:  the index of the dax device; daxdevs are referred to by index
+ *          in fmaps, and the server resolves the index to a particular daxdev
+ *
+ * Returns: 0=success
+ *          -errno=failure
+ */
+static int
+famfs_fuse_get_daxdev(struct fuse_mount *fm, const u64 index)
+{
+	struct fuse_daxdev_out daxdev_out = { 0 };
+	struct fuse_conn *fc = fm->fc;
+	struct famfs_daxdev *daxdev;
+	int err = 0;
+
+	FUSE_ARGS(args);
+
+	/* Store the daxdev in our table */
+	if (index >= fc->dax_devlist->nslots) {
+		pr_err("%s: index(%lld) > nslots(%d)\n",
+		       __func__, index, fc->dax_devlist->nslots);
+		err = -EINVAL;
+		goto out;
+	}
+
+	args.opcode = FUSE_GET_DAXDEV;
+	args.nodeid = index;
+
+	args.in_numargs = 0;
+
+	args.out_numargs = 1;
+	args.out_args[0].size = sizeof(daxdev_out);
+	args.out_args[0].value = &daxdev_out;
+
+	/* Send GET_DAXDEV command */
+	err = fuse_simple_request(fm, &args);
+	if (err) {
+		pr_err("%s: err=%d from fuse_simple_request()\n",
+		       __func__, err);
+		/*
+		 * Error will be that the payload is smaller than FMAP_BUFSIZE,
+		 * which is the max we can handle. Empty payload handled below.
+		 */
+		goto out;
+	}
+
+	down_write(&fc->famfs_devlist_sem);
+
+	daxdev = &fc->dax_devlist->devlist[index];
+
+	/* Abort if daxdev is now valid (race - another thread got it first) */
+	if (daxdev->valid) {
+		up_write(&fc->famfs_devlist_sem);
+		/* We already have a valid entry at this index */
+		pr_debug("%s: daxdev already known\n", __func__);
+		goto out;
+	}
+
+	/* Verify that the dev is valid and can be opened and gets the devno */
+	err = famfs_verify_daxdev(daxdev_out.name, &daxdev->devno);
+	if (err) {
+		up_write(&fc->famfs_devlist_sem);
+		pr_err("%s: err=%d from famfs_verify_daxdev()\n", __func__, err);
+		goto out;
+	}
+
+	/* This will fail if it's not a dax device */
+	daxdev->devp = dax_dev_get(daxdev->devno);
+	if (!daxdev->devp) {
+		up_write(&fc->famfs_devlist_sem);
+		pr_warn("%s: device %s not found or not dax\n",
+			__func__, daxdev_out.name);
+		err = -ENODEV;
+		goto out;
+	}
+
+	daxdev->name = kstrdup(daxdev_out.name, GFP_KERNEL);
+	wmb(); /* all daxdev fields must be visible before marking it valid */
+	daxdev->valid = 1;
+
+	up_write(&fc->famfs_devlist_sem);
+
+out:
+	return err;
+}
+
+/**
+ * famfs_update_daxdev_table() - Update the daxdev table
+ * @fm   - fuse_mount
+ * @meta - famfs_file_meta, in-memory format, built from a GET_FMAP response
+ *
+ * This function is called for each new file fmap, to verify whether all
+ * referenced daxdevs are already known (i.e. in the table). Any daxdev
+ * indices referenced in @meta but not in the table will be retrieved via
+ * famfs_fuse_get_daxdev() and added to the table
+ *
+ * Return: 0=success
+ *         -errno=failure
+ */
+static int
+famfs_update_daxdev_table(
+	struct fuse_mount *fm,
+	const struct famfs_file_meta *meta)
+{
+	struct famfs_dax_devlist *local_devlist;
+	struct fuse_conn *fc = fm->fc;
+	int err;
+	int i;
+
+	/* First time through we will need to allocate the dax_devlist */
+	if (unlikely(!fc->dax_devlist)) {
+		local_devlist = kcalloc(1, sizeof(*fc->dax_devlist), GFP_KERNEL);
+		if (!local_devlist)
+			return -ENOMEM;
+
+		local_devlist->nslots = MAX_DAXDEVS;
+
+		local_devlist->devlist = kcalloc(MAX_DAXDEVS,
+						 sizeof(struct famfs_daxdev),
+						 GFP_KERNEL);
+		if (!local_devlist->devlist) {
+			kfree(local_devlist);
+			return -ENOMEM;
+		}
+
+		/* We don't need famfs_devlist_sem here because we use cmpxchg */
+		if (cmpxchg(&fc->dax_devlist, NULL, local_devlist) != NULL) {
+			kfree(local_devlist->devlist);
+			kfree(local_devlist); /* another thread beat us to it */
+		}
+	}
+
+	down_read(&fc->famfs_devlist_sem);
+	for (i = 0; i < fc->dax_devlist->nslots; i++) {
+		if (!(meta->dev_bitmap & (1ULL << i)))
+			continue;
+
+		/* This file meta struct references devindex i
+		 * if devindex i isn't in the table; get it...
+		 */
+		if (!(fc->dax_devlist->devlist[i].valid)) {
+			up_read(&fc->famfs_devlist_sem);
+
+			err = famfs_fuse_get_daxdev(fm, i);
+			if (err)
+				pr_err("%s: failed to get daxdev=%d\n",
+				       __func__, i);
+
+			down_read(&fc->famfs_devlist_sem);
+		}
+	}
+	up_read(&fc->famfs_devlist_sem);
+
+	return 0;
+}
 
 /***************************************************************************/
 
@@ -342,6 +575,9 @@ famfs_file_init_dax(
 	if (rc)
 		goto errout;
 
+	/* Make sure this fmap doesn't reference any unknown daxdevs */
+	famfs_update_daxdev_table(fm, meta);
+
 	/* Publish the famfs metadata on fi->famfs_meta */
 	inode_lock(inode);
 	if (fi->famfs_meta) {
diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
index 058645cb10a1..e76b9057a1e0 100644
--- a/fs/fuse/famfs_kfmap.h
+++ b/fs/fuse/famfs_kfmap.h
@@ -64,4 +64,30 @@ struct famfs_file_meta {
 	};
 };
 
+/*
+ * famfs_daxdev - tracking struct for a daxdev within a famfs file system
+ *
+ * This is the in-memory daxdev metadata that is populated by parsing
+ * the responses to GET_FMAP messages
+ */
+struct famfs_daxdev {
+	/* Include dev uuid? */
+	bool valid;
+	bool error;
+	dev_t devno;
+	struct dax_device *devp;
+	char *name;
+};
+
+#define MAX_DAXDEVS 24
+
+/*
+ * famfs_dax_devlist - list of famfs_daxdev's
+ */
+struct famfs_dax_devlist {
+	int nslots;
+	int ndevs;
+	struct famfs_daxdev *devlist;
+};
+
 #endif /* FAMFS_KFMAP_H */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f9e920e95baf..d308b74c83ec 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1018,6 +1018,8 @@ struct fuse_conn {
 	u8 blkbits;
 
 #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	struct rw_semaphore famfs_devlist_sem;
+	struct famfs_dax_devlist *dax_devlist;
 	char *shadow;
 #endif
 };
@@ -1663,13 +1665,15 @@ int famfs_file_init_dax(struct fuse_mount *fm,
 			     struct inode *inode, void *fmap_buf,
 			     size_t fmap_size);
 void __famfs_meta_free(void *map);
-#endif
+void famfs_teardown(struct fuse_conn *fc);
+#else
 static inline void famfs_teardown(struct fuse_conn *fc)
 {
 #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
 	kfree(fc->shadow);
 #endif
 }
+#endif
 
 static inline void famfs_meta_init(struct fuse_inode *fi)
 {
@@ -1688,6 +1692,13 @@ static inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,
 #endif
 }
 
+static inline void famfs_init_devlist_sem(struct fuse_conn *fc)
+{
+#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+	init_rwsem(&fc->famfs_devlist_sem);
+#endif
+}
+
 static inline void famfs_meta_free(struct fuse_inode *fi)
 {
 #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 391ead26bfa2..78787efcfd07 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1497,8 +1497,10 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 				u64 in_flags = ((u64)ia->in.flags2 << 32)
 						| ia->in.flags;
 
-				if (in_flags & FUSE_DAX_FMAP)
+				if (in_flags & FUSE_DAX_FMAP) {
+					famfs_init_devlist_sem(fc);
 					fc->famfs_iomap = 1;
+				}
 			}
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
diff --git a/fs/namei.c b/fs/namei.c
index bf0f66f0e9b9..b47511ac7337 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4162,6 +4162,7 @@ bool may_open_dev(const struct path *path)
 	return !(path->mnt->mnt_flags & MNT_NODEV) &&
 		!(path->mnt->mnt_sb->s_iflags & SB_I_NODEV);
 }
+EXPORT_SYMBOL(may_open_dev);
 
 static int may_open(struct mnt_idmap *idmap, const struct path *path,
 		    int acc_mode, int flag)
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index e6dd3c24bb11..2432ccc4f913 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -247,6 +247,9 @@
  *      - struct fuse_famfs_simple_ext
  *      - struct fuse_famfs_iext
  *      - struct fuse_famfs_fmap_header
+ *    - Add the following structs for the GET_DAXDEV message and reply
+ *      - struct fuse_get_daxdev_in
+ *      - struct fuse_get_daxdev_out
  *    - Add the following enumerated types
  *      - enum fuse_famfs_file_type
  *      - enum famfs_ext_type
@@ -678,6 +681,7 @@ enum fuse_opcode {
 
 	/* Famfs / devdax opcodes */
 	FUSE_GET_FMAP           = 54,
+	FUSE_GET_DAXDEV         = 55,
 
 	/* CUSE specific operations */
 	CUSE_INIT		= 4096,
@@ -1369,6 +1373,22 @@ struct fuse_famfs_fmap_header {
 	uint64_t reserved1;
 };
 
+struct fuse_get_daxdev_in {
+	uint32_t        daxdev_num;
+};
+
+#define DAXDEV_NAME_MAX 256
+
+/* fuse_daxdev_out has enough space for a uuid if we need it */
+struct fuse_daxdev_out {
+	uint16_t index;
+	uint16_t reserved;
+	uint32_t reserved2;
+	uint64_t reserved3;
+	uint64_t reserved4;
+	char name[DAXDEV_NAME_MAX];
+};
+
 static inline int32_t fmap_msg_min_size(void)
 {
 	/* Smallest fmap message is a header plus one simple extent */
-- 
2.49.0

