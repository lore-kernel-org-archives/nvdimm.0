Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F534A012F
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 18:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791309707; cv=none; b=F4oj2CWZqgDazUYhMRIOYO1wSJW9xWzbcQir81u5w1KzF2vETTgrElq/h8ncVCwEubMwe2vwYliJDVgYn9yu5Nbj/OLSdWRCX8tAjCJnu9Ol6v3px8gfWoY5ajfRMavmtI4WIIKO5sfnHJWq1fZRtpO2AXI6SjKjgerV4IcLrQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791309707; c=relaxed/simple;
	bh=DjhcPylcHhCqjFXAuyirPeUa+NH5Ei9QeLolft6Argk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=P8fB+VOLER+qMOKm7qaZyPMQp7Ypg3C2srejFCiiFclZBblo3U6D29wLU9E0M2TAnWtZFJzE9V/FXVl+Og0WmMbUydt21sbIuuhAHZZ0Seq4dqGRJy8YILSblL/cnyrL5kP4aBhtTUS9nLyc8186Np+EZQBIQRdvNK3sum2ncwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KeLFoopD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KeLFoopD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791309702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+EleZpynb4+a3XFu5iGO0EyTuAjdCIAH6pPcLUR432s=;
	b=KeLFoopDRUkQ2WxzpIsvZkXKpOmSxL+hj/QtJIizX7h+UHpUjz/VtnBOuIKQAop5uHZrNf
	wqDBFyE2S2Of8TuV1wkeZ+0BiPT7kKhYbpHs7J43Y6v6WZoLTzMdFKyaesBXKWQdEqMQs8
	HnNccFFTCe/h6dUtlsdD/3hqQ8JCYqc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-zRd-A4WkPraEu9YG_fHaUQ-1; Tue, 06 Oct 2026 14:01:38 -0400
X-MC-Unique: zRd-A4WkPraEu9YG_fHaUQ-1
X-Mimecast-MFC-AGG-ID: zRd-A4WkPraEu9YG_fHaUQ_1791309697
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c2e2a9fa1fcso394733366b.0
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 11:01:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791309697; x=1791914497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+EleZpynb4+a3XFu5iGO0EyTuAjdCIAH6pPcLUR432s=;
        b=0qbZyAR1xG3xGWrF25QgUKucAMGONrL0dSWl2j3M/0yMC84pW4mphrFu1phy54F+TY
         BLQJ0JAeNxUZ+n/uX4sCIflOaq9xOTwpp2Or2tF2TdFOK1gRndNal6akaBLIJPkliGUx
         MzwcrcvYA+FkI05wLzmrp+bEoIuaROiB2lFzyb/scNCt74L2WCjQaDB7q1Et8FFvXknl
         mo+pFWwKIzRJxKrTCjYeODKX+EP8/4OH/nchso0jYvcWPlYnXqb5J74gVi754KwR3SQ9
         CGEmPQIbvnAHgqmXZgUQN88i77gKRUitZx0LcyEsvK7Hqm+1Q7cccozUIrV57HVA8yeA
         7wXQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1y39WzqnHYDhlVbMUak/akc+NX5asyDWwAhznHgme3hWvSmgtrZYIeFK4WG2cloD+Q33BNXY=@lists.linux.dev
X-Gm-Message-State: AFuF++mFDZZRuDkXx1wgIEQs7xZY88SResQdyATstK+t354YxrBbRZEb
	10Ys+M6Zgj/FfFpN6NEUMUSyW4cxn5yFm6zh5J3uDL3wXAN6LqZgytM1/FnBexHZ0qpl2f1kpYC
	xteQWqngyiWNM0Ln8x5c2axjaS4v0GDk9ZW+O90xnbHw5xofHwAGVNj+wMA==
X-Gm-Gg: AYBFou0lm8F+FDX4SeVHplNPWWKLsKxpoSKXmljBB9jQc7PVbAr9YlxmVjvhykO2cr8
	bh88kgOvqN3YA3Ku8/yg6WiELqa8Rk4OjeY1kNNNeQztkqAzSZ5srfEpeQoo0iQ98w0H88gQsoT
	ID4FLLUYOVZDAg3pcnHRvTGkS1aN5Aju70qOKn/jjJw+VTzRD7FmDlTJHniYZPXQ/imvmz7b+dg
	rTa3ErQKYk0EnJteyOZShCgpNUDDqjp6AIJ+Y2sTtM06srM/RzcIqfJjsD+6L+J46e99305yeaH
	q/3v3uJdKqMHSpaAGfEcrCphLSOT9bo9yrLpTPP/ElSzokE3gUd2mSAP7e2SgWHa10zXrvytvVD
	gXj2iXUga5QNSPN66EWXggBhtcVCRc41e7gczHwdSxhVY++VV0rBtIgEO
X-Received: by 2002:a17:907:3e07:b0:c2b:4142:2db1 with SMTP id a640c23a62f3a-c316a0c01b1mr244832066b.40.1791309697154;
        Tue, 06 Oct 2026 11:01:37 -0700 (PDT)
X-Received: by 2002:a17:907:3e07:b0:c2b:4142:2db1 with SMTP id a640c23a62f3a-c316a0c01b1mr244829266b.40.1791309696784;
        Tue, 06 Oct 2026 11:01:36 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb01e5942sm5056684a12.9.2026.10.06.11.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 11:01:36 -0700 (PDT)
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
Subject: [PATCH v3 9/9] fuse: add support for striped backing
Date: Tue,  6 Oct 2026 20:01:14 +0200
Message-ID: <20261006180115.1425232-10-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261006180115.1425232-1-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0NIJe2XXkM7wWAkC-h6SRAl37qhg0URoJEsB_2EY6dQ_1791309697
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
index 4f418185c0b7..049e0b4514bc 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -109,12 +109,18 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
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
 
@@ -127,9 +133,15 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
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
@@ -256,6 +268,7 @@ int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_o
 	struct fuse_backing *fb;
 	unsigned int i;
 	int err;
+	u64 chunk_size = 0;
 
 	if (!arg->num_extents)
 		return fuse_EIO("no extents");
@@ -273,7 +286,18 @@ int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_o
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
index 5d38dc1b6f0c..cd10156e09d4 100644
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
index 3bfedd0cdbdd..31172de72477 100644
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
index 60060da98e8d..6b2fe68b4ab5 100644
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

