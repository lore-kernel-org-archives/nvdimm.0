Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B3B376BE9
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426797; cv=none; b=mmffXx7VZHt+AcCk+WspU3/Ku2rdM7SVZbqWv032Ng/DSJS6PfnA4hSL1FM5Z4/cr+NBSF237MC/vR8KhLML7JuJBstfAZK7YAH4HvfxPiT2J0YkozEkvEMW+8QuJS7x3udZusdVsHXxEwHnsE6WY2nruqbebveNy2N7AFwi/mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426797; c=relaxed/simple;
	bh=i2MbScQp53wnHab/LOYIZRdE11EJmi7T0QaHDjYoSIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejcOCb39xE1WgsKd9lukxbKaqW56LPj4RMUnrOQ2xLRZXUMoKl3rESQr5nGeR8aqZYJ3GKUXmMpR141cnB3YdiibBxvYFaeCDEExf86BkKpa9tbi69jmfF8fV8A266SBUHJSWtPIGCzRIQSJI1L7aqgpl8sbrxSODeAQNJUh/vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOid9gOZ; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOid9gOZ"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-3e12fd71984so180874fac.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426760; x=1769031560; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xzA3++0AwHlPnd5jxD7A0iv1Y+cF9KH3CdhD6HJs30=;
        b=kOid9gOZ9gnXM1/6a/s356LuA1D83uJJboHl2yXt6fbDl6QJlseljdTkykIK53Yrhz
         wWUxFL1K7hBuSiMSa3Qx9o6RFGA2OX+a/SH1xAk4oMHdBSJXwYH9Hi8W8/bPM+NQz82V
         vT5EYiZ3AEKq+2ApUfS/j0+Gy6dA0eq0zkfJQWN3PqLGaGmLKL3+lrFxomaY8CZc/2ep
         vaOC/1ZtIVhcqB5Ar6yE/SNLX922Lvhp3O25eT7HN2FdVTtj9ryTKfNAT3HO9QwA8Lia
         VO+SUmmPD2w4dQIQULU9mEiYvtTm0maa3bSphTRkZHNVzR8sEypNPp4t7Dv2ptBzKlLc
         kx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426760; x=1769031560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0xzA3++0AwHlPnd5jxD7A0iv1Y+cF9KH3CdhD6HJs30=;
        b=PkG2u11Tq+f70PZjXlVd96DVT4fziKxKbOrAO6XEEjtyS02nK3emBxnDk0Lp99Xnce
         fYMHmX+F2Gz0EqWTM7qFrwLGfGILIUURndJO18vlES0QW3uggrbTScs+Z7dbbFk6gtFU
         HqrdSExbJ7t9L4x+fq9kFpDngsvqdeUw3Jba35knsAuNclN71X8/vIMLzW5GlacCr2Ec
         y2OUe/YaaIuojDsS+OGKZpvoMoScRqhs0LVykh6lhrG4e1tSGBDRvcEK7+U8zrIZOIix
         s4kSYPcjN1f9zSGKxYDOe/beBNEDOFhgVvi1+HGauDIuxLp6kEqqdViOPE14YCuYMzsh
         rNpw==
X-Forwarded-Encrypted: i=1; AJvYcCUOy+FyD/XdjERvb+tecM/6tmlvkqDnzA+LDw29XSHNmhzptYxJ0QeYD1bJRE3Y8D6GVkkFiDc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwG4Vizn94fgpioTRjzHXkuYczsJ06QQbgsj2+OyTcqyQnWC1U2
	1Yg0h7YhgtcILcP2GgM/a0R404shU2olb4ia6pAR2iVzU+2K6MxEuWT3
X-Gm-Gg: AY/fxX5R37g0B+D+oEwp+9KMBsUe+T0iv6XZgODYrayi5rctcqQ3x5GUlPJmuq7Hxj1
	+f1ltBvsrpmmznaclO38eoEO63zmb+u8ZR1DtoXPFZaHF69Oo47095jcC/NX+UJbgCiKuiCGlni
	1cPCvq68oPZzabp8n+Wg8pDnrvd03CMdcCzY65Q7N5Fqwvd610X07r53NTsf22SBfebulep9Paa
	V17g0gBvse7THeDNTnS8fqChFFAhm28k/LL8SfQ8UgvEoQRIgYaPREnA7MztlrGnWnVN8BlmM3E
	aZbrloMiKA8TFtb/1ykTRuMm6FPzwzHpTs+WmqfrexEok8xc5WO4TMAUWti4NjKhxSyVGkvEX2o
	mbEVe+pXK5/qXEkQF6+98Au9Fpt0bKgDj/FMYf2an6dIum1ujnAh8qQEFDV2oODt66ozVwMp3PM
	6auXVWEPTbFcJpXAiMoWkeGwWhoMhbKBDsi4aQ9BGJSQRC
X-Received: by 2002:a05:6871:2995:b0:404:526:8041 with SMTP id 586e51a60fabf-4040ba841ecmr2788166fac.20.1768426759946;
        Wed, 14 Jan 2026 13:39:19 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4041fcf2144sm1325107fac.1.2026.01.14.13.39.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:39:19 -0800 (PST)
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
Subject: [PATCH V4 13/19] famfs_fuse: Create files with famfs fmaps
Date: Wed, 14 Jan 2026 15:32:00 -0600
Message-ID: <20260114213209.29453-14-john@groves.net>
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

On completion of GET_FMAP message/response, setup the full famfs
metadata such that it's possible to handle read/write/mmap directly to
dax. Note that the devdax_iomap plumbing is not in yet...

* Add famfs_kfmap.h: in-memory structures for resolving famfs file maps
  (fmaps) to dax.
* famfs.c: allocate, initialize and free fmaps
* inode.c: only allow famfs mode if the fuse server has CAP_SYS_RAWIO
* Update MAINTAINERS for the new file.

Signed-off-by: John Groves <john@groves.net>
---
 MAINTAINERS               |   1 +
 fs/fuse/famfs.c           | 336 +++++++++++++++++++++++++++++++++++++-
 fs/fuse/famfs_kfmap.h     |  67 ++++++++
 fs/fuse/fuse_i.h          |   8 +-
 fs/fuse/inode.c           |  19 ++-
 include/uapi/linux/fuse.h |  56 +++++++
 6 files changed, 477 insertions(+), 10 deletions(-)
 create mode 100644 fs/fuse/famfs_kfmap.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e3d0aa5eb361..6f8a7c813c2f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10386,6 +10386,7 @@ L:	linux-cxl@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 F:	fs/fuse/famfs.c
+F:	fs/fuse/famfs_kfmap.h
 
 FUTEX SUBSYSTEM
 M:	Thomas Gleixner <tglx@kernel.org>
diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index 615819cc922d..e3b5f204de82 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -18,9 +18,336 @@
 #include <linux/namei.h>
 #include <linux/string.h>
 
+#include "famfs_kfmap.h"
 #include "fuse_i.h"
 
 
+/***************************************************************************/
+
+void __famfs_meta_free(void *famfs_meta)
+{
+	struct famfs_file_meta *fmap = famfs_meta;
+
+	if (!fmap)
+		return;
+
+	switch (fmap->fm_extent_type) {
+	case SIMPLE_DAX_EXTENT:
+		kfree(fmap->se);
+		break;
+	case INTERLEAVED_EXTENT:
+		if (fmap->ie)
+			kfree(fmap->ie->ie_strips);
+
+		kfree(fmap->ie);
+		break;
+	default:
+		pr_err("%s: invalid fmap type\n", __func__);
+		break;
+	}
+
+	kfree(fmap);
+}
+DEFINE_FREE(__famfs_meta_free, void *, if (_T) __famfs_meta_free(_T))
+
+static int
+famfs_check_ext_alignment(struct famfs_meta_simple_ext *se)
+{
+	int errs = 0;
+
+	if (se->dev_index != 0)
+		errs++;
+
+	/* TODO: pass in alignment so we can support the other page sizes */
+	if (!IS_ALIGNED(se->ext_offset, PMD_SIZE))
+		errs++;
+
+	if (!IS_ALIGNED(se->ext_len, PMD_SIZE))
+		errs++;
+
+	return errs;
+}
+
+/**
+ * famfs_fuse_meta_alloc() - Allocate famfs file metadata
+ * @fmap_buf:  fmap buffer from fuse server
+ * @fmap_buf_size: size of fmap buffer
+ * @metap:         pointer where 'struct famfs_file_meta' is returned
+ *
+ * Returns: 0=success
+ *          -errno=failure
+ */
+static int
+famfs_fuse_meta_alloc(
+	void *fmap_buf,
+	size_t fmap_buf_size,
+	struct famfs_file_meta **metap)
+{
+	struct famfs_file_meta *meta __free(__famfs_meta_free) = NULL;
+	struct fuse_famfs_fmap_header *fmh;
+	size_t extent_total = 0;
+	size_t next_offset = 0;
+	int errs = 0;
+	int i, j;
+
+	fmh = fmap_buf;
+
+	/* Move past fmh in fmap_buf */
+	next_offset += sizeof(*fmh);
+	if (next_offset > fmap_buf_size) {
+		pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
+		       __func__, __LINE__, next_offset, fmap_buf_size);
+		return -EINVAL;
+	}
+
+	if (fmh->nextents < 1) {
+		pr_err("%s: nextents %d < 1\n", __func__, fmh->nextents);
+		return -EINVAL;
+	}
+
+	if (fmh->nextents > FUSE_FAMFS_MAX_EXTENTS) {
+		pr_err("%s: nextents %d > max (%d) 1\n",
+		       __func__, fmh->nextents, FUSE_FAMFS_MAX_EXTENTS);
+		return -E2BIG;
+	}
+
+	meta = kzalloc(sizeof(*meta), GFP_KERNEL);
+	if (!meta)
+		return -ENOMEM;
+
+	meta->error = false;
+	meta->file_type = fmh->file_type;
+	meta->file_size = fmh->file_size;
+	meta->fm_extent_type = fmh->ext_type;
+
+	switch (fmh->ext_type) {
+	case FUSE_FAMFS_EXT_SIMPLE: {
+		struct fuse_famfs_simple_ext *se_in;
+
+		se_in = fmap_buf + next_offset;
+
+		/* Move past simple extents */
+		next_offset += fmh->nextents * sizeof(*se_in);
+		if (next_offset > fmap_buf_size) {
+			pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
+			       __func__, __LINE__, next_offset, fmap_buf_size);
+			return -EINVAL;
+		}
+
+		meta->fm_nextents = fmh->nextents;
+
+		meta->se = kcalloc(meta->fm_nextents, sizeof(*(meta->se)),
+				   GFP_KERNEL);
+		if (!meta->se)
+			return -ENOMEM;
+
+		if ((meta->fm_nextents > FUSE_FAMFS_MAX_EXTENTS) ||
+		    (meta->fm_nextents < 1))
+			return -EINVAL;
+
+		for (i = 0; i < fmh->nextents; i++) {
+			meta->se[i].dev_index  = se_in[i].se_devindex;
+			meta->se[i].ext_offset = se_in[i].se_offset;
+			meta->se[i].ext_len    = se_in[i].se_len;
+
+			/* Record bitmap of referenced daxdev indices */
+			meta->dev_bitmap |= (1 << meta->se[i].dev_index);
+
+			errs += famfs_check_ext_alignment(&meta->se[i]);
+
+			extent_total += meta->se[i].ext_len;
+		}
+		break;
+	}
+
+	case FUSE_FAMFS_EXT_INTERLEAVE: {
+		s64 size_remainder = meta->file_size;
+		struct fuse_famfs_iext *ie_in;
+		int niext = fmh->nextents;
+
+		meta->fm_niext = niext;
+
+		/* Allocate interleaved extent */
+		meta->ie = kcalloc(niext, sizeof(*(meta->ie)), GFP_KERNEL);
+		if (!meta->ie)
+			return -ENOMEM;
+
+		/*
+		 * Each interleaved extent has a simple extent list of strips.
+		 * Outer loop is over separate interleaved extents
+		 */
+		for (i = 0; i < niext; i++) {
+			u64 nstrips;
+			struct fuse_famfs_simple_ext *sie_in;
+
+			/* ie_in = one interleaved extent in fmap_buf */
+			ie_in = fmap_buf + next_offset;
+
+			/* Move past one interleaved extent header in fmap_buf */
+			next_offset += sizeof(*ie_in);
+			if (next_offset > fmap_buf_size) {
+				pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
+				       __func__, __LINE__, next_offset,
+				       fmap_buf_size);
+				return -EINVAL;
+			}
+
+			nstrips = ie_in->ie_nstrips;
+			meta->ie[i].fie_chunk_size = ie_in->ie_chunk_size;
+			meta->ie[i].fie_nstrips    = ie_in->ie_nstrips;
+			meta->ie[i].fie_nbytes     = ie_in->ie_nbytes;
+
+			if (!meta->ie[i].fie_nbytes) {
+				pr_err("%s: zero-length interleave!\n",
+				       __func__);
+				return -EINVAL;
+			}
+
+			/* sie_in = the strip extents in fmap_buf */
+			sie_in = fmap_buf + next_offset;
+
+			/* Move past strip extents in fmap_buf */
+			next_offset += nstrips * sizeof(*sie_in);
+			if (next_offset > fmap_buf_size) {
+				pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",
+				       __func__, __LINE__, next_offset,
+				       fmap_buf_size);
+				return -EINVAL;
+			}
+
+			if ((nstrips > FUSE_FAMFS_MAX_STRIPS) || (nstrips < 1)) {
+				pr_err("%s: invalid nstrips=%lld (max=%d)\n",
+				       __func__, nstrips,
+				       FUSE_FAMFS_MAX_STRIPS);
+				errs++;
+			}
+
+			/* Allocate strip extent array */
+			meta->ie[i].ie_strips =
+				kcalloc(ie_in->ie_nstrips,
+					sizeof(meta->ie[i].ie_strips[0]),
+					GFP_KERNEL);
+			if (!meta->ie[i].ie_strips)
+				return -ENOMEM;
+
+			/* Inner loop is over strips */
+			for (j = 0; j < nstrips; j++) {
+				struct famfs_meta_simple_ext *strips_out;
+				u64 devindex = sie_in[j].se_devindex;
+				u64 offset   = sie_in[j].se_offset;
+				u64 len      = sie_in[j].se_len;
+
+				strips_out = meta->ie[i].ie_strips;
+				strips_out[j].dev_index  = devindex;
+				strips_out[j].ext_offset = offset;
+				strips_out[j].ext_len    = len;
+
+				/* Record bitmap of referenced daxdev indices */
+				meta->dev_bitmap |= (1 << devindex);
+
+				extent_total += len;
+				errs += famfs_check_ext_alignment(&strips_out[j]);
+				size_remainder -= len;
+			}
+		}
+
+		if (size_remainder > 0) {
+			/* Sum of interleaved extent sizes is less than file size! */
+			pr_err("%s: size_remainder %lld (0x%llx)\n",
+			       __func__, size_remainder, size_remainder);
+			return -EINVAL;
+		}
+		break;
+	}
+
+	default:
+		pr_err("%s: invalid ext_type %d\n", __func__, fmh->ext_type);
+		return -EINVAL;
+	}
+
+	if (errs > 0) {
+		pr_err("%s: %d alignment errors found\n", __func__, errs);
+		return -EINVAL;
+	}
+
+	/* More sanity checks */
+	if (extent_total < meta->file_size) {
+		pr_err("%s: file size %ld larger than map size %ld\n",
+		       __func__, meta->file_size, extent_total);
+		return -EINVAL;
+	}
+
+	if (cmpxchg(metap, NULL, meta) != NULL) {
+		pr_debug("%s: fmap race detected\n", __func__);
+		return 0; /* fmap already installed */
+	}
+	meta = NULL; /* disarm __free() - the meta struct was consumed */
+
+	return 0;
+}
+
+/**
+ * famfs_file_init_dax() - init famfs dax file metadata
+ *
+ * @fm:        fuse_mount
+ * @inode:     the inode
+ * @fmap_buf:  fmap response message
+ * @fmap_size: Size of the fmap message
+ *
+ * Initialize famfs metadata for a file, based on the contents of the GET_FMAP
+ * response
+ *
+ * Return: 0=success
+ *          -errno=failure
+ */
+int
+famfs_file_init_dax(
+	struct fuse_mount *fm,
+	struct inode *inode,
+	void *fmap_buf,
+	size_t fmap_size)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct famfs_file_meta *meta = NULL;
+	int rc;
+
+	if (fi->famfs_meta) {
+		pr_notice("%s: i_no=%ld fmap_size=%ld ALREADY INITIALIZED\n",
+			  __func__,
+			  inode->i_ino, fmap_size);
+		return 0;
+	}
+
+	rc = famfs_fuse_meta_alloc(fmap_buf, fmap_size, &meta);
+	if (rc)
+		goto errout;
+
+	/* Publish the famfs metadata on fi->famfs_meta */
+	inode_lock(inode);
+	if (fi->famfs_meta) {
+		rc = -EEXIST; /* file already has famfs metadata */
+	} else {
+		if (famfs_meta_set(fi, meta) != NULL) {
+			pr_debug("%s: file already had metadata\n", __func__);
+			__famfs_meta_free(meta);
+			/* rc is 0 - the file is valid */
+			goto unlock_out;
+		}
+		i_size_write(inode, meta->file_size);
+		inode->i_flags |= S_DAX;
+	}
+ unlock_out:
+	inode_unlock(inode);
+	return 0;
+
+errout:
+	inode_unlock(inode);
+	if (rc)
+		__famfs_meta_free(meta);
+
+	return rc;
+}
+
 #define FMAP_BUFSIZE PAGE_SIZE
 
 int
@@ -64,11 +391,8 @@ fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)
 	}
 	fmap_size = rc;
 
-	/* We retrieved the "fmap" (the file's map to memory), but
-	 * we haven't used it yet. A call to famfs_file_init_dax() will be added
-	 * here in a subsequent patch, when we add the ability to attach
-	 * fmaps to files.
-	 */
+	/* Convert fmap into in-memory format and hang from inode */
+	rc = famfs_file_init_dax(fm, inode, fmap_buf, fmap_size);
 
-	return 0;
+	return rc;
 }
diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
new file mode 100644
index 000000000000..18ab22bcc5a1
--- /dev/null
+++ b/fs/fuse/famfs_kfmap.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * famfs - dax file system for shared fabric-attached memory
+ *
+ * Copyright 2023-2026 Micron Technology, Inc.
+ */
+#ifndef FAMFS_KFMAP_H
+#define FAMFS_KFMAP_H
+
+/*
+ * The structures below are the in-memory metadata format for famfs files.
+ * Metadata retrieved via the GET_FMAP response is converted to this format
+ * for use in resolving file mapping faults.
+ *
+ * The GET_FMAP response contains the same information, but in a more
+ * message-and-versioning-friendly format. Those structs can be found in the
+ * famfs section of include/uapi/linux/fuse.h (aka fuse_kernel.h in libfuse)
+ */
+
+enum famfs_file_type {
+	FAMFS_REG,
+	FAMFS_SUPERBLOCK,
+	FAMFS_LOG,
+};
+
+/* We anticipate the possibility of supporting additional types of extents */
+enum famfs_extent_type {
+	SIMPLE_DAX_EXTENT,
+	INTERLEAVED_EXTENT,
+	INVALID_EXTENT_TYPE,
+};
+
+struct famfs_meta_simple_ext {
+	u64 dev_index;
+	u64 ext_offset;
+	u64 ext_len;
+};
+
+struct famfs_meta_interleaved_ext {
+	u64 fie_nstrips;
+	u64 fie_chunk_size;
+	u64 fie_nbytes;
+	struct famfs_meta_simple_ext *ie_strips;
+};
+
+/*
+ * Each famfs dax file has this hanging from its fuse_inode->famfs_meta
+ */
+struct famfs_file_meta {
+	bool                   error;
+	enum famfs_file_type   file_type;
+	size_t                 file_size;
+	enum famfs_extent_type fm_extent_type;
+	u64 dev_bitmap; /* bitmap of referenced daxdevs by index */
+	union {
+		struct {
+			size_t         fm_nextents;
+			struct famfs_meta_simple_ext  *se;
+		};
+		struct {
+			size_t         fm_niext;
+			struct famfs_meta_interleaved_ext *ie;
+		};
+	};
+};
+
+#endif /* FAMFS_KFMAP_H */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index b66b5ca0bc11..dbfec5b9c6e1 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1642,6 +1642,9 @@ extern void fuse_sysctl_unregister(void);
 /* famfs.c */
 
 #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
+int famfs_file_init_dax(struct fuse_mount *fm,
+			struct inode *inode, void *fmap_buf,
+			size_t fmap_size);
 void __famfs_meta_free(void *map);
 
 /* Set fi->famfs_meta = NULL regardless of prior value */
@@ -1659,7 +1662,10 @@ static inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,
 
 static inline void famfs_meta_free(struct fuse_inode *fi)
 {
-	famfs_meta_set(fi, NULL);
+	if (fi->famfs_meta != NULL) {
+		__famfs_meta_free(fi->famfs_meta);
+		famfs_meta_set(fi, NULL);
+	}
 }
 
 static inline int fuse_file_famfs(struct fuse_inode *fi)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f2d742d723dc..b9933d0fbb9f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1464,8 +1464,21 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 				timeout = arg->request_timeout;
 
 			if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
-			    flags & FUSE_DAX_FMAP)
-				fc->famfs_iomap = 1;
+			    flags & FUSE_DAX_FMAP) {
+				/* famfs_iomap is only allowed if the fuse
+				 * server has CAP_SYS_RAWIO. This was checked
+				 * in fuse_send_init, and FUSE_DAX_IOMAP was
+				 * set in in_flags if so. Only allow enablement
+				 * if we find it there. This function is
+				 * normally not running in fuse server context,
+				 * so we can't do the capability check here...
+				 */
+				u64 in_flags = ((u64)ia->in.flags2 << 32)
+						| ia->in.flags;
+
+				if (in_flags & FUSE_DAX_FMAP)
+					fc->famfs_iomap = 1;
+			}
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1527,7 +1540,7 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount *fm)
 		flags |= FUSE_SUBMOUNTS;
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
-	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
+	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) && capable(CAP_SYS_RAWIO))
 		flags |= FUSE_DAX_FMAP;
 
 	/*
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 9eff9083d3b5..cf678bebbfe0 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -243,6 +243,13 @@
  *
  *  7.46
  *  - Add FUSE_DAX_FMAP capability - ability to handle in-kernel fsdax maps
+ *  - Add the following structures for the GET_FMAP message reply components:
+ *    - struct fuse_famfs_simple_ext
+ *    - struct fuse_famfs_iext
+ *    - struct fuse_famfs_fmap_header
+ *  - Add the following enumerated types
+ *    - enum fuse_famfs_file_type
+ *    - enum famfs_ext_type
  */
 
 #ifndef _LINUX_FUSE_H
@@ -1318,6 +1325,55 @@ struct fuse_uring_cmd_req {
 
 /* Famfs fmap message components */
 
+#define FAMFS_FMAP_VERSION 1
+
 #define FAMFS_FMAP_MAX 32768 /* Largest supported fmap message */
+#define FUSE_FAMFS_MAX_EXTENTS 32
+#define FUSE_FAMFS_MAX_STRIPS 32
+
+enum fuse_famfs_file_type {
+	FUSE_FAMFS_FILE_REG,
+	FUSE_FAMFS_FILE_SUPERBLOCK,
+	FUSE_FAMFS_FILE_LOG,
+};
+
+enum famfs_ext_type {
+	FUSE_FAMFS_EXT_SIMPLE = 0,
+	FUSE_FAMFS_EXT_INTERLEAVE = 1,
+};
+
+struct fuse_famfs_simple_ext {
+	uint32_t se_devindex;
+	uint32_t reserved;
+	uint64_t se_offset;
+	uint64_t se_len;
+};
+
+struct fuse_famfs_iext { /* Interleaved extent */
+	uint32_t ie_nstrips;
+	uint32_t ie_chunk_size;
+	uint64_t ie_nbytes; /* Total bytes for this interleaved_ext;
+			     * sum of strips may be more
+			     */
+	uint64_t reserved;
+};
+
+struct fuse_famfs_fmap_header {
+	uint8_t file_type; /* enum famfs_file_type */
+	uint8_t reserved;
+	uint16_t fmap_version;
+	uint32_t ext_type; /* enum famfs_log_ext_type */
+	uint32_t nextents;
+	uint32_t reserved0;
+	uint64_t file_size;
+	uint64_t reserved1;
+};
+
+static inline int32_t fmap_msg_min_size(void)
+{
+	/* Smallest fmap message is a header plus one simple extent */
+	return (sizeof(struct fuse_famfs_fmap_header)
+		+ sizeof(struct fuse_famfs_simple_ext));
+}
 
 #endif /* _LINUX_FUSE_H */
-- 
2.52.0

