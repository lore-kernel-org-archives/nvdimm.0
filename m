Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3378127B51
	for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 17:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410330; cv=none; b=dgv6HRVr3YqUYiR8AjMk+kvBs/zjAPVOxMylC3FW3/+UWN/uGZoUq5Vd0KwvDcLsOibGqBXPSph0TryW87ijcANy8uuRywJa9SqJzgqXpLc2dyrc8tLpHr4qudyv8WCnKC/sngsXfyDN2TzO9ewvmhx1uecH8nmUtnCLE0x0x7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410330; c=relaxed/simple;
	bh=f7nr9BHgMNY07SuBb7AMIuKL8EhAF6Lae/DCFaA0XMM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B6ZiHLulbMcyAZ/AxtYumUs9YWLbaSSfzZSKfH9/fU355WtJ2snui9YZ3aiFMZ41NlHhgL6isGaZPTQpwhP4AvUnYTQhDqIZOji1Va0FP0GyG65kL5b4oPM/CA0YCsyfIolQC233qHwfdMczlUup0C6tDj7RXh2niMRhd+ZnlTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D9jRzO2t; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9jRzO2t"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6ee3a49bdcfso515401a34.0
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 10:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714410328; x=1715015128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvRMVdHLhDXhOx55ypqAZ1Z/pDm9XYtxQRRB/JnE99c=;
        b=D9jRzO2tdEvnfGvk3ElftrvWUpG+2ooWxiYNq0ZtN+XGgtwfuOzReody9uW8EYZeN7
         ZfgCmTthL4ZxMlBUdq+GFFzPaAyEdTUJHtrMxm5voDgArwrnXTeiAk2CDZ8ERQArMYeT
         9flnoG7sVGvpxvqCBetK7hSLm46KTXtTPtSgXeIuqNUL7BIxhtsULXSrc2rFogI0igwv
         goqz4H4eU1NS3ByZODkDfW1fW9iejiq2G+gaHvpXhQLybLH4Pgt3yhCce8UqQQsyPEOC
         PoI5fOEdovJrl1+nDhpFlndba09d4h4jJN9OEzum/o0Au9gwQdPMZlTEJauH5TgF9rB7
         T7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410328; x=1715015128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MvRMVdHLhDXhOx55ypqAZ1Z/pDm9XYtxQRRB/JnE99c=;
        b=nlI5H0fX7rpZ7mFgNjg57yL13PLkaihy2m8+VD+YMItDA5S/U1zFL4MXwGMfMPb1Ja
         beUhmsEiK0XI8R6yZQViYzWO3j1ZeTmJPBeHDPA6tTPJ5pYE/bt7jhgk5cgo6lyDlN9P
         rezmJxL6nvC5/lR2jOJbGviC6n3jkUcXHzXzEKFjy/kWvW0E/Vy/nQEwWUGxOgRPyU8H
         gEHnn4CCM8zZMH8Nuz6JQGEDYr0eVVoEp3GnkgdDIAUb0QrBkdgBF0WhsyUn0urvj4aA
         Rtp36PvVD/PvQhW0S2pvno4NusJgQc1fmgdE2l3TAPEhza7/47CQetNWNuvnKhlNQsht
         iXCg==
X-Forwarded-Encrypted: i=1; AJvYcCWi1DwYK3ZkGOB24VoojK552c5j7v0kxeNoHPl/Gq0trzOW0TxxgbtG8/rRbxREkdDevjdiU3RwYlVOpIcxBv2X+0HniFe3
X-Gm-Message-State: AOJu0YzBF+po1XABKh+xkSV/F8QdqkmRVU9cDN31c/IacCS4sOHq2q1+
	Kj6YdNyYHBSrPkvlekvxPaRPUDQDcorjSkQKr6qOY4KsCGifkadk
X-Google-Smtp-Source: AGHT+IG/ZcwB0huKygPBvFdcgDmjShYrcDklwOFhU2UIhkvvjhkEis6/aiEjDF1au3eTMnKT4Qud0g==
X-Received: by 2002:a05:6830:59:b0:6ee:3232:160a with SMTP id d25-20020a056830005900b006ee3232160amr328210otp.38.1714410326944;
        Mon, 29 Apr 2024 10:05:26 -0700 (PDT)
Received: from localhost.localdomain ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id g1-20020a9d6201000000b006ea20712e66sm4074448otj.17.2024.04.29.10.05.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Apr 2024 10:05:26 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John Groves <jgroves@micron.com>,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	Randy Dunlap <rdunlap@infradead.org>,
	Jerome Glisse <jglisse@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Eishan Mirakhur <emirakhur@micron.com>,
	Ravi Shankar <venkataravis@micron.com>,
	Srinivasulu Thanneeru <sthanneeru@micron.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Julien Panis <jpanis@baylibre.com>,
	Stanislav Fomichev <sdf@google.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	John Groves <john@groves.net>
Subject: [RFC PATCH v2 10/12] famfs: Introduce file_operations read/write
Date: Mon, 29 Apr 2024 12:04:26 -0500
Message-Id: <4584f1e26802af540a60eadb70f42c6ac5fe4679.1714409084.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <cover.1714409084.git.john@groves.net>
References: <cover.1714409084.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit introduces fs/famfs/famfs_file.c and the famfs
file_operations for read/write.

This is not usable yet because:

* It calls dax_iomap_rw() with NULL iomap_ops (which will be
  introduced in a subsequent commit).
* famfs_ioctl() is coming in a later commit, and it is necessary
  to map a file to a memory allocation.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/Makefile         |   2 +-
 fs/famfs/famfs_file.c     | 122 ++++++++++++++++++++++++++++++++++++++
 fs/famfs/famfs_inode.c    |   2 +-
 fs/famfs/famfs_internal.h |   2 +
 4 files changed, 126 insertions(+), 2 deletions(-)
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
index 000000000000..48036c71d4ed
--- /dev/null
+++ b/fs/famfs/famfs_file.c
@@ -0,0 +1,122 @@
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
+		pr_debug("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
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
+	max_count = max_t(size_t, 0, i_size - iocb->ki_pos);
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
+	ssize_t rc;
+
+	rc = famfs_rw_prep(iocb, to);
+	if (rc)
+		return rc;
+
+	if (!iov_iter_count(to))
+		return 0;
+
+	rc = dax_iomap_rw(iocb, to, NULL /*&famfs_iomap_ops */);
+
+	file_accessed(iocb->ki_filp);
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
+	ssize_t rc;
+
+	rc = famfs_rw_prep(iocb, from);
+	if (rc)
+		return rc;
+
+	if (!iov_iter_count(from))
+		return 0;
+
+	return dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);
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
+	.splice_read	   = filemap_splice_read,
+	.splice_write	   = iter_file_splice_write,
+	.llseek		   = generic_file_llseek,
+};
+
diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
index e00e9cdecadf..490a2c0fd326 100644
--- a/fs/famfs/famfs_inode.c
+++ b/fs/famfs/famfs_inode.c
@@ -56,7 +56,7 @@ static struct inode *famfs_get_inode(struct super_block *sb,
 		break;
 	case S_IFREG:
 		inode->i_op = &famfs_file_inode_operations;
-		inode->i_fop = NULL /* &famfs_file_operations */;
+		inode->i_fop = &famfs_file_operations;
 		break;
 	case S_IFDIR:
 		inode->i_op = &famfs_dir_inode_operations;
diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
index 951b32ec4fbd..36efaef425e7 100644
--- a/fs/famfs/famfs_internal.h
+++ b/fs/famfs/famfs_internal.h
@@ -11,6 +11,8 @@
 #ifndef FAMFS_INTERNAL_H
 #define FAMFS_INTERNAL_H
 
+extern const struct file_operations famfs_file_operations;
+
 struct famfs_mount_opts {
 	umode_t mode;
 };
-- 
2.43.0

