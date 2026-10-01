Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF473A48E9
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 15:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867401; cv=none; b=Q3MBFzJLJtXv8+f43vvTOixWEl6Uup1OnZy2sHGRpJQZSSkS7c0qC+g1e/5sqUIbEwlZBKG9onqr8zwD934K6QTryN8sEv9fbEwOqgTVr6rV4UawwVow1tIrfGBkQrWu71qAw61jsdG3mclxnhY2QVSvQa2CmfeI/iH1i8SevdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867401; c=relaxed/simple;
	bh=J+Px55dagdfMw7YfxNKze6OmLaUjKceUErnuXWFGryg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=F3SWiRV/IPgdk/c5IC8kWzzg+5+EPdKhDv+iiWzEsvO9vh0HyJjhgPji5EFWCa6IAgfu4lE2REgtIV8oPR/QNJPYCl++vNBIKUDB/nRLqCrdozmfLjLxP+vydZHfXzbDIlHh2WoHDDf7lCm/LssxNUmOz2ghO7AIA9nOMjUu8Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U0H2qzLv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U0H2qzLv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790867398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbYNmywWjThKt2Qey6sPOBu4/6mlPeMPuesMztax4Yg=;
	b=U0H2qzLvW717Ch9ZCy/gsqQL6upDHXg2ZwLu57vQTZCv13mjhOVLqSGgHmLHtLevN4BvZX
	OAOiu2WNAkd5ki0YbVvHXjrukdBV2w8nA6+MPU5Ed3GHNkmEEdd6eDTQEqLJm3R4QSH8CO
	c7j5PB4vhH3UfWdujXLpRbeQC0ZCjKc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-A7DQLZcxO_KtkWC6RdKktA-1; Thu, 01 Oct 2026 11:09:55 -0400
X-MC-Unique: A7DQLZcxO_KtkWC6RdKktA-1
X-Mimecast-MFC-AGG-ID: A7DQLZcxO_KtkWC6RdKktA_1790867394
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c29452ecadeso775266666b.3
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 08:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790867394; x=1791472194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NbYNmywWjThKt2Qey6sPOBu4/6mlPeMPuesMztax4Yg=;
        b=ViakIgTkLMjcDXwcgYvVrpARAI/pN+DXl2Rfaawj81taixA8ZrPVnFl1zELSmu0we6
         V27fTY4TtHI8bhjxo0AO2C+NnVaPmIqNftHhDyelqJzWrK90D+qjV66FPg/yExIhuFB7
         P5q1UBj80omOG9DP2VvZ1wxEWVUfDt2JDkNpz4yts7zxQkz/e1thHB58G6tkyJfzdHdH
         7hBZRbSMh9/+LgTwFnIf6JSHpeiOX40r1TKKl0pUxsswnHjODEhAdWYK+YKWMXJTW7/S
         HLmDHahd5ZtZpaT+vxMdDzrP6+nLkaAYJvSvR7mUEHJCvK8t8Vkjnih2GoaJn8zeHF7w
         Iafg==
X-Forwarded-Encrypted: i=1; AKwUvBwMcb0SIUml11GNWKfPMgeHO0O6XqgzTu6z0Azg06FhsUtbhVAzuKUrW5XLzMyoEKK4SQudo0U=@lists.linux.dev
X-Gm-Message-State: AFuF++lQJbqzeVLTxf5odw2q8FHExhAFqbZE0N3xuumPOeajlVqxKhtZ
	x5keSXX9WROJaKWNF8AKd8y7lH9mh8ajp/E2/G4yU4liHPqJrVmcArvSSl61LB5OV1Qvv+uDzI9
	ijphYh3ImKcBuE83BY6RDewIh43NryHi2d4aSEYeEzn+AmwxZelaUOa2tvQ==
X-Gm-Gg: AYBFou3cvF43OkRsnF4ACmCxDtRb5BnZQCAmqt94sPZs4S05FtNgpr3x3oIjTqF4boY
	uuFZKiXbs6Oia/L+5ijA3lGpGGXVF9aXuvEigrDPxjycTtAXP1is+F/ijCLqB+xRpw5NBAkOZZU
	Yp47uOlEyrFhPeE6TC0w9gArLF0deUcTCduKXOXF9ub7zAYRG8b9JtK6s/yotaJ8xbaQoOuLkaa
	fvotmp6rFRixvxIMRZuyF8mhI6qgfScb/K7aTPZd/G6EIzN7DnKTkFXyD6YyefU1VjxFqdqxk5K
	YVGhbma4YjYpKWSU0GNS9xo4B3DoaCybHbGClhc51Weil+PBNlHS3R/Z3dEAlrIYakF0JoLZpPC
	F6CZSCRm6tgJp++t1puYSWlby6PgvR1ljMKRB2TBU14nX/dN/EGCQsyfVZ+g=
X-Received: by 2002:a17:907:86a3:b0:c29:c079:676d with SMTP id a640c23a62f3a-c2e23749ee1mr410211466b.3.1790867394272;
        Thu, 01 Oct 2026 08:09:54 -0700 (PDT)
X-Received: by 2002:a17:907:86a3:b0:c29:c079:676d with SMTP id a640c23a62f3a-c2e23749ee1mr410209366b.3.1790867393806;
        Thu, 01 Oct 2026 08:09:53 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-245-188.pool.digikabel.hu. [193.226.245.188])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d86372sm177735166b.56.2026.10.01.08.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:09:52 -0700 (PDT)
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
Subject: [PATCH v2 8/8] fuse: add support for striped backing
Date: Thu,  1 Oct 2026 17:07:26 +0200
Message-ID: <20261001150935.655979-9-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261001150935.655979-1-mszeredi@redhat.com>
References: <20261001150935.655979-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D3htLJ9CT0guMk5viJnk-q7Enrdfke1QFLfMxOhXdg4_1790867394
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

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/ext_map.c         | 27 ++++++++++++++++++++++++---
 fs/fuse/fuse_i.h          |  1 +
 fs/fuse/notify.c          |  2 +-
 include/uapi/linux/fuse.h |  5 ++++-
 4 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
index 61cb22e821b6..356a5ec4f5e1 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -101,12 +101,18 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
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
 
@@ -119,9 +125,12 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 	}
 
 	ext_len = fie->end - fie->start;
+	addr = fie->backing_offset;
+	if (check_mul_overflow(ncycle, ext_len, &tmp) || check_add_overflow(addr, tmp, &addr))
+		return fuse_EIO("extent address overflow");
 
-	iomap->offset = fie->start;
-	iomap->addr = fie->backing_offset;
+	iomap->offset = fie->start + seq_off;
+	iomap->addr = addr;
 	iomap->length = ext_len;
 	iomap->dax_dev = fie->backing->dax_dev;
 	iomap->type = IOMAP_MAPPED;
@@ -242,6 +251,7 @@ int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_o
 	struct fuse_backing *fb;
 	unsigned int i;
 	int err;
+	u64 chunk_size = 0;
 
 	if (!arg->num_extents)
 		return fuse_EIO("no extents");
@@ -259,7 +269,18 @@ int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_o
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
index 7248588b45c4..83cc1dd67cef 100644
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
index b17786492f0b..f371acb73cda 100644
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

