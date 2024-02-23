Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5DE145338
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710180; cv=none; b=d01xWXDKBu/YzF4zrEChWslXXdWiafG0c3K2Q4rKAxclWg6B8GcgOxDVxK9a0Y9AjSuAHVKnTLfnhOsxp+H8s4dLm87gp1kOidwzPUPrh6Kw1U3zWM41xsSTaTQq+t98BmRKgMFvIZ7W3n+kUBJb2+BAHZGpnRtUJ6Hi/zMKcNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710180; c=relaxed/simple;
	bh=jYmxy3JFMAN0mad3tJYaUDo5JWHwAqTIs9pH9XFTFKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oWVVoNUuTg4s4o11fEFHno68vuzAto2oCUrfAM8suvPWdo6C0NM4ZOwovQALbb2WEMZhxh2+wrYTPQrS/ISD7X7/+XXjmiRFbqNtNvThlWpcoTDJx6NVLJvcG0mZdFaRebVrAluBirmIVpjRmAKHaIc9AZz4XFK/0iLO9VgPJbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHISop0Q; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHISop0Q"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e2da00185dso497567a34.1
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710178; x=1709314978; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpWp5wNXSRx+i2XDMUwzlPOWNd0LdWimzvwNrKtQTig=;
        b=KHISop0QOGs1tUqiaCNHLXORSyI+iK6uov+Gbj2SYo0QcKgVI9kSYCZ7W9vllLZb+/
         phTBHdHustr4891iPI7FO3HqgKbdu3yZxRLlUTVTTnMPSTbK4gehmJerLhDLLzdmcpxB
         +EiEmJL1WLSNBGE9TRZQqgmjBnlgE8edmHPt6o0hVfBPj+ItibednQVGOEkA1I+qLWHu
         7lj/cuvpomBXeBle5ETUVSw9oeRfSDnsrdNHktjCor0pq0kM/BPqWgeqRLxxx8PVnzEQ
         fwJPZOEYvAnjpyhHNbg2k5j4f30PaSWVoN8wV1T/0CPuxgomJUwkoUr4ZoV1wm8CxWmR
         yQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710178; x=1709314978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FpWp5wNXSRx+i2XDMUwzlPOWNd0LdWimzvwNrKtQTig=;
        b=DOl15HokxlluDIk5Ylld7G6eAWoKP/l25eVKMhpAxLiFuSfAmw2FtGgUDP5A3UgyXw
         tOvk+2Z892p6nQQ9OsvzsO+9KjmIz60lVe79N3NjfhIOQMCOFagTpVSSd9Io6ey9zgEm
         fRGknwhoJnb9Y6LStHDjHTPvnXIUdrH3Vt71ybUVW+h6qSMHs3ttYhdCS4UKq7bfCdSh
         yek9FWmhPKT42GEQbq4ieIjWXprRRPkf/wWDcUVB9K2v1L9K9zARJRYEpadHd9QrEQq8
         pWg3vVfPgF5UyXFWWq8xZT6k+lAaPhckJC5iGZ12RSxMm9juTCoJrsja04q55pAtSZth
         eZjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbEGVRGyfJa4npDVN658IOQQS4bfPE9OSdKOGZwMVZnxNQ2FMiw2WAfabGLdIdiBSEpa0cbiVWChUnrR0GzkrilZ8qbpj3
X-Gm-Message-State: AOJu0YzJKevfb1ivjLeLrPjk5fRx4RtEh75OtskIbrVOflrmCwuUZ4OT
	FQxXV5P5fGkor7mORKuVLD4Nh8CYsmVjlwuJID5sK7REMjmv8Tcq
X-Google-Smtp-Source: AGHT+IGv8FMbQ9vzN7mZzAqvBQGzhE2aAS91+mTwvqifPrAqjLgsl4U6TqglN2diLu8SM4tYIK17Pw==
X-Received: by 2002:a05:6870:d38b:b0:21f:4267:7983 with SMTP id k11-20020a056870d38b00b0021f42677983mr535476oag.49.1708710177826;
        Fri, 23 Feb 2024 09:42:57 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:57 -0800 (PST)
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
Subject: [RFC PATCH 14/20] famfs: Add struct file_operations
Date: Fri, 23 Feb 2024 11:41:58 -0600
Message-Id: <3f19cd8daab0dc3c4d0381019ce61cd106970097.1708709155.git.john@groves.net>
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

This commit introduces the famfs file_operations. We call
thp_get_unmapped_area() to force PMD page alignment. Our read and
write handlers (famfs_dax_read_iter() and famfs_dax_write_iter())
call dax_iomap_rw() to do the work.

famfs_file_invalid() checks for various ways a famfs file can be
in an invalid state so we can fail I/O or fault resolution in those
cases. Those cases include the following:

* No famfs metadata
* file i_size does not match the originally allocated size
* file is not flagged as DAX
* errors were detected previously on the file

An invalid file can often be fixed by replaying the log, or by
umount/mount/log replay - all of which are user space operations.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/famfs_file.c | 136 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
index fc667d5f7be8..5228e9de1e3b 100644
--- a/fs/famfs/famfs_file.c
+++ b/fs/famfs/famfs_file.c
@@ -19,6 +19,142 @@
 #include <uapi/linux/famfs_ioctl.h>
 #include "famfs_internal.h"
 
+/*********************************************************************
+ * file_operations
+ */
+
+/* Reject I/O to files that aren't in a valid state */
+static ssize_t
+famfs_file_invalid(struct inode *inode)
+{
+	size_t i_size       = i_size_read(inode);
+	struct famfs_file_meta *meta = inode->i_private;
+
+	if (!meta) {
+		pr_err("%s: un-initialized famfs file\n", __func__);
+		return -EIO;
+	}
+	if (i_size != meta->file_size) {
+		pr_err("%s: something changed the size from  %ld to %ld\n",
+		       __func__, meta->file_size, i_size);
+		meta->error = 1;
+		return -ENXIO;
+	}
+	if (!IS_DAX(inode)) {
+		pr_err("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
+		meta->error = 1;
+		return -ENXIO;
+	}
+	if (meta->error) {
+		pr_err("%s: previously detected metadata errors\n", __func__);
+		meta->error = 1;
+		return -EIO;
+	}
+	return 0;
+}
+
+static ssize_t
+famfs_dax_read_iter(
+	struct kiocb		*iocb,
+	struct iov_iter		*to)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	size_t i_size       = i_size_read(inode);
+	size_t count        = iov_iter_count(to);
+	size_t max_count;
+	ssize_t rc;
+
+	rc = famfs_file_invalid(inode);
+	if (rc)
+		return rc;
+
+	max_count = max_t(size_t, 0, i_size - iocb->ki_pos);
+
+	if (count > max_count)
+		iov_iter_truncate(to, max_count);
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
+/**
+ * famfs_write_iter()
+ *
+ * We need our own write-iter in order to prevent append
+ */
+static ssize_t
+famfs_dax_write_iter(
+	struct kiocb    *iocb,
+	struct iov_iter *from)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	size_t i_size       = i_size_read(inode);
+	size_t count        = iov_iter_count(from);
+	size_t max_count;
+	ssize_t rc;
+
+	rc = famfs_file_invalid(inode);
+	if (rc)
+		return rc;
+
+	/* Starting offset of write is: iocb->ki_pos
+	 * length is iov_iter_count(from)
+	 */
+	max_count = max_t(size_t, 0, i_size - iocb->ki_pos);
+
+	/* If write would go past EOF, truncate it to end at EOF since famfs does not
+	 * alloc-on-write
+	 */
+	if (count > max_count)
+		iov_iter_truncate(from, max_count);
+
+	if (!iov_iter_count(from))
+		return 0;
+
+	return dax_iomap_rw(iocb, from, &famfs_iomap_ops);
+}
+
+static int
+famfs_file_mmap(
+	struct file		*file,
+	struct vm_area_struct	*vma)
+{
+	struct inode		*inode = file_inode(file);
+	ssize_t rc;
+
+	rc = famfs_file_invalid(inode);
+	if (rc)
+		return (int)rc;
+
+	file_accessed(file);
+	vma->vm_ops = &famfs_file_vm_ops;
+	vm_flags_set(vma, VM_HUGEPAGE);
+	return 0;
+}
+
+const struct file_operations famfs_file_operations = {
+	.owner             = THIS_MODULE,
+
+	/* Custom famfs operations */
+	.write_iter	   = famfs_dax_write_iter,
+	.read_iter	   = famfs_dax_read_iter,
+	.mmap		   = famfs_file_mmap,
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
 /*********************************************************************
  * iomap_operations
  *
-- 
2.43.0

