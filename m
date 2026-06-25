Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D8B3DA7CA
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386938; cv=none; b=ecjoVuafkr6XlOFtEZ6H9qDciFwGspjIvGNzpgSEU3HZ5tlDsSNo+IymZ/KiKONb+e0ScflEMK80nbZE3+0O6hDhmWOgSoBd0N5QPljSYoaWhJjKTChwbLs8HdJqEj7R9B3s7nlVchqc4UDmFxZes/7NY7tZFv0QsekBWkDpams=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386938; c=relaxed/simple;
	bh=IOnH9C5alUD48vFy0f2TCtsifjFBNBKn6sUv32XH1vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1uhn0UDGBefAR+wGWfXD610vTEdcd6jaBJp5qe/jiQ2nFvtuVTe2iY6BwK0X3/rLi/pHYziNt/K92YRLtBczCAGOJnlnFTmgcrz8R4qHQJxOr9uKukaGxHHfcFEYQDhTOIVsn4WzQvZH/Y+/JfHE+lnjtVou02ys3MxKeqJNLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qzkbo2/t; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qzkbo2/t"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30bc871ecdfso2539013eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386936; x=1782991736; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HPvnhzk1tHShACPNm9Xrc+5UHRnHnNyUZW8MnVrGVI=;
        b=Qzkbo2/tPghU2Tl/RLeY/TVdAQnu997RUDIl4PXEQlC4UHDS56Ey1h1z/bZOX7mUBb
         tlZueRcYd0smBzYCPCpS4vKz81vsY6J0yMvjzvqebH/w/P2GE5lXDoHw4EqnEn8cV34l
         2m5KcsifSX4yIZNx514tEfCtIKfL8m913z4AUNOPM5xG2i76UrfQi4a5ZJ1YqzQNWDmd
         8qSNaeXil8IK3PS/Jw/cJ+xQnWCZUF2rROeniaPMQh6WPpiCwTXthzGG2k2iwZiuZnWw
         hp4nj4ckL7zNkZ9gzBBVMcBVtyC2DAvKNQfOeQLDlkFKJq2fUPKbgJO+F9cZ8mDHSwT9
         7nfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386936; x=1782991736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+HPvnhzk1tHShACPNm9Xrc+5UHRnHnNyUZW8MnVrGVI=;
        b=NbsLrOVKerfT16R/gFN73RlmU0RflE04ya84sxKqBG9OEBlEwjtDRR6NeQS9X4SXSP
         w32z0EVC8wZyiC6wupk/FstUCMyODcPeE/nUP+HOrqYQ8mBy1nPu+KhPvj1qS2DJyttG
         y+9ZU4lZDE00gQI0ij5jokKgmKHq0zZgpq8wPFDp7kCRdJTaFhdvlMLolkhiLlr6n65D
         bwV8uctbzLrD845Hile/pNgfjTdfM2Uy5JngA0lyhzonv73aPzizOfDiE9GFrQFgRlXn
         g1Mx+iWiuP7mHfjd3EDa1+v5aTglEmxK0kxZVXJxIqKgRQt1ShubvIn5aFXvlId+gwkx
         QxcA==
X-Gm-Message-State: AOJu0YyK6MDu1jc0BiRr43VtcgNuUwtQclhguN/ePqQ49ZERwMNQ/r8F
	QZvbrs5AzR94a4TxYXjeKoulH3hkgguTE6Xg8h5M0Ez6khHdw3ySbmp9
X-Gm-Gg: AfdE7clV6iclZdIVqmofps2rd/HS/rvLfpKpJi+z2erNPPjMi4EPcfWWIi0AdupOdQT
	0W/ljb7+8M2ID5+eeEraa52dUm01Oi1f7/NkVB+UcivMCmfjFi/cI1sE+BwFaOHs9mEBEb3Do1x
	QL74XUzwlQo9HN9vSKSAubEPynx43CQI24CXdV89Mfnhfe1/ohJ9Fevfjs/U0ofA0/Y3u9350ac
	xNoYkNoXpiPgUKsruCc9zo2fhkySKATPuhYuCZ98sSmfw6XZEf63tobiUGA0uHaAEXK6T/QqNRh
	6V+GtXq+j8GApGX1eITVP9ctRkJlt9a3dZSbbQK4tCiGNmo9fu/0WsB72Me+2aXKqNjLRv3MM5j
	hpS79TPHD+qOQCWej7pb5ih7URQUZwcvs6+fQ7WRvfKAkTG7hzNgtSVnMm7JamxV7MZZTU0yrb9
	+97rdU9gtn9bfupGk4iG+UaxPy1fQpeMhSM1//RqY8/QYUwoXlKfb2DxYKsZsrt8QYMh9U
X-Received: by 2002:a05:7300:f602:b0:304:d75b:f5df with SMTP id 5a478bee46e88-30c84eb7db9mr2017837eec.19.1782386935896;
        Thu, 25 Jun 2026 04:28:55 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:55 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v11 19/31] cxl/extent: Enforce cross-region tag uniqueness
Date: Thu, 25 Jun 2026 04:04:56 -0700
Message-ID: <20260625112638.550691-20-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The per-region scans in cxlr_add_extent() and uuid_claim_tagged() only
catch a tag re-appearing on the same cxlr_dax.  The orchestrator owns
tag allocation and is responsible for global uniqueness, but a buggy FM
(or firmware redelivering a tag for a previously-closed allocation)
can still hand the same uuid to extents on two different regions or
memdevs, and the per-region checks accept the second one — leaving
two independent cxl_dc_tag_group objects with the same uuid.

Add a host-wide registry of live tag groups with non-null uuids.
alloc_tag_group() inserts on success, free_tag_group() removes; both
skip the null-uuid case since the spec defines no cross-chain identity
for untagged allocations.

A second group with the same uuid is then rejected: cxl_validate_group()
consults the registry via cxl_tag_already_committed() and returns
-EEXIST before the group is realized, and cxl_tag_register() returns
-EBUSY as a backstop against a racing insert between validate and
realize.

No exit hook is needed: cxl_core only unloads after every dependent
module has, by which point every live tag group has been freed and
the registry is empty.

Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/core/core.h   |  5 ++++
 drivers/cxl/core/extent.c | 59 +++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c   | 16 +++++++++++
 drivers/cxl/cxl.h         |  3 ++
 4 files changed, 83 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index bbbb86ababad..ab75cc67c24d 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -67,6 +67,7 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
 		   u16 seq_num);
+bool cxl_tag_already_committed(const uuid_t *tag);
 int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
 int online_tag_group(struct cxl_dc_tag_group *group, bool skip_release);
 #else
@@ -90,6 +91,10 @@ static inline int online_tag_group(struct cxl_dc_tag_group *group,
 {
 	return 0;
 }
+static inline bool cxl_tag_already_committed(const uuid_t *tag)
+{
+	return false;
+}
 static inline
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 				     struct cxl_endpoint_decoder **cxled)
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index a590a89f3580..36be56ca1097 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -18,8 +18,60 @@ static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
 	memdev_release_extent(mds, &dc_extent->dpa_range);
 }
 
+/*
+ * Host-wide registry of live tag groups with non-null uuids.  Enforces
+ * that within this host, a tag uuid identifies exactly one allocation
+ * across all regions and memdevs — closing the gap left by the
+ * per-region scans in cxlr_add_extent() and uuid_claim_tagged().  The
+ * orchestrator (FM) owns tag-uuid allocation per spec; this is a
+ * defense against firmware bugs and orchestrator misbehavior.  Untagged
+ * (null uuid) allocations are not tracked: the spec defines no
+ * cross-chain identity for them.
+ */
+static DEFINE_MUTEX(cxl_tag_lock);
+static LIST_HEAD(cxl_tag_groups);
+
+static int cxl_tag_register(struct cxl_dc_tag_group *grp)
+{
+	struct cxl_dc_tag_group *g;
+
+	if (uuid_is_null(&grp->uuid))
+		return 0;
+
+	guard(mutex)(&cxl_tag_lock);
+	list_for_each_entry(g, &cxl_tag_groups, registry_node)
+		if (uuid_equal(&g->uuid, &grp->uuid))
+			return -EBUSY;
+	list_add_tail(&grp->registry_node, &cxl_tag_groups);
+	return 0;
+}
+
+static void cxl_tag_unregister(struct cxl_dc_tag_group *grp)
+{
+	if (uuid_is_null(&grp->uuid))
+		return;
+
+	guard(mutex)(&cxl_tag_lock);
+	list_del(&grp->registry_node);
+}
+
+bool cxl_tag_already_committed(const uuid_t *tag)
+{
+	struct cxl_dc_tag_group *g;
+
+	if (uuid_is_null(tag))
+		return false;
+
+	guard(mutex)(&cxl_tag_lock);
+	list_for_each_entry(g, &cxl_tag_groups, registry_node)
+		if (uuid_equal(&g->uuid, tag))
+			return true;
+	return false;
+}
+
 static void free_tag_group(struct cxl_dc_tag_group *group)
 {
+	cxl_tag_unregister(group);
 	xa_destroy(&group->dc_extents);
 	/* Drop the pin taken in alloc_tag_group(). */
 	put_device(&group->cxlr_dax->dev);
@@ -60,12 +112,19 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
 {
 	struct cxl_dc_tag_group *group __free(kfree) =
 				kzalloc(sizeof(*group), GFP_KERNEL);
+	int rc;
+
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
 	group->cxlr_dax = cxlr_dax;
 	uuid_copy(&group->uuid, uuid);
 	xa_init(&group->dc_extents);
+	INIT_LIST_HEAD(&group->registry_node);
+
+	rc = cxl_tag_register(group);
+	if (rc)
+		return ERR_PTR(rc);
 
 	/*
 	 * Pin cxlr_dax: it is used after cxl_rwsem.region is dropped, so a
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index a072355f2f7c..0e6d6ad0390b 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1540,6 +1540,22 @@ static int cxl_validate_group(struct cxl_memdev_state *mds, const uuid_t *tag,
 	struct device *dev = mds->cxlds.dev;
 	struct cxl_extent_list_node *pos;
 
+	/*
+	 * Cross-More-chain uniqueness.  A non-null tag seen in this group must
+	 * not already correspond to a committed tag group anywhere on this
+	 * host.  More=0 was supposed to close that allocation, and tag uuids
+	 * must be unique across all regions and memdevs (the orchestrator owns
+	 * assignment per spec).  Either constraint failing — same chain
+	 * redelivered, or two distinct allocations colliding on the same uuid —
+	 * is a firmware/orchestrator bug; reject the whole group.
+	 */
+	if (cxl_tag_already_committed(tag)) {
+		dev_warn(dev,
+			 "Tag %pUb: dropping group, tag already committed (firmware/orchestrator bug)\n",
+			 tag);
+		return -EEXIST;
+	}
+
 	/* Sequence-number integrity */
 	if (cxl_check_group_seq(dev, tag, group, shareable))
 		return -EINVAL;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index aae7eecd191a..e82d8bf1388b 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -598,6 +598,8 @@ struct cxl_dax_region {
  *		allocations.
  * @nr_extents: live count of dc_extents in the group; the group is freed
  *		when the last dc_extent device is released.
+ * @registry_node: anchor in the host-wide non-null-tag registry that
+ *		enforces tag uuid uniqueness across all regions and memdevs.
  * @skip_device_release: tear the group down without sending a Release DC
  *		command to the device.  Set when rejecting a group whose
  *		extents this host never accepted, so they are omitted from the
@@ -609,6 +611,7 @@ struct cxl_dc_tag_group {
 	uuid_t uuid;
 	struct xarray dc_extents;
 	unsigned int nr_extents;
+	struct list_head registry_node;
 	bool skip_device_release;
 };
 
-- 
2.43.0

