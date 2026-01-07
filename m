Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D32D33D6CA
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806342; cv=none; b=dmmy9vqMsrTmRCK7nY6NTPnhYiH/uqyl4y2oqOC5dxnamQKWcTIX7CrZXZHcXVpCbl+9/egtl4ZLR0dmJIAP7yoaL3fF5nDVimnwCEH8ucpXI5IQC4/QYOBV/v18JDN/yaZxXJNWD62L68zS+9L6iZouR9yfiZKtWZQ8DevEHUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806342; c=relaxed/simple;
	bh=dEOXcM0qLcGyYDdpYrpwaPuAKh0TeDT6z74M9N7a6x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivDPyc2m4e5/vq9Usmn7wSIbr5IrIkSQpnqg4G8DszC0bisFOei1vqn4w1uV3qVK8RnFp0T5djs+e19T6cCCriMnS4skDsIt4jrht3dtZzoPfxSjnokpVO7EORcfLAdeKZ0/CtFsvcmQiNu32k20uTuqtJJJA+15eB8GaTehneA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iqKjpmbp; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iqKjpmbp"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b2d32b9777so325614285a.2
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 09:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767806329; x=1768411129; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsUBbcgm6GmRe1pvdN9mqC0Y9Ykr2Q9MySmIE+mClu8=;
        b=iqKjpmbp0nm2rhKINJjvuDYNbibn+7/QsfbxeW57TS6aSpxlerbYNXG/rT2AzlhywF
         0lgZOWZ/NSXX2wmvX2DM/cRK3TB2LY1hvc68A5v8w8yJ4KMNjlk17FvhiRO9ZFgYavTu
         Haqfp6TdPvGp98d1PmKwtqo9eXIQ4HskRg7wLDMVrjIUgZBFPeROwGqmf1evCKN0yozR
         Djzi9WyiIMPHyxha+VFGKVIt7B9kPEnC3awqiPXZ2gQheh9UOv1pjfcmuH7KgFkyHggl
         SYcMvvvUcz5zG0RBweqVdun0ETUYi7scBFivYNhmHWPgc+PnbsBftM9oKTxzmP3XWiO0
         n3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767806329; x=1768411129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IsUBbcgm6GmRe1pvdN9mqC0Y9Ykr2Q9MySmIE+mClu8=;
        b=n7B2urCd1N0lp1Md3GjyjEtWjecZMvmnQm9YfAAhAXY6qi1yMXM2I/kLB7wY40F45O
         qbRX5s2KRXl3/ebXXP6kywA9L/Ga3HEjpUOKwWvxXGANgx13diIL7ILgsiNIuccvlPuY
         obEfYJRJUSC0jIggzzSz2qUVz5lqoc0oWscBF8llv5qEZMnmVOGa6DJdNkr93ZmAMO9s
         sZIoix4ea0ZKa6VhHEzNSybJBT2r9TrYFe7JtlEMcXBs9g+8BGHFx1TzJuy9HszBJNW5
         Mc9rmcl3G5GX395Pq+thBxKeTUzhxXW0cUtuoWjKJGSOFgPHSzIJb+nAXMtaZA0O0kMp
         9AsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhpgz7wIQtqlGdPOifrQzKCONAG0oR1d3d7I4cCJ1KQw25CY4btPlXtmQl+uNusgaFxeVJQjU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyax37IAlLn4Rmnh8mQPhJt9HZu/BXEv7mKfFJMXl5TQhrI4wme
	44DPiIBRGfksnpf1/LVFleFkmyrOt3wMFw3W0s3eIXuktCkfLpL2km5r
X-Gm-Gg: AY/fxX7r/JsbmVPARjBAhlMTSt6WUfL0FLAtjx5rJbATl5MBHx/0jJxwwjWlV2N6dUv
	nHE0qm5bqhlYQiazV2OQDtWMcQ3i8VexJuyPnTwXSPaq/q1379xQmT3+JKTZPAQ80HFpAG93csm
	Ox7HxrLQ8rvFTvWw/EzD+25vRn2rVRVaIeP11kgoBlvKoi/lzmDUqL9yqJdRhJQpk6K4s/MAsZ6
	3G2yrcaPaswm2b58x5ElP7mkyv9jxZXRc6COw32f2DiG0sRRl3U7GP10J43g+YM94oRLNr2I94g
	iddmCJdGEknFH3C5h+wB0gMSCVElmFAQFTK3BFKAek00liN2vnxWi6PTJiVZMU+tllWyLduk1FM
	4/W7phxDeYwwiqqrGVcL3FQBBFkOxWYQDR8auShPoiOOtxKQzUMNUZuMq8lHBHJrKhYVAtZweck
	6VCqHueOTAzXCyFqfT3I9T71uOedDBVRa1Lp/gcMTZwq8+
X-Google-Smtp-Source: AGHT+IEAvq5jIS7yNdaICnZjGGLTm+9F3WfQSWgCD5SfovqjmCa/xKQRtzE2sJgjYbpKAc4uVl4aqw==
X-Received: by 2002:a05:6808:150f:b0:45a:5894:4979 with SMTP id 5614622812f47-45a6bdbcf78mr1522078b6e.20.1767800073716;
        Wed, 07 Jan 2026 07:34:33 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:33 -0800 (PST)
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
Subject: [PATCH V3 18/21] famfs_fuse: Add holder_operations for dax notify_failure()
Date: Wed,  7 Jan 2026 09:33:27 -0600
Message-ID: <20260107153332.64727-19-john@groves.net>
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
 fs/fuse/famfs.c       | 115 +++++++++++++++++++++++++++++++++++++++---
 fs/fuse/famfs_kfmap.h |   3 +-
 2 files changed, 109 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index c02b14789c6e..4eb87c5c628e 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -20,6 +20,26 @@
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
@@ -48,9 +68,12 @@ famfs_teardown(struct fuse_conn *fc)
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
@@ -174,6 +197,17 @@ famfs_fuse_get_daxdev(struct fuse_mount *fm, const u64 index)
 		goto out;
 	}
 
+	err = fs_dax_get(daxdev->devp, fc, &famfs_fuse_dax_holder_ops);
+	if (err) {
+		/* If fs_dax_get() fails, we don't attempt recovery;
+		 * We mark the daxdev valid with dax_err
+		 */
+		daxdev->dax_err = 1;
+		pr_err("%s: fs_dax_get(%lld) failed\n",
+		       __func__, (u64)daxdev->devno);
+		err = -EBUSY;
+	}
+
 	daxdev->name = kstrdup(daxdev_out.name, GFP_KERNEL);
 	wmb(); /* all daxdev fields must be visible before marking it valid */
 	daxdev->valid = 1;
@@ -254,6 +288,38 @@ famfs_update_daxdev_table(
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
+	down_read(&fc->famfs_devlist_sem);
+	for (i = 0; i < fc->dax_devlist->nslots; i++) {
+		if (fc->dax_devlist->devlist[i].valid) {
+			struct famfs_daxdev *dd = &fc->dax_devlist->devlist[i];
+
+			if (dd->devp != dax_devp)
+				continue;
+
+			dd->error = true;
+			up_read(&fc->famfs_devlist_sem);
+
+			pr_err("%s: memory error on daxdev %s (%d)\n",
+			       __func__, dd->name, i);
+			goto done;
+		}
+	}
+	up_read(&fc->famfs_devlist_sem);
+	pr_err("%s: memory err on unrecognized daxdev\n", __func__);
+
+done:
+}
+
 /***************************************************************************/
 
 void
@@ -611,6 +677,26 @@ famfs_file_init_dax(
 
 static ssize_t famfs_file_bad(struct inode *inode);
 
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
@@ -648,6 +734,7 @@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 
 		/* Is the data is in this striped extent? */
 		if (local_offset < ext_size) {
+			struct famfs_daxdev *dd;
 			u64 chunk_num       = local_offset / chunk_size;
 			u64 chunk_offset    = local_offset % chunk_size;
 			u64 stripe_num      = chunk_num / nstrips;
@@ -656,6 +743,7 @@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 			u64 strip_offset    = chunk_offset + (stripe_num * chunk_size);
 			u64 strip_dax_ofs = fei->ie_strips[strip_num].ext_offset;
 			u64 strip_devidx = fei->ie_strips[strip_num].dev_index;
+			int rc;
 
 			if (strip_devidx >= fc->dax_devlist->nslots) {
 				pr_err("%s: strip_devidx %llu >= nslots %d\n",
@@ -670,6 +758,15 @@ famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
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
@@ -767,6 +864,7 @@ famfs_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 		if (local_offset < dax_ext_len) {
 			loff_t ext_len_remainder = dax_ext_len - local_offset;
 			struct famfs_daxdev *dd;
+			int rc;
 
 			if (daxdev_idx >= fc->dax_devlist->nslots) {
 				pr_err("%s: daxdev_idx %llu >= nslots %d\n",
@@ -777,11 +875,11 @@ famfs_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 
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
@@ -966,7 +1064,8 @@ famfs_file_bad(struct inode *inode)
 		return -EIO;
 	}
 	if (meta->error) {
-		pr_debug("%s: previously detected metadata errors\n", __func__);
+		pr_debug("%s: previously detected metadata errors\n",
+			 __func__);
 		return -EIO;
 	}
 	if (i_size != meta->file_size) {
diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
index e76b9057a1e0..6a6420bdff48 100644
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
2.49.0

