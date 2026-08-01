Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EAB3546C8
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599510; cv=none; b=iFXgwpwLEfbRr/hJgW+aJTH6r4BYnlzaBEC5P4W7lE3V/xAxyvVLFsg5gSmzmi02iDMY+vSdiTe3acfgeztjdKprbypbPqyu4EHSqsyKSm7moW3ck+6ubLzQpDTzIbZQoYV8EcUL4mxd153A5e7ysea0ESr9x8Sq0qPINoZ8zaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599510; c=relaxed/simple;
	bh=PHUqDIjZ/fDz2a0/0v9uQuWQT4kuiEnCn87yNoeA1yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceyifdA5bUClvJbDPSQaKkrcy4C3enoNl+neSOXUnCzBv/X2TqduG7VJ1UHPj5Gr1L9NGmie0qWAAbux0UxlM/mU2N0x1HFP0dt9s0AgTExi2DiuXa6R697wu3R9Oq2lZZpK3OCkDaOnTg62CXynyf7ZTNcQk9x92yvvSzo8XTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E7dhYcwA; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7dhYcwA"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cf27856f9cso20477505ad.2
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 08:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599508; x=1786204308; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ijUzk6DmoV2KfP6NttCifTbOeJnZ78uDbymc6z2HdV8=;
        b=E7dhYcwAKKVHlFekDjuljZLqcQsnNDCo7VcCOdtVAD+K5sf6TgU4pFRtsx/2aAfBv8
         p85Fw2+NWdALohnxdYd5nAvTk5bAaOA4dYpjzs8s8Lc0l+6KGNWUTO24KmP4rbZLvL0g
         2/wsqulCbml4v2KJaFrOZ5HCHrunx1otW/PbkZWwv2VCa+AEv91YN6GjjKFUPhoxkAxL
         BldfKDc0UKQNTeItFWCmQrRPScWe3qeZAK3leV0LQcUiAZzFmTQSE5fWuKYzH3wRzFBm
         KmhUNjPD2XzGFgblJoIdyAenuzEsLHlpilmHDQlzvwAdJs0JG3pD38kg1GcMcELJH6fY
         Is3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599508; x=1786204308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ijUzk6DmoV2KfP6NttCifTbOeJnZ78uDbymc6z2HdV8=;
        b=ddZCKjKQ+j9iYMSjOYOielIyY73ZVEoJgywrlGzMm4dU9bt1raUW+WDtkusbRtirHz
         pGfzIjNL0QtHSiO0pGGULp3Uncp0RoP9/6PBaw5ZKxQr6jkt9v26yehF+L/W9tAdeeUZ
         f4jqbfxyvzbart2kvIqI1F0sbK98J6j58nxAd+wv8wGAHmHmYawxFEFK+JEn5aErWEVj
         rx3lDyYPxRYJZLPldVmqLEumo1jIbfNYKFPHK1A5hZKlK3S701fSgrrvXtrBcqHfH+mG
         9mhQqbpjtdrml7Llcp0sFhxDycGa6ZpQsXAtnc0CZaDsyvIgG3r41vIwYim0IceFh++a
         56Qw==
X-Forwarded-Encrypted: i=1; AHgh+RqsBWXPCYsk58hXWC7lmKaCwF67X8+kEVgRKleEQMZD5CKEmBfq6jgWdCLPCiOv0rKB5MfthXw=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywq5X+x0swgrc48OlSYnaMPq1rdP2Yy6LTj/5G+4/BSo4COIBzw
	UbrPmFVPjeAKWPxwx0p6K+5SDgmqrrDg1QbT8f3YWhPgeruYr+GEvIbd
X-Gm-Gg: AR+sD136xbUdc3Ezfuy662bAnppbCpi4uoRsD7f/MeJpMGDYv2UmsbNIBj/+6k3OWTE
	E3PIxgbfH2iLSJrIwUY4l59uTA9y/5SflyXfCb6lRUjD4iLdCkq7KifG7MtAts4DOQ77vv62LAS
	pQnN5iCGEq58Srd1uNzmp2FM63gdgkKSAU/xRn9JQjj619d6TiWM7Ub+wSp3FR16SLxWfliKgGQ
	gbP0LBuR2SmYmrf90FgdbqrOD1Y0N03uRj4vzgfsjaN0YBhwTYAIy+L9PK5j8Fuk8WcQLFKa5jt
	4tclLw/S0n6HrY0gXAMnfjdDM6CVVea6wmDGp/a9bRSSqgtWHfbioTNbfruBr4DzuBsMLBFfVxf
	hfCyJDFa0OoXvPB3YC1Z+RwW1qbv0j3X3nIcMsBR4B3FbTrhVnkvv1HLg8DsgF5Hd8ivfl5enDC
	qvRavzuIW+Q1EHEnsJzlGjZXczh/8ONvnFBzj3qd7DlnKvVxEA6VOmMgtv2Rh5Q2FKQ9ld0BKZr
	iOq5pcM68/+W6UWwdfmiPvKMvKr3jwZbwkeUt58e6vkzR58cNWG+noc5CU=
X-Received: by 2002:a17:902:e945:b0:2cc:9179:335 with SMTP id d9443c01a7336-2d0521e87a4mr39523185ad.8.1785599508438;
        Sat, 01 Aug 2026 08:51:48 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:51:47 -0700 (PDT)
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
Subject: [PATCH v5 14/16] io_uring/rsrc: add uncloneable regbuf flag
Date: Sat,  1 Aug 2026 16:46:26 +0100
Message-ID: <65be6058af60c33328f9ccd8133d24e2bbbd0f84.1785596451.git.asml.silence@gmail.com>
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

It's hard to implement cloning if the internal structure needs to be
mutable and/or relies on other ring resources. In preparation to such
buffer types, add a flag indicating that the buffer can't be cloned. It
might be possible to add cloning in the future for them, but that would
likely need reallocating the structure and reacquiring resources in case
by case manner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 +++++
 io_uring/rsrc.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 406619158fbb..f041b0db77af 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1381,6 +1381,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node = NULL;
 		} else {
+			if (src_node->buf->flags & IO_REGBUF_F_UNCLONEABLE) {
+				io_rsrc_data_free(ctx, &data);
+				return -ENOMEM;
+			}
+
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				io_rsrc_data_free(ctx, &data);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 98ae8ef51009..83aa86e6f320 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -29,7 +29,8 @@ enum {
 };
 
 enum {
-	IO_REGBUF_F_KBUF		= 1,
+	IO_REGBUF_F_KBUF		= 1 << 0,
+	IO_REGBUF_F_UNCLONEABLE		= 1 << 1,
 };
 
 struct io_mapped_ubuf {
-- 
2.54.0

