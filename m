Received: from a11-131.smtp-out.amazonses.com (a11-131.smtp-out.amazonses.com [54.240.11.131])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD3C41835B;
	Sat, 29 Aug 2026 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023502; cv=none; b=InDhQKCsqvZs+ZvfG6HXKMj2MMThx0mzFec8XfVfS1OcFb2EHEmA1kYnf4DtrLN96pUIYCjRucDtB8O0evJa77GnVp3PXcGvWe4SPGV7FlLdM9VqoDZtg9+r7N/Pr6UyxZ6UZO3txlDpz+mMOZl+1j7LJpdLmN4ooLilSVl3kpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023502; c=relaxed/simple;
	bh=t7hOYY1N5YwMOj8VPblq7xGMHgyoyIb7jJUbKHoIeb8=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=RDvMbaxiH6OOrC9R6kPRrfGtR3IoCfqfcL6wdDvB1bPZuqkEODG9VvPmebUOPQfQczxwpqsz8KhGUMFbGmuMSgh9htdIZ1XUYJEDzJ3u6x9LVqp7fvv4ulB0DNN8y12IMHgZ0gItXr1y0ohdbn/VZTJTl1k4/JWr7328AwT3YMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Pz7h2oLn; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=WjLtU/07; arc=none smtp.client-ip=54.240.11.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Pz7h2oLn";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="WjLtU/07"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023496;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=t7hOYY1N5YwMOj8VPblq7xGMHgyoyIb7jJUbKHoIeb8=;
	b=Pz7h2oLnDGevKDC84f3ClgUJnfwJ6iRNaMsK3zwA1Fa5M1lETm54ulyjR3uHAPur
	79NNLpIb6hf9/syJ9MmSWreFq7+TwLumI3a6X64umY0ThmikJpXMnDqNP79X+pyzpE1
	Sl69gbASInVo0xGydSiv63aV7MCsEmMv1tizjZjY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023496;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=t7hOYY1N5YwMOj8VPblq7xGMHgyoyIb7jJUbKHoIeb8=;
	b=WjLtU/07F2Wvef+mu93KHxNQay0GXQWPr+XjFBHqpZWeTF9GE5BuSNfkkTHkwIoY
	xUzvhI2HPJcYbSSP3c4D2r6qilVVqc2TNFm/pQ1GhcmfzujslarBinyHxkf6wpOYxQD
	4HD5bsGFHyldaPfCIiikDHfssGRNbfgH6VBXhFx8=
Subject: [PATCH V14 05/12] famfs: Introduce file_operations read/write
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Jake_Edge?= <jake@lwn.net>, 
	=?UTF-8?Q?Shuah_Khan?= <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?David_Hildenbrand?= <david@kernel.org>, 
	=?UTF-8?Q?Christian_Bra?= =?UTF-8?Q?uner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Darrick_J_=2E_Wong?= <djwong@kernel.org>, 
	=?UTF-8?Q?Randy_Dunlap?= <rdunlap@infradead.org>, 
	=?UTF-8?Q?Jeff_Layton?= <jlayton@kernel.org>, 
	=?UTF-8?Q?Amir_Goldstein?= <amir73il@gmail.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?Stefan_Hajnoczi?= <shajnocz@redhat.com>, 
	=?UTF-8?Q?Joanne_Koong?= <joannelkoong@gmail.com>, 
	=?UTF-8?Q?Josef_Bacik?= <josef@toxicpanda.com>, 
	=?UTF-8?Q?Bagas_Sanjaya?= <bagasdotme@gmail.com>, 
	=?UTF-8?Q?Chen_Linxuan?= <chenlinxuan@uniontech.com>, 
	=?UTF-8?Q?James_Morse?= <james.morse@arm.com>, 
	=?UTF-8?Q?Fuad_Tabba?= <tabba@google.com>, 
	=?UTF-8?Q?Sean_Christopherson?= <seanjc@google.com>, 
	=?UTF-8?Q?Shivank_Garg?= <shivankg@amd.com>, 
	=?UTF-8?Q?Ackerley_Tng?= <ackerleytng@google.com>, 
	=?UTF-8?Q?Gregory_Pric?= =?UTF-8?Q?e?= <gourry@gourry.net>, 
	=?UTF-8?Q?Andrew_Morton?= <akpm@linux-foundation.org>, 
	=?UTF-8?Q?Namjae_Jeon?= <linkinjeon@kernel.org>, 
	=?UTF-8?Q?Lorenzo_Stoakes?= <ljs@kernel.org>, 
	=?UTF-8?Q?Greg_Kroah-Hartman?= <gregkh@linuxfoundation.org>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Pasha_Tatashin?= <pasha.tatashin@soleen.com>, 
	=?UTF-8?Q?Haren_Myneni?= <haren@linux.ibm.com>, 
	=?UTF-8?Q?Pratyush_Yadav?= <pratyush@kernel.org>, 
	=?UTF-8?Q?Giovanni_Cabiddu?= <giovanni.cabiddu@intel.com>, 
	=?UTF-8?Q?Jiri_Slaby?= <jirislaby@kernel.org>, 
	=?UTF-8?Q?Ethan_Nelson-Moo?= =?UTF-8?Q?re?= <enelsonmoore@gmail.com>, 
	=?UTF-8?Q?Gabriel_Whigham?= <gabewhigham@gmail.com>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40m?= =?UTF-8?Q?icron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40?= =?UTF-8?Q?vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sat, 29 Aug 2026 17:11:36 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
References: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com> 
 <20260829171125.7424-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAADGpW
Thread-Topic: [PATCH V14 05/12] famfs: Introduce file_operations read/write
X-Wm-Sent-Timestamp: 1788023495
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e815fe0-2d476878-af01-41a0-81bc-7bd5a97c154b-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.11.131

From: John Groves <john@groves.net>

This commit introduces fs/famfs/famfs_file.c and the famfs
file_operations for read/write.

This is not usable yet because:

* It calls dax_iomap_rw() with NULL iomap_ops (which will be
  introduced in a subsequent commit).
* famfs_ioctl() is coming in a later commit, and it is necessary
  to map a file to a memory allocation.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: John Groves <john@groves.net>
---

 fs/famfs/Makefile         |   2 +-
 fs/famfs/famfs_file.c     | 141 ++++++++++++++++++++++++++++++++++++++
 fs/famfs/famfs_inode.c    |   2 +-
 fs/famfs/famfs_internal.h |   2 +
 4 files changed, 145 insertions(+), 2 deletions(-)
 create mode 100644 fs/famfs/famfs_file.c

diff --git a/fs/famfs/Makefile b/fs/famfs/Makefile
index 62230bcd6793..8cac90c090a4 100644
--- a/fs/famfs/Makefile
+++ b/fs/famfs/Makefile
@@ -2,4 +2,4 @@
 
 obj-$(CONFIG_FAMFS) += famfs.o
 
-famfs-y := famfs_inode.o
+famfs-y := famfs_inode.o famfs_file.o
diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
new file mode 100644
index 000000000000..1369fe1824bc
--- /dev/null
+++ b/fs/famfs/famfs_file.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * famfs - dax file system for shared fabric-attached memory
+ *
+ * Copyright 2023-2024 Micron Technology, Inc.
+ *
+ * This file system, originally based on ramfs the dax support from xfs,
+ * is intended to allow multiple host systems to mount a common file system
+ * view of dax files that map to shared memory.
+ */
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/dax.h>
+#include <linux/iomap.h>
+
+#include "famfs_internal.h"
+
+/*********************************************************************
+ * file_operations
+ */
+
+/* Reject I/O to files that aren't in a valid state */
+static ssize_t
+famfs_file_invalid(struct inode *inode)
+{
+	if (!IS_DAX(inode)) {
+		pr_debug("%s: inode %llx IS_DAX is false\n",
+			 __func__, (u64)inode);
+		return -ENXIO;
+	}
+	return 0;
+}
+
+static ssize_t
+famfs_rw_prep(struct kiocb *iocb, struct iov_iter *ubuf)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct famfs_fs_info *fsi = sb->s_fs_info;
+	size_t i_size = i_size_read(inode);
+	size_t count = iov_iter_count(ubuf);
+	size_t max_count;
+	ssize_t rc;
+
+	if (fsi->deverror)
+		return -ENODEV;
+
+	rc = famfs_file_invalid(inode);
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
+static ssize_t
+famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter	*to)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	ssize_t rc;
+
+	/* dax_iomap_rw() requires i_rwsem held (shared for read) */
+	inode_lock_shared(inode);
+	rc = famfs_rw_prep(iocb, to);
+	if (rc || !iov_iter_count(to)) {
+		inode_unlock_shared(inode);
+		return rc;
+	}
+
+	rc = dax_iomap_rw(iocb, to, NULL /*&famfs_iomap_ops */);
+	inode_unlock_shared(inode);
+
+	if (rc > 0)
+		file_accessed(iocb->ki_filp);
+	return rc;
+}
+
+/**
+ * famfs_dax_write_iter()
+ *
+ * We need our own write-iter in order to prevent append
+ *
+ * @iocb:
+ * @from: iterator describing the user memory source for the write
+ */
+static ssize_t
+famfs_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	struct famfs_fs_info *fsi = inode->i_sb->s_fs_info;
+	ssize_t rc;
+
+	if (!famfs_opt_enabled(fsi, FAMFS_OPT_WRITE))
+		return -EPERM;
+
+	/* dax_iomap_rw() requires i_rwsem held (exclusive for write) */
+	inode_lock(inode);
+	rc = famfs_rw_prep(iocb, from);
+	if (rc || !iov_iter_count(from)) {
+		inode_unlock(inode);
+		return rc;
+	}
+
+	kiocb_modified(iocb); /* mtime/ctime + strip set[e]uid */
+
+	rc = dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);
+	inode_unlock(inode);
+	return rc;
+}
+
+const struct file_operations famfs_file_operations = {
+	.owner             = THIS_MODULE,
+
+	/* Custom famfs operations */
+	.write_iter	   = famfs_dax_write_iter,
+	.read_iter	   = famfs_dax_read_iter,
+	.unlocked_ioctl    = NULL /*famfs_file_ioctl*/,
+	.mmap		   = NULL /* famfs_file_mmap */,
+
+	/* Force PMD alignment for mmap */
+	.get_unmapped_area = thp_get_unmapped_area,
+
+	/* Generic Operations */
+	.fsync		   = noop_fsync,
+	.splice_read	   = copy_splice_read,
+	.splice_write	   = iter_file_splice_write,
+	.llseek		   = generic_file_llseek,
+};
+
diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
index b7a3d8d6ee8c..9e8662c4ac98 100644
--- a/fs/famfs/famfs_inode.c
+++ b/fs/famfs/famfs_inode.c
@@ -59,7 +59,7 @@ famfs_get_inode(
 		break;
 	case S_IFREG:
 		inode->i_op = &famfs_file_inode_operations;
-		inode->i_fop = NULL /* &famfs_file_operations */;
+		inode->i_fop = &famfs_file_operations;
 		break;
 	case S_IFDIR:
 		inode->i_op = &famfs_dir_inode_operations;
diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
index 30f0b01010d5..ff9f1d3f686e 100644
--- a/fs/famfs/famfs_internal.h
+++ b/fs/famfs/famfs_internal.h
@@ -15,6 +15,8 @@
 #include <linux/bits.h>
 #include <linux/build_bug.h>
 
+extern const struct file_operations famfs_file_operations;
+
 struct famfs_mount_opts {
 	umode_t mode;
 };
-- 
2.53.0

