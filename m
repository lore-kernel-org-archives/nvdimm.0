Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383D73246EC
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599490; cv=none; b=Edyh+KsYv3nDKvLOAdvcMgi6/idfqtrabvD/StKxbxxNIXozZ/XUQRwqHTNbEPckWMy7ksZoq4d91jIplyd2qMgap92RuZX6EPCXROX9cEISXxtWnXhPIsPc9uxnq9qhl3/cWQ2NAla99KiBHeGqYapuEDwO+hGmVw4W980Yh7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599490; c=relaxed/simple;
	bh=zMJagFkkbrY21o8z8rVc1idAHLHFZUQVRbfwdxyhOfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYRzAtwxyGl6nWnk65sPrLvcMp+aHt0qEzoJSnRd5OPgFtjUs4ksGsI0FIbo7XQpETJ1MpOCCrurL/F7aEhHy5uECDD6DhTovF2i3Ac6vhENcqokGfOsO+kpWXzkF91QGiiItu/ycS4HnANPCv3ZMyjGrpixZk9XWmz7bjs4cZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kM3TJ525; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kM3TJ525"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc73e322dbso18809025ad.1
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 08:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599487; x=1786204287; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GRFULSZF3QJGSk4pMI6BKC5bl2viqB4gAVktXW+uhWs=;
        b=kM3TJ525EMMRk8juIm5ZAkQyKBBy9kcUoXcHCQyzqUoqfXJ3RQmRYfiYG0J6LCtHXO
         KGqruwNmaYsTU8aY3KiOs7Kl0CHhYsb+jfBXZS+dyrg1UBSMBz9ve72OBJb62wBSIpZB
         YHgydudNiFI7fpLy4/2bc+QWSHxQ263H2N3SP2jv2YnQW0JB+DnIbHbOvdTZRAh7vUuO
         /dBHKoL63Ej+wCX4MePmR/E3l89j8GvEWFbpsmh9WZiK45PFJoyR1uemoqCOv41POUkd
         Y0wxVGBLbOHVjOJMRZ/X6z+DhU9BPxFI0qoyigeWayXFx4aYLIx3EuFtU2puMXu1wSYP
         XSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599487; x=1786204287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GRFULSZF3QJGSk4pMI6BKC5bl2viqB4gAVktXW+uhWs=;
        b=ex+joA41KyZEYELLMj3j6G0uTjqx7Oy864GEabumNumKz5q28Le7UMX6ai7NlTerpF
         cEoi/4ju4B5YOQ9NwW3bDUMq2SqVmW4EKVBf6LMUYSP5sOJZg0RlYznllgldpipelZ0i
         ACcFmQvl2vsAepe77Ir3T+fz3oKW5IF6L5x9i8jhFeaDb69RQoGTrCigRXSL94IsgEM8
         aguacTYKUBBR/Toa9ssCdfUssUuMCwpCgNbko9WgKdr1ixGvNFVYaRD4VLLoPFn5MoKq
         QO5/Thzdm5DmaUD4suRokbKQnRWeMWo1RVXfHQsmNfQorWMoN6UaiTb3HcrNaEpLqEzf
         8QUw==
X-Forwarded-Encrypted: i=1; AHgh+RoXAPM+u9e+ufjTDuKat2+KEhsMkg2MygKUvkfy+IQWUhgueYuYSLExs9XTCF/0iUXrwuNqutM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGnSTLUmxV+Lx4QJm330+DS6HSyBMUIZ0MGB5wiASUeAu8Rwhj
	5Ma/mqYljaUNHPto5JF8OnXPaK+8rT0gAj7uMdT2UsdCWy+RRk2PsHLu
X-Gm-Gg: AR+sD12Cc8YvLdQjteU/3jht64IZkqYccSUCD34eu/IvFfhul8oVGqpSNkMtJDGooFq
	esplZcYHajRpjuuFAjJ6Gez9wabRQB2WHQR7i3g/0V0mKsIvHK1yWQaoVHD5UCNGSAcUyOuBPBL
	Nmn2AxfR6bWxL5EFIoepTVLC0DlEneoLXoE64YtpLuynWXHzAClQmYRUmeofsEVFuARsSu4xiTW
	ovWUC6HitiTiMDRBRDjIhoXSTThz6m7aw/Lj8gFO0tLOvyFkqndg15kYJKILI8qe35b9TI24U9o
	e7TFLB4KMmB+pr289Bk+Jv8hWNnGl1+eapoJ4BPRfDmFSzi6TMLL7swjJqbsDDHSkl3cFcBp3Kx
	MlWHNB7x17vNhdxKnCl0sdDCYuZaYpmrij7lipBoV32l00Xq0r0/zZKWjp3fm1VzKOiHtaqK6mH
	k9tZkFGEcVNCwD1lCQEJTY+hphmv1By6L0bCbBtG6Mca4viGebVA9T4y4BnKCmtLU5oM6U7od6b
	fGtsQiWusOqMgDITNHc0eEbZl5zPXuRrcQdk8x6KfzdkJs=
X-Received: by 2002:a17:903:298b:b0:2ca:ecf6:9104 with SMTP id d9443c01a7336-2d0521bcbb7mr39843045ad.4.1785599487521;
        Sat, 01 Aug 2026 08:51:27 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:51:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v5 13/16] io_uring/rsrc: extend buffer update
Date: Sat,  1 Aug 2026 16:46:25 +0100
Message-ID: <9bca69c80c76a49eb353faaaf3ea00a82e9cecbc.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to pass more information to buffer registration than we can fit
into a single struct iovec. This patch allows users to optionally pass
struct io_uring_regbuf_desc. Apart from having more space for future use
cases, it also introduces registration types.

Currently, the type can be either of IO_REGBUF_TYPE_UADDR, which mirrors
the iovec path, or IO_REGBUF_TYPE_EMPTY for leaving a buffer table slot
empty. The next patch introduces a dmabuf backed type, and can be useful
for other extensions like splicing a list of user addresses (i.e.
iovec[]), interoperability with zcrx, kernel allocated memory like was
brough up by Cristoph. Note, the type only represents a registration
option, which is distinct from how io_uring internally stores it.

The flags field is not used yet but always useful to have, e.g. we can
encode read-only / write-only restrictions using it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 27 +++++++++++++-
 io_uring/rsrc.c               | 69 ++++++++++++++++++++++-------------
 2 files changed, 69 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 909fb7aea638..98b259901185 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -790,13 +790,38 @@ struct io_uring_rsrc_update {
 
 struct io_uring_rsrc_update2 {
 	__u32 offset;
-	__u32 resv;
+	__u32 flags;
 	__aligned_u64 data;
 	__aligned_u64 tags;
 	__u32 nr;
 	__u32 resv2;
 };
 
+/* struct io_uring_rsrc_update2::flags */
+enum io_uring_rsrc_reg_flags {
+	/*
+	 * Use the extended descriptor format for buffer updates,
+	 * see struct io_uring_regbuf_desc
+	 */
+	IORING_RSRC_UPDATE_EXTENDED		= 1U << 1,
+};
+
+/* Buffer registration type, passed in struct io_uring_regbuf_desc::type */
+enum io_uring_regbuf_type {
+	IO_REGBUF_TYPE_EMPTY,
+	IO_REGBUF_TYPE_UADDR,
+
+	__IO_REGBUF_TYPE_MAX,
+};
+
+struct io_uring_regbuf_desc {
+	__u32 type; /* enum io_uring_regbuf_type */
+	__u32 flags;
+	__u64 size;
+	__u64 uaddr;
+	__u64 __resv[7];
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8af371ba6c06..406619158fbb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -27,11 +27,6 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
-struct io_uring_regbuf_desc {
-	__u64 uaddr;
-	__u64 size;
-};
-
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 						   struct io_uring_regbuf_desc *desc);
 
@@ -90,9 +85,12 @@ static void io_iov_to_regbuf_desc(const struct iovec *iov,
 				  struct io_uring_regbuf_desc *desc)
 {
 	*desc = (struct io_uring_regbuf_desc) {
+		.type = IO_REGBUF_TYPE_UADDR,
 		.uaddr = (u64)(uintptr_t)iov->iov_base,
 		.size = iov->iov_len,
 	};
+	if (!desc->uaddr)
+		desc->type = IO_REGBUF_TYPE_EMPTY;
 }
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
@@ -323,6 +321,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -ENXIO;
 	if (up->offset + nr_args > ctx->file_table.data.nr)
 		return -EINVAL;
+	if (up->flags)
+		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
 		u64 tag = 0;
@@ -382,9 +382,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 				   struct io_uring_rsrc_update2 *up,
 				   unsigned int nr_args)
 {
+	bool extended = up->flags & IORING_RSRC_UPDATE_EXTENDED;
 	u64 __user *tags = u64_to_user_ptr(up->tags);
-	struct iovec fast_iov, *iov;
-	struct iovec __user *uvec;
 	u64 user_data = up->data;
 	__u32 done;
 	int i, err;
@@ -393,29 +392,49 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -ENXIO;
 	if (up->offset + nr_args > ctx->buf_table.nr)
 		return -EINVAL;
+	if (up->flags & ~IORING_RSRC_UPDATE_EXTENDED)
+		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
 		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
-		uvec = u64_to_user_ptr(user_data);
-		iov = iovec_from_user(uvec, 1, 1, &fast_iov, io_is_compat(ctx));
-		if (IS_ERR(iov)) {
-			err = PTR_ERR(iov);
-			break;
-		}
 		if (tags && copy_from_user(&tag, &tags[done], sizeof(tag))) {
 			err = -EFAULT;
 			break;
 		}
 
-		io_iov_to_regbuf_desc(iov, &desc);
+		if (extended) {
+			if (copy_from_user(&desc, u64_to_user_ptr(user_data),
+					   sizeof(desc))) {
+				err = -EFAULT;
+				break;
+			}
+			user_data += sizeof(desc);
+		} else {
+			struct iovec __user *uvec = u64_to_user_ptr(user_data);
+			struct iovec fast_iov, *iov;
+
+			if (io_is_compat(ctx))
+				user_data += sizeof(struct compat_iovec);
+			else
+				user_data += sizeof(struct iovec);
+
+			iov = iovec_from_user(uvec, 1, 1, &fast_iov, io_is_compat(ctx));
+			if (IS_ERR(iov)) {
+				err = PTR_ERR(iov);
+				break;
+			}
+			io_iov_to_regbuf_desc(iov, &desc);
+		}
+
 		node = io_sqe_buffer_register(ctx, &desc);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
 		}
+
 		if (tag) {
 			if (!node) {
 				err = -EINVAL;
@@ -426,10 +445,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
 		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
 		ctx->buf_table.nodes[i] = node;
-		if (io_is_compat(ctx))
-			user_data += sizeof(struct compat_iovec);
-		else
-			user_data += sizeof(struct iovec);
 	}
 	return done ? done : err;
 }
@@ -464,7 +479,7 @@ int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
-	if (up.resv || up.resv2)
+	if (up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
@@ -478,7 +493,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
-	if (!up.nr || up.resv || up.resv2)
+	if (!up.nr || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, type, &up, up.nr);
 }
@@ -578,12 +593,9 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_uring_rsrc_update2 up2;
 	int ret;
 
+	memset(&up2, 0, sizeof(up2));
 	up2.offset = up->offset;
 	up2.data = up->arg;
-	up2.nr = 0;
-	up2.tags = 0;
-	up2.resv = 0;
-	up2.resv2 = 0;
 
 	if (up->offset == IORING_FILE_INDEX_ALLOC) {
 		ret = io_files_update_with_index_alloc(req, issue_flags);
@@ -882,8 +894,13 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
-	if (!uaddr) {
-		if (size)
+	if (desc->type >= __IO_REGBUF_TYPE_MAX)
+		return ERR_PTR(-EINVAL);
+	if (!mem_is_zero(&desc->__resv, sizeof(desc->__resv)) || desc->flags)
+		return ERR_PTR(-EINVAL);
+
+	if (desc->type == IO_REGBUF_TYPE_EMPTY) {
+		if (uaddr || size)
 			return ERR_PTR(-EFAULT);
 		/* remove the buffer without installing a new one */
 		return NULL;
-- 
2.54.0

