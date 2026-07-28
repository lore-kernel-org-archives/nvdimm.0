Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385147CC70
	for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 21:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274207; cv=none; b=YnftUNXQ/tLGeafaBJXonyZ+8d7bGvLIXlRIHfEH6uv1boCg/rBpiu1aMyoJEujP8aXYSnpkror0gor1Iu5Ul0IFQKGszS0Va1XPI/0j8MGYkJ8c8kkPKQ8Mxt39VMNQUm6kizHMXQN4fg0P0rSiXIl4fi14BlImlLGPpqAnbTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274207; c=relaxed/simple;
	bh=oZ3BFAy9cLxeqXthNExBNBD2GMUwMIJfwvoNUFcW7pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3vmk7SV1pAyCdgxAjNM+uM39pZYPum7267SOKhkpIizLnPDNTxtoa2YLztgqqhY95f9iXteGw5G//XAr5CPZwjb6sGHzKu2r90ml6MxV/sQ2BCJ0JBEeLrcj2txtEGsqLgVCM0uEDVl5ZyjZtRpWaDXLxzYpRTpty+lIh+5tN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dahnZPrh; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dahnZPrh"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47de008b020so180584f8f.1
        for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 14:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274203; x=1785879003; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/6LlJ8gBFfbSI101GpfmueMUxhwNSOZCGEsyX/W5uwU=;
        b=dahnZPrhH5JmwrKyidSVL/5TwidVaFJxDgq691fd7n9PLWCeeD6I1GGtcB143ygIS3
         8MBRJ/g8h5TWPy1/JVYPpOrd9G/UgRCmF6Q0w56Lm/ra0cYhMmwFwkuC+y3FveSGSUNS
         sgdL5U14miRU2/G9m3aJFMI3X3Wvn9PhCgRrmQQ460AQ8a59Xl1XTVOSEtQewBqEkhyL
         SX6S+Xnm0KsnFtaSNujIjmv3FNu6iO0YigsxYR8MIdzo7M2l1wsSY0tzNwDFPORdP8ze
         sHzrUKE0n9K/vVfOFbUIh9+U8qTcy2J6gqoViUqFKqoHHXj4rG2krPSSh9dlteI11Zm9
         kMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274203; x=1785879003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/6LlJ8gBFfbSI101GpfmueMUxhwNSOZCGEsyX/W5uwU=;
        b=EMwQhWCNlS8BHg2rc9bpKAmjJZAHS/sYwlaxHe38+8MbmSz611TDPdF6oKs9u3BXzj
         1Xv6kyb9dzZVo7rSiYH/aQKTNBD/q4GVxMQxM/ZlyhRyaFgFmsIDmui4L4unUTn1dMW+
         8JZhNhmsZbSN+wI1L+oefJvwjzUEQla2UDXAlwvuA0EW/VlVvQ/G8khjEwEiq/C14xwP
         4FQvXlAaNPi3q4L2EAC3LyvUTPhAYUJMVkfEUplZ+8TnGh1s+TL1WSXJtAPeUCI0cvf4
         JevOQtnfhqwit11zrdnz/vncd6buO7DlmAAsOgdeKqqfs0f8pcTgDdG3tyQbT+OQEp50
         9UDg==
X-Forwarded-Encrypted: i=1; AHgh+RrdvLtgfS0oex1efuXOIkAaLhvDkTNplrm7y8hEAL/eQzXJzDUSG2LANpaPBgRbEyDj2ghmrH0=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywj2Uh9milzv35Id+ve2+LQ9sYfjvuKNHK0CWIu5KsGDVyXGn+6
	4utv2fc2u71KsGRyo8/m4YwUIxAsZTGnhmDrELLhKuO1rf5fF6DJqrb7
X-Gm-Gg: AR+sD11AftceBwP2D4thevU7aymEpsUANKJ0jIsRRaGX43b/LPLpZsjlCzlVcCBgLPi
	hcHmahjnqKNnFjKZ9/UCznbB00F4D0hbe2deF+1C6JSAgwOq19fkWAuQcGTxRln3AfFhuo2nzOU
	2VH3H5hgl+RXS+/pVSdm7k1H1XRvg7hng4hhBsRrFR1NwRoy3sR84Mb459SqFYZKmZqEYriVUbb
	mlLLUJ2u/53stuowhyvddBMpbkQfsO7SZBeTnZ1ZRFBpikqsbp7Ezap7SubRIgky9bqbo5T4uCO
	ay+FY6RqlJP2gY95dgU6pSoeu5SVQdc5lRXyPeSf1c+bEIMe4/231OJjpr1F17oIZLBYZjv00ok
	v4UDmNh1QlPwQ2Rq27NRxmkA7MFknnsVYNdRdQt/tdf6WQuWr/7S4NKxv1lrppuAc6mpQ0rmvrd
	nG5PXPga5bXdeuqZqxj68GqHwIiH2zWh4cs6StwIY+rxZDcO3vr3XUoxd40MtAznKDIUGgypyzc
	Ku5Ep/8
X-Received: by 2002:a5d:5f42:0:b0:47f:93e8:af81 with SMTP id ffacd0b85a97d-47fb1e913femr4235891f8f.10.1785274203054;
        Tue, 28 Jul 2026 14:30:03 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:30:01 -0700 (PDT)
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
Subject: [PATCH v4 10/14] io_uring/rsrc: introduce buf registration structure
Date: Tue, 28 Jul 2026 22:29:22 +0100
Message-ID: <41eda7b5d52e11d307ce4218397763538c1594ba.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to following changes, instead of passing an iovec for
buffer registration introduce a new structure. It'll be moved to uapi
later, but for now it's initialised early from a user provided iovec.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8d0f2ee24e0c..8af371ba6c06 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -27,8 +27,13 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
+struct io_uring_regbuf_desc {
+	__u64 uaddr;
+	__u64 size;
+};
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov);
+						   struct io_uring_regbuf_desc *desc);
 
 static int hpage_acct_ref(struct io_ring_ctx *ctx, struct page *hpage,
 			  bool *acct_new)
@@ -81,6 +86,15 @@ static bool hpage_acct_unref(struct io_ring_ctx *ctx, struct page *hpage)
 
 #define IO_CACHED_BVECS_SEGS	32
 
+static void io_iov_to_regbuf_desc(const struct iovec *iov,
+				  struct io_uring_regbuf_desc *desc)
+{
+	*desc = (struct io_uring_regbuf_desc) {
+		.uaddr = (u64)(uintptr_t)iov->iov_base,
+		.size = iov->iov_len,
+	};
+}
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -381,6 +395,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -394,7 +409,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		node = io_sqe_buffer_register(ctx, iov);
+
+		io_iov_to_regbuf_desc(iov, &desc);
+		node = io_sqe_buffer_register(ctx, &desc);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -853,26 +870,26 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov)
+						   struct io_uring_regbuf_desc *desc)
 {
+	unsigned long uaddr = (unsigned long)desc->uaddr;
+	size_t size = desc->size;
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
 	struct io_rsrc_node *node;
 	unsigned long off;
-	size_t size;
 	int ret, nr_pages, i;
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
-	if (!iov->iov_base) {
-		if (iov->iov_len)
+	if (!uaddr) {
+		if (size)
 			return ERR_PTR(-EFAULT);
 		/* remove the buffer without installing a new one */
 		return NULL;
 	}
 
-	ret = io_validate_user_buf_range((unsigned long)iov->iov_base,
-					 iov->iov_len);
+	ret = io_validate_user_buf_range(uaddr, size);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -881,8 +898,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
-				&nr_pages);
+	pages = io_pin_pages(uaddr, size, &nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
 		pages = NULL;
@@ -904,10 +920,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (ret)
 		goto done;
 
-	size = iov->iov_len;
 	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
-	imu->len = iov->iov_len;
+	imu->ubuf = uaddr;
+	imu->len = size;
 	imu->folio_shift = PAGE_SHIFT;
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
@@ -917,7 +932,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
 
-	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
+	off = uaddr & ~PAGE_MASK;
 	if (coalesced)
 		off += data.first_folio_page_idx << PAGE_SHIFT;
 
@@ -969,6 +984,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		memset(iov, 0, sizeof(*iov));
 
 	for (i = 0; i < nr_args; i++) {
+		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -992,7 +1008,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov);
+		io_iov_to_regbuf_desc(iov, &desc);
+		node = io_sqe_buffer_register(ctx, &desc);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
-- 
2.54.0

