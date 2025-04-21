Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2322B1DA61B
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199279; cv=none; b=PJjsFSBcg0hzO260wFOJQJuNOLCfbxaZz0xLQpvbO8ETlMw4auJkq5liiREflfhgionSaK8J2i1yBmg/ZMrVFINa3o/WJSqIH9TVF2EXpyTCQMb4G5AtY+yIOVx780i4zQI1b+p/HqCcYfAiM3KpJmJIuvoazNlgkXx62pc28Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199279; c=relaxed/simple;
	bh=JJavKmU5g6tWJWTxuJpGUXY96eQIHoKD8uqAsnDeOI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MuxFCdX+8mLGyS4zOBLrHg8TE1qUMS2FDBx3BWUvWrjuZLTWYlgNhmLmWLHaQBGsKIKvRkekGH0qpVawqfYpBQ4/elG45+nedVPZlRBfswDB1r34PdUDW4G4V+M4Fn8OjbbhZcwfx/siAUooFVR4WL4gnSP1N7yLDOxhG3r6HqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ip8pCytN; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ip8pCytN"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7300069c447so1408809a34.2
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199276; x=1745804076; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcrAxqtjszSaQiT74e0heontuc8sXS7oh97ApQYTn+o=;
        b=ip8pCytNVR6I7sxPbh6lt1dkONWewgDpmMAMLot4ACMEl8AzdziaOr1+tVghM/y0yn
         2K+H+Uwu9PqNovBV8gfjpMEaPPsCJMk8FW6ahdMrjyEus7BMOssU+eHGrV/5dBNtc1ZR
         /M3KOQCGRCbINZf2D768CHm0vweT6JoeULADX9BkExMNziPxl6vHzhRLM/KE4LMLgsUx
         intbENJ1lKchMHkgYE/dPbBV+3VRfDkhy6gIa+KTn4vbDEz0BW2Aq1kLCZw6TRjVY5E1
         Fz/Q/lz0RkPSHWyXiL9jyFYDA3WUSRjh4kx6ydbPUDGWXUzbXqNxASQmhp+S3aDPqs3M
         8K+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199276; x=1745804076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcrAxqtjszSaQiT74e0heontuc8sXS7oh97ApQYTn+o=;
        b=fApvFNOJKh62/VfUPIPcGFnszEpAHOYDxDMQ+OiYq+E5WHu2KPynWymBJcCCyzHlcQ
         0JWHq5ejtz+/GeQwvpHMJUc91XSlyARK02ToJVWgMSYDYmEZpOPzybIzWSAQ0cY9BYlN
         tfEkSJMBR4xlJ/J5GlxkONpIi8JW/dGNdsojfEgUqyqmuE3t4p44LaIzvtPySu9dCadd
         M4oSl+R+fh/FAqBMd0/cdyZaDPCgKUc1UfgfuvNlOUgdRwX5vrVRmBzvqSHVJ7uTgMpL
         gnadq1rNisuYWMa9udH942JqCM4NMi4nuqfmjDiD354Sa8K6wOzGJmkxXme3Z9sl+3Z5
         jqaw==
X-Forwarded-Encrypted: i=1; AJvYcCUuRjkOQ9j/NyGJG5ilFasxyh0f2NccxSnKC7XN/6RnbF2akDmtp9oGnN/pv7gSYGWV8s6wD30=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywv9cwBwOn6Cr908m4L0+QlNnlIOhZdzVezqtTzxzRmebnDxvp7
	c1jygRJIEJfXwQKPBT4fOp4+RK19AqhjuVaGZrDdMGg4bzGSSWk8
X-Gm-Gg: ASbGncvELkd03LxCYTcEcc+SmYHvkR5DY4d0SIhwIYIzHziptrx74ILGPJ8W7cchSvn
	u6vexoihJYPaTsHgW6BCVVPnNsoQi/Zf5f0GO0x+9Fb3IEsYgv2MnGhdvNL67g8XXokrx6a+suI
	PtDhfpAzutlWjyeEEC2wPnjD7yk+PW+NZDdmQP+mQIbTDOKY+dHlF9ThYdWMYjwhXvcd2RXKkJj
	CoSaywdu//TDPgrn2O5BwfM1v9Vg2j28cjRbrtgT/RhRjcpvyWLnaNWtkYY4leZO4Lp3Bbtx4oV
	YtbX9rB89aD1EBIy2BDW+kC+ONWf9eDKN6cJHcBSn7sztZPFHp/hD+KG2ftV0N7C9QoErT39G6X
	DpYL/
X-Google-Smtp-Source: AGHT+IFWNSElaLO5LfPycQSgAB52unjbLEM8kKy6vLbqFxmUQJ1htR96UknIbJZHxCYAGWw5emcl2Q==
X-Received: by 2002:a05:6830:670c:b0:72b:a6a9:8465 with SMTP id 46e09a7af769-73006333daemr6668386a34.23.1745199276180;
        Sun, 20 Apr 2025 18:34:36 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:35 -0700 (PDT)
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
Subject: [RFC PATCH 14/19] famfs_fuse: GET_DAXDEV message and daxdev_table
Date: Sun, 20 Apr 2025 20:33:41 -0500
Message-Id: <20250421013346.32530-15-john@groves.net>
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

* The new GET_DAXDEV message/response is enabled
* The command it triggered by the update_daxdev_table() call, if there
  are any daxdevs in the subject fmap that are not represented in the
  daxdev_dable yet.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs.c           | 281 ++++++++++++++++++++++++++++++++++++--
 fs/fuse/famfs_kfmap.h     |  23 ++++
 fs/fuse/fuse_i.h          |   4 +
 fs/fuse/inode.c           |   2 +
 fs/namei.c                |   1 +
 include/uapi/linux/fuse.h |  15 ++
 6 files changed, 316 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index e62c047d0950..2e182cb7d7c9 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -20,6 +20,250 @@
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
+		if (devlist->devlist[i].valid && devlist->devlist[i].devp)
+			fs_put_dax(devlist->devlist[i].devp, fc);
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
+ * famfs_fuse_get_daxdev()
+ *
+ * Send a GET_DAXDEV message to the fuse server to retrieve info on a
+ * dax device.
+ *
+ * @fm    - fuse_mount
+ * @index - the index of the dax device; daxdevs are referred to by index
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
+	pr_notice("%s: index=%lld\n", __func__, index);
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
+		/* Error will be that the payload is smaller than FMAP_BUFSIZE,
+		 * which is the max we can handle. Empty payload handled below.
+		 */
+		goto out;
+	}
+
+	down_write(&fc->famfs_devlist_sem);
+
+	daxdev = &fc->dax_devlist->devlist[index];
+	pr_debug("%s: dax_devlist %llx daxdev[%lld]=%llx\n", __func__,
+		 (u64)fc->dax_devlist, index, (u64)daxdev);
+
+	/* Abort if daxdev is now valid */
+	if (daxdev->valid) {
+		up_write(&fc->famfs_devlist_sem);
+		/* We already have a valid entry at this index */
+		err = -EALREADY;
+		goto out;
+	}
+
+	/* This verifies that the dev is valid and can be opened and gets the devno */
+	pr_debug("%s: famfs_verify_daxdev(%s)\n", __func__, daxdev_out.name);
+	err = famfs_verify_daxdev(daxdev_out.name, &daxdev->devno);
+	if (err) {
+		up_write(&fc->famfs_devlist_sem);
+		pr_err("%s: err=%d from famfs_verify_daxdev()\n", __func__, err);
+		goto out;
+	}
+
+	/* This will fail if it's not a dax device */
+	pr_debug("%s: dax_dev_get(%x)\n", __func__, daxdev->devno);
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
+	pr_debug("%s: daxdev(%lld, %s)=%llx opened and marked valid\n",
+		 __func__, index, daxdev->name, (u64)daxdev);
+
+out:
+	return err;
+}
+
+/**
+ * famfs_update_daxdev_table()
+ *
+ * This function is called for each new file fmap, to verify whether all
+ * referenced daxdevs are already known (i.e. in the table). Any daxdev
+ * indices that are not in the table will be retrieved via
+ * famfs_fuse_get_daxdev()
+ * @fm   - fuse_mount
+ * @meta - famfs_file_meta, in-memory format, built from a GET_FMAP response
+ *
+ * Returns: 0=success
+ *          -errno=failure
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
+	pr_debug("%s: dev_bitmap=0x%llx\n", __func__, meta->dev_bitmap);
+
+	/* First time through we will need to allocate the dax_devlist */
+	if (!fc->dax_devlist) {
+		local_devlist = kcalloc(1, sizeof(*fc->dax_devlist), GFP_KERNEL);
+		if (!local_devlist)
+			return -ENOMEM;
+
+		local_devlist->nslots = MAX_DAXDEVS;
+		pr_debug("%s: allocate dax_devlist=%llx\n", __func__,
+			 (u64)local_devlist);
+
+		local_devlist->devlist = kcalloc(MAX_DAXDEVS,
+						 sizeof(struct famfs_daxdev),
+						 GFP_KERNEL);
+		if (!local_devlist->devlist) {
+			kfree(local_devlist);
+			return -ENOMEM;
+		}
+
+		/* We don't need the famfs_devlist_sem here because we use cmpxchg... */
+		if (cmpxchg(&fc->dax_devlist, NULL, local_devlist) != NULL) {
+			pr_debug("%s: aborting new devlist\n", __func__);
+			kfree(local_devlist->devlist);
+			kfree(local_devlist); /* another thread beat us to it */
+		} else {
+			pr_debug("%s: published new dax_devlist %llx / %llx\n",
+				 __func__, (u64)local_devlist,
+				 (u64)local_devlist->devlist);
+		}
+	}
+
+	down_read(&fc->famfs_devlist_sem);
+	for (i = 0; i < fc->dax_devlist->nslots; i++) {
+		if (meta->dev_bitmap & (1ULL << i)) {
+			/* This file meta struct references devindex i
+			 * if devindex i isn't in the table; get it...
+			 */
+			if (!(fc->dax_devlist->devlist[i].valid)) {
+				up_read(&fc->famfs_devlist_sem);
+
+				pr_notice("%s: daxdev=%d (%llx) invalid...getting\n",
+					  __func__, i,
+					  (u64)(&fc->dax_devlist->devlist[i]));
+				err = famfs_fuse_get_daxdev(fm, i);
+				if (err)
+					pr_err("%s: failed to get daxdev=%d\n",
+					       __func__, i);
+
+				down_read(&fc->famfs_devlist_sem);
+			}
+		}
+	}
+	up_read(&fc->famfs_devlist_sem);
+
+	return 0;
+}
+
+/***************************************************************************/
 
 void
 __famfs_meta_free(void *famfs_meta)
@@ -67,12 +311,15 @@ famfs_check_ext_alignment(struct famfs_meta_simple_ext *se)
 }
 
 /**
- * famfs_meta_alloc() - Allocate famfs file metadata
+ * famfs_fuse_meta_alloc() - Allocate famfs file metadata
  * @metap:       Pointer to an mcache_map_meta pointer
  * @ext_count:  The number of extents needed
+ *
+ * Returns: 0=success
+ *          -errno=failure
  */
 static int
-famfs_meta_alloc_v3(
+famfs_fuse_meta_alloc(
 	void *fmap_buf,
 	size_t fmap_buf_size,
 	struct famfs_file_meta **metap)
@@ -92,28 +339,25 @@ famfs_meta_alloc_v3(
 	if (next_offset > fmap_buf_size) {
 		pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
 		       __func__, __LINE__, next_offset, fmap_buf_size);
-		rc = -EINVAL;
-		goto errout;
+		return -EINVAL;
 	}
 
 	if (fmh->nextents < 1) {
 		pr_err("%s: nextents %d < 1\n", __func__, fmh->nextents);
-		rc = -EINVAL;
-		goto errout;
+		return -EINVAL;
 	}
 
 	if (fmh->nextents > FUSE_FAMFS_MAX_EXTENTS) {
 		pr_err("%s: nextents %d > max (%d) 1\n",
 		       __func__, fmh->nextents, FUSE_FAMFS_MAX_EXTENTS);
-		rc = -E2BIG;
-		goto errout;
+		return -E2BIG;
 	}
 
 	meta = kzalloc(sizeof(*meta), GFP_KERNEL);
 	if (!meta)
 		return -ENOMEM;
-	meta->error = false;
 
+	meta->error = false;
 	meta->file_type = fmh->file_type;
 	meta->file_size = fmh->file_size;
 	meta->fm_extent_type = fmh->ext_type;
@@ -298,6 +542,20 @@ famfs_meta_alloc_v3(
 	return rc;
 }
 
+/**
+ * famfs_file_init_dax()
+ *
+ * Initialize famfs metadata for a file, based on the contents of the GET_FMAP
+ * response
+ *
+ * @fm        - fuse_mount
+ * @inode     - the inode
+ * @fmap_buf  - fmap response message
+ * @fmap_size - Size of the fmap message
+ *
+ * Returns: 0=success
+ *          -errno=failure
+ */
 int
 famfs_file_init_dax(
 	struct fuse_mount *fm,
@@ -316,10 +574,13 @@ famfs_file_init_dax(
 		return -EEXIST;
 	}
 
-	rc = famfs_meta_alloc_v3(fmap_buf, fmap_size, &meta);
+	rc = famfs_fuse_meta_alloc(fmap_buf, fmap_size, &meta);
 	if (rc)
 		goto errout;
 
+	/* Make sure this fmap doesn't reference any unknown daxdevs */
+	famfs_update_daxdev_table(fm, meta);
+
 	/* Publish the famfs metadata on fi->famfs_meta */
 	inode_lock(inode);
 	if (fi->famfs_meta) {
diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
index ce785d76719c..325adb8b99c5 100644
--- a/fs/fuse/famfs_kfmap.h
+++ b/fs/fuse/famfs_kfmap.h
@@ -60,4 +60,27 @@ struct famfs_file_meta {
 	};
 };
 
+/*
+ * dax_devlist
+ *
+ * This is the in-memory daxdev metadata that is populated by
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
+struct famfs_dax_devlist {
+	int nslots;
+	int ndevs;
+	struct famfs_daxdev *devlist; /* XXX: make this an xarray! */
+};
+
 #endif /* FAMFS_KFMAP_H */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d8e0ac784224..4c4c4f0ff280 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1561,7 +1561,11 @@ extern void fuse_sysctl_unregister(void);
 int famfs_file_init_dax(struct fuse_mount *fm,
 			     struct inode *inode, void *fmap_buf,
 			     size_t fmap_size);
+ssize_t famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
+ssize_t famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to);
+int famfs_file_mmap(struct file *file, struct vm_area_struct *vma);
 void __famfs_meta_free(void *map);
+void famfs_teardown(struct fuse_conn *fc);
 #endif
 
 static inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index e86bf330117f..af1629b07a30 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1051,6 +1051,8 @@ void fuse_conn_put(struct fuse_conn *fc)
 		}
 		if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 			fuse_backing_files_free(fc);
+		if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
+			famfs_teardown(fc);
 		call_rcu(&fc->rcu, delayed_release);
 	}
 }
diff --git a/fs/namei.c b/fs/namei.c
index ecb7b95c2ca3..75a1e1d46593 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3380,6 +3380,7 @@ bool may_open_dev(const struct path *path)
 	return !(path->mnt->mnt_flags & MNT_NODEV) &&
 		!(path->mnt->mnt_sb->s_iflags & SB_I_NODEV);
 }
+EXPORT_SYMBOL(may_open_dev);
 
 static int may_open(struct mnt_idmap *idmap, const struct path *path,
 		    int acc_mode, int flag)
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 0f6ff1ffb23d..982d4fc66ef8 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1328,4 +1328,19 @@ struct fuse_famfs_fmap_header {
 	uint64_t file_size;
 	uint64_t reserved1;
 };
+
+struct fuse_get_daxdev_in {
+	uint32_t        daxdev_num;
+};
+
+#define DAXDEV_NAME_MAX 256
+struct fuse_daxdev_out {
+	uint16_t index;
+	uint16_t reserved;
+	uint32_t reserved2;
+	uint64_t reserved3; /* enough space for a uuid if we need it */
+	uint64_t reserved4;
+	char name[DAXDEV_NAME_MAX];
+};
+
 #endif /* _LINUX_FUSE_H */
-- 
2.49.0

