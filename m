Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A2C4DD3B7
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 15:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163862; cv=none; b=cI4e/oCiYGrPl+OC+pEgK0aPWF6sRK66XBlvIzYK81X7Pi1ox3J1ZaBXwPVLTYVCKbzt1J1VtZ/Y0LHxTG92phml7FXranzt4OYM8ZOBPnpaKWwqgDOodJoaITIPZLDDQW++Gh+OvYKDe8p2HfxvFPcqBsXLmgXGoPrxYIuU0X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163862; c=relaxed/simple;
	bh=7BUL7LrIJwKZfLyXB8aUZj3zJf1dl2EUTwhnYn12Z7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ReHbfAtXr8mV4xyjHwOctl66yg98H5OqfHysaP2twJAI+2Qpj7S29V1nai1/Jf1cvgiQRLSkVP0KJIl0Mhva7G0pc8ikQRJlbgJzylRvloVo43xA+uXhVmydNg+tFG8PujjyLQEzd5u1zZXTsixQaFrFb0CN8Z/s1g0/CbGnJNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSEZ0yPH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSEZ0yPH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792163856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wi3n3JQ/cHKeUcsyNYS5wpcW4DOqjpEHfKPbOyr8HiU=;
	b=dSEZ0yPHJKB1cU84bt859dqyFgLT4OAj3CrryhZD+xLDLt5MRSbauu4JrYDjEKebw3SL5a
	rkLm3uy72bUYWmw7h3PNvVf+vGr6Rp7/fBp/5dIVHngIf4xtzkdBmfdxMSXFCFFV71pNDe
	qmrCAb1dy3oFksNfmZnLLH7MLBj5B7Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-3z-zTZmZPBWLLUF92E5_JQ-1; Fri, 16 Oct 2026 15:17:35 +0000
X-MC-Unique: 3z-zTZmZPBWLLUF92E5_JQ-1
X-Mimecast-MFC-AGG-ID: 3z-zTZmZPBWLLUF92E5_JQ_1792163854
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1813fea7dso603525e9.2
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 08:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163854; x=1792768654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wi3n3JQ/cHKeUcsyNYS5wpcW4DOqjpEHfKPbOyr8HiU=;
        b=x1vV4k8cWGfLQBY2dZe1CGTHQB0vvwOIeROaSA7fsZ2YAXA4YSenVhtVetIl0u1NXF
         9ywKbvwBE4IXCC5SRNKYYlH11Ce2EDo2xzipgTbnu0wbBDKh1iwVEi8HxiPchXcCfRFX
         YJI1EL4amewVhexdLyIR5rDsmBxZq4lC11wFflTWATcyWzip9RuUo07WfM+2btSFomtK
         R5KuKRfO41Ue8ZgS9w0ncXnmgd7B4Wrhfn8T2QRKKKcWwwVCm7KC3yxigwaa3V7mRRRN
         g++itmfsqW5h9GKNeUbYyQ9fpopE0sSWHwzYOR7pviOA+1pI57gQ8w2+QT4yTym744qY
         N6Cg==
X-Forwarded-Encrypted: i=1; AKwUvBxNQfVaZOtgNBYkPfA2UcPuigdQwJysrzz5RxUVm3b9X7vRoF+lUmrnX2S7xFdUhb8IRV+btF0=@lists.linux.dev
X-Gm-Message-State: AFq9FYKxooywY8qISTop5WZjfD9LLCmvxzxeOrARBr8iVXpL2dejFe2/
	4GNCrkh3ftWvWM5DKQ4slksuTNCkV38i/CYstwvTLFjgeCLwyALUF+VOJK0oFQA8THIo5+mNjcK
	iAJVdAIpdq3xQ8k/vQtLVjNb7Vu7YGzCXtvssmwe1KgqzjcjlwPGg3whZNA==
X-Gm-Gg: AYBFou116zzc7xAIAbuqVtVAJAn7PCuZx7SQFie84fqonFTM+itWC1zQM7CPhzWsiF6
	9IBSCZb0rxYm5x6xvwOOH49ak7+8T1+x0ZORSGtvYwvv04jQ+rkXPo91ya9wysyqbdFgOhTFQ2L
	L7+yWLGeHAwK+2IAEqoz9goLAREa8LTQtSkjDRk8eTsCSDAvkZId4Z7atkIci/Vl6HVHdg0d2fX
	C2Dp1kmpAiLtD0s7/aNZBhRDaFBpbMl0smHx8dyncewdKFDFJMbwr9U+OXcfwlMtsmcViI9OdtQ
	8aDB8KxL8aqRsbw8LsX4LuhjAGuoaCcGr0i8/aYcnJwzjHrmPVObkUqKadbuee28Yx/nFvu5rAE
	wVkhHkKFSw/28goZCpbOkDA==
X-Received: by 2002:a05:600c:c084:b0:49f:d6f0:6f24 with SMTP id 5b1f17b1804b1-4a1d75af414mr2646065e9.2.1792163854055;
        Fri, 16 Oct 2026 08:17:34 -0700 (PDT)
X-Received: by 2002:a05:600c:c084:b0:49f:d6f0:6f24 with SMTP id 5b1f17b1804b1-4a1d75af414mr2645825e9.2.1792163853710;
        Fri, 16 Oct 2026 08:17:33 -0700 (PDT)
Received: from maszat.com (85-67-2-18.pool.digikabel.hu. [85.67.2.18])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8de7230sm64621665e9.14.2026.10.16.08.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:17:33 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: fuse-devel@lists.linux.dev
Cc: John Groves <john@groves.net>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v5 09/10] fuse: add support for striped backing
Date: Fri, 16 Oct 2026 17:16:36 +0200
Message-ID: <20261016151638.2962413-10-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261016151638.2962413-1-mszeredi@redhat.com>
References: <20261016151638.2962413-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kyk0s9mNB1ekHmazqnQItYWNTTfeTlHlYZlYrGx7eWU_1792163854
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add the FUSE_BACKING_MAP_CYCLIC flag for FUSE_NOTIFY_BACKING_MAP
notifications to enable creating striped maps.

This is just a set of regular extents that repeats after the end of the
last extent using a striping pattern (i.e. on the target backings the
stripes have a contiguous footprint).

Two additional limits apply compared to non-cyclic extent map population:

 - the size of the extents (chunk size) must be equal

 - the extents must start from zero offset and follow each other without
   gaps.

Originally-by: John Groves <john@groves.net>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/ext_map.c         | 30 +++++++++++++++++++++++++++---
 fs/fuse/fuse_i.h          |  1 +
 fs/fuse/notify.c          |  2 +-
 include/uapi/linux/fuse.h |  5 ++++-
 4 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
index 744940cbf36e..7adb78cf552d 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -103,12 +103,18 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 {
 	struct fuse_backing *fb = fuse_inode_backing(get_fuse_inode(inode));
 	struct fuse_iext *fie;
+	u64 ncycle = 0, seq_off = 0, addr, tmp;
 	loff_t ext_len;
 
 	if (!fb || fb->type != FUSE_BACKING_EXTMAP)
 		return fuse_EIO("missing or wrong type backing");
 
-	fie = fuse_find_extent(&fb->extents, offset);
+	if (fb->cycle_length) {
+		ncycle = div64_u64(offset, fb->cycle_length);
+		seq_off = ncycle * fb->cycle_length;
+	}
+
+	fie = fuse_find_extent(&fb->extents, offset - seq_off);
 	if (!fie)
 		return fuse_EIO("missing mapping");
 
@@ -121,9 +127,15 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 	}
 
 	ext_len = fie->end - fie->start;
+	addr = fie->backing_offset;
+	if (check_mul_overflow(ncycle, ext_len, &tmp) || check_add_overflow(addr, tmp, &addr))
+		return fuse_EIO("extent address overflow");
 
-	iomap->offset = fie->start;
-	iomap->addr = fie->backing_offset;
+	if (check_add_overflow(addr, ext_len, &tmp))
+		return fuse_EIO("extent end overflow");
+
+	iomap->offset = fie->start + seq_off;
+	iomap->addr = addr;
 	iomap->length = ext_len;
 	iomap->dax_dev = fie->backing->dax_dev;
 	iomap->type = IOMAP_MAPPED;
@@ -259,6 +271,7 @@ int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_o
 	struct fuse_backing *fb;
 	unsigned int i;
 	int err;
+	u64 chunk_size = 0;
 
 	if (!arg->num_extents)
 		return fuse_EIO("no extents");
@@ -276,7 +289,18 @@ int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_o
 		return -EINVAL;
 	}
 
+	if (arg->flags & FUSE_BACKING_MAP_CYCLIC) {
+		chunk_size = ext[0].length;
+		err = -EINVAL;
+		if (check_mul_overflow(chunk_size, arg->num_extents, &fb->cycle_length))
+			goto err_put;
+	}
+
 	for (i = 0; i < arg->num_extents; i++) {
+		err = -EINVAL;
+		if (chunk_size && (ext[i].offset != chunk_size * i || ext[i].length != chunk_size))
+			goto err_put;
+
 		err = fuse_add_extent(fc, &fb->extents, &ext[i]);
 		if (err)
 			goto err_put;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 8419a4d3451b..4a63268c4b25 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -110,6 +110,7 @@ struct fuse_backing {
 		};
 		struct {
 			struct rb_root extents;
+			u64 cycle_length;
 		};
 	};
 	u64 backing_id;
diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
index 90d1f5c053e6..984e4945e3e3 100644
--- a/fs/fuse/notify.c
+++ b/fs/fuse/notify.c
@@ -461,7 +461,7 @@ static int fuse_notify_map(struct fuse_conn *fc, unsigned int size,
 	if (outarg.reserved[0] != 0 || outarg.reserved[1] != 0)
 		return -EINVAL;
 
-	if (outarg.flags & ~FUSE_BACKING_MAP_CREATE)
+	if (outarg.flags & ~(FUSE_BACKING_MAP_CREATE | FUSE_BACKING_MAP_CYCLIC))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 43a92d834cd3..616430a2973c 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -255,7 +255,8 @@
  *  - add FUSE_DEV_IOC_BACKING_CREATE, struct fuse_backing_create_in
  *  - add FUSE_NOTIFY_BACKING_REMOVE, struct fuse_notify_backing_remove_out
  *  - add backing_id_64 to fuse_open_out
- *  - add FUSE_NOTIFY_BACKING_MAP, fuse_notify_backing_map_out, fuse_extent, FUSE_BACKING_MAP_CREATE
+ *  - add FUSE_NOTIFY_BACKING_MAP, fuse_notify_backing_map_out, fuse_extent
+ *  - add FUSE_BACKING_MAP_CREATE, FUSE_BACKING_MAP_CYCLIC
  */
 
 #ifndef _LINUX_FUSE_H
@@ -1219,8 +1220,10 @@ struct fuse_notify_backing_remove_out {
  * notify_map flags
  *
  * FUSE_BACKING_MAP_CREATE:	create backing with the supplied ID
+ * FUSE_BACKING_MAP_CYCLIC:	map repeats after last extent
  */
 #define FUSE_BACKING_MAP_CREATE	(1 << 0)
+#define FUSE_BACKING_MAP_CYCLIC	(1 << 1)
 
 struct fuse_notify_backing_map_out {
 	uint64_t	backing_id;
-- 
2.54.0

