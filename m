Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181013DA7FD
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386933; cv=none; b=k8O/di8TvnGMcpvZnsot+CGa6OvMQopxz0Ef/2pTtpRZG/NF+ZeqzPqprlG5CvUNrYXv2S7gQ8J6GeAW89B1tuzvHVGwDvV9OcRB3VHT39FR/xA6mzW/VqOoJJ6v9Jbyd3duVsoAXtw8sW8iLZh56JkZXsIVWIxu4Io5Nx2w1pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386933; c=relaxed/simple;
	bh=tGJS3OWIuvqlRtp8ltIyZ9tQp3OjdG0pLRwZN4RJnWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iF+2TgOkcUAiAbTWv328IXj7/4DN7ZiPhE7H4CEk/iYA7aQGxL6a7aZpwJczocqXWyghYllHufg9fBd6FVUCgMR/3BJbZhy017avg6KUTSwnGOW23Td/w7cRajmza7OS3fPB4uDjYB/7P7VjUs/glzJ6w1RUdpVGswR4odxiHD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r76g1+k1; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r76g1+k1"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-30c03b09e02so4770728eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386931; x=1782991731; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cccXPDkOqVbE0XMqms+Nb/0oa1QeHw8Ja9M0piaWkDI=;
        b=r76g1+k14NlcbrdAMQxRShvVnH7xJJMHAvVcPmnTVJpYX9q0sgyvP+zIP+QIin31SB
         fginY+tKJiUBSexq2yuNxza3wohBk+XiNXWuJp/DIxozPyPBV0kPfoX+VT4NGEo91OfN
         TTc7P+0wxGpSAV4SX08t+2ojxfPCutV/F89P/mctdlyik9qMn1yt0UoInHSoGrZ363aj
         /lVu0ioIR6Ro5QhSFHFksykNCtksZcVS86aDyEcHcHXdupQph80/iwxFCFI77c1MynY+
         fMXMXfiPR77bZ/w22hNuoRLkKhr3kAveakmekPRUMYz2Nww2Y0DJBe9ESvKy7JmMkqGd
         NFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386931; x=1782991731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cccXPDkOqVbE0XMqms+Nb/0oa1QeHw8Ja9M0piaWkDI=;
        b=JWYTuD5Tk9ACZp21Ipr9S3FfQkz1rixkMGSUkTbY0/MbAuhJX9/3xMzvkZwVE/lUnm
         e2XwBpVp626SR8eYyZoNysWVfeIWz1xR+mjUgQGazLaNsNIYxptEocTCSLwTs+RpCbOa
         /IhqlDBwSflhcViMprVw/IHg9w2UWjzGtZmQ0ao/pdR/zUuJ5ZCwe153W9dRkeTcY0Dt
         J53Y1s0p4DNQiOmjRdrS5yZNUqXa2ZBREajql3u+4rBoBKEiF66wJBBo96V6ZR0Zu8KV
         yome7mwtvcNOXjAyXNu/8XBF1fbZxvd22BqcZz2kIzCUf3iexnVWNbspq0xY7Yxuqszw
         uoIw==
X-Gm-Message-State: AOJu0YyJKEbFa+ShkfrM9FHjyWksJOTfKksrt3Fgi4qbsXQZJfsNjc1c
	TpQQW0u5pt8m2zR7/lng7oExEz8sbREh0delxDoVuzb/OC/EoaNoMMcF
X-Gm-Gg: AfdE7cm/jBdt70Bu4uo+PP1P1nMDpnfQmmGx4LeAnCxyb1RmDST8eS37Uq8/TMxJp4Z
	a2Y2Ehlu+djLejSR4cdNLcA7LP82cGzShzpOlCsmZ1RuEyqmOxex4aI9o877AXjbz0zeIYW8Wpc
	DfgcOboQkRUvAE8Q6gLf86j6AxkX7H0Ly6PGJGcVFgLvrmt3WHQ0Z0uvLEdWfcVv3e+eJlC4gZX
	dqoATsSTnFMSSUhJcNZL+sku08RZSmkCs61MvGivvdBB3NCASZz7eVBeDkPj0m/EirzCX3hzNMt
	7uzKQeIXQLAqQCahLXY74a7ewbCQ47uzjb0gSImmPLit47wJ/KFY65Sb7eMXQJL3foeeLTCyY+6
	yeE5UfhOmBvzzHXSRQ9OnQaJKIvbeloustNciQOTfGPcSOAo9wtfoCLMvjB3ELATs1LsZ9dGRlp
	XdxGC5ajAm76MwIWGu71ZMYku3WtGhOQ4MAWRpTxZVa897yG86tTIyxms267ob+3SiMyAdR52/P
	Obd4kI=
X-Received: by 2002:a05:7300:1895:b0:30b:ab02:9e52 with SMTP id 5a478bee46e88-30c84dd56cdmr2558153eec.30.1782386931038;
        Thu, 25 Jun 2026 04:28:51 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:50 -0700 (PDT)
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
Subject: [PATCH v11 16/31] cxl/extent: Validate DC extent partition
Date: Thu, 25 Jun 2026 04:04:53 -0700
Message-ID: <20260625112638.550691-17-anisa.su@samsung.com>
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

From: Ira Weiny <iweiny@kernel.org>

Extend cxl_validate_extent() — the per-extent check of the add pipeline
to check partition membership.

Resolves an extent's DPA to its containing DC partition.  Sharability is
a property of the partition (part->shareable), taken from its CDAT DSMAS
entry.

An extent from a sharable partition must carry a non-null tag, since hosts
sharing the allocation key on that tag.  A null tag there is a device
firmware bug; reject the extent.

shared_extn_seq validation is checked in cxl_check_group_seq() once the
whole tag group is collected.

Based on patches by John Groves.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: John Groves <John@Groves.net>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. cxl_extent_dc_partition() declared static — it is only called
 from extent.c at this point.  A subsequent commit ("cxl/mem: Enforce
 tag-group semantics") drops static and adds the declaration to core.h
 when mbox.c starts calling it.
2. In cxl_validate_extent(), declare the local uuid as a struct
 (uuid_t uuid) and fill it via import_uuid(&uuid, extent->uuid) instead
 of casting (uuid_t *)extent->uuid.
---
 drivers/cxl/core/extent.c | 85 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 6e67e787d14d..2e770c5279c2 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -76,11 +76,67 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
 	return no_free_ptr(group);
 }
 
+/*
+ * Find the DC (Dynamic Capacity) partition that fully contains @ext_range,
+ * or NULL if the extent falls outside every DC partition on this memdev.
+ * The returned pointer is owned by mds->cxlds.part[] and lives for the
+ * lifetime of the memdev.
+ */
+static const struct cxl_dpa_partition *
+cxl_extent_dc_partition(struct cxl_memdev_state *mds,
+			struct cxl_extent *extent,
+			struct range *ext_range)
+{
+	struct cxl_dev_state *cxlds = &mds->cxlds;
+	struct device *dev = mds->cxlds.dev;
+
+	/*
+	 * A device-side error could cause end < start, which range_contains()
+	 * would treat as contained in any partition.
+	 */
+	if (ext_range->end < ext_range->start) {
+		dev_err_ratelimited(dev,
+				    "DC extent DPA %pra (%pU) has invalid length (firmware bug)\n",
+				    ext_range, extent->uuid);
+		return NULL;
+	}
+
+	for (int i = 0; i < cxlds->nr_partitions; i++) {
+		struct cxl_dpa_partition *part = &cxlds->part[i];
+		struct range partition_range = {
+			.start = part->res.start,
+			.end = part->res.end,
+		};
+
+		if (part->mode != CXL_PARTMODE_DYNAMIC_RAM_1)
+			continue;
+
+		if (range_contains(&partition_range, ext_range)) {
+			dev_dbg(dev, "DC extent DPA %pra (DCR:%pra)(%pU)\n",
+				ext_range, &partition_range, extent->uuid);
+			return part;
+		}
+	}
+
+	dev_err_ratelimited(dev,
+			    "DC extent DPA %pra (%pU) is not in a valid DC partition\n",
+			    ext_range, extent->uuid);
+	return NULL;
+}
+
 /*
  * Stage 1 of the add pipeline: pure, no allocation.  Resolve the extent
- * to its region/endpoint decoder and ext_range, and verify the range
- * fits in the resolved endpoint decoder's DPA resource.  Further
- * per-extent invariants layer into this function in subsequent commits.
+ * to its region/endpoint decoder and ext_range, and enforce every
+ * per-extent invariant the device must satisfy:
+ *
+ *   - DPA falls inside a Dynamic Capacity partition (cxl_extent_dc_partition).
+ *   - Sharability is a property of the partition (part->shareable), not of
+ *     the shared_extn_seq value: a sharable-partition extent must carry a
+ *     non-null tag, and a non-sharable-partition extent must leave
+ *     shared_extn_seq reserved (zero).  The dense 0..n-1 numbering within a
+ *     sharable tag group is validated separately (cxl_check_group_seq()).
+ *   - DPA resolves to an endpoint decoder attached to a region.
+ *   - The extent's range is fully contained in that ED's DPA resource.
  *
  * Caller must hold cxl_rwsem.region for read (cxl_dpa_to_region()).
  * On success, @out_cxled / @out_cxlr_dax / @out_ext_range carry the
@@ -94,6 +150,8 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
 {
 	u64 start_dpa = le64_to_cpu(extent->start_dpa);
 	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct device *dev = mds->cxlds.dev;
+	const struct cxl_dpa_partition *part;
 	struct cxl_endpoint_decoder *cxled;
 	struct cxl_region *cxlr;
 	struct range ext_range = (struct range) {
@@ -101,6 +159,27 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
 		.end = start_dpa + le64_to_cpu(extent->length) - 1,
 	};
 	struct range ed_range;
+	uuid_t uuid;
+
+	import_uuid(&uuid, extent->uuid);
+
+	part = cxl_extent_dc_partition(mds, extent, &ext_range);
+	if (!part)
+		return -ENXIO;
+
+	if (part->shareable) {
+		if (uuid_is_null(&uuid)) {
+			dev_err_ratelimited(dev,
+				"DC extent DPA %pra: sharable-partition extent has null tag (firmware bug)\n",
+				&ext_range);
+			return -ENXIO;
+		}
+	} else if (le16_to_cpu(extent->shared_extn_seq)) {
+		dev_err_ratelimited(dev,
+			"DC extent DPA %pra (%pU): non-sharable partition but shared_extn_seq=%u (firmware bug)\n",
+			&ext_range, &uuid, le16_to_cpu(extent->shared_extn_seq));
+		return -ENXIO;
+	}
 
 	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
 	if (!cxlr || !cxlr->cxlr_dax)
-- 
2.43.0

