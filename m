Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833386;
	b=MbHouvQY4slHR+0z9qIpY5YYaxW/b0jLmk1BHymP5VnpuL+DU1DOgd/eEPKvSOJU/6f1
	 Weh0Dv2fqpfOpU4BGuD8D0W/p434J/KtqJ6fHTAQNskAWahg0Nm1/dAFDvQmQYgTCYx7I
	 5tD3DhHxxC4S0nVoHV/FjHOVsNVVdgiyY4OybzMla18Y1e+uUxm1Tpbzj0T0Ngq10gAo9
	 Xa3WtB1LBWu2tgKTGgr49KLQe3FSvSOs3MmN103ykIgATVUYotyCJJlkiXChdDZ2dzfS/
	 rSXYlu9wgIyM9hvax/Zr4OwLEqM8NbYK6aJoETKYEZJjTHNU97JY4bgKFAUCLXooDLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833386;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=9lJTku6tZLx6gKrffgVjANOZdcGCC7AXBaK81+9zGYE=;
	b=X4WFiRAcXqbY2Vj7cDuLONMIYVtubMpXw+Vp4gv1Vv2LmQfJs0ZQWONS/aJd8R8LOUtW
	 GsRAfzGJwOWVvqieqqqEXd3uoXgEgWtxDPst3JF9MdWjkYeiWW52wPf8T93dERWTmWEok
	 UFDsKul3alkD5V7qzMwD+5ZyYUsLln0x09RsBrVEA/xeshrJ4mrU9beG5MCc3UHl1m9NI
	 g8aBl0LyFfAzwapl8Rnwt4TBQIsPa+TdvIZPmFo2soirKgOUKO4JKf45mZrUP99DJQtRP
	 vbP8WeKdPcp/hlIiyywxZbhvHXTjfznngmZPyMK0Eb6T1AK32bp2jJPKMRf97MAtSlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JLBvE7X7;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55D606D802
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E55D606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JLBvE7X7
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e977109392so7838455ad.0
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833385; x=1794438185; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9lJTku6tZLx6gKrffgVjANOZdcGCC7AXBaK81+9zGYE=;
        b=JLBvE7X7rUauu91iD1rb2Xdb+HcHw0LOAMqaIwItujFibjgGXEppu5w4fsTsQ3ZftK
         g/Kz7yZppLnKlU+sZH1OOxRYiKgrKkO8bf/dQdRjeS4jV9ZtfiqRKOTQQJp3R53cAzOt
         OWEOxBoLZsTn/ebe7aM6TlotPQ7puhV1guVI2mIKtA94vHDl/A483YT7iS8men11xolx
         VgFCGuE0z4wVGUPi/fUIjohWDAzaVTqao2cXdKUulgZdW6cb6DRowcMrtS/zZOBPevWo
         W4/j99ld/4qUE62865jXwMF3blyAPPhVCzFlxXbpwOQ9R4GeWavLfGRSZJS4g6vgjsbr
         +znQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833385; x=1794438185;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9lJTku6tZLx6gKrffgVjANOZdcGCC7AXBaK81+9zGYE=;
        b=PjIuuH3azdWFGU/6KzCtDAkwqwW+qD7bLWHCFTfdR7k39EV7mTUsy9XlU4W3kxY03d
         EeMMGgsuFjILigPhzliLeD5FNDp229u2uomZwotPCzTexIL6/CIqoAYrDpW7XALwIOH8
         VBTp9lsxMVLDmGG0qE0refsWhRyzrGDHrrV2jScvUuD8r3pRaz+lSD9Fr6++WsC2lRxb
         ZM6X3yG/GdjyOWsfBJK9mpt1Svs9BPUBTjnPL1Ho5eoP3g4HUn4dUgXknrYYNIyeIVIc
         Q+ebvMVwhry08cPBIfanN1Gh+h/Wt0B9HwVFyN7iw7oGrvCgDaFyZqW9Z3qquoDLwgD+
         a0tA==
X-Gm-Message-State: APuU4Z98m9p6U2VrViJFkYyZ2PYfODza36mV2TErsBxX5A8vYiGtN2kK
	yo9QQSiFZFej65fjNrmjaBitf49aiH5DhQvnTlNQeqHKWzmFvPYo0Iow
X-Gm-Gg: AYBFou3HhEUZ9p2veMwqfdQm43tjR8aJt7LJm/h2hsgCqQDtp9IcLsmhCX4N393BQCO
	qVCEdIpE29sWwMbUxUPSTEYhEpCSomxecWms5rGiuMj+YCD9DhKIrSd5b9TNnvlJknnaJ5q/Vqw
	Tb99fRVMKgXE9UNtsjpNfPgdvdnjEh2unwCCheRJHkUuiMLNAoDa3yVgTYaT4Jo2Dj53Ock8ATg
	DGYRi/jr4MDr1huRQ04RUaqCnXlYD7GbSvoZzkfSKzRv/AkZNaNy3Y+hvg3/nL/417dQ3hiWD6x
	Y6RLtCrFr2UFuhLxACDvW66zzTyd0xhGju2HS4WTdZy6rqO3R9xAPdc7BSQvbEr7dVBjWk6aMCA
	+gZO0aEeX5rdZ+pSBLDpg8DybWpzL3PhyFVGa4bRl11OIFpQaDmkilA0x/HutIYnqlzWW5LURR1
	7hRuTO/LuV6eSLb0JE5s5Zs0CBk+ss27Cw9mF7ZtGm2BgLrUyzx4VUU0dc/jLAnYoZF0SuLaCOu
	57/L77oDm/RLoFPFXh3xVTURg5VBoaCdCTA1UQ2PRpcPAiqYTatxYrqXN5MvHEpe6r4Ws+o+FlS
	Dq/VUzd9SzZCgltPYRwIekyCji1QxoCwKAWrSEvYyb2XuMJQJyk=
X-Received: by 2002:a17:902:dacf:b0:2e2:dfe4:adab with SMTP id d9443c01a7336-2eb36426d08mr166711845ad.10.1793833384590;
        Wed, 04 Nov 2026 15:03:04 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:03:04 -0800 (PST)
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
Subject: [PATCH v1 10/14] cxl/extent: Enforce cross-region tag uniqueness
Date: Thu,  5 Nov 2026 08:02:34 +0900
Message-ID: <20261104230445.66625-11-anisa.su@samsung.com>
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

A tag uuid identifies one allocation across all regions and memdevs,
but nothing checks a new group's tag against the allocations already
live on the host: cxlr_add_extent() only compares it with the chain
group being assembled.  The orchestrator owns tag allocation and is
responsible for global uniqueness, but if a firmware bug or other issue
causes a repeated tag, the kernel should also reject it.

Add a host-wide list of live tag groups with non-null uuids.  Null uuids
are skipped because untagged extents are not associated with a single
logical allocation.

Check the list during tag group validation and return -EEXIST if the tag
is already live on the host via cxl_tag_already_committed().  New tags
are inserted to the list via cxl_tag_register(), which inserts atomically
under cxl_tag_lock.

Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 drivers/cxl/core/core.h   |  6 +++++
 drivers/cxl/core/extent.c | 56 +++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c   | 16 +++++++++++
 drivers/cxl/cxl.h         |  3 +++
 4 files changed, 81 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 528eec2a1cc3..b7f8886db498 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -79,6 +79,7 @@ void kill_regions(struct cxl_root_decoder *cxlrd);
 
 int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
 		   u16 seq_num);
+bool cxl_tag_already_committed(const uuid_t *tag);
 int online_tag_group(struct cxl_dc_tag_group *group);
 bool rm_tag_group(struct cxl_dc_tag_group *group);
 void discard_tag_group(struct cxl_dc_tag_group *group);
@@ -117,6 +118,11 @@ static inline int cxl_dax_untagged_add(struct cxl_dax_region *cxlr_dax)
 	return 0;
 }
 
+static inline bool cxl_tag_already_committed(const uuid_t *tag)
+{
+	return false;
+}
+
 static inline
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 				     struct cxl_endpoint_decoder **cxled)
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 334a97ab583d..4a59db823af4 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -6,6 +6,54 @@
 
 #include "core.h"
 
+/*
+ * Host-wide list of live tag groups with non-null uuids: a tag uuid
+ * identifies exactly one allocation across all regions and memdevs.
+ * The orchestrator owns tag allocation; this rejects a repeated tag
+ * from a firmware bug or other issue.  Untagged (null uuid) extents are
+ * not tracked: they are not associated with a single allocation.
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
 static struct cxl_dc_tag_group *to_dc_tag_group(struct device *dev)
 {
 	return container_of(dev, struct cxl_dc_tag_group, dev);
@@ -15,6 +63,7 @@ static void dc_tag_group_release(struct device *dev)
 {
 	struct cxl_dc_tag_group *group = to_dc_tag_group(dev);
 
+	cxl_tag_unregister(group);
 	xa_destroy(&group->dc_extents);
 	/* Drop the pin taken in alloc_tag_group(). */
 	put_device(&group->cxlr_dax->dev);
@@ -93,12 +142,19 @@ static struct cxl_dc_tag_group *
 alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
 {
 	struct cxl_dc_tag_group *group __free(kfree) = kzalloc_obj(*group);
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
index a1d3e04a1e1b..0fa501f5800c 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1640,6 +1640,22 @@ static int cxl_validate_group(struct cxl_memdev_state *mds, const uuid_t *tag,
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
+		dev_warn_ratelimited(dev,
+				     "Tag %pUb: dropping group, tag already committed (firmware/orchestrator bug)\n",
+				     tag);
+		return -EEXIST;
+	}
+
 	/* Sequence-number integrity */
 	if (cxl_check_group_seq(dev, tag, group, shareable))
 		return -EINVAL;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f7d7749d704c..79f5773f8f81 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -642,6 +642,8 @@ struct cxl_dax_region {
  *		allocations.
  * @nr_extents: live count of dc_extents in the group; the group is freed
  *		when the last dc_extent device is released.
+ * @registry_node: anchor in the host-wide non-null-tag registry that
+ *		enforces tag uuid uniqueness across all regions and memdevs.
  */
 struct cxl_dc_tag_group {
 	struct device dev;
@@ -649,6 +651,7 @@ struct cxl_dc_tag_group {
 	uuid_t uuid;
 	struct xarray dc_extents;
 	unsigned int nr_extents;
+	struct list_head registry_node;
 };
 
 bool is_dc_extent(struct device *dev);
-- 
2.43.0

