Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CE1379992
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426868; cv=none; b=DWUkN5+bNTYn1ehl6/cH0D2AQljyOkJGv+/QioabbocxDTHk6VvKUkTN4iY7JkLZlsOH1ETzge+xtchndc8K6dKynzK0vvh0iJ2EuMQliEjx9LvmkEJuxGQG6RE5CLYVWtD7Hs3w5KpJA7VUr/QgsAJb1vqnynHL/X/u0OBDhZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426868; c=relaxed/simple;
	bh=YrTApsaqoq/8RmqhsSS5NBd3td1SLSnIDUJjr5L7XnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pg7gzeLj/+KQPuQ/Kuv382xeQgidXZBgmf4gFmSsPv78vSvY+HLWKDd4VdoecEGl+1aOi1oGonsuWrIf8rKarQCLh9fvsf9YeFjBNY5LjkA3BqO+/IDEg5C6goalyEP7BrRxmnAFXxh17tKn7b+OPUqDwETDDkjiOmxCG8aU/AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VYdYbjy2; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYdYbjy2"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-3ec4d494383so224266fac.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426859; x=1769031659; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcyLyDaHq6QDAy39EcjDJMRicgWNCaTcNxUYUhPTYH8=;
        b=VYdYbjy2Ey+tPilSIIILCxVPAq80V4RcjjgARrGXN/qd3HybydKNGfQIRWHjYsyFU/
         N7NeShVq6+6nZZBE1eX4HeXa051o/reSjdnWszEcI9+B2xD2VwfYCGORKNmnh32dZYEP
         YDrqAtFFpLnWcp4IBC8/40z6EG20q3gyzwHSH2ZUV6SwjDKS7ZbF2c+XJdrImFQkM7sR
         hKVGewgn/q/9w/vcWAkVIRU0KW4Y7d/ZA66ws3A4R/e9h4olxXSWXIuBuRhkrcXgvYjT
         GMEv6xxf12wNcxjKDfkfb4LaalL6a1R9jI7ldBUS9OuctJoIsETocqniRL3haAigRg0e
         OM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426859; x=1769031659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RcyLyDaHq6QDAy39EcjDJMRicgWNCaTcNxUYUhPTYH8=;
        b=rAiHDEbfK2QfmvzDZERb/5iB9XtAli6HoyOTALWcsb1sVCNiEhUF852CJyPQQD7akI
         l8SMoJI5rIe3sAdxD8paxq2kQ6uTHawvylqx21DUa9Uj5v347MJbftgYHVbTn7+9R82g
         OM6onwnee1w0jEVBiySdLlFR6nl0qZckn8Fb5mEMRVxcxZ+j8yLg8QvEDtLX6Amy1Szr
         n6IL2KTqYTVWm5fNPRjArwHkskegn9nTj4+DkjJAvUEqMD2vpqRnibs/2bcv+nOCcsu6
         rZmdU1+mLpFsOp9FGS2ZKxUQl+Y6nIkYHUtP2wn5hFDcdypiNB8FpJttgskk68teeyt+
         Go+w==
X-Forwarded-Encrypted: i=1; AJvYcCU8/lJXF/98IYWbD3+TuTmqynd6OGzWVzy96bvIdgc+IauPySECKNpvkfmjueCiCtuUEYK++mk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxfniIch7siMASwHEOjDpRDzec1Ymx64l/J+1OR9vgVAB7vLx7
	r+XbWIAGOc4vstPuBNXOPA8PbEWXdB2lWLrvn2oxpEqsA5K6Eaczt6MV
X-Gm-Gg: AY/fxX457SwZhLP6xIgUHtZuinocBEtnSEFtfmjgv5G5g3q2YmD3gobgHQl3W2yrgTD
	lm23kM/sCLsvcxYaBCAsTAQEsNggvPQqfj+DuLO5CjXdRKpCMra2iQmkV9Dn6aJx0w0gMjrJuuo
	N6UehkW3ouzk4BpB6uz8ebxml7iOvlzCCSdZEC9GtVhEnBnrY504pQROaIxI6Ptv8sVf18iQnF/
	jOsUieqc5nAguRGatQdyU0PKO8DPqMlt8JsU66D3Zdscv8jhOlTXEJ39/Utp/pzZdUNs1VITtCU
	CbwM8gHeqTzbDRbTtWrCPuN2rAck7sDiGBCoaMcJQFFSzdbS7lFRV89b0zkj6DdO+CbOPw+Uomt
	wQkUOFDRPbWdPuVIrTa5E4gUFSdLzdkSS4b02uRh4cy5SyLxbw5WU+n/pOVBEIDbe+Z0r0UEPJl
	xVH3W4fo1AD2+eAqC1bYzoNJwcRM2YSaO/uyNfH/4m1ONMHHWcK9JREyw=
X-Received: by 2002:a05:6870:b51f:b0:3e8:4166:4e5e with SMTP id 586e51a60fabf-40406f7d609mr2811717fac.17.1768426859090;
        Wed, 14 Jan 2026 13:40:59 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de8cbfsm17089364fac.3.2026.01.14.13.40.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:40:58 -0800 (PST)
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V4 16/19] famfs_fuse: Add holder_operations for dax notify_failure()
Date: Wed, 14 Jan 2026 15:32:03 -0600
Message-ID: <20260114213209.29453-17-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114213209.29453-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114213209.29453-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Memory errors are at least somewhat more likely on disaggregated memory
than on-board memory. This commit registers to be notified by fsdev_dax
in the event that a memory failure is detected.

When a file access resolves to a daxdev with memory errors, it will fail
with an appropriate error.

If a daxdev failed fs_dax_get(), we set dd->dax_err. If a daxdev called
our notify_failure(), set dd->error. When any of the above happens, set
(file)->error and stop allowing access.

In general, the recovery from memory errors is to unmount the file
system and re-initialize the memory, but there may be usable degraded
modes of operation - particularly in the future when famfs supports
file systems backed by more than one daxdev. In those cases,
accessing data that is on a working daxdev can still work.

For now, return errors for any file that has encountered a memory or dax
error.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs.c       | 110 +++++++++++++++++++++++++++++++++++++++---
 fs/fuse/famfs_kfmap.h |   3 +-
 2 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index 2de70aef1df8..ee3526175b6b 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -21,6 +21,26 @@
 #include "famfs_kfmap.h"
 #include "fuse_i.h"
 
+static void famfs_set_daxdev_err(
+	struct fuse_conn *fc, struct dax_device *dax_devp);
+
+static int
+famfs_dax_notify_failure(struct dax_device *dax_devp, u64 offset,
+			u64 len, int mf_flags)
+{
+	struct fuse_conn *fc = dax_holder(dax_devp);
+
+	famfs_set_daxdev_err(fc, dax_devp);
+
+	return 0;
+}
+
+static const struct dax_holder_operations famfs_fuse_dax_holder_ops = {
+	.notify_failure		= famfs_dax_notify_failure,
+};
+
+/*****************************************************************************/
+
 /*
  * famfs_teardown()
  *
@@ -47,9 +67,12 @@ famfs_teardown(struct fuse_conn *fc)
 		if (!dd->valid)
 			continue;
 
-		/* Release reference from dax_dev_get() */
-		if (dd->devp)
+		/* Only call fs_put_dax if fs_dax_get succeeded */
+		if (dd->devp) {
+			if (!dd->dax_err)
+				fs_put_dax(dd->devp, fc);
 			put_dax(dd->devp);
+		}
 
 		kfree(dd->name);
 	}
@@ -170,6 +193,17 @@ famfs_fuse_get_daxdev(struct fuse_mount *fm, const u64 index)
 		if (!daxdev->name)
 			return -ENOMEM;
 
+		rc = fs_dax_get(daxdev->devp, fc, &famfs_fuse_dax_holder_ops);
+		if (rc) {
+			/* If fs_dax_get() fails, we don't attempt recovery;
+			 * We mark the daxdev valid with dax_err
+			 */
+			daxdev->dax_err = 1;
+			pr_err("%s: fs_dax_get(%lld) failed\n",
+			       __func__, (u64)daxdev->devno);
+			return -EBUSY;
+		}
+
 		wmb(); /* All other fields must be visible before valid */
 		daxdev->valid = 1;
 	}
@@ -245,6 +279,36 @@ famfs_update_daxdev_table(
 	return 0;
 }
 
+static void
+famfs_set_daxdev_err(
+	struct fuse_conn *fc,
+	struct dax_device *dax_devp)
+{
+	int i;
+
+	/* Gotta search the list by dax_devp;
+	 * read lock because we're not adding or removing daxdev entries
+	 */
+	scoped_guard(rwsem_write, &fc->famfs_devlist_sem) {
+		for (i = 0; i < fc->dax_devlist->nslots; i++) {
+			if (fc->dax_devlist->devlist[i].valid) {
+				struct famfs_daxdev *dd;
+
+				dd = &fc->dax_devlist->devlist[i];
+				if (dd->devp != dax_devp)
+					continue;
+
+				dd->error = true;
+
+				pr_err("%s: memory error on daxdev %s (%d)\n",
+				       __func__, dd->name, i);
+				return;
+			}
+		}
+	}
+	pr_err("%s: memory err on unrecognized daxdev\n", __func__);
+}
+
 /***************************************************************************/
 
 void __famfs_meta_free(void *famfs_meta)
@@ -583,6 +647,26 @@ famfs_file_init_dax(
 
 static int famfs_file_bad(struct inode *inode);
 
+static int famfs_dax_err(struct famfs_daxdev *dd)
+{
+	if (!dd->valid) {
+		pr_err("%s: daxdev=%s invalid\n",
+		       __func__, dd->name);
+		return -EIO;
+	}
+	if (dd->dax_err) {
+		pr_err("%s: daxdev=%s dax_err\n",
+		       __func__, dd->name);
+		return -EIO;
+	}
+	if (dd->error) {
+		pr_err("%s: daxdev=%s memory error\n",
+		       __func__, dd->name);
+		return -EHWPOISON;
+	}
+	return 0;
+}
+
 static int
 famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 			 loff_t file_offset, off_t len, unsigned int flags)
@@ -617,6 +701,7 @@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 
 		/* Is the data is in this striped extent? */
 		if (local_offset < ext_size) {
+			struct famfs_daxdev *dd;
 			u64 chunk_num       = local_offset / chunk_size;
 			u64 chunk_offset    = local_offset % chunk_size;
 			u64 chunk_remainder = chunk_size - chunk_offset;
@@ -625,6 +710,7 @@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 			u64 strip_offset    = chunk_offset + (stripe_num * chunk_size);
 			u64 strip_dax_ofs = fei->ie_strips[strip_num].ext_offset;
 			u64 strip_devidx = fei->ie_strips[strip_num].dev_index;
+			int rc;
 
 			if (strip_devidx >= fc->dax_devlist->nslots) {
 				pr_err("%s: strip_devidx %llu >= nslots %d\n",
@@ -639,6 +725,15 @@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 				goto err_out;
 			}
 
+			dd = &fc->dax_devlist->devlist[strip_devidx];
+
+			rc = famfs_dax_err(dd);
+			if (rc) {
+				/* Shut down access to this file */
+				meta->error = true;
+				return rc;
+			}
+
 			iomap->addr    = strip_dax_ofs + strip_offset;
 			iomap->offset  = file_offset;
 			iomap->length  = min_t(loff_t, len, chunk_remainder);
@@ -736,6 +831,7 @@ famfs_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 		if (local_offset < dax_ext_len) {
 			loff_t ext_len_remainder = dax_ext_len - local_offset;
 			struct famfs_daxdev *dd;
+			int rc;
 
 			if (daxdev_idx >= fc->dax_devlist->nslots) {
 				pr_err("%s: daxdev_idx %llu >= nslots %d\n",
@@ -746,11 +842,11 @@ famfs_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 
 			dd = &fc->dax_devlist->devlist[daxdev_idx];
 
-			if (!dd->valid || dd->error) {
-				pr_err("%s: daxdev=%lld %s\n", __func__,
-				       daxdev_idx,
-				       dd->valid ? "error" : "invalid");
-				goto err_out;
+			rc = famfs_dax_err(dd);
+			if (rc) {
+				/* Shut down access to this file */
+				meta->error = true;
+				return rc;
 			}
 
 			/*
diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
index eb9f70b5cb81..0fff841f5a9e 100644
--- a/fs/fuse/famfs_kfmap.h
+++ b/fs/fuse/famfs_kfmap.h
@@ -73,7 +73,8 @@ struct famfs_file_meta {
 struct famfs_daxdev {
 	/* Include dev uuid? */
 	bool valid;
-	bool error;
+	bool error; /* Dax has reported a memory error (probably poison) */
+	bool dax_err; /* fs_dax_get() failed */
 	dev_t devno;
 	struct dax_device *devp;
 	char *name;
-- 
2.52.0

