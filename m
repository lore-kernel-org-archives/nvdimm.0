Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB22497385
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867396; cv=none; b=SXMxCT6KiVuO2J1dmL2zOWab5m2gpP/VJC7E6zBNGij1zOT9CJQelZQ6Gh36Yr3IV6GVCDS0XBnu1g2+wfWobgKkxZhriEQ/X11PV9L1WtZlErNVyq0IiFoVUt57i2sRF1KX22ucF2pHHlwzhxhwS+6r/Gjz/89cB6WFe5i0FlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867396; c=relaxed/simple;
	bh=WSOqae0kAUD8nlX97Q1R6ThuIhrpQuSJOmcr8uQ/jWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=U7tmVsGiNQ3N5a5lg0LAi9DQ/bvPRTmVosAPskhZisOkrvtNpGltRKaWvP7i8EiqjueG4s/4OwfHbOC67s4ShpO86zBRfiQnvtGBMAsRdwnBdPhofDPzbI1vGxzoRsw99w7iu4uyjSxHteSaIfK/omT3ZINnldyTt5szXbgxBjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E/W7Y5A2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E/W7Y5A2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790867393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/MRvowv/cgy0rcGVItnbBcQGFd+7CZ9G4+hpqpJXSVA=;
	b=E/W7Y5A28oeIbFJCWQ49eYgBHKsu5X0ReoBdb5qWQoEbBLDuEOY+mHen0PSkdP0eAufhVO
	JWhrNeyPwTapeBJA7BKrqWWP3Vd7Qx3G8uDa53TwRvi2eovfByl/COIEIHXZNYMqCB8NQQ
	CgGkHuB3QNCvnHnbET86hlrWZd1Zrl0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-JBjDfloUOA2ysD4_uQ8pOA-1; Thu, 01 Oct 2026 11:09:52 -0400
X-MC-Unique: JBjDfloUOA2ysD4_uQ8pOA-1
X-Mimecast-MFC-AGG-ID: JBjDfloUOA2ysD4_uQ8pOA_1790867391
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2e315271c1so148988166b.0
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 08:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790867391; x=1791472191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/MRvowv/cgy0rcGVItnbBcQGFd+7CZ9G4+hpqpJXSVA=;
        b=YxBsfpN53qfGyNz1wQzGqP6uoWn11IUiDLbCg/Yh1y0Kuw9u9wVZy4DZ+5El3LQ+W9
         ZNBbQHvNNTbR2fuk6VSR2BLJ9WhnbzD8KrbS9lQUb7CWpGGLaIDZEFgGMt2IZ+ziIzQi
         cf/d00491+gBDEOkehn1gImHkNA1sxNenherzWvMyGJcGBVnhSNutiEcOHrQQEUM23Zl
         cv07vEtSq+phAxLK2bcob8LRfamCGUepMrWly5/DTCTzS+tBQwfJCz0jk1aMhb9xaS8k
         oseJT4iGKGVVFjJUTa9FtR0h8DzGdCSJDU+TOM1p0nGDm2EQQ9tkq4PGS/2xaS0EtJga
         takg==
X-Forwarded-Encrypted: i=1; AKwUvBymudI9zoUziCPtCvFv6EBD6DOJzIjf9F9/M+ex7Q6YR3CAA+vTELwERRfpz1mB/Kni8lKyicA=@lists.linux.dev
X-Gm-Message-State: AFuF++nCuEHNNtgHmjuunEdOnMlrCm3H0SUgbL725pFwvVMHB7peFSuY
	6sD+0AUZ3NxtePAkgsXDuIugFA8yn9WJPAmbi0madsIiJEiiFk8UeotI2xSc4OHToJ5cmnYn/gz
	TYBjubSbXqo1Diy82AazPQWZjHssaY6yw3em6wsVdT+K+4QbuVamR98jqCw==
X-Gm-Gg: AYBFou1qU8MWIllsV5aPfzx/1s4Ygw3+wN9lCoty5xkBa9gtLLP6GPcuqXhQo9jpoFF
	TtUnJm9j+fYYCnezqUDokpbjjAhwt+hAjM9FDqyCrabnDpptA4FLRY92Diw+MqmeD/yYOtLtONH
	mp6nlxrC8ijNJ4mtb16I+rNIIv51CmyDlPQs1WxBLqMC6RZDd9ZWZJ84OcoTB3UHOCZ0jdMhbU8
	4+EIb6D9uV3rv7sMj3DVkTIbi/U8MlxHu7iRkLJYA47mjUZm8nBKThu38vqbwUZXGeOxib4/Ebh
	TWLyLLMDZZ3VAL6HV438uiCEaNFryV1zW0o3WEKxcJ0bwu0zenqqwp8/JPKlzorfqdxsNxya1vI
	Eb92DHfrd0buzJT7e2H0k0+6Oyep4JIiujsf3LUtFl19A3598dOvgVkj7Rrg=
X-Received: by 2002:a17:907:1b11:b0:c26:19de:912d with SMTP id a640c23a62f3a-c2e23dcfd7amr452466566b.32.1790867390850;
        Thu, 01 Oct 2026 08:09:50 -0700 (PDT)
X-Received: by 2002:a17:907:1b11:b0:c26:19de:912d with SMTP id a640c23a62f3a-c2e23dcfd7amr452464166b.32.1790867390429;
        Thu, 01 Oct 2026 08:09:50 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-245-188.pool.digikabel.hu. [193.226.245.188])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d86372sm177735166b.56.2026.10.01.08.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:09:49 -0700 (PDT)
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
Subject: [PATCH v2 6/8] fuse: add extent map data structure
Date: Thu,  1 Oct 2026 17:07:24 +0200
Message-ID: <20261001150935.655979-7-mszeredi@redhat.com>
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
X-Mimecast-MFC-PROC-ID: tOpTVBeiAa6rG52BD0JSvYV1bSY_cinMdli7KX_YBdI_1790867391
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add support for creating and managing extent maps that map file regions to
dax device regions.

Introduce FUSE_NOTIFY_BACKING_MAP for populating extent maps from
userspace.

Extent maps are handled as a new type of backing and are assigned a 64 bit
backing ID by the server.

One extent consists of

 - offset within the containing backing
 - length of extent
 - target backing ID
 - offset into target backing

Extents must be non-overlapping, and can only refer to dax device backings
for now.

At this point only support creating and populating the extent map in one
operation, though the interface is not limited by this and later may be
changed, so that partial population of an extent map would be possible.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/Makefile          |   2 +-
 fs/fuse/backing.c         |  36 +++++++++--
 fs/fuse/ext_map.c         | 129 ++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h          |  14 ++++-
 fs/fuse/notify.c          |  44 +++++++++++++
 include/uapi/linux/fuse.h |  26 ++++++++
 6 files changed, 244 insertions(+), 7 deletions(-)
 create mode 100644 fs/fuse/ext_map.c

diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index 5858feafa916..da9e802d7ae1 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -15,7 +15,7 @@ fuse-y += dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o ioctl.o r
 fuse-y += poll.o notify.o
 fuse-y += iomode.o
 fuse-$(CONFIG_FUSE_VDAX) += dax.o
-fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o backing.o
+fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o backing.o ext_map.o
 fuse-$(CONFIG_SYSCTL) += sysctl.o
 fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
 
diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index c852f0498961..e954391d696d 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -32,6 +32,10 @@ static void fuse_backing_free(struct fuse_backing *fb)
 	case FUSE_BACKING_DAXDEV:
 		fs_put_dax(fb->dax_dev, fb);
 		break;
+
+	case FUSE_BACKING_EXTMAP:
+		fuse_ext_map_destroy(&fb->extents);
+		break;
 	}
 	kfree_rcu(fb, rcu);
 }
@@ -84,7 +88,7 @@ static const struct rhashtable_params fuse_backing_prm = {
 	.key_len = sizeof_field(struct fuse_backing, backing_id),
 };
 
-static int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb)
+int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb)
 {
 	return rhashtable_insert_fast(&fc->backing_64_ht, &fb->hash_node, fuse_backing_prm);
 }
@@ -306,12 +310,36 @@ static void fuse_backing_rht_free(void *p, void *data)
 
 void fuse_backing_files_free(struct fuse_conn *fc)
 {
-	if (fc->backing_id_64) {
-		rhashtable_free_and_destroy(&fc->backing_64_ht, fuse_backing_rht_free, NULL);
-	} else {
+	struct rhashtable_iter iter;
+	struct fuse_backing *fb;
+
+	if (!fc->backing_id_64) {
 		idr_for_each(&fc->backing_files_map, fuse_backing_idr_free, NULL);
 		idr_destroy(&fc->backing_files_map);
+		return;
 	}
+
+	/*
+	 * extents are referencing other backings, put these refs before
+	 * destroying the backings themselves
+	 */
+	rhashtable_walk_enter(&fc->backing_64_ht, &iter);
+	rhashtable_walk_start(&iter);
+	while ((fb = rhashtable_walk_next(&iter))) {
+		if (IS_ERR(fb)) {
+			if (PTR_ERR(fb) == -EAGAIN)
+				continue;
+			break;
+		}
+		if (fb->type == FUSE_BACKING_EXTMAP) {
+			fuse_ext_map_destroy(&fb->extents);
+			fb->extents.rb_node = NULL;
+		}
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+
+	rhashtable_free_and_destroy(&fc->backing_64_ht, fuse_backing_rht_free, NULL);
 }
 
 void fuse_backing_files_init_64(struct fuse_conn *fc)
diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
new file mode 100644
index 000000000000..ab01d678d08e
--- /dev/null
+++ b/fs/fuse/ext_map.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "fuse_i.h"
+#include <linux/rbtree.h>
+#include <linux/pagemap.h>
+
+struct fuse_iext {
+	struct rb_node rb;
+	u64 start;
+	u64 end; /* exclusive */
+	struct fuse_backing *backing;
+	u64 backing_offset;
+};
+
+void fuse_ext_map_destroy(struct rb_root *extents)
+{
+	struct fuse_iext *fie, *tmp;
+
+	rbtree_postorder_for_each_entry_safe(fie, tmp, extents, rb) {
+		fuse_backing_put(fie->backing);
+		kfree(fie);
+	}
+}
+
+static int fuse_add_extent(struct fuse_conn *fc, struct rb_root *extents,
+			   struct fuse_extent *ext)
+{
+	struct fuse_iext *new_fie __free(kfree) = kzalloc_obj(*new_fie);
+	struct rb_node *parent = NULL, **link = &extents->rb_node;
+	loff_t end;
+
+	if (!new_fie)
+		return -ENOMEM;
+
+	if (ext->reserved[0] || ext->reserved[1])
+		return fuse_EIO("reserved fields set");
+
+	if (!PAGE_ALIGNED(ext->offset) || !PAGE_ALIGNED(ext->length) || !PAGE_ALIGNED(ext->addr))
+		return fuse_EIO("not page aligned");
+
+	if (!ext->length)
+		return fuse_EIO("zero sized extent");
+
+	if (overflows_type(ext->offset, loff_t) ||
+	    check_add_overflow(ext->offset, ext->length, &end))
+		return fuse_EIO("offset overflow");
+
+	new_fie->start = ext->offset;
+	new_fie->end = end;
+	new_fie->backing_offset = ext->addr;
+
+	while (*link) {
+		struct fuse_iext *fie = rb_entry(*link, typeof(*fie), rb);
+
+		parent = *link;
+		if (new_fie->end <= fie->start)
+			link = &parent->rb_left;
+		else if (new_fie->start >= fie->end)
+			link = &parent->rb_right;
+		else
+			return fuse_EIO("overlap");
+	}
+
+	new_fie->backing = fuse_backing_lookup(fc, ext->backing_id);
+	if (!new_fie->backing)
+		return fuse_EIO("backing not found");
+
+	if (new_fie->backing->type != FUSE_BACKING_DAXDEV) {
+		fuse_backing_put(new_fie->backing);
+		return fuse_EIO("backing is not dax device");
+	}
+
+	rb_link_node(&new_fie->rb, parent, link);
+	rb_insert_color(&no_free_ptr(new_fie)->rb, extents);
+
+	return 0;
+}
+
+bool fuse_ext_map_is_dax(struct fuse_backing *fb)
+{
+	struct fuse_iext *fie;
+
+	if (WARN_ON(RB_EMPTY_ROOT(&fb->extents)))
+		return false;
+
+	fie = rb_entry(fb->extents.rb_node, typeof(*fie), rb);
+	return fie->backing->type == FUSE_BACKING_DAXDEV;
+}
+
+int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_out *arg,
+			  struct fuse_extent *ext)
+{
+	struct fuse_backing *fb;
+	unsigned int i;
+	int err;
+
+	if (!arg->num_extents)
+		return fuse_EIO("no extents");
+
+	if (arg->flags & FUSE_BACKING_MAP_CREATE) {
+		fb = kzalloc_obj(*fb);
+		if (!fb)
+			return -ENOMEM;
+
+		refcount_set(&fb->count, 1);
+		fb->type = FUSE_BACKING_EXTMAP;
+		fb->backing_id = arg->backing_id;
+	} else {
+		/* Adding extents to an existing extmap backing is not yet supported */
+		return -EINVAL;
+	}
+
+	for (i = 0; i < arg->num_extents; i++) {
+		err = fuse_add_extent(fc, &fb->extents, &ext[i]);
+		if (err)
+			goto err_put;
+	}
+
+	err = 0;
+	if (arg->flags & FUSE_BACKING_MAP_CREATE) {
+		err = fuse_backing_add_64(fc, fb);
+		if (!err)
+			return 0;
+	}
+
+err_put:
+	fuse_backing_put(fb);
+	return err;
+}
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 3e7ffb9bb2c3..5a20f3863ee2 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -24,7 +24,7 @@
 #include <linux/backing-dev.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
-#include <linux/rbtree.h>
+#include <linux/rbtree_types.h>
 #include <linux/poll.h>
 #include <linux/workqueue.h>
 #include <linux/kref.h>
@@ -92,6 +92,7 @@ struct fuse_submount_lookup {
 enum fuse_backing_type {
 	FUSE_BACKING_PATH,
 	FUSE_BACKING_DAXDEV,
+	FUSE_BACKING_EXTMAP,
 };
 
 /* Container for data related to mapping to backing file */
@@ -107,6 +108,9 @@ struct fuse_backing {
 			struct dax_device *dax_dev;
 			bool dax_error;
 		};
+		struct {
+			struct rb_root extents;
+		};
 	};
 	u64 backing_id;
 	struct rhash_head hash_node;
@@ -1303,7 +1307,6 @@ void fuse_file_release(struct inode *inode, struct fuse_file *ff,
 /* backing.c */
 #ifdef CONFIG_FUSE_PASSTHROUGH
 void fuse_backing_put(struct fuse_backing *fb);
-
 #else
 
 static inline void fuse_backing_put(struct fuse_backing *fb)
@@ -1312,6 +1315,7 @@ static inline void fuse_backing_put(struct fuse_backing *fb)
 #endif
 
 struct fuse_backing *fuse_backing_lookup(struct fuse_conn *fc, u64 backing_id);
+int fuse_backing_add_64(struct fuse_conn *fc, struct fuse_backing *fb);
 void fuse_backing_files_init(struct fuse_conn *fc);
 void fuse_backing_files_init_64(struct fuse_conn *fc);
 void fuse_backing_files_free(struct fuse_conn *fc);
@@ -1362,4 +1366,10 @@ extern void fuse_sysctl_unregister(void);
 #define fuse_sysctl_unregister()	do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
+/* ext_map.c */
+
+void fuse_ext_map_destroy(struct rb_root *extents);
+bool fuse_ext_map_is_dax(struct fuse_backing *fb);
+int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_out *arg,
+			  struct fuse_extent *ext);
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
index 93e916a16ac9..7c427f88bbc5 100644
--- a/fs/fuse/notify.c
+++ b/fs/fuse/notify.c
@@ -434,6 +434,47 @@ static int fuse_notify_backing_remove(struct fuse_conn *fc, unsigned int size,
 	return fuse_backing_close_64(fc, outarg.backing_id);
 }
 
+static int fuse_notify_map(struct fuse_conn *fc, unsigned int size,
+			   struct fuse_copy_state *cs)
+{
+	struct fuse_notify_backing_map_out outarg;
+	struct fuse_extent *ext __free(kvfree) = NULL;
+	int err;
+
+	if (size < sizeof(outarg))
+		return -EINVAL;
+
+	err = fuse_copy_one(cs, &outarg, sizeof(outarg));
+	if (err)
+		return err;
+
+	if (outarg.num_extents > FUSE_MAX_EXTENTS)
+		return -EINVAL;
+
+	size -= sizeof(outarg);
+	if (size != outarg.num_extents * sizeof(*ext))
+		return -EINVAL;
+
+	if (outarg.reserved[0] != 0 || outarg.reserved[1] != 0)
+		return -EINVAL;
+
+	if (outarg.flags & ~FUSE_BACKING_MAP_CREATE)
+		return -EINVAL;
+
+	if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
+		return -EOPNOTSUPP;
+
+	ext = kvmalloc_objs(*ext, outarg.num_extents);
+	if (!ext)
+		return -ENOMEM;
+
+	err = fuse_copy_one(cs, ext, size);
+	if (err)
+		return err;
+
+	return fuse_ext_map_populate(fc, &outarg, ext);
+}
+
 int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 		unsigned int size, struct fuse_copy_state *cs)
 {
@@ -468,6 +509,9 @@ int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 	case FUSE_NOTIFY_BACKING_REMOVE:
 		return fuse_notify_backing_remove(fc, size, cs);
 
+	case FUSE_NOTIFY_BACKING_MAP:
+		return fuse_notify_map(fc, size, cs);
+
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 60fb2add5e12..b17786492f0b 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -255,6 +255,7 @@
  *  - add FUSE_DEV_IOC_BACKING_CREATE, struct fuse_backing_create_in
  *  - add FUSE_NOTIFY_BACKING_REMOVE, struct fuse_notify_backing_remove_out
  *  - add backing_id_64 to fuse_open_out
+ *  - add FUSE_NOTIFY_BACKING_MAP, fuse_notify_backing_map_out, fuse_extent, FUSE_BACKING_MAP_CREATE
  */
 
 #ifndef _LINUX_FUSE_H
@@ -716,6 +717,7 @@ enum fuse_notify_code {
 	FUSE_NOTIFY_INC_EPOCH = 8,
 	FUSE_NOTIFY_PRUNE = 9,
 	FUSE_NOTIFY_BACKING_REMOVE = 10,
+	FUSE_NOTIFY_BACKING_MAP = 11,
 };
 
 /* The read buffer is required to be at least 8k, but may be much larger */
@@ -1213,6 +1215,30 @@ struct fuse_notify_backing_remove_out {
 	uint64_t	reserved;
 };
 
+/**
+ * notify_map flags
+ *
+ * FUSE_BACKING_MAP_CREATE:	create backing with the supplied ID
+ */
+#define FUSE_BACKING_MAP_CREATE	(1 << 0)
+
+struct fuse_notify_backing_map_out {
+	uint64_t	backing_id;
+	uint32_t	num_extents;
+	uint32_t	flags;
+	uint64_t	reserved[2];
+};
+
+#define FUSE_MAX_EXTENTS 1365		/*  (1 << 16) / sizeof(struct fuse_extent) */
+
+struct fuse_extent {
+	uint64_t	offset;		/* offset of extent into parent backing */
+	uint64_t	length;		/* extent length */
+	uint64_t	backing_id;	/* target backing */
+	uint64_t	addr;		/* target offset within backing file/device */
+	uint64_t	reserved[2];
+};
+
 #define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
 #define FUSE_SETUPMAPPING_FLAG_READ (1ull << 1)
 struct fuse_setupmapping_in {
-- 
2.54.0

