Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FE11DB13A
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199287; cv=none; b=tHI2OlF4bm+WSF3L3+szSYm5GcSLvUsBB9cssTuif1uQMG6VHRuscPvhuubAgUflVvgJMLcDlec/tgrMRH3/I2Zdr0NkyDSyzVIv1GgLXUCHXi5CRcR94ArYTersPbDR2huE16TvYke9zpgcjcfYTXIvhFqcNfnXZrOrZUSJeYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199287; c=relaxed/simple;
	bh=xGy57wKMHcPHaHQmqC7PU7UgEP988xP7vfKFR5LKz6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SlVd5/cqP4ZQzCxeVgbf9Vr4WaPTazkhFSMEPwHwXjyJ4TBdSxW6BYwWQKoiIWk4SD1gp3Ya70Mh54vWlQNv47D+DalUpTBKkCcePWJu5YxjJMVOxBlIvLNpXetEZkXINbLuRmYudIoe3VKpbGDCqyCg9Tze7iEgHwViN0gYjt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGDkpdm1; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGDkpdm1"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-72bb97260ceso1235865a34.1
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199284; x=1745804084; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kGY/iAQALrENz7kCElkxfNZCIv66dIEClpF9MaGB4Dg=;
        b=iGDkpdm1j9EhqgQC2Vy+xfa73Iw6WBoXNc0GWIp+Z9xds5GVE3MrnJRDqdp94b8hKg
         BJ3PJ0FWUy6zwQUK8vtg7ctXSAhmFc6g3cZ/Ue5TduJ2u8u6GfzKOi+/HsA+X2nW8gij
         kcP5u5bq2Nv1EkTHyp0iQ9JUfSZSPexX49gvB90jXbXhbr5rx4OsnCctP9YLMmGIo8dU
         8mvolXoCKm0+WfdFottW8j+c53QwB86yuvRdjzTdjsP2KpSIHCdjdF1kcUyvPDlmDkmg
         TEYcqOqTBpODwhfuXS65cWtQrjVWmoxyC8+Zk9cmbV5XjlFacmYZR04GmhhgMwyZcEN+
         Xdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199284; x=1745804084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kGY/iAQALrENz7kCElkxfNZCIv66dIEClpF9MaGB4Dg=;
        b=O7QlcECaqH09HSdGOYOLSoLeiI3TipUUrbP7Ub0MOfTQ9RigbcjHA1wuUkFczJ0H+S
         NswZsdC1nVYm2Nmb6VVIembg0jmSLyIRLgKgnCdKn3vR3JpP7ln/GRV4jL2mATQvbmY0
         DcMh6y+3g5ql/6xP5rcOddW1MRYyEBlaLAnZteuOeAJe9d6cSn6st9B33y/W5x0rvJJA
         RFDE2ZDKZPsjPgTYKmgAOQDS/jQlNDXk7DRAu21nsgBPH9ilwv4XjgkTEuhZt39OCt7e
         zcZzaEfHYejX1PUcby9E2OEi5PBTclDlBSUxD+LlVwM27+3sMwynVMKrSiWddr2botdK
         vf6g==
X-Forwarded-Encrypted: i=1; AJvYcCWAGxqy/kq7mJAzMQs5jIyYLg/THNtTijiJJiG6dTiz2oCd51k/N+YycQ+E1am4j+FlpfkVlAw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDj9hOlBCiOw2OukhLnZV0X+syU4wAdgdGIzM8kZbuukOIZs0U
	nq1nABgS3TNjvbqdsKOJWAIpnEtbw1OjRLmtBpIM5z5wN85FYIWH
X-Gm-Gg: ASbGncujbtTMG+p2gbF6jONCMy2H9lNpsf5+WzzfjIVrVoWZiFnJq5qT70qBlBXhzo/
	GeTuWNKw7a7X7ic1JisCvj6haJrVDSuo60h7/Ie6Ty2ayCssO4Or+xXHRi6R8qkhLYpd802CaUu
	zVLAbWQZPGgxlx4r98wtKPJQDGS5lwI7SHnl+anKkWEXDrJjTajTlAwIAw4RjdjzzeEAG0u5Cbr
	LgZFQikXkDHNs09dr3KMt4QbpKRfqBPf6B7Q9TLb/1EdMb+eWSVpsAloW13eQc3Mmgazc4Bk4iv
	e32HyYUQRoERgFtwF1TNQ2efxZEBSmD7QXgHFZkPu9YLfcGKZNyBaOD0nBDHLNK54ik4jg==
X-Google-Smtp-Source: AGHT+IHi4NS1xMTqypMU3t1y5JPLpqGjkg0Jz7FECLjaMyt6sb+shrqrVp3uCCLvcJOP+hFAPH4l6Q==
X-Received: by 2002:a05:6830:4709:b0:72b:992b:e41 with SMTP id 46e09a7af769-730063311a1mr6130128a34.23.1745199284265;
        Sun, 20 Apr 2025 18:34:44 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:43 -0700 (PDT)
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
Subject: [RFC PATCH 16/19] famfs_fuse: Add holder_operations for dax notify_failure()
Date: Sun, 20 Apr 2025 20:33:43 -0500
Message-Id: <20250421013346.32530-17-john@groves.net>
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

If we get a notify_failure() call on a daxdev, set its error flag and
prevent further access to that device.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs.c  | 154 ++++++++++++++++++++++++++++++++++-------------
 fs/fuse/file.c   |   6 +-
 fs/fuse/fuse_i.h |   6 +-
 3 files changed, 117 insertions(+), 49 deletions(-)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index 8c12e8bd96b2..363031704c8d 100644
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
@@ -169,6 +189,15 @@ famfs_fuse_get_daxdev(struct fuse_mount *fm, const u64 index)
 		goto out;
 	}
 
+	err = fs_dax_get(daxdev->devp, fc, &famfs_fuse_dax_holder_ops);
+	if (err) {
+		up_write(&fc->famfs_devlist_sem);
+		pr_err("%s: fs_dax_get(%lld) failed\n",
+		       __func__, (u64)daxdev->devno);
+		err = -EBUSY;
+		goto out;
+	}
+
 	daxdev->name = kstrdup(daxdev_out.name, GFP_KERNEL);
 	wmb(); /* all daxdev fields must be visible before marking it valid */
 	daxdev->valid = 1;
@@ -263,6 +292,38 @@ famfs_update_daxdev_table(
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
@@ -610,10 +671,10 @@ famfs_file_init_dax(
  * offsets within a dax device.
  */
 
-static ssize_t famfs_file_invalid(struct inode *inode);
+static ssize_t famfs_file_bad(struct inode *inode);
 
 static int
-famfs_meta_to_dax_offset_v2(struct inode *inode, struct iomap *iomap,
+famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 			 loff_t file_offset, off_t len, unsigned int flags)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
@@ -628,7 +689,7 @@ famfs_meta_to_dax_offset_v2(struct inode *inode, struct iomap *iomap,
 		goto err_out;
 	}
 
-	if (famfs_file_invalid(inode))
+	if (famfs_file_bad(inode))
 		goto err_out;
 
 	iomap->offset = file_offset;
@@ -649,6 +710,7 @@ famfs_meta_to_dax_offset_v2(struct inode *inode, struct iomap *iomap,
 
 		/* Is the data is in this striped extent? */
 		if (local_offset < ext_size) {
+			struct famfs_daxdev *dd;
 			u64 chunk_num       = local_offset / chunk_size;
 			u64 chunk_offset    = local_offset % chunk_size;
 			u64 stripe_num      = chunk_num / nstrips;
@@ -658,9 +720,11 @@ famfs_meta_to_dax_offset_v2(struct inode *inode, struct iomap *iomap,
 			u64 strip_dax_ofs = fei->ie_strips[strip_num].ext_offset;
 			u64 strip_devidx = fei->ie_strips[strip_num].dev_index;
 
-			if (!fc->dax_devlist->devlist[strip_devidx].valid) {
-				pr_err("%s: daxdev=%lld invalid\n", __func__,
-					strip_devidx);
+			dd = &fc->dax_devlist->devlist[strip_devidx];
+			if (!dd->valid || dd->error) {
+				pr_err("%s: daxdev=%lld %s\n", __func__,
+				       strip_devidx,
+				       dd->valid ? "error" : "invalid");
 				goto err_out;
 			}
 			iomap->addr    = strip_dax_ofs + strip_offset;
@@ -695,9 +759,9 @@ famfs_meta_to_dax_offset_v2(struct inode *inode, struct iomap *iomap,
 }
 
 /**
- * famfs_meta_to_dax_offset() - Resolve (file, offset, len) to (daxdev, offset, len)
+ * famfs_fileofs_to_daxofs() - Resolve (file, offset, len) to (daxdev, offset, len)
  *
- * This function is called by famfs_iomap_begin() to resolve an offset in a
+ * This function is called by famfs_fuse_iomap_begin() to resolve an offset in a
  * file to an offset in a dax device. This is upcalled from dax from calls to
  * both  * dax_iomap_fault() and dax_iomap_rw(). Dax finishes the job resolving
  * a fault to a specific physical page (the fault case) or doing a memcpy
@@ -717,7 +781,7 @@ famfs_meta_to_dax_offset_v2(struct inode *inode, struct iomap *iomap,
  * Return values: 0. (info is returned in a modified @iomap struct)
  */
 static int
-famfs_meta_to_dax_offset(struct inode *inode, struct iomap *iomap,
+famfs_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
 			 loff_t file_offset, off_t len, unsigned int flags)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
@@ -731,12 +795,13 @@ famfs_meta_to_dax_offset(struct inode *inode, struct iomap *iomap,
 		goto err_out;
 	}
 
-	if (famfs_file_invalid(inode))
+	if (famfs_file_bad(inode))
 		goto err_out;
 
 	if (meta->fm_extent_type == INTERLEAVED_EXTENT)
-		return famfs_meta_to_dax_offset_v2(inode, iomap, file_offset,
-						   len, flags);
+		return famfs_interleave_fileofs_to_daxofs(inode, iomap,
+							  file_offset,
+							  len, flags);
 
 	iomap->offset = file_offset;
 
@@ -757,10 +822,14 @@ famfs_meta_to_dax_offset(struct inode *inode, struct iomap *iomap,
 		 */
 		if (local_offset < dax_ext_len) {
 			loff_t ext_len_remainder = dax_ext_len - local_offset;
+			struct famfs_daxdev *dd;
+
+			dd = &fc->dax_devlist->devlist[daxdev_idx];
 
-			if (!fc->dax_devlist->devlist[daxdev_idx].valid) {
-				pr_err("%s: daxdev=%lld invalid\n", __func__,
-					daxdev_idx);
+			if (!dd->valid || dd->error) {
+				pr_err("%s: daxdev=%lld %s\n", __func__,
+				       daxdev_idx,
+				       dd->valid ? "error" : "invalid");
 				goto err_out;
 			}
 
@@ -808,7 +877,7 @@ famfs_meta_to_dax_offset(struct inode *inode, struct iomap *iomap,
 }
 
 /**
- * famfs_iomap_begin() - Handler for iomap_begin upcall from dax
+ * famfs_fuse_iomap_begin() - Handler for iomap_begin upcall from dax
  *
  * This function is pretty simple because files are
  * * never partially allocated
@@ -824,7 +893,7 @@ famfs_meta_to_dax_offset(struct inode *inode, struct iomap *iomap,
  * @srcmap:
  */
 static int
-famfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+famfs_fuse_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		  unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
@@ -835,21 +904,21 @@ famfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	WARN_ON(size != meta->file_size);
 
-	return famfs_meta_to_dax_offset(inode, iomap, offset, length, flags);
+	return famfs_fileofs_to_daxofs(inode, iomap, offset, length, flags);
 }
 
 /* Note: We never need a special set of write_iomap_ops because famfs never
  * performs allocation on write.
  */
 const struct iomap_ops famfs_iomap_ops = {
-	.iomap_begin		= famfs_iomap_begin,
+	.iomap_begin		= famfs_fuse_iomap_begin,
 };
 
 /*********************************************************************
  * vm_operations
  */
 static vm_fault_t
-__famfs_filemap_fault(struct vm_fault *vmf, unsigned int pe_size,
+__famfs_fuse_filemap_fault(struct vm_fault *vmf, unsigned int pe_size,
 		      bool write_fault)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -886,25 +955,25 @@ famfs_is_write_fault(struct vm_fault *vmf)
 static vm_fault_t
 famfs_filemap_fault(struct vm_fault *vmf)
 {
-	return __famfs_filemap_fault(vmf, 0, famfs_is_write_fault(vmf));
+	return __famfs_fuse_filemap_fault(vmf, 0, famfs_is_write_fault(vmf));
 }
 
 static vm_fault_t
 famfs_filemap_huge_fault(struct vm_fault *vmf, unsigned int pe_size)
 {
-	return __famfs_filemap_fault(vmf, pe_size, famfs_is_write_fault(vmf));
+	return __famfs_fuse_filemap_fault(vmf, pe_size, famfs_is_write_fault(vmf));
 }
 
 static vm_fault_t
 famfs_filemap_page_mkwrite(struct vm_fault *vmf)
 {
-	return __famfs_filemap_fault(vmf, 0, true);
+	return __famfs_fuse_filemap_fault(vmf, 0, true);
 }
 
 static vm_fault_t
 famfs_filemap_pfn_mkwrite(struct vm_fault *vmf)
 {
-	return __famfs_filemap_fault(vmf, 0, true);
+	return __famfs_fuse_filemap_fault(vmf, 0, true);
 }
 
 static vm_fault_t
@@ -926,16 +995,23 @@ const struct vm_operations_struct famfs_file_vm_ops = {
  * file_operations
  */
 
-/* Reject I/O to files that aren't in a valid state */
+/**
+ * famfs_file_bad() - Check for files that aren't in a valid state
+ *
+ * @inode - inode
+ *
+ * Returns: 0=success
+ *          -errno=failure
+ */
 static ssize_t
-famfs_file_invalid(struct inode *inode)
+famfs_file_bad(struct inode *inode)
 {
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct famfs_file_meta *meta = fi->famfs_meta;
 	size_t i_size = i_size_read(inode);
 
 	if (!meta) {
-		pr_debug("%s: un-initialized famfs file\n", __func__);
+		pr_err("%s: un-initialized famfs file\n", __func__);
 		return -EIO;
 	}
 	if (meta->error) {
@@ -956,7 +1032,7 @@ famfs_file_invalid(struct inode *inode)
 }
 
 static ssize_t
-famfs_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
+famfs_fuse_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
 {
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	size_t i_size = i_size_read(inode);
@@ -964,7 +1040,7 @@ famfs_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
 	size_t max_count;
 	ssize_t rc;
 
-	rc = famfs_file_invalid(inode);
+	rc = famfs_file_bad(inode);
 	if (rc)
 		return rc;
 
@@ -980,11 +1056,11 @@ famfs_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
 }
 
 ssize_t
-famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to)
+famfs_fuse_read_iter(struct kiocb *iocb, struct iov_iter	*to)
 {
 	ssize_t rc;
 
-	rc = famfs_rw_prep(iocb, to);
+	rc = famfs_fuse_rw_prep(iocb, to);
 	if (rc)
 		return rc;
 
@@ -997,20 +1073,12 @@ famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to)
 	return rc;
 }
 
-/**
- * famfs_dax_write_iter()
- *
- * We need our own write-iter in order to prevent append
- *
- * @iocb:
- * @from: iterator describing the user memory source for the write
- */
 ssize_t
-famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
+famfs_fuse_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	ssize_t rc;
 
-	rc = famfs_rw_prep(iocb, from);
+	rc = famfs_fuse_rw_prep(iocb, from);
 	if (rc)
 		return rc;
 
@@ -1021,12 +1089,12 @@ famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 }
 
 int
-famfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+famfs_fuse_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(file);
 	ssize_t rc;
 
-	rc = famfs_file_invalid(inode);
+	rc = famfs_file_bad(inode);
 	if (rc)
 		return (int)rc;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 11201195924d..47b3d76acb38 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1778,7 +1778,7 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_read_iter(iocb, to);
 	if (fuse_file_famfs(fi))
-		return famfs_dax_read_iter(iocb, to);
+		return famfs_fuse_read_iter(iocb, to);
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
 	if (ff->open_flags & FOPEN_DIRECT_IO)
@@ -1802,7 +1802,7 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_write_iter(iocb, from);
 	if (fuse_file_famfs(fi))
-		return famfs_dax_write_iter(iocb, from);
+		return famfs_fuse_write_iter(iocb, from);
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
 	if (ff->open_flags & FOPEN_DIRECT_IO)
@@ -2648,7 +2648,7 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_mmap(file, vma);
 	if (fuse_file_famfs(fi))
-		return famfs_file_mmap(file, vma);
+		return famfs_fuse_mmap(file, vma);
 
 	/*
 	 * If inode is in passthrough io mode, because it has some file open
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 4c4c4f0ff280..702c1849720c 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1561,9 +1561,9 @@ extern void fuse_sysctl_unregister(void);
 int famfs_file_init_dax(struct fuse_mount *fm,
 			     struct inode *inode, void *fmap_buf,
 			     size_t fmap_size);
-ssize_t famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
-ssize_t famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to);
-int famfs_file_mmap(struct file *file, struct vm_area_struct *vma);
+ssize_t famfs_fuse_write_iter(struct kiocb *iocb, struct iov_iter *from);
+ssize_t famfs_fuse_read_iter(struct kiocb *iocb, struct iov_iter	*to);
+int famfs_fuse_mmap(struct file *file, struct vm_area_struct *vma);
 void __famfs_meta_free(void *map);
 void famfs_teardown(struct fuse_conn *fc);
 #endif
-- 
2.49.0

