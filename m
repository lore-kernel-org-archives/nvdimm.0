Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.76
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793862043;
	b=guSkuhl+SAx3tW31MiqZP5EXdXslP/eGdC6mZmz2gmE5XGkBb/7HV2W2NQFXrhy26JQ+
	 ZMrsR6imAFwnosmpLCU54WNJ0S4IYiYgI2LsKSMZLk0T7KwRo8560gUsh6VY5DmMavo7p
	 xTI/0P6OxX69vuqvCa8MCDtnCsv5FEawj96D/FQ9RrnvdIhV33c5GsjydYxGKlHzIYK2z
	 YrcEvj05cAqZIHp+oo9PlXwawJbVoWgZ8k96j+DsluFsUuHUmd1gfBaHsqe35hKk/8B+p
	 fPZV/w+kXxks+FJHRx+KeNnCGv6unxSr+3kZISkb72ySR0eqXRr2e9tFxP89DNU2t1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793862043;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xg8nXZtLp4oyb17OmIrfnuQowTn1P59jW3Dg4lobw/A=;
	b=0+Szr9KHGe6w1G0Jz+zuyBzmMA5Ju95lkiQUazesM4enpCP62eueNO6+d9KTVTsxwjYw
	 D9WCFFOc3nrnouS6IJkXTk8JBJ4rXF0CvgXuBa5+f+x+ZDAMTGgoGZT9fpbndZZIYYk8j
	 vBCW3e/eoyV7/VXSbaZb9MY7VN1KL84OjtsiGQL8d9P47KXRDNt47HWoLnNIuUtwhvNMp
	 CQqo2qjJQrRSTU6o4mzeJkN3TWd+69CRkEqMt38tfWzJqkoadD7K1hLEmry/rGcM2WHdg
	 gn9tjePu6t/s0Yq717t8h7Rb6ZNoXDC2P6S2znSyZja2In9byzMfdE1SC94BaxJp70g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=h23ZjTS+;
	arc=none smtp.remote-ip=95.215.58.76
Received: from mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC019606A32D
	for <nvdimm@lists.linux.dev>; Thu,  5 Nov 2026 07:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC019606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=h23ZjTS+
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=wHNd6ESNgC5Ksw+CY79MAj+VAYD20bCYtUJOCQAgBeE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793862040; v=1; x=1794466840;
 b=h23ZjTS+sMfw/fSgET1a6EQQOq62+rKCyha5hbKDRHDq9JIDxlBEevp1LSefq3/YdiHFrwyZ
 xR7a54BddqN0taszXNsAuD0BDkoo48tsAlVr4BE2X3S6dKo62SRd4OC8n6kOn3foSXesFKwRw4H
 UwWJTUEoqiJBMHYdZJsTkre4=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7a0aea14e9d952c6;
	Thu, 05 Nov 2026 07:00:36 +0000
X-Mizu-Trace-ID: 7a0aea14e9d952c6
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 6/6] ext4: support dma-buf registered buffers for direct I/O
Date: Thu,  5 Nov 2026 14:58:47 +0800
Message-ID: <20261105065847.196540-7-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

Add the init_dma_buf_io_ctx fop for ext4 files.  The data of every
regular file lives on the block device of the mount, so the buffer is
registered for that device and an ext4 file cannot move to another disk
after the registration.

A device mapping can only be read or written by a direct I/O bio.
Add a fast check at ext4_file_read_iter/ext4_file_write_iter entry.
Refuse the iterator for buffered I/O in the two dispatchers; the DAX
methods are covered by dax_iomap_rw() and direct I/O by the iomap and
block layer guards.

A direct I/O write whose tail still needs the page cache reports the
bytes the block layer already submitted instead of the error, as that
part cannot be undone and the remainder can never be copied.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/ext4/file.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 374b4bc25bd5..46629915fa84 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -139,6 +139,12 @@ static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
+	/* a device mapping can only be read by a direct I/O bio */
+	if (iov_iter_is_dmabuf_map(to) &&
+	    (!(iocb->ki_flags & IOCB_DIRECT) ||
+	     !ext4_should_use_dio(iocb, to)))
+		return -EOPNOTSUPP;
+
 #ifdef CONFIG_FS_DAX
 	if (IS_DAX(inode))
 		return ext4_dax_read_iter(iocb, to);
@@ -670,6 +676,13 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		ssize_t err;
 		loff_t endbyte;
 
+		/*
+		 * The page cache cannot copy from a device mapping.  What
+		 * direct I/O already submitted stands on its own.
+		 */
+		if (iov_iter_is_dmabuf_map(from))
+			return ret > 0 ? ret : -EAGAIN;
+
 		/*
 		 * There is no support for atomic writes on buffered-io yet,
 		 * we should never fallback to buffered-io for DIO atomic
@@ -773,6 +786,12 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (unlikely(ret))
 		return ret;
 
+	/* a device mapping can only be written by a direct I/O bio */
+	if (iov_iter_is_dmabuf_map(from) &&
+	    (!(iocb->ki_flags & IOCB_DIRECT) ||
+	     !ext4_should_use_dio(iocb, from)))
+		return -EOPNOTSUPP;
+
 #ifdef CONFIG_FS_DAX
 	if (IS_DAX(inode))
 		return ext4_dax_write_iter(iocb, from);
@@ -1032,10 +1051,24 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	return vfs_setpos(file, offset, maxbytes);
 }
 
+/*
+ * The data of every regular file lives on the block device of the
+ * filesystem, so an ext4 file cannot move to another disk after the
+ * buffer has been registered.
+ */
+static int ext4_file_init_dma_buf_io_ctx(struct file *file,
+					 struct dma_buf_io_ctx *ctx)
+{
+	return iomap_file_init_dma_buf_io_ctx(file,
+					      file_inode(file)->i_sb->s_bdev,
+					      ctx);
+}
+
 const struct file_operations ext4_file_operations = {
 	.llseek		= ext4_llseek,
 	.read_iter	= ext4_file_read_iter,
 	.write_iter	= ext4_file_write_iter,
+	.init_dma_buf_io_ctx = ext4_file_init_dma_buf_io_ctx,
 	.iopoll		= iocb_bio_iopoll,
 	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
-- 
2.43.0

