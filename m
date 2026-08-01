Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C63C30CD95
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599531; cv=none; b=lNRqDEk05AEhDjR6HZ1UHOmbPvFh6VxT1qJzvdKVTFItshHPHhe3kunotuzPH5qSCy1L08OFnaj0jiDW35oWaxMmJakFNWaExCDLCfkHYvE8OJhjNk0D6jyXjHw7vA0II/BX7/TFcfiDf8h4irKjInJ6ntSxflDayeCwYlLA7HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599531; c=relaxed/simple;
	bh=7qlj+n0xMTYMM8wbxh5YbBlihhCnKaVVIBe7eTfypEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HP13LceYVjJgh+gJZp4HmnkZ5kpqv5OXYg57NcpPu9EqjsFQ08tIHTN2bb6i7vnDc3luqbjyxwzw75LxDn57ExHvCqTdCIpXfJHRLstehFZ6g9xag8i/p4O0tAqa/RmChBmD9iKvVPi3XzAQ7O3QGumiddBPk+04I4byx8AQsp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kCRBigG/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kCRBigG/"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cea3004256so22572885ad.0
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 08:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599530; x=1786204330; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4DE9iwPHyfteVjhRD5r56Chvjj2EVxXiQr3A0KjARNc=;
        b=kCRBigG/wze1jbBzVrHUglgVqjHSU5LE/9xNCJf0f8Jjk9SgpPWR3NWOAV7Ho8iMHG
         ZZVotNe4G8tfH+OKeG6VHoqSC5iZl28dpcju4zo1eA9GF0PNiKKZwuQVGDrVq+SO6qm8
         MV1JJhwqrztpgV7XnA12HS3AHJOMeqmQ1TQ5CV2gw/gzonk3pH5/TPUS3z4A4MxjMCif
         GuOjt+zpsJw1tzcU5rjNA6Y4/96sqtU27LgsJgLELdpNQf+HMvjvi3ad7dm+/BFtNZJG
         887xx7N3kNbjynn3lddyCL+ajmPy6vbMNhBkiA3EUJZYYIk0KSJ+C1If8mDofPuUQio9
         PMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599530; x=1786204330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4DE9iwPHyfteVjhRD5r56Chvjj2EVxXiQr3A0KjARNc=;
        b=bDMCxr2hClG7rQOu7DxEkhuVgUpnHE04+0HvxKWuEyQYzB9k8uwEJM9qkap4NuKJaH
         7IALY7Mu/F8tpP2c2/6ex4TTsD0yVJstrzakN6ObYK4jCUy+qkZdrNsxM7CQwGn+WhhE
         V+UrOXQxCgkc9U2UkSL6Hs25C17jbhirukoZ7hqwMmRzhmpBZndOq5GEOQh/tqhEZnOZ
         n8JmT14ZiGqUljg57wKSaR/GNV59pl7m96WVUhBmEKQ3yntu93dBji7Xai02FH52lwHO
         Df6NI44UM3XGB4UtN+nlcmIIc4nsQRFujuQ50drirPIAKmWpqYyZ/CYI8xltIOkOLrNT
         OxWQ==
X-Forwarded-Encrypted: i=1; AHgh+RoR/BhA3EBgcolG9dxjiKooJUGmwYnlrqriFXl7UGpVHhP6OI8aoP2/znzmmZGG4mJRbrAOQv8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSw6QxRv5YpG3cuRwq6mXs8lyuPOXnjYGtTBRq1tdK2NUa/QN/
	uVdZyBNFL8SQoZrWfyaX1VeZhGCzHW3b2pAnwHJZ/kc6AjwSNQnS1wDZ
X-Gm-Gg: AR+sD12rQZJWPY1/SRzzfXEtg/tP1Tooxcl3YsHf0vEE4B4IUFdqUXgLHXMx8JKmJwc
	noU7tGejJj57lIx78dyEC+HwjWW3OCNzSmCwolC3mtp3RjsOG0uGY/CjOks009/jO6eCj/tNnnd
	94Az74+mAQb615+fwZgwULsI0TDDv7JkRxCnVee0CD9rsc8BC8AOv6ML8sZBqzEApJHYNTR4ND6
	mTgtZzgxrzY7+Q5t1MhTgSGYuwappHl6332KJyybAEyg3WNYuGi36Y0puzejUfZbSZJKGvIHQPp
	dhsf7UTg4g4QSZ5Jibxb1SHt+mc4fbIXwhpsYwVwjSsP/AYVU6RBWadKex/KmfK56rGOJRryZ7b
	TBZQpdO03otHEU8xi1jjuYNalK0PNnyeECK7o+9IORYdXa9Mq8sInnnlQlWir7rN7HmoxEE+ig2
	4h+zO6xhXAQxuyJqa23y8ILDeUg+YFq9fjHqldIEayc8YIFitjOsHfB/sRq2YFAPv3058KiaU02
	nNj3SYEJbVX3VDkHsIUi64yuGcn+3QixCnbPAOR1ukH4w4=
X-Received: by 2002:a17:903:1aa6:b0:2cf:32bc:9722 with SMTP id d9443c01a7336-2d0524671d5mr36849685ad.34.1785599529680;
        Sat, 01 Aug 2026 08:52:09 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:52:09 -0700 (PDT)
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
Subject: [PATCH v5 15/16] io_uring/rsrc: add regbuf import flags
Date: Sat,  1 Aug 2026 16:46:27 +0100
Message-ID: <ddd0458a78fd1666fb109993668afb01d35bd155.1785596451.git.asml.silence@gmail.com>
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

We'll have special registered buffer types that can't be used with all
opcodes and need special handling. Add separate flags to control
registered buffer import, which will be used to specify what kind of
buffers the caller can handle.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c |  8 ++++----
 io_uring/rsrc.h | 24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f041b0db77af..fcdc4edd2858 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1245,9 +1245,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+			unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
@@ -1656,9 +1656,9 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	return 0;
 }
 
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags)
+			unsigned nr_iovs, unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 	struct io_mapped_ubuf *imu;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 83aa86e6f320..f12abaf63270 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -65,12 +65,28 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 				      unsigned issue_flags);
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags);
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
+			unsigned issue_flags, unsigned import_flags);
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags);
+			unsigned nr_iovs, unsigned issue_flags,
+			unsigned import_flags);
+
+static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+				    u64 buf_addr, size_t len, int ddir,
+				    unsigned issue_flags)
+{
+	return __io_import_reg_buf(req, iter, buf_addr, len, ddir, issue_flags, 0);
+}
+
+static inline int io_import_reg_vec(int ddir, struct iov_iter *iter,
+				    struct io_kiocb *req, struct iou_vec *vec,
+				    unsigned nr_iovs, unsigned issue_flags)
+{
+	return __io_import_reg_vec(ddir, iter, req, vec, nr_iovs, issue_flags, 0);
+}
+
 int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 			const struct iovec __user *uvec, size_t uvec_segs);
 
-- 
2.54.0

