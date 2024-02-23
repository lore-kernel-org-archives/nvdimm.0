Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1992D13A27A
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710178; cv=none; b=DIn2sXL5Zdoo4OkIj+BHkmFuUyqtnkyXpzS2GDA0rmOvCLFBvIuDylmAIkqTEYl918OHTXhpNVuF7uyzsjQMU0kwu1W3jB3eJQTL99rd4Qh7NEh44JtG8QGbD7R8sXBTRjbNTfUxwdqsmuMlv/fsydaMeml8/udUXl+9rivbDl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710178; c=relaxed/simple;
	bh=PUD0vMbRgGZdbJrCGYGYILmZtfRGBeQr9bzqDwdIVbc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FEwWVxk3/G6pV8DXnzmu0H/KtoCJ+D37TNtOwVkmwKU9X9N318eOIVxX1Hi0aQZqtT4rd3rUtBzbviMCnvwrvshwsEJwbbW5efvYLxx7TLWVrPAi2DYNgp4EyMlGvecyiXqqkkst+yeNd9VTMCkcR0lVwOB792CUZlKx0D2b+jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hjffp+fl; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hjffp+fl"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6e4875e875aso166122a34.2
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710175; x=1709314975; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffFa5LaeRHtZzXvAYgjrZx1FIfP+qFqp6PEwqgPiWCk=;
        b=Hjffp+flVNG2hu1n2i6ktPXlJYjaqtG5cRSyupqhzakMQ8ONJmsj43s3H2f6c7C5vp
         mrsTlQsmEOx24oW2g0T0oiv+XP0Hl8rDB2OyEz7uFYRgqNY+g2//vpqUNmgXYD2P4rd7
         E7lIo0/vQXH2jZO/8J4Y0KJPkOTzUa4L45FvTDBy2INCj+tppRhpLElx3JpXyIquC+aq
         iK1S0heNM0zcVeuQjby+Itnv7RdXH3SSXbLdQ8vDoCsh/JMh5kMKCGBoHURhV7BBW+F9
         cFx/gkts0dH+uJ3bAFUUENX2GJ9Cs/5H+Yk19xryNn9sRjhA1T1ERKu5bTW/eeIsZqTC
         pv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710175; x=1709314975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ffFa5LaeRHtZzXvAYgjrZx1FIfP+qFqp6PEwqgPiWCk=;
        b=RMPqmJ95vN8ymgRIsUs91qyAhPDbRiXCpN8rGVRlPXeVyQ4zpyyw6XigKTMyBFGAIC
         18kVKxsrvBVUod7tUJwRdDck7TK4LVW3v1U7deDQdEssYPojcruqouo9HPp3/yGlRpOc
         RaHfmKxqoecSCe0/sARVwBLTr7xWkItlhGEX792iecIyhs1MyWBaFBOXT+tF0fCUXWd4
         qn9nCyUXGZBy0Ine66y8iI1AWeWZTktPiaKR9GNIMq6D1HyMVK2kGZ8VXOSV7qybhpPw
         tgFXziYzkp80jC71NCTsPFiT92dikAMfs/3zajdyGcj38pz96FkII77EjjBYMKtWCNtb
         6Hng==
X-Forwarded-Encrypted: i=1; AJvYcCUy03UZdIJWzkfXqilYBzXcSPdG2DOU4cgxy6D+oHjnKBEeA0NL0rHfA+g3SHLpgdxbaS5xcBhJ6m02HAdpCG6XFOf/l29r
X-Gm-Message-State: AOJu0YxN2qzsR42V4yuacGDWRmoeGqvR+EAlOz6GjLDvbx2wK2e43pJe
	EE9YIHhjAzYvrOp/AQchm+0EAYlbekPys+vcQFkuZ6ln6B0rCuA0
X-Google-Smtp-Source: AGHT+IEHirLXRV+6OKdrF+r7Z5tOqjqyN0zId5OKwsBBpwfkkZXqy9jpKoxd8tEFzTGfWYOfe+Tq4Q==
X-Received: by 2002:a05:6871:7810:b0:21e:be10:f39d with SMTP id oy16-20020a056871781000b0021ebe10f39dmr577039oac.46.1708710175230;
        Fri, 23 Feb 2024 09:42:55 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:55 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John@Groves.net,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	John Groves <john@groves.net>
Subject: [RFC PATCH 13/20] famfs: Add iomap_ops
Date: Fri, 23 Feb 2024 11:41:57 -0600
Message-Id: <2996a7e757c3762a9a28c789645acd289f5f7bc0.1708709155.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <cover.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit introduces the famfs iomap_ops. When either
dax_iomap_fault() or dax_iomap_rw() is called, we get a callback
via our iomap_begin() handler. The question being asked is
"please resolve (file, offset) to (daxdev, offset)". The function
famfs_meta_to_dax_offset() does this.

The per-file metadata is just an extent list to the
backing dax dev.  The order of this resolution is O(N) for N
extents. Note with the current user space, files usually have
only one extent.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/famfs_file.c | 245 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 245 insertions(+)
 create mode 100644 fs/famfs/famfs_file.c

diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
new file mode 100644
index 000000000000..fc667d5f7be8
--- /dev/null
+++ b/fs/famfs/famfs_file.c
@@ -0,0 +1,245 @@
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
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/dax.h>
+#include <linux/uio.h>
+#include <linux/iomap.h>
+#include <uapi/linux/famfs_ioctl.h>
+#include "famfs_internal.h"
+
+/*********************************************************************
+ * iomap_operations
+ *
+ * This stuff uses the iomap (dax-related) helpers to resolve file offsets to
+ * offsets within a dax device.
+ */
+
+/**
+ * famfs_meta_to_dax_offset()
+ *
+ * This function is called by famfs_iomap_begin() to resolve an offset in a file to
+ * an offset in a dax device. This is upcalled from dax from calls to both
+ * dax_iomap_fault() and dax_iomap_rw(). Dax finishes the job resolving a fault to
+ * a specific physical page (the fault case) or doing a memcpy variant (the rw case)
+ *
+ * Pages can be PTE (4k), PMD (2MiB) or (theoretically) PuD (1GiB)
+ * (these sizes are for X86; may vary on other cpu architectures
+ *
+ * @inode  - the file where the fault occurred
+ * @iomap  - struct iomap to be filled in to indicate where to find the right memory, relative
+ *           to a dax device.
+ * @offset - the offset within the file where the fault occurred (will be page boundary)
+ * @len    - the length of the faulted mapping (will be a page multiple)
+ *           (will be trimmed in *iomap if it's disjoint in the extent list)
+ * @flags
+ */
+static int
+famfs_meta_to_dax_offset(
+	struct inode *inode,
+	struct iomap *iomap,
+	loff_t        offset,
+	loff_t        len,
+	unsigned int  flags)
+{
+	struct famfs_file_meta *meta = (struct famfs_file_meta *)inode->i_private;
+	int i;
+	loff_t local_offset = offset;
+	struct famfs_fs_info  *fsi = inode->i_sb->s_fs_info;
+
+	iomap->offset = offset; /* file offset */
+
+	for (i = 0; i < meta->tfs_extent_ct; i++) {
+		loff_t dax_ext_offset = meta->tfs_extents[i].offset;
+		loff_t dax_ext_len    = meta->tfs_extents[i].len;
+
+		if ((dax_ext_offset == 0) && (meta->file_type != FAMFS_SUPERBLOCK))
+			pr_err("%s: zero offset on non-superblock file!!\n", __func__);
+
+		/* local_offset is the offset minus the size of extents skipped so far;
+		 * If local_offset < dax_ext_len, the data of interest starts in this extent
+		 */
+		if (local_offset < dax_ext_len) {
+			loff_t ext_len_remainder = dax_ext_len - local_offset;
+
+			/*+
+			 * OK, we found the file metadata extent where this data begins
+			 * @local_offset      - The offset within the current extent
+			 * @ext_len_remainder - Remaining length of ext after skipping local_offset
+			 *
+			 * iomap->addr is the offset within the dax device where that data
+			 * starts
+			 */
+			iomap->addr    = dax_ext_offset + local_offset; /* dax dev offset */
+			iomap->offset  = offset; /* file offset */
+			iomap->length  = min_t(loff_t, len, ext_len_remainder);
+			iomap->dax_dev = fsi->dax_devp;
+			iomap->type    = IOMAP_MAPPED;
+			iomap->flags   = flags;
+
+			return 0;
+		}
+		local_offset -= dax_ext_len; /* Get ready for the next extent */
+	}
+
+	/* Set iomap to zero length in this case, and return 0
+	 * This just means that the r/w is past EOF
+	 */
+	iomap->addr    = offset;
+	iomap->offset  = offset; /* file offset */
+	iomap->length  = 0; /* this had better result in no access to dax mem */
+	iomap->dax_dev = fsi->dax_devp;
+	iomap->type    = IOMAP_MAPPED;
+	iomap->flags   = flags;
+
+	return 0;
+}
+
+/**
+ * famfs_iomap_begin()
+ *
+ * This function is pretty simple because files are
+ * * never partially allocated
+ * * never have holes (never sparse)
+ * * never "allocate on write"
+ */
+static int
+famfs_iomap_begin(
+	struct inode	       *inode,
+	loff_t			offset,
+	loff_t			length,
+	unsigned int		flags,
+	struct iomap	       *iomap,
+	struct iomap	       *srcmap)
+{
+	struct famfs_file_meta *meta = inode->i_private;
+	size_t size;
+	int rc;
+
+	size = i_size_read(inode);
+
+	WARN_ON(size != meta->file_size);
+
+	rc = famfs_meta_to_dax_offset(inode, iomap, offset, length, flags);
+
+	return rc;
+}
+
+/* Note: We never need a special set of write_iomap_ops because famfs never
+ * performs allocation on write.
+ */
+const struct iomap_ops famfs_iomap_ops = {
+	.iomap_begin		= famfs_iomap_begin,
+};
+
+/*********************************************************************
+ * vm_operations
+ */
+static vm_fault_t
+__famfs_filemap_fault(
+	struct vm_fault		*vmf,
+	unsigned int		pe_size,
+	bool			write_fault)
+{
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
+	vm_fault_t		ret;
+
+	if (write_fault) {
+		sb_start_pagefault(inode->i_sb);
+		file_update_time(vmf->vma->vm_file);
+	}
+
+	if (IS_DAX(inode)) {
+		pfn_t pfn;
+
+		ret = dax_iomap_fault(vmf, pe_size, &pfn, NULL, &famfs_iomap_ops);
+		if (ret & VM_FAULT_NEEDDSYNC)
+			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
+	} else {
+		/* All famfs faults will be dax... */
+		pr_err("%s: oops, non-dax fault\n", __func__);
+		ret = VM_FAULT_SIGBUS;
+	}
+
+	if (write_fault)
+		sb_end_pagefault(inode->i_sb);
+
+	return ret;
+}
+
+static inline bool
+famfs_is_write_fault(
+	struct vm_fault		*vmf)
+{
+	return (vmf->flags & FAULT_FLAG_WRITE) &&
+	       (vmf->vma->vm_flags & VM_SHARED);
+}
+
+static vm_fault_t
+famfs_filemap_fault(
+	struct vm_fault		*vmf)
+{
+	/* DAX can shortcut the normal fault path on write faults! */
+	return __famfs_filemap_fault(vmf, 0,
+			IS_DAX(file_inode(vmf->vma->vm_file)) && famfs_is_write_fault(vmf));
+}
+
+static vm_fault_t
+famfs_filemap_huge_fault(
+	struct vm_fault	*vmf,
+	unsigned int	 pe_size)
+{
+	if (!IS_DAX(file_inode(vmf->vma->vm_file))) {
+		pr_err("%s: file not marked IS_DAX!!\n", __func__);
+		return VM_FAULT_SIGBUS;
+	}
+
+	/* DAX can shortcut the normal fault path on write faults! */
+	return __famfs_filemap_fault(vmf, pe_size, famfs_is_write_fault(vmf));
+}
+
+static vm_fault_t
+famfs_filemap_page_mkwrite(
+	struct vm_fault		*vmf)
+{
+	return __famfs_filemap_fault(vmf, 0, true);
+}
+
+static vm_fault_t
+famfs_filemap_pfn_mkwrite(
+	struct vm_fault		*vmf)
+{
+	return __famfs_filemap_fault(vmf, 0, true);
+}
+
+static vm_fault_t
+famfs_filemap_map_pages(
+	struct vm_fault	       *vmf,
+	pgoff_t			start_pgoff,
+	pgoff_t			end_pgoff)
+{
+	vm_fault_t ret;
+
+	ret = filemap_map_pages(vmf, start_pgoff, end_pgoff);
+	return ret;
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
-- 
2.43.0

