Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30D54D2EE4
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163864; cv=none; b=DZ4XqQcvH/TzLPOAdLv0DZXASnYsrKMQZNP7LQHOihbhPIv9ZmmSvXiv5TyvKb8RS6H8DBUGBW7ELbcw1rNC02Fg63d8BX5ukI49HtVOs24milkDnq0rIyNqiHuDK9ATB+tILXFIVHSWojkW2CePN4Y3dSU36KK3JonDQdH3W2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163864; c=relaxed/simple;
	bh=LwrEl/KIm3L/LbbB/5787EIipRgdD+mk0VksZUL6s7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=dhDf27F107FYDjyDQnU5kknsbGQyvKlnjE2BDQmPwXJBumbXRUJGnWBZWFf7GL3TVeMiMKQWkWEq8K01h+nZag638FuAX4DYHeIIinqpiN0fE2R4ocDOHUp7voTGF+ZJ3ssmopPCnZJR6dRxnts0hvIQY4JM01f+GmHKVD3SWxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bd+71Woe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bd+71Woe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792163857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iGSFy06Pa/ILrqJ50XlN6mRc2cdKzAo47WOs6A7tQnQ=;
	b=bd+71WoeofKKCWtJ2SoZfPGBmHMyIpzHrChKk4tWEUfOR0xfRMB+df44VH/brv9n6MwDFJ
	22V+5XFPSqHNHSHZeNt6JaJbsmsNeD6ohkNa4VNorqj2wKzwg85cwZJleQf8YEivBLgj+9
	z0jSnpW9ifF61VL/INyweSbxLJH3tAk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-G2yej4f9NwiXY9mHTcBA_A-1; Fri, 16 Oct 2026 15:17:36 +0000
X-MC-Unique: G2yej4f9NwiXY9mHTcBA_A-1
X-Mimecast-MFC-AGG-ID: G2yej4f9NwiXY9mHTcBA_A_1792163856
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48dfaaea30cso867077f8f.0
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 08:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163855; x=1792768655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iGSFy06Pa/ILrqJ50XlN6mRc2cdKzAo47WOs6A7tQnQ=;
        b=mB/YaQB8aIyVzh1Lpott+ThyJexER52oGxYKbBknbcSjM2fXe62H26a/gUtb6JtImQ
         X+zklmCfkGFzGW+RcCISyNhXgLCwQQ2gToFTfaffHCqqmjfIY/sruyiAoHK2ZvVFk0i1
         sX6W7pWaJMa290H1GQVlqYIw6WGApG/QaDz28ihvl9/QiKwbloNkGwlLYqwhg6718UvG
         qD9g9KVQ2N1rGBYqEogFr9C2k0rY3JmhNwoowIo0Z9a37WIqxxDjAWP51NfTWNtopzdF
         7QS3493ehEgwxfGIvemR+GCHXpb9ZJqkh6XPRFRHuizOv1i8RWW1tLmtwzkd1N6qQLMr
         QfGA==
X-Forwarded-Encrypted: i=1; AKwUvBzt4EGLzJ+mAdcsTmLnqM7s8J5ILeKJu/2/SOvth1g1aUNrC4SRm3DrdF+9+Pl+K0rfsRUvjPQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYK3DpQno8CouBaxHfx4BRhqPbJlbf7DnHzVvhgvihM/+V8nlo84
	ArF7mkpgXKOgqq1yWIw5p4CQCE40NHUYhjBF5TIbCDt+yUKFlsLh8fNl/jj9vWb1YP+Ax8qxc49
	claJw1ab6WToMaPV0t1tQj0wgQNVroesqnrxIpD0+lYgyRNzJo/gwoLkjZQ==
X-Gm-Gg: AYBFou25fDqsGx/Bo67PUfvcWrN4fveg94an+uVKuBMYewzo8pmZk453J4U6fuMt83T
	GuT2Nt6akFRoPR38emfTxprAT+URN2RpZu0ZXUOLPzdaw1GKffzQN/K5kDLQNoL2PS4BiyZd4t6
	aBWbXx9JM/qnsYNeoS8CQgigT+jHIqr+6xdyrWpsjIZLMIQHZ9Bx525OBqM0h+RjMRQIH+Ncx9e
	XYfJaTwJwcI3SUt++zMb+TVNqkA0QT99w9uGo4jFU7zf1axb9ugL0idNT2zaanK7YnJe8nwvIQ7
	zgb3aY3NZ2fzuPelj6lUfbWpnTQQaE5oM7zaiqYNNL0T/jycus9K368VhaZXHcRcpTRhU36WgYF
	A3q2FCvDp+IbiObgS9P8Yrw==
X-Received: by 2002:a05:600c:8587:b0:49c:ffab:551f with SMTP id 5b1f17b1804b1-4a1d7616d37mr2027985e9.22.1792163855317;
        Fri, 16 Oct 2026 08:17:35 -0700 (PDT)
X-Received: by 2002:a05:600c:8587:b0:49c:ffab:551f with SMTP id 5b1f17b1804b1-4a1d7616d37mr2027515e9.22.1792163854940;
        Fri, 16 Oct 2026 08:17:34 -0700 (PDT)
Received: from maszat.com (85-67-2-18.pool.digikabel.hu. [85.67.2.18])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8de7230sm64621665e9.14.2026.10.16.08.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:17:34 -0700 (PDT)
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
Subject: [PATCH v5 10/10] fuse: resolve extent maps in O(1) when possible
Date: Fri, 16 Oct 2026 17:16:37 +0200
Message-ID: <20261016151638.2962413-11-mszeredi@redhat.com>
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
X-Mimecast-MFC-PROC-ID: Ccjtw-mlrT2zQqFjWTt49tABwSUOUW0ycUeiEYM6U9U_1792163856
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: John Groves <john@groves.net>

fuse_ext_map_iomap_begin() runs on every mapping fault of a DAX
extent-mapped file, meaning the TLB-miss-plus-page-table-miss case,
and on every chunk of every read/write.  These are not page faults in
the usual sense: nothing is read in from storage.  The fault only
installs page table entries for memory that is already there, so there
is no I/O to amortize the resolver's cost against; whatever it costs
is added to the cost of a memory access.

The rbtree it walks is built from individually allocated nodes.  Each
level is a dependent, un-prefetchable dereference and a potential LLC
miss (~100ns), so a striped file with S strips pays log2(S) of them
per resolution, and that is a large fraction of a mapping fault that
otherwise costs little more than the page table update itself.

Replace the rbtree in struct fuse_backing with a packed, sorted array
of fuse_iext extents, allocated once per map rather than once per
extent.  The array packs the extents into the fewest cache lines, and
fault handling is O(1) when the map allows it:

 - A cyclic (striped) map is required to have equal-length extents
   contiguous from zero, so a file offset converts arithmetically to a
   strip index and cycle number.  This patch validates that and does
   it.

 - A simple map whose extents happen to be equal-length and contiguous
   from zero (the common famfs allocation) resolves as offset / ext_len.
   This patch detects that at populate time and does it.

 - An irregular map falls back to a binary search of the packed array.

famfs currently always produces maps that resolve in O(1).

Because the extents are sorted at populate time, a cyclic map's extents
no longer have to arrive in offset order, and the overlap check is an
adjacent-pair compare over the sorted array rather than a check at each
rbtree insertion.  Error returns are unchanged: -EIO with a message for
malformed extents and overlaps, -EINVAL for a non-uniform cyclic map.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/backing.c |   7 +-
 fs/fuse/ext_map.c | 219 +++++++++++++++++++++++++++++-----------------
 fs/fuse/fuse_i.h  |   8 +-
 3 files changed, 147 insertions(+), 87 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 390668157de3..8c21a8a74efb 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -34,7 +34,7 @@ static void fuse_backing_free(struct fuse_backing *fb)
 		break;
 
 	case FUSE_BACKING_EXTMAP:
-		fuse_ext_map_destroy(&fb->extents);
+		fuse_ext_map_destroy(fb);
 		break;
 	}
 	kfree_rcu(fb, rcu);
@@ -356,10 +356,9 @@ void fuse_backing_files_free(struct fuse_conn *fc)
 				continue;
 			break;
 		}
-		if (fb->type == FUSE_BACKING_EXTMAP && !RB_EMPTY_ROOT(&fb->extents)) {
+		if (fb->type == FUSE_BACKING_EXTMAP && fb->extents) {
 			rhashtable_walk_stop(&iter);
-			fuse_ext_map_destroy(&fb->extents);
-			fb->extents.rb_node = NULL;
+			fuse_ext_map_destroy(fb);
 			rhashtable_walk_start(&iter);
 		}
 	}
diff --git a/fs/fuse/ext_map.c b/fs/fuse/ext_map.c
index 7adb78cf552d..7f04edc33fe3 100644
--- a/fs/fuse/ext_map.c
+++ b/fs/fuse/ext_map.c
@@ -1,58 +1,87 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include "fuse_i.h"
-#include <linux/rbtree.h>
 #include <linux/pagemap.h>
 #include <linux/iomap.h>
 #include <linux/dax.h>
+#include <linux/sort.h>
+#include <linux/log2.h>
+#include <linux/math64.h>
 
 struct fuse_iext {
-	struct rb_node rb;
 	u64 start;
 	u64 end; /* exclusive */
 	struct fuse_backing *backing;
 	u64 backing_offset;
 };
 
-void fuse_ext_map_destroy(struct rb_root *extents)
+void fuse_ext_map_destroy(struct fuse_backing *fb)
 {
-	struct fuse_iext *fie, *tmp;
+	unsigned int i;
 
-	rbtree_postorder_for_each_entry_safe(fie, tmp, extents, rb) {
-		fuse_backing_put(fie->backing);
-		kfree(fie);
-	}
+	for (i = 0; i < fb->nr_extents; i++)
+		fuse_backing_put(fb->extents[i].backing);
+
+	kvfree(fb->extents);
+	fb->extents = NULL;
+	fb->nr_extents = 0;
 }
 
-static struct fuse_iext *fuse_find_extent(struct rb_root *extents, u64 offset)
+/*
+ * Resolve @offset to an extent.
+ *
+ * A uniform map (all extents the same length, contiguous from offset zero) is
+ * resolved with a single array index.  A cyclic map is uniform by construction;
+ * the index wraps and *ncycle is the number of complete cycles before @offset.
+ * Only an irregular map needs a search: a binary search of the sorted array.
+ */
+static struct fuse_iext *fuse_find_extent(struct fuse_backing *fb, u64 offset,
+					  u64 *ncycle)
 {
-	struct rb_node *node = extents->rb_node;
+	struct fuse_iext *ext = fb->extents;
+	unsigned int lo, hi;
+	u64 idx;
+
+	*ncycle = 0;
+
+	/* If the extents are uniform... */
+	if (fb->ext_len) {
+		idx = div64_u64(offset, fb->ext_len);
+
+		if (fb->cycle_length) {
+			u32 rem;
+
+			*ncycle = div_u64_rem(idx, fb->nr_extents, &rem);
+			idx = rem;
+		} else if (idx >= fb->nr_extents) {
+			return NULL;
+		}
+		return &ext[idx];
+	}
 
-	while (node) {
-		struct fuse_iext *fie = rb_entry(node, typeof(*fie), rb);
+	/* Extents are not uniform: binary search the extents array */
+	lo = 0;
+	hi = fb->nr_extents;
+	while (lo < hi) {
+		unsigned int mid = lo + (hi - lo) / 2;
 
-		if (offset < fie->start)
-			node = node->rb_left;
-		else if (offset >= fie->end)
-			node = node->rb_right;
+		if (offset < ext[mid].start)
+			hi = mid;
+		else if (offset >= ext[mid].end)
+			lo = mid + 1;
 		else
-			return fie;
+			return &ext[mid];
 	}
 
 	return NULL;
 }
 
-static int fuse_add_extent(struct fuse_conn *fc, struct rb_root *extents,
+static int fuse_add_extent(struct fuse_conn *fc, struct fuse_iext *new_fie,
 			   struct fuse_extent *ext)
 {
-	struct fuse_iext *new_fie __free(kfree) = kzalloc_obj(*new_fie);
-	struct rb_node *parent = NULL, **link = &extents->rb_node;
 	loff_t end;
 	u64 tmp;
 
-	if (!new_fie)
-		return -ENOMEM;
-
 	if (ext->reserved[0] || ext->reserved[1])
 		return fuse_EIO("reserved fields set");
 
@@ -67,33 +96,74 @@ static int fuse_add_extent(struct fuse_conn *fc, struct rb_root *extents,
 	    check_add_overflow(ext->addr, ext->length, &tmp))
 		return fuse_EIO("offset overflow");
 
+	new_fie->backing = fuse_backing_lookup(fc, ext->backing_id);
+	if (!new_fie->backing)
+		return fuse_EIO("backing not found");
+
+	if (new_fie->backing->type != FUSE_BACKING_DAXDEV) {
+		fuse_backing_put(new_fie->backing);
+		new_fie->backing = NULL;
+		return fuse_EIO("backing is not dax device");
+	}
+
 	new_fie->start = ext->offset;
 	new_fie->end = end;
 	new_fie->backing_offset = ext->addr;
 
-	while (*link) {
-		struct fuse_iext *fie = rb_entry(*link, typeof(*fie), rb);
+	return 0;
+}
+
+static int fuse_iext_cmp(const void *a, const void *b)
+{
+	const struct fuse_iext *x = a, *y = b;
 
-		parent = *link;
-		if (new_fie->end <= fie->start)
-			link = &parent->rb_left;
-		else if (new_fie->start >= fie->end)
-			link = &parent->rb_right;
-		else
+	if (x->start < y->start)
+		return -1;
+	return x->start > y->start;
+}
+
+/*
+ * fb has an array of extents;
+ * - Sort it to guarantee they are in file offset order
+ * - Check whether it is uniform (starts at ofs=0, all same size, no gaps)
+ * - Validate if cyclic
+ *
+ * Array-based extent lists have better cache locality than a tree
+ * (packed into cache lines). Uniform simple extent lists and all currently
+ * valid cyclic extent lists can be indexed in O(1) at fault time. And
+ * when search is needed, arrays can be bisected for balanced O(log2 n).
+ */
+static int fuse_ext_map_finish(struct fuse_backing *fb, bool cyclic)
+{
+	struct fuse_iext *ext = fb->extents;
+	unsigned int n = fb->nr_extents;
+	unsigned int i;
+	bool uniform;
+	u64 len;
+
+	sort(ext, n, sizeof(*ext), fuse_iext_cmp, NULL);
+
+	len = ext[0].end - ext[0].start;
+	uniform = ext[0].start == 0;
+
+	/* Check for uniformity */
+	for (i = 1; i < n; i++) {
+		if (ext[i].start < ext[i - 1].end)
 			return fuse_EIO("overlap");
-	}
 
-	new_fie->backing = fuse_backing_lookup(fc, ext->backing_id);
-	if (!new_fie->backing)
-		return fuse_EIO("backing not found");
+		if (ext[i].start != ext[i - 1].end ||
+		    ext[i].end - ext[i].start != len)
+			uniform = false;
+	}
 
-	if (new_fie->backing->type != FUSE_BACKING_DAXDEV) {
-		fuse_backing_put(new_fie->backing);
-		return fuse_EIO("backing is not dax device");
+	if (cyclic) {
+		if (!uniform ||
+		    check_mul_overflow(len, (u64)n, &fb->cycle_length))
+			return -EINVAL;
 	}
 
-	rb_link_node(&new_fie->rb, parent, link);
-	rb_insert_color(&no_free_ptr(new_fie)->rb, extents);
+	if (uniform)
+		fb->ext_len = len;
 
 	return 0;
 }
@@ -103,18 +173,13 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 {
 	struct fuse_backing *fb = fuse_inode_backing(get_fuse_inode(inode));
 	struct fuse_iext *fie;
-	u64 ncycle = 0, seq_off = 0, addr, tmp;
+	u64 ncycle, seq_off, addr, tmp;
 	loff_t ext_len;
 
 	if (!fb || fb->type != FUSE_BACKING_EXTMAP)
 		return fuse_EIO("missing or wrong type backing");
 
-	if (fb->cycle_length) {
-		ncycle = div64_u64(offset, fb->cycle_length);
-		seq_off = ncycle * fb->cycle_length;
-	}
-
-	fie = fuse_find_extent(&fb->extents, offset - seq_off);
+	fie = fuse_find_extent(fb, offset, &ncycle);
 	if (!fie)
 		return fuse_EIO("missing mapping");
 
@@ -127,6 +192,7 @@ static int fuse_ext_map_iomap_begin(struct inode *inode, loff_t offset, loff_t l
 	}
 
 	ext_len = fie->end - fie->start;
+	seq_off = ncycle * fb->cycle_length;
 	addr = fie->backing_offset;
 	if (check_mul_overflow(ncycle, ext_len, &tmp) || check_add_overflow(addr, tmp, &addr))
 		return fuse_EIO("extent address overflow");
@@ -256,13 +322,10 @@ int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma)
 
 bool fuse_ext_map_is_dax(struct fuse_backing *fb)
 {
-	struct fuse_iext *fie;
-
-	if (WARN_ON(fb->type != FUSE_BACKING_EXTMAP || RB_EMPTY_ROOT(&fb->extents)))
+	if (WARN_ON(fb->type != FUSE_BACKING_EXTMAP || !fb->nr_extents))
 		return false;
 
-	fie = rb_entry(fb->extents.rb_node, typeof(*fie), rb);
-	return fie->backing->type == FUSE_BACKING_DAXDEV;
+	return fb->extents[0].backing->type == FUSE_BACKING_DAXDEV;
 }
 
 int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_out *arg,
@@ -271,47 +334,41 @@ int fuse_ext_map_populate(struct fuse_conn *fc, struct fuse_notify_backing_map_o
 	struct fuse_backing *fb;
 	unsigned int i;
 	int err;
-	u64 chunk_size = 0;
 
 	if (!arg->num_extents)
 		return fuse_EIO("no extents");
 
-	if (arg->flags & FUSE_BACKING_MAP_CREATE) {
-		fb = kzalloc_obj(*fb);
-		if (!fb)
-			return -ENOMEM;
-
-		refcount_set(&fb->count, 1);
-		fb->type = FUSE_BACKING_EXTMAP;
-		fb->backing_id = arg->backing_id;
-	} else {
-		/* Adding extents to an existing extmap backing is not yet supported */
+	/* Adding extents to an existing extmap backing is not yet supported */
+	if (!(arg->flags & FUSE_BACKING_MAP_CREATE))
 		return -EINVAL;
-	}
 
-	if (arg->flags & FUSE_BACKING_MAP_CYCLIC) {
-		chunk_size = ext[0].length;
-		err = -EINVAL;
-		if (check_mul_overflow(chunk_size, arg->num_extents, &fb->cycle_length))
-			goto err_put;
-	}
+	fb = kzalloc_obj(*fb);
+	if (!fb)
+		return -ENOMEM;
 
-	for (i = 0; i < arg->num_extents; i++) {
-		err = -EINVAL;
-		if (chunk_size && (ext[i].offset != chunk_size * i || ext[i].length != chunk_size))
-			goto err_put;
+	refcount_set(&fb->count, 1);
+	fb->type = FUSE_BACKING_EXTMAP;
+	fb->backing_id = arg->backing_id;
+
+	err = -ENOMEM;
+	fb->extents = kvcalloc(arg->num_extents, sizeof(*fb->extents), GFP_KERNEL);
+	if (!fb->extents)
+		goto err_put;
 
-		err = fuse_add_extent(fc, &fb->extents, &ext[i]);
+	for (i = 0; i < arg->num_extents; i++) {
+		err = fuse_add_extent(fc, &fb->extents[i], &ext[i]);
 		if (err)
 			goto err_put;
+		fb->nr_extents++;
 	}
 
-	err = 0;
-	if (arg->flags & FUSE_BACKING_MAP_CREATE) {
-		err = fuse_backing_add_64(fc, fb);
-		if (!err)
-			return 0;
-	}
+	err = fuse_ext_map_finish(fb, arg->flags & FUSE_BACKING_MAP_CYCLIC);
+	if (err)
+		goto err_put;
+
+	err = fuse_backing_add_64(fc, fb);
+	if (!err)
+		return 0;
 
 err_put:
 	fuse_backing_put(fb);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 4a63268c4b25..311252eef2e9 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -95,6 +95,8 @@ enum fuse_backing_type {
 	FUSE_BACKING_EXTMAP,
 };
 
+struct fuse_iext;
+
 /* Container for data related to mapping to backing file */
 struct fuse_backing {
 	enum fuse_backing_type type;
@@ -109,7 +111,9 @@ struct fuse_backing {
 			bool dax_error;
 		};
 		struct {
-			struct rb_root extents;
+			struct fuse_iext *extents;
+			unsigned int nr_extents;
+			u64 ext_len;
 			u64 cycle_length;
 		};
 	};
@@ -1376,7 +1380,7 @@ extern void fuse_sysctl_unregister(void);
 
 /* ext_map.c */
 
-void fuse_ext_map_destroy(struct rb_root *extents);
+void fuse_ext_map_destroy(struct fuse_backing *fb);
 ssize_t fuse_ext_map_write_iter(struct kiocb *iocb, struct iov_iter *from);
 ssize_t fuse_ext_map_read_iter(struct kiocb *iocb, struct iov_iter *to);
 int fuse_ext_map_mmap(struct file *file, struct vm_area_struct *vma);
-- 
2.54.0

