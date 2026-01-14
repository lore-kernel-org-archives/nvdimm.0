Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F2E36D4F8
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426684; cv=none; b=Heo8nLkX2B+X8PR2ijsm/m8aHc5AKTzorSlCpl4FYMwgOVgp12wsNhQrTX7PIBu4/uXJi9789kO1iUmlnp3nsJtGmToYbv6v7V6ob5fLxcSwu4La68yxdqcbvhtCxCi0BpNf2N9znu7g9mt512xvqGAZeUKCMSFn+by9b1y87Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426684; c=relaxed/simple;
	bh=R7GTFFfXsW/hexMTH2rCgun0nMW8P9e1Nnjtsj10A/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyHNAa3kBkjxcouVu+m0wyRvjvh+yehQoktoAGfV4uxjW5h/ykHnb24ocPN3yjuEOFsN0ONbV2ZmqZhsZWmWZkqwNgJrrPa1ZOWISSgmogykDxlOYYCUS+lBvO18GyYPG3tqSEk7LcSaLyAT9K+mnr5hV+6OjOXDv+HcgOFmL6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUH5QMpO; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUH5QMpO"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfd57f0bf7so98218a34.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426661; x=1769031461; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s0It4v+QKYzMVVAEFprn518ODvuGudSilDEyQY60PAU=;
        b=hUH5QMpOkwHWqFtS4qK8uHVNgHsOKORekr4JUDIGYIB8b52n+Ar7EJmR8+4N1Ot+B2
         XAOaR8dCps29WIfHz3wWAwXvdoFHxitSGlp550oVDx9yUZat7ILA+NGJTSLT7051ZgE9
         5jNZLp2amBaCXYqdY3wXHk5+9/9Hft7Hs7HpqRkI5aYORpWbDOKvJ/QeVMNAwNwrl9ma
         BV+G4vgMX59d1Q9GgXv7wAZXBvU+yO0g/UAeKG9VErAMIEbBwCB6WoqtTZA/am0uDitm
         jPOVGMP2zqR2M5613oCb3zCDgD4yhz02fekh8X6NWGxecCrdGhHscvIBxRlv78dlseI0
         kviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426661; x=1769031461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0It4v+QKYzMVVAEFprn518ODvuGudSilDEyQY60PAU=;
        b=K6/AAuqtjvpE9QiOnT5YNWo91hsLxUXxzdPp/yZ5u351sYLX4yBxwPy+ZPiJwm8Nmk
         RCP1Pl1yEsfPg/P/v4W/GPNYmJ0F9aUUqdSWskBkozkEKAlSAfm8iVsieBVR9EN0R9rw
         iDfYhfG/UQCcdYm537XoJlmRpQfdXEPvLUS3VgHYQGuO00OcUt0lUtnUjmtX9LaqHzgV
         PhwPEaZu40BBhonEjlNZVnXTmuqrb7iUtyH3uCXNpdBZ+WAFp+GrE7oT3ApywudpUJ0k
         aq8G4rhTNLCXtHQIFPTg+rryPVFtXr5/HQ+Jt36eQQvdIw9HY31hYZg6D9dXHvw2bbjF
         8MPA==
X-Forwarded-Encrypted: i=1; AJvYcCXLgq5txw5lF6lPwlrqlBkLpLcuwDiD1hC64deb29ixUhbMK6qpOqqeVTR9MZS2Y9afDxTPoms=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhNvXvd6el6DZMDK3KE8tanAYdC0BbQ2YuFSDYMiKa3ZzbbNLl
	i4/IA6eRR0enph3yq7K7SMRXo5qwvJEJNKdZb9UC1Diqmkf6o7keG6LX
X-Gm-Gg: AY/fxX6N6Yqje+1fYH4Y2StuoKWCJU1u8MBQzKl1nNCPQfJ7xW3Z6cLvtBoSiHU2XuE
	qqB3skw4rmXkl11NebjIWdklRGZD+sI/8rd9/Qal1e2gBaUZTzMQsOWg8QKqRnCRpeXCTOE8HV4
	HC4yMNrvEMXZFXOM1SuL7qbAwvu+erJH9sy8uk5oaijAfhXTcPCfcKtN/AngaVc1TBuRl5+bDe3
	h8NLFRMdjVTjX0zMkOKP9k8yOGeHeXT+ZrfcyZXlNVoDdYCSbzMMGaFO9laSCZbldeomEkfadgV
	SHH4GYhFwd/MduvBwpt8/DP46N2ZLCxibYYLQ2cUeR3Ne25boI2oqs1TPO23d4cMDValO9ezI/n
	PThA/LYgWIN+A+k67C7WpdDF+ctG6OIH57GE1kF33hnskcq8lYAzxhw/16U5rs8slrdqaLf0KHf
	HCMhXwkUfkocmRZFqsZR+okyjNs1sofcb1QT8kMQ35LWUw
X-Received: by 2002:a05:6830:8118:b0:7c7:61e0:a4ee with SMTP id 46e09a7af769-7cfc8aa04cfmr2494300a34.11.1768426661010;
        Wed, 14 Jan 2026 13:37:41 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478d9f54sm19757067a34.23.2026.01.14.13.37.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:37:40 -0800 (PST)
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
Subject: [PATCH V4 10/19] famfs_fuse: Update macro s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
Date: Wed, 14 Jan 2026 15:31:57 -0600
Message-ID: <20260114213209.29453-11-john@groves.net>
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

Virtio_fs now needs to determine if an inode is DAX && not famfs.
This relaces the FUSE_IS_DAX() macro with FUSE_IS_VIRTIO_DAX(),
in preparation for famfs in later commits. The dummy
fuse_file_famfs() macro will be replaced with a working
function.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/dir.c    |  2 +-
 fs/fuse/file.c   | 13 ++++++++-----
 fs/fuse/fuse_i.h |  9 ++++++++-
 fs/fuse/inode.c  |  4 ++--
 fs/fuse/iomode.c |  2 +-
 5 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 4b6b3d2758ff..1400c9d733ba 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -2153,7 +2153,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		is_truncate = true;
 	}
 
-	if (FUSE_IS_DAX(inode) && is_truncate) {
+	if (FUSE_IS_VIRTIO_DAX(fi) && is_truncate) {
 		filemap_invalidate_lock(mapping);
 		fault_blocked = true;
 		err = fuse_dax_break_layouts(inode, 0, -1);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 01bc894e9c2b..093569033ed1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -252,7 +252,7 @@ static int fuse_open(struct inode *inode, struct file *file)
 	int err;
 	bool is_truncate = (file->f_flags & O_TRUNC) && fc->atomic_o_trunc;
 	bool is_wb_truncate = is_truncate && fc->writeback_cache;
-	bool dax_truncate = is_truncate && FUSE_IS_DAX(inode);
+	bool dax_truncate = is_truncate && FUSE_IS_VIRTIO_DAX(fi);
 
 	if (fuse_is_bad(inode))
 		return -EIO;
@@ -1812,11 +1812,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
@@ -1833,11 +1834,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
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
@@ -2370,10 +2372,11 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
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
@@ -2934,7 +2937,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		.mode = mode
 	};
 	int err;
-	bool block_faults = FUSE_IS_DAX(inode) &&
+	bool block_faults = FUSE_IS_VIRTIO_DAX(fi) &&
 		(!(mode & FALLOC_FL_KEEP_SIZE) ||
 		 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 7f16049387d1..45e108dec771 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1508,7 +1508,14 @@ void fuse_free_conn(struct fuse_conn *fc);
 
 /* dax.c */
 
-#define FUSE_IS_DAX(inode) (IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode))
+static inline bool fuse_file_famfs(struct fuse_inode *fuse_inode) /* Will be superseded */
+{
+	(void)fuse_inode;
+	return false;
+}
+#define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)	\
+					&& IS_DAX(&fuse_inode->inode)  \
+					&& !fuse_file_famfs(fuse_inode))
 
 ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to);
 ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 819e50d66622..ed667920997f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -162,7 +162,7 @@ static void fuse_evict_inode(struct inode *inode)
 	/* Will write inode on close/munmap and in all other dirtiers */
 	WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);
 
-	if (FUSE_IS_DAX(inode))
+	if (FUSE_IS_VIRTIO_DAX(fi))
 		dax_break_layout_final(inode);
 
 	truncate_inode_pages_final(&inode->i_data);
@@ -170,7 +170,7 @@ static void fuse_evict_inode(struct inode *inode)
 	if (inode->i_sb->s_flags & SB_ACTIVE) {
 		struct fuse_conn *fc = get_fuse_conn(inode);
 
-		if (FUSE_IS_DAX(inode))
+		if (FUSE_IS_VIRTIO_DAX(fi))
 			fuse_dax_inode_cleanup(inode);
 		if (fi->nlookup) {
 			fuse_queue_forget(fc, fi->forget, fi->nodeid,
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index 3728933188f3..31ee7f3304c6 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -203,7 +203,7 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 	 * io modes are not relevant with DAX and with server that does not
 	 * implement open.
 	 */
-	if (FUSE_IS_DAX(inode) || !ff->args)
+	if (FUSE_IS_VIRTIO_DAX(fi) || !ff->args)
 		return 0;
 
 	/*
-- 
2.52.0

