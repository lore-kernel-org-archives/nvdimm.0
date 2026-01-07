Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF88395268
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800075; cv=none; b=WpWHUuagG+bm7sqHyEr9s0p+zABob0gg8EEkJJIyiCTRzE2jP4DyieRZjXfjJ7hE7HIGhxenuXpa19F9L/BicIsd9R5sq5eh57AZtejpFgzWMPFUZDQshwQQZcth6+XDwVXFSVKtpBrCF1JUk+lef0tjPuPWKZQtGPGyNv8XHvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800075; c=relaxed/simple;
	bh=x1HevHzr3na0O8/IiFxQw38tuXfKxwG/GQFHodSpajc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Be78PDWymYrlLKJFcybzlsrlmYmkjohXbk3ZjChwmhfvg+0bc0fdeMNG7ZOen6YZHO1+6J7HQnDhn3xtcsrZnYZ8DHs8a6QtpR67NYvFF2s6IfPVqzTQprpOMgosAzu+dCrLQnwdpL+kJR2GYenm1JZ2JDLr1fLpk84FGcdH26E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fiSap7py; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fiSap7py"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-455ddb90934so747975b6e.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800071; x=1768404871; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5SqoQ/RrRvmvQNe0j4L2pW17kZHbFwtV+OnjS+wxCg=;
        b=fiSap7pyYRSXn7b6xLE5aVcvkggVw+Q/gCtvNaXoFrFyH7WEm5I/lVErxbJFgYfMTF
         29zGP03EsCDgzLM1ktjXciYyMWTRbrwwX2Iu4zhEWj0NeVNmz8buTaaj/si0ch/aBqa1
         39YCDrN1gnK5Sp3BithYjDXr6o+3Xh0o3nvP9EZW4+tYgb/+4/5A4ygNXCbfIZbQkHBp
         dqs421NNwaa1S66I53pqKN2uXLGtQqs1ftlMw+u3+nXZ/CsJ9eI3USTu9VpYQozQS5eS
         7a9znKMvx9NT7dsytWTFChwaaegGdqOqap8OvItk6HFxPmezrerethrMtME53c9OACMQ
         /Riw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800071; x=1768404871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J5SqoQ/RrRvmvQNe0j4L2pW17kZHbFwtV+OnjS+wxCg=;
        b=nVGkSVO1h6knD5Z76TSNhgl8x9psI2sMipOVWpY30MmtNmQrZVouHXOYx4JcKfEXE/
         R04OSmFzya3y1aQMZwWoUXpNs2Zq55xo/NnFaeC7KGw+7j4/NvVnXa77iWLrxiD9+tfv
         bVF+QbKmTzjjgirFKRaEo54BF3o9JGWcRhGZsWqMiiEkSOLvtiesdt5HYKBnjdrvZ8dh
         gG91Ve1RkAqhQ089Ocalh8vIh2ZEunHFijUe7NiZEUGnseyQZAMjIOLhOiVF8tnLJ+z9
         x1OFp5A6nK02/PAaCQ243QQeuZt/jcQHIsbEmSuAlggcXI73hvEVe1u0e3YpKp+zkxyO
         VwQA==
X-Forwarded-Encrypted: i=1; AJvYcCWNXVbxfd3xBjPjWSiMoxynA0pzjoGUW6IFS+SgKSXy9kKcgRPdtMWqi/Ke5ZM/1YpZMNnG6Q4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywpzu9umoPGTsxVWC7kB4fcJWBKV1FqdYgD1iC+w6w1uMy1Py/t
	Y8bfovAWgnFth7o+g8E1bpQyRSQo8I5ZxN6dpoNfiyUK4X2LLZJtb47K
X-Gm-Gg: AY/fxX5I5Ukz8Irx4JZdvy4b6qsaHL9Sg+FBPz7L+Q2s7PBWB4QPdpXtaKLbUy/AtAS
	pxd1aAJ9ikjs5/Typ4/74yl9m7YhsDrbXAbnD1om40fYMjeOs4TOZpNOiRa4LYfv53EWOtTEkYA
	VGlTYM/IgzVCWqUZgxByNCdMQRdiFNTVlOp5+995SMFKV6qIhRAKWe1XYExXIe2plyi4sFbhSlJ
	2WvpvkJetVMfMP/+eZfPdr+jxAwX22xxNeVybEQk7anbYsn8gru62q4QOgX4Lsi3hkdTx9klQ0I
	ikYr7L3HgaZh5uq1c13lCBhLK2N/ula0hEuvyv7P3uqP/9ibpubJzgT/9k5knTnv5UfM5T17hxF
	yrS18DujfXno3py3/MfB7Z7+YwBlqsksNwVZD8D4XVLBSnBPewsZTKr2bg9bz4EY8shSfkpYZQk
	r2kx29WDhn1D325Wqn05U81pKzRJ5t8CCFm9FDB9QlTOt7
X-Google-Smtp-Source: AGHT+IER9TEcP0Gd0RbsM3hsxTOU129XPPmV1lfMnDIbnqKGjMILdd47hgMEMRu2pd2P+LaOJ3lJwA==
X-Received: by 2002:a05:6808:c1b2:b0:450:907:b523 with SMTP id 5614622812f47-45a6bd54369mr1160511b6e.6.1767800071059;
        Wed, 07 Jan 2026 07:34:31 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:30 -0800 (PST)
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
Subject: [PATCH V3 17/21] famfs_fuse: Plumb dax iomap and fuse read/write/mmap
Date: Wed,  7 Jan 2026 09:33:26 -0600
Message-ID: <20260107153332.64727-18-john@groves.net>
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

This commit fills in read/write/mmap handling for famfs files. The
dev_dax_iomap interface is used - just like xfs in fs-dax mode.

* Read/write are handled by famfs_fuse_[read|write]_iter() via
  dax_iomap_rw() to fsdev_dax.
* Mmap is handled by famfs_fuse_mmap()
* Faults are handled by famfs_filemap*fault(), using dax_iomap_fault()
  to fsdev_dax.
* File offset to dax offset resolution is handled via
  famfs_fuse_iomap_begin(), which uses famfs "fmaps" to resolve the
  the requested (file, offset) to an offset on a dax device (by way of
  famfs_fileofs_to_daxofs() and famfs_interleave_fileofs_to_daxofs())

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs.c  | 458 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c   |  18 +-
 fs/fuse/fuse_i.h |  18 ++
 3 files changed, 492 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index b5cd1b5c1d6c..c02b14789c6e 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -602,6 +602,464 @@ famfs_file_init_dax(
 	return rc;
 }
 
+/*********************************************************************
+ * iomap_operations
+ *
+ * This stuff uses the iomap (dax-related) helpers to resolve file offsets to
+ * offsets within a dax device.
+ */
+
+static ssize_t famfs_file_bad(struct inode *inode);
+
+static int
+famfs_interleave_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
+			 loff_t file_offset, off_t len, unsigned int flags)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct famfs_file_meta *meta = fi->famfs_meta;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	loff_t local_offset = file_offset;
+	int i;
+
+	/* This function is only for extent_type INTERLEAVED_EXTENT */
+	if (meta->fm_extent_type != INTERLEAVED_EXTENT) {
+		pr_err("%s: bad extent type\n", __func__);
+		goto err_out;
+	}
+
+	if (famfs_file_bad(inode))
+		goto err_out;
+
+	iomap->offset = file_offset;
+
+	for (i = 0; i < meta->fm_niext; i++) {
+		struct famfs_meta_interleaved_ext *fei = &meta->ie[i];
+		u64 chunk_size = fei->fie_chunk_size;
+		u64 nstrips = fei->fie_nstrips;
+		u64 ext_size = fei->fie_nbytes;
+
+		ext_size = min_t(u64, ext_size, meta->file_size);
+
+		if (ext_size == 0) {
+			pr_err("%s: ext_size=%lld file_size=%ld\n",
+			       __func__, fei->fie_nbytes, meta->file_size);
+			goto err_out;
+		}
+
+		/* Is the data is in this striped extent? */
+		if (local_offset < ext_size) {
+			u64 chunk_num       = local_offset / chunk_size;
+			u64 chunk_offset    = local_offset % chunk_size;
+			u64 stripe_num      = chunk_num / nstrips;
+			u64 strip_num       = chunk_num % nstrips;
+			u64 chunk_remainder = chunk_size - chunk_offset;
+			u64 strip_offset    = chunk_offset + (stripe_num * chunk_size);
+			u64 strip_dax_ofs = fei->ie_strips[strip_num].ext_offset;
+			u64 strip_devidx = fei->ie_strips[strip_num].dev_index;
+
+			if (strip_devidx >= fc->dax_devlist->nslots) {
+				pr_err("%s: strip_devidx %llu >= nslots %d\n",
+				       __func__, strip_devidx,
+				       fc->dax_devlist->nslots);
+				goto err_out;
+			}
+
+			if (!fc->dax_devlist->devlist[strip_devidx].valid) {
+				pr_err("%s: daxdev=%lld invalid\n", __func__,
+					strip_devidx);
+				goto err_out;
+			}
+
+			iomap->addr    = strip_dax_ofs + strip_offset;
+			iomap->offset  = file_offset;
+			iomap->length  = min_t(loff_t, len, chunk_remainder);
+
+			iomap->dax_dev = fc->dax_devlist->devlist[strip_devidx].devp;
+
+			iomap->type    = IOMAP_MAPPED;
+			iomap->flags   = flags;
+
+			return 0;
+		}
+		local_offset -= ext_size; /* offset is beyond this striped extent */
+	}
+
+ err_out:
+	pr_err("%s: err_out\n", __func__);
+
+	/* We fell out the end of the extent list.
+	 * Set iomap to zero length in this case, and return 0
+	 * This just means that the r/w is past EOF
+	 */
+	iomap->addr    = 0; /* there is no valid dax device offset */
+	iomap->offset  = file_offset; /* file offset */
+	iomap->length  = 0; /* this had better result in no access to dax mem */
+	iomap->dax_dev = NULL;
+	iomap->type    = IOMAP_MAPPED;
+	iomap->flags   = flags;
+
+	return 0;
+}
+
+/**
+ * famfs_fileofs_to_daxofs() - Resolve (file, offset, len) to (daxdev, offset, len)
+ *
+ * This function is called by famfs_fuse_iomap_begin() to resolve an offset in a
+ * file to an offset in a dax device. This is upcalled from dax from calls to
+ * both  * dax_iomap_fault() and dax_iomap_rw(). Dax finishes the job resolving
+ * a fault to a specific physical page (the fault case) or doing a memcpy
+ * variant (the rw case)
+ *
+ * Pages can be PTE (4k), PMD (2MiB) or (theoretically) PuD (1GiB)
+ * (these sizes are for X86; may vary on other cpu architectures
+ *
+ * @inode:  The file where the fault occurred
+ * @iomap:       To be filled in to indicate where to find the right memory,
+ *               relative  to a dax device.
+ * @file_offset: Within the file where the fault occurred (will be page boundary)
+ * @len:         The length of the faulted mapping (will be a page multiple)
+ *               (will be trimmed in *iomap if it's disjoint in the extent list)
+ * @flags:
+ *
+ * Return values: 0. (info is returned in a modified @iomap struct)
+ */
+static int
+famfs_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,
+			 loff_t file_offset, off_t len, unsigned int flags)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct famfs_file_meta *meta = fi->famfs_meta;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	loff_t local_offset = file_offset;
+	int i;
+
+	if (!fc->dax_devlist) {
+		pr_err("%s: null dax_devlist\n", __func__);
+		goto err_out;
+	}
+
+	if (famfs_file_bad(inode))
+		goto err_out;
+
+	if (meta->fm_extent_type == INTERLEAVED_EXTENT)
+		return famfs_interleave_fileofs_to_daxofs(inode, iomap,
+							  file_offset,
+							  len, flags);
+
+	iomap->offset = file_offset;
+
+	for (i = 0; i < meta->fm_nextents; i++) {
+		/* TODO: check devindex too */
+		loff_t dax_ext_offset = meta->se[i].ext_offset;
+		loff_t dax_ext_len    = meta->se[i].ext_len;
+		u64 daxdev_idx = meta->se[i].dev_index;
+
+
+		/* TODO: test that superblock and log offsets only happen
+		 * with superblock and log files. Requires instrumentaiton
+		 * from user space...
+		 */
+
+		/* local_offset is the offset minus the size of extents skipped
+		 * so far; If local_offset < dax_ext_len, the data of interest
+		 * starts in this extent
+		 */
+		if (local_offset < dax_ext_len) {
+			loff_t ext_len_remainder = dax_ext_len - local_offset;
+			struct famfs_daxdev *dd;
+
+			if (daxdev_idx >= fc->dax_devlist->nslots) {
+				pr_err("%s: daxdev_idx %llu >= nslots %d\n",
+				       __func__, daxdev_idx,
+				       fc->dax_devlist->nslots);
+				goto err_out;
+			}
+
+			dd = &fc->dax_devlist->devlist[daxdev_idx];
+
+			if (!dd->valid || dd->error) {
+				pr_err("%s: daxdev=%lld %s\n", __func__,
+				       daxdev_idx,
+				       dd->valid ? "error" : "invalid");
+				goto err_out;
+			}
+
+			/*
+			 * OK, we found the file metadata extent where this
+			 * data begins
+			 * @local_offset      - The offset within the current
+			 *                      extent
+			 * @ext_len_remainder - Remaining length of ext after
+			 *                      skipping local_offset
+			 * Outputs:
+			 * iomap->addr:   the offset within the dax device where
+			 *                the  data starts
+			 * iomap->offset: the file offset
+			 * iomap->length: the valid length resolved here
+			 */
+			iomap->addr    = dax_ext_offset + local_offset;
+			iomap->offset  = file_offset;
+			iomap->length  = min_t(loff_t, len, ext_len_remainder);
+
+			iomap->dax_dev = fc->dax_devlist->devlist[daxdev_idx].devp;
+
+			iomap->type    = IOMAP_MAPPED;
+			iomap->flags   = flags;
+			return 0;
+		}
+		local_offset -= dax_ext_len; /* Get ready for the next extent */
+	}
+
+ err_out:
+	pr_err("%s: err_out\n", __func__);
+
+	/* We fell out the end of the extent list.
+	 * Set iomap to zero length in this case, and return 0
+	 * This just means that the r/w is past EOF
+	 */
+	iomap->addr    = 0; /* there is no valid dax device offset */
+	iomap->offset  = file_offset; /* file offset */
+	iomap->length  = 0; /* this had better result in no access to dax mem */
+	iomap->dax_dev = NULL;
+	iomap->type    = IOMAP_MAPPED;
+	iomap->flags   = flags;
+
+	return 0;
+}
+
+/**
+ * famfs_fuse_iomap_begin() - Handler for iomap_begin upcall from dax
+ *
+ * This function is pretty simple because files are
+ * * never partially allocated
+ * * never have holes (never sparse)
+ * * never "allocate on write"
+ *
+ * @inode:  inode for the file being accessed
+ * @offset: offset within the file
+ * @length: Length being accessed at offset
+ * @flags:
+ * @iomap:  iomap struct to be filled in, resolving (offset, length) to
+ *          (daxdev, offset, len)
+ * @srcmap:
+ */
+static int
+famfs_fuse_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+		  unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct famfs_file_meta *meta = fi->famfs_meta;
+	size_t size;
+
+	size = i_size_read(inode);
+
+	WARN_ON(size != meta->file_size);
+
+	return famfs_fileofs_to_daxofs(inode, iomap, offset, length, flags);
+}
+
+/* Note: We never need a special set of write_iomap_ops because famfs never
+ * performs allocation on write.
+ */
+const struct iomap_ops famfs_iomap_ops = {
+	.iomap_begin		= famfs_fuse_iomap_begin,
+};
+
+/*********************************************************************
+ * vm_operations
+ */
+static vm_fault_t
+__famfs_fuse_filemap_fault(struct vm_fault *vmf, unsigned int pe_size,
+		      bool write_fault)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	vm_fault_t ret;
+	unsigned long pfn;
+
+	if (!IS_DAX(file_inode(vmf->vma->vm_file))) {
+		pr_err("%s: file not marked IS_DAX!!\n", __func__);
+		return VM_FAULT_SIGBUS;
+	}
+
+	if (write_fault) {
+		sb_start_pagefault(inode->i_sb);
+		file_update_time(vmf->vma->vm_file);
+	}
+
+	ret = dax_iomap_fault(vmf, pe_size, &pfn, NULL, &famfs_iomap_ops);
+	if (ret & VM_FAULT_NEEDDSYNC)
+		ret = dax_finish_sync_fault(vmf, pe_size, pfn);
+
+	if (write_fault)
+		sb_end_pagefault(inode->i_sb);
+
+	return ret;
+}
+
+static inline bool
+famfs_is_write_fault(struct vm_fault *vmf)
+{
+	return (vmf->flags & FAULT_FLAG_WRITE) &&
+	       (vmf->vma->vm_flags & VM_SHARED);
+}
+
+static vm_fault_t
+famfs_filemap_fault(struct vm_fault *vmf)
+{
+	return __famfs_fuse_filemap_fault(vmf, 0, famfs_is_write_fault(vmf));
+}
+
+static vm_fault_t
+famfs_filemap_huge_fault(struct vm_fault *vmf, unsigned int pe_size)
+{
+	return __famfs_fuse_filemap_fault(vmf, pe_size, famfs_is_write_fault(vmf));
+}
+
+static vm_fault_t
+famfs_filemap_page_mkwrite(struct vm_fault *vmf)
+{
+	return __famfs_fuse_filemap_fault(vmf, 0, true);
+}
+
+static vm_fault_t
+famfs_filemap_pfn_mkwrite(struct vm_fault *vmf)
+{
+	return __famfs_fuse_filemap_fault(vmf, 0, true);
+}
+
+static vm_fault_t
+famfs_filemap_map_pages(struct vm_fault	*vmf, pgoff_t start_pgoff,
+			pgoff_t	end_pgoff)
+{
+	return filemap_map_pages(vmf, start_pgoff, end_pgoff);
+}
+
+const struct vm_operations_struct famfs_file_vm_ops = {
+	.fault		= famfs_filemap_fault,
+	.huge_fault	= famfs_filemap_huge_fault,
+	.map_pages	= famfs_filemap_map_pages,
+	.page_mkwrite	= famfs_filemap_page_mkwrite,
+	.pfn_mkwrite	= famfs_filemap_pfn_mkwrite,
+};
+
+/*********************************************************************
+ * file_operations
+ */
+
+/**
+ * famfs_file_bad() - Check for files that aren't in a valid state
+ *
+ * @inode - inode
+ *
+ * Returns: 0=success
+ *          -errno=failure
+ */
+static ssize_t
+famfs_file_bad(struct inode *inode)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct famfs_file_meta *meta = fi->famfs_meta;
+	size_t i_size = i_size_read(inode);
+
+	if (!meta) {
+		pr_err("%s: un-initialized famfs file\n", __func__);
+		return -EIO;
+	}
+	if (meta->error) {
+		pr_debug("%s: previously detected metadata errors\n", __func__);
+		return -EIO;
+	}
+	if (i_size != meta->file_size) {
+		pr_warn("%s: i_size overwritten from %ld to %ld\n",
+		       __func__, meta->file_size, i_size);
+		meta->error = true;
+		return -ENXIO;
+	}
+	if (!IS_DAX(inode)) {
+		pr_debug("%s: inode %llx IS_DAX is false\n",
+			 __func__, (u64)inode);
+		return -ENXIO;
+	}
+	return 0;
+}
+
+static ssize_t
+famfs_fuse_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	size_t i_size = i_size_read(inode);
+	size_t count = iov_iter_count(ubuf);
+	size_t max_count;
+	ssize_t rc;
+
+	rc = famfs_file_bad(inode);
+	if (rc)
+		return rc;
+
+	/* Avoid unsigned underflow if position is past EOF */
+	if (iocb->ki_pos >= i_size)
+		max_count = 0;
+	else
+		max_count = i_size - iocb->ki_pos;
+
+	if (count > max_count)
+		iov_iter_truncate(ubuf, max_count);
+
+	if (!iov_iter_count(ubuf))
+		return 0;
+
+	return rc;
+}
+
+ssize_t
+famfs_fuse_read_iter(struct kiocb *iocb, struct iov_iter	*to)
+{
+	ssize_t rc;
+
+	rc = famfs_fuse_rw_prep(iocb, to);
+	if (rc)
+		return rc;
+
+	if (!iov_iter_count(to))
+		return 0;
+
+	rc = dax_iomap_rw(iocb, to, &famfs_iomap_ops);
+
+	file_accessed(iocb->ki_filp);
+	return rc;
+}
+
+ssize_t
+famfs_fuse_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	ssize_t rc;
+
+	rc = famfs_fuse_rw_prep(iocb, from);
+	if (rc)
+		return rc;
+
+	if (!iov_iter_count(from))
+		return 0;
+
+	return dax_iomap_rw(iocb, from, &famfs_iomap_ops);
+}
+
+int
+famfs_fuse_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode = file_inode(file);
+	ssize_t rc;
+
+	rc = famfs_file_bad(inode);
+	if (rc)
+		return (int)rc;
+
+	file_accessed(file);
+	vma->vm_ops = &famfs_file_vm_ops;
+	vm_flags_set(vma, VM_HUGEPAGE);
+	return 0;
+}
+
 #define FMAP_BUFSIZE PAGE_SIZE
 
 int
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 1f64bf68b5ee..45a09a7f0012 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1831,6 +1831,8 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_read_iter(iocb, to);
+	if (fuse_file_famfs(fi))
+		return famfs_fuse_read_iter(iocb, to);
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
 	if (ff->open_flags & FOPEN_DIRECT_IO)
@@ -1853,6 +1855,8 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_write_iter(iocb, from);
+	if (fuse_file_famfs(fi))
+		return famfs_fuse_write_iter(iocb, from);
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
 	if (ff->open_flags & FOPEN_DIRECT_IO)
@@ -1868,9 +1872,13 @@ static ssize_t fuse_splice_read(struct file *in, loff_t *ppos,
 				unsigned int flags)
 {
 	struct fuse_file *ff = in->private_data;
+	struct inode *inode = file_inode(in);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
-	if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
+	if (fuse_file_famfs(fi))
+		return -EIO; /* famfs does not use the page cache... */
+	else if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
 		return fuse_passthrough_splice_read(in, ppos, pipe, len, flags);
 	else
 		return filemap_splice_read(in, ppos, pipe, len, flags);
@@ -1880,9 +1888,13 @@ static ssize_t fuse_splice_write(struct pipe_inode_info *pipe, struct file *out,
 				 loff_t *ppos, size_t len, unsigned int flags)
 {
 	struct fuse_file *ff = out->private_data;
+	struct inode *inode = file_inode(out);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
-	if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
+	if (fuse_file_famfs(fi))
+		return -EIO; /* famfs does not use the page cache... */
+	else if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
 		return fuse_passthrough_splice_write(pipe, out, ppos, len, flags);
 	else
 		return iter_file_splice_write(pipe, out, ppos, len, flags);
@@ -2390,6 +2402,8 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	/* DAX mmap is superior to direct_io mmap */
 	if (FUSE_IS_VIRTIO_DAX(fi))
 		return fuse_dax_mmap(file, vma);
+	if (fuse_file_famfs(fi))
+		return famfs_fuse_mmap(file, vma);
 
 	/*
 	 * If inode is in passthrough io mode, because it has some file open
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d308b74c83ec..5e52c3ba6e94 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1664,6 +1664,9 @@ extern void fuse_sysctl_unregister(void);
 int famfs_file_init_dax(struct fuse_mount *fm,
 			     struct inode *inode, void *fmap_buf,
 			     size_t fmap_size);
+ssize_t famfs_fuse_write_iter(struct kiocb *iocb, struct iov_iter *from);
+ssize_t famfs_fuse_read_iter(struct kiocb *iocb, struct iov_iter	*to);
+int famfs_fuse_mmap(struct file *file, struct vm_area_struct *vma);
 void __famfs_meta_free(void *map);
 void famfs_teardown(struct fuse_conn *fc);
 #else
@@ -1673,6 +1676,21 @@ static inline void famfs_teardown(struct fuse_conn *fc)
 	kfree(fc->shadow);
 #endif
 }
+static inline ssize_t famfs_fuse_write_iter(struct kiocb *iocb,
+					    struct iov_iter *to)
+{
+	return -ENODEV;
+}
+static inline ssize_t famfs_fuse_read_iter(struct kiocb *iocb,
+					   struct iov_iter *to)
+{
+	return -ENODEV;
+}
+static inline int famfs_fuse_mmap(struct file *file,
+				  struct vm_area_struct *vma)
+{
+	return -ENODEV;
+}
 #endif
 
 static inline void famfs_meta_init(struct fuse_inode *fi)
-- 
2.49.0

