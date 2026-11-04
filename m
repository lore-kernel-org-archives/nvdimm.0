Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833382;
	b=aA1o0F71ErfxVB75BA7F0XSjXk+NqM/pT0mJBbeZu4ggpMZBZsLV5AXOHMuwBg4icTC9
	 rytvvQavg7Dg4qHe/GsSzm8v+Mdo91yhAAUge3+eDIJtp4FlJnqKTmwEKXulEk3sWQU6D
	 yFEScUDrVBJehz55Ah+Q1Hw6wiI1VkAwP/IiLb14k9yj8XpX0RZAhzLq7xJ/7mo2xWSKd
	 UyM/FeJap7C06k7P7BULGYtzMSgBCFnRP6urt1e9/A3uDwWzhnUfCjZS2J7Oz7sNSKbit
	 Hfv6v+X/8TO00bcX0vBx9oczxEP5C2Kol3UEqRTvbt6HqnMJeXU2HxR6bBXKmwVfyUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833382;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mt4NXnFUgai2Xnc1lF4x0zhTMSSIiHVRUW1YIB9DFa0=;
	b=c1mZxqiMY0c/eVbOcHoeM5f77Xi9MVv758ZgkiCnOKZf+X5hfI3YnkGa0RrCzorjegKD
	 nC+dSiiiwYD1ZuhQzEKVG8BIMab4UA1p5EwjRFlHzB2t+iTD/y5lCcgrfn3BSMRU5RqOS
	 Pf+f+CaaOZLFKTlqqKnCoL9dFHLFsZLal6wUBxZO+cinx43eDlPfGLwmIi5s7rfq+Yktm
	 adFUBwEa1arSuEyTbHVldcBG2PkxQ3+Rttx//CDX9eOXU9zpiMx3X9dG1YFSxnWSlPNXN
	 6UeZU/elz9PEKRlaEAlaVdzCusxTtmg8f/UKQWLmE4wlGKHFunICrdZYVBHoySbsHWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b+d7Vicb;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0311606D82A
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0311606D82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b+d7Vicb
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ed06b725fdso575965ad.0
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833381; x=1794438181; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mt4NXnFUgai2Xnc1lF4x0zhTMSSIiHVRUW1YIB9DFa0=;
        b=b+d7VicbDkprZXIraIcEegAMsh3l8XVLhE12Nzg/0Im7KRaRlWJU7+NlyjFwigWxN1
         HoVJ/eDA2B7JusXps4XRed1nOTShhhQHPYoB5t5gSpLyhL2p8FwYKtkICJy6DnNcNQwd
         l/npSOhV3wc6ljiP8OVZcz6a9H/8uDP3UC+00q57sUff3pLPQDT2VpuUoxaHvS/DhUlJ
         hIndmG2ZZWNXrK/Qb3DkUXiafmYHH3ZMjA4eBokdsTMpBIc68ZdT6ye/KL4COBQ21pkZ
         XjCp1EiYljP2RJgA6ZwCntboM/rQB4+BIGDV+Ql2jEu8G0JpxVtt62l3DBB5/p+Lk+a8
         bGrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833381; x=1794438181;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mt4NXnFUgai2Xnc1lF4x0zhTMSSIiHVRUW1YIB9DFa0=;
        b=XMheiFrL9WmsuiZMtbaEscEi4Q1U3rPAohDq558uccjZ4CM7lD4vYIoLJhoMv47svn
         AFroM2j/NR9yBIY932n3EUbyg20ro0zq6Gh1lkWLI+SRHklFs/z9kuNQKHfrgyLoejDa
         iQ6MFbUrF+KrpeHGzSSaOqAR80mOU6/pdYVJKUz32TMD2D0tX9eMoucsMj9OKvBxKfkA
         Dt02CzjjTr0oCZ+pk1fMiTG0XyET8JA6SCKWQQkzE/k3gU7BJn02m1NITozM4Ikl8ojt
         fIh1212FUSr64M/6OyMwv7bzQ/pYNj8DsEP/IRge3VfZBsMfuU1MYIdLuZTLMjKLooJN
         sghA==
X-Gm-Message-State: APuU4Z/iAS45thlOgKqkHnHEN8YsLovV0II7yNTOkZ37wJV7hx+B9adz
	HEFVkDAqj4ye4FAPsFJzIZbDARaq88zqZpX1W33LPmlNx3mVapiH54Vy
X-Gm-Gg: AYBFou2ADjNiqjhUK5SdMvawoKBE66HyDgmbC8SVkEni7hKKTXyhEYHCWwrIMyKKDJd
	PFSfyzXrqpE4ulOJ/rGlL5C/WI95vc5csn+U5Fuw2qJmgRrIPDa1SbuzILXPGzt8Ro9xpM20m6o
	IX4Ukm3XWi1/fOCfFT9qNXdHPiRyhzVzO2Dzt9Vha+BRz7dJI8H+Lt6U3eB4/iRVA0vl1FZB3k8
	gYlRDxugZJ/2CS11ggGwJJydewmDpjfFU6hmXJYmDFLhSlS8Haiwzdy1fRAgX0TMoi3dRK824nj
	OwOFhb+sRGlfekqF+DCX9e8RHDHBwGMXeu8nfcOXuM1L6gVB8PqEfg4jpkPFUvLyYTuIlH7+htG
	fcRO7NaKVB87H0zbv38K2Lul9t6vjLYvbbF4fLfiG9zlcyY/fHWfss7uu6P+WxJuvIFdJCMiYvl
	FQ8D1AHci7QHrkLVWwqIaE7ayLM0VNk0yP+6AUO4d3l4K3u8bRDoqWvl9gTJthv1RNiw0IKv8MC
	X6Fx17aIMH6ZQl9u/3uJzecE2FJuHiz9ZSEDU2RjUl87KzjU4BA7Y+IEX03tagDJAfr0mSmeuyv
	XqFphzC0aKeO30Y3FQ/2hygrGbSPW3y48i2dc30Wb7FrHjmpMSg=
X-Received: by 2002:a17:902:ce02:b0:2e6:2023:29fb with SMTP id d9443c01a7336-2ed244dcbe3mr5438885ad.29.1793833381225;
        Wed, 04 Nov 2026 15:03:01 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:03:00 -0800 (PST)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v1 09/14] cxl/mem: Enforce tag-group semantics
Date: Thu,  5 Nov 2026 08:02:33 +0900
Message-ID: <20261104230445.66625-10-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104230445.66625-1-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The previous commits added validation for individual extents.  Add
two group-level checks to cxl_validate_group():

  - Sequence integrity (cxl_check_group_seq): sharability is taken from
    the group's DC partition attribute (cxl_group_is_shareable).

    For a sharable partition, extents have a shared_extn_seq number,
    which must be 0..n-1 for a tag. Any gaps or duplicate values are an
    error.

    The field is reserved for non-sharable extents, and
    cxl_validate_extent() rejects a non-zero value there when the group
    is realized.  Therefore, cxl_check_group_seq only applies to
    sharable groups.

  - cxl_check_group_partition: verify tagged allocations
    don't span DC partitions.

Each check drops the whole group on violation.

Tag uniqueness checks land in a subsequent commit.

Based on patches by John Groves.

Co-developed-by: John Groves <John@Groves.net>
Signed-off-by: John Groves <John@Groves.net>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 drivers/cxl/core/mbox.c | 138 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 133 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index a605ffc4c64f..a1d3e04a1e1b 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1452,6 +1452,119 @@ static void extract_tag_group(struct list_head *pending,
 	}
 }
 
+/*
+ * Validate shared_extn_seq across a tag group from a sharable partition,
+ * already sorted ascending.  Per CXL r4.0 Table 8-230 the device stamps
+ * each extent of an n-extent sharable allocation with a unique value in
+ * 0..n-1, so the sorted group must be exactly 0, 1, ..., n-1.  A gap,
+ * duplicate, or out-of-range value is a device firmware bug.
+ *
+ * Non-sharable extents must carry 0 here, which cxl_validate_extent()
+ * enforces per extent when the group is realized, so only sharable
+ * groups are checked; sharability comes from the partition, not the
+ * seq value.
+ */
+static int cxl_check_group_seq(struct device *dev,
+			       const uuid_t *tag,
+			       const struct list_head *group,
+			       bool shareable)
+{
+	struct cxl_extent_list_node *pos;
+	u16 expected = 0;
+
+	if (!shareable)
+		return 0;
+
+	list_for_each_entry(pos, group, list) {
+		u16 s = le16_to_cpu(pos->extent->shared_extn_seq);
+
+		if (s != expected) {
+			dev_warn_ratelimited(dev,
+					     "Tag %pUb: sharable shared_extn_seq must be dense 0..n-1: expected %u got %u (firmware bug)\n",
+					     tag, expected, s);
+			return -EINVAL;
+		}
+		expected++;
+	}
+	return 0;
+}
+
+/*
+ * A tag group's sharability is a property of the DC partition holding its
+ * extents (cxl_check_group_partition() separately enforces that the group
+ * does not span partitions).  Resolve it from the first extent; an empty
+ * group or an extent outside any DC partition is treated as non-sharable.
+ */
+static bool cxl_group_is_shareable(struct cxl_memdev_state *mds,
+				   const struct list_head *group)
+{
+	const struct cxl_dpa_partition *part;
+	struct cxl_extent_list_node *first;
+	struct cxl_extent *extent;
+	struct range ext_range;
+
+	if (list_empty(group))
+		return false;
+
+	first = list_first_entry(group, struct cxl_extent_list_node, list);
+	extent = first->extent;
+	ext_range = (struct range) {
+		.start = le64_to_cpu(extent->start_dpa),
+		.end = le64_to_cpu(extent->start_dpa) +
+			le64_to_cpu(extent->length) - 1,
+	};
+	part = cxl_extent_dc_partition(mds, extent, &ext_range);
+	return part && part->shareable;
+}
+
+/*
+ * For tagged groups, reject allocations that span DC partitions.  A tag
+ * is an allocation identity; the partition's CDAT DSMAS entry is what
+ * tells the host which attributes (sharable, writable, coherency)
+ * apply.  Untagged groups are skipped — the spec does not define a
+ * cross-chain identity for them.
+ */
+static int cxl_check_group_partition(struct cxl_memdev_state *mds,
+				     const uuid_t *tag,
+				     const struct list_head *group)
+{
+	struct device *dev = mds->cxlds.dev;
+	const struct cxl_dpa_partition *first_part = NULL;
+	u64 first_dpa = 0;
+	struct cxl_extent_list_node *pos;
+
+	if (uuid_is_null(tag) || list_empty(group))
+		return 0;
+
+	list_for_each_entry(pos, group, list) {
+		struct cxl_extent *extent = pos->extent;
+		struct range ext_range = (struct range) {
+			.start = le64_to_cpu(extent->start_dpa),
+			.end = le64_to_cpu(extent->start_dpa) +
+				le64_to_cpu(extent->length) - 1,
+		};
+		const struct cxl_dpa_partition *part;
+
+		part = cxl_extent_dc_partition(mds, extent, &ext_range);
+		if (!part)
+			return -ENXIO;
+
+		if (!first_part) {
+			first_part = part;
+			first_dpa = ext_range.start;
+			continue;
+		}
+
+		if (part != first_part) {
+			dev_warn_ratelimited(dev,
+					     "Tag %pUb: extents span DC partitions (DPA:%#llx and DPA:%#llx), firmware bug\n",
+					     tag, first_dpa, ext_range.start);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 /*
  * Realize a tag @group: assign each extent its dax-side @seq_num and add it
  * via cxl_add_extent(), then online the resulting tag group.  Returns the
@@ -1460,7 +1573,7 @@ static void extract_tag_group(struct list_head *pending,
  * the caller to drop.
  */
 static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
-			     struct list_head *group)
+			     struct list_head *group, bool shareable)
 {
 	struct device *dev = mds->cxlds.dev;
 	struct cxl_extent_list_node *pos;
@@ -1475,7 +1588,12 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
 	/* Each extent gets a dense dax-side seq_num, 0..n-1 */
 	seq_num = -1;
 	list_for_each_entry(pos, group, list) {
-		seq_num++;
+		/* Sharable: device-assigned dense 0..n-1; otherwise by arrival */
+		if (shareable)
+			seq_num = le16_to_cpu(pos->extent->shared_extn_seq);
+		else
+			seq_num++;
+
 		rc = cxl_add_extent(mds, pos->extent, seq_num);
 		if (rc < 0) {
 			dev_dbg(dev,
@@ -1517,11 +1635,19 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
  * added, or a negative errno if it must be dropped.
  */
 static int cxl_validate_group(struct cxl_memdev_state *mds, const uuid_t *tag,
-			      struct list_head *group)
+			      struct list_head *group, bool shareable)
 {
 	struct device *dev = mds->cxlds.dev;
 	struct cxl_extent_list_node *pos;
 
+	/* Sequence-number integrity */
+	if (cxl_check_group_seq(dev, tag, group, shareable))
+		return -EINVAL;
+
+	/* Partition equality (skipped for null UUID) */
+	if (cxl_check_group_partition(mds, tag, group))
+		return -EINVAL;
+
 	/* Alignment gate — drop the group if any member fails */
 	list_for_each_entry(pos, group, list) {
 		if (!cxl_extent_dcd_aligned(pos->extent)) {
@@ -1559,6 +1685,7 @@ static int cxl_add_pending(struct cxl_memdev_state *mds,
 	while (!list_empty(pending)) {
 		struct cxl_extent_list_node *first;
 		LIST_HEAD(group);
+		bool shareable;
 		uuid_t tag;
 		int cnt;
 
@@ -1581,13 +1708,14 @@ static int cxl_add_pending(struct cxl_memdev_state *mds,
 		 * the stable sort maintains arrival order.
 		 */
 		list_sort(NULL, &group, extent_seq_compare);
+		shareable = cxl_group_is_shareable(mds, &group);
 
-		if (cxl_validate_group(mds, &tag, &group)) {
+		if (cxl_validate_group(mds, &tag, &group, shareable)) {
 			drop_extent_group(&group);
 			continue;
 		}
 
-		cnt = cxl_realize_group(mds, &tag, &group);
+		cnt = cxl_realize_group(mds, &tag, &group, shareable);
 		if (cnt < 0) {
 			drop_extent_group(&group);
 			continue;
-- 
2.43.0

