Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797F638886B
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529453; cv=none; b=Pji7LZnn4APrImsU++wI+td7Wfg/Rnq9nclorkIfm3IVXvJCT0lrI+YGxoecYbuqgNDKyHkHCoRoA7eNLCl9c4dIgOORG4FWFLyJGGJ8iCeNSFMltva4x/eSGO3Pk5CFavScfJNbUK5G4Qavc/IehynWgNRinqmOrPjMqbaPDUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529453; c=relaxed/simple;
	bh=gKHsMOo3U8ogPTf8EO+rxX/WXeg527xCY1DR9mB6g58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sK9s1cDsVXQPACbjUp/PJ6uAO5aS0Jm15IkuXU4mTGd7sUe4UVF3t3wZ28Z8wpnxYzQ28d/E48DSoL19WvDYK4t7olIOJXQHWgvXUl/siZrPTRTOSql0wVXboZX/CTPxG9ZoBd0AJzJ6pxffCRlY6JQUW4VqOVtcR5jev1dgDgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nzjZZR5M; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nzjZZR5M"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-133466cf955so24035622c88.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529451; x=1780134251; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqVfs6tjDDURbhRxkrKwQ4ZptDDu5a3li/NIrzqLAV8=;
        b=nzjZZR5M0Mp4nXogvDeY9PsKOZuVgN3kFib+A20PGm/b5awVTt6GC6gUsl/xHedQ9j
         ceOO/dUQm7e4mNAyoOTvJozXrHbnDM+OnCO0WZaRcUe25cTncs9WkYqQ6e1ESfe9B5Px
         hmuN7sXw5j7+xXhJhRY76J4DZJ3+brJIcNiVV1bhSzQUjHoiwT4QQxL748bu/PMx6YXD
         j+MWP7TGD4j1PhIYJ5nF0SFMG+0F/gB2YD2nfQMb0UVMO3tzAciXYMB4RVXNCDtxBoFp
         y4FYmjlhaKuR1Y25SmHd6YhYXbXsezyDGqHMn1GBDR9VJDvsoMvHL0gotmrHBoqjIr3/
         HOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529451; x=1780134251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MqVfs6tjDDURbhRxkrKwQ4ZptDDu5a3li/NIrzqLAV8=;
        b=TOCQFlTlUGXkBEP5oRhwNDgwu9/7a7wvcCDU05pRH8K+BYMXu4uIyWUkHdTKFJJdVQ
         zkF5Lpnruhs4SduNkmnh7glf4v+nNny4pm8R+pE57R6ROVmDaGhvx/b1dXoeQEaZ7jT5
         /NE3Yhi9jye5xwAnWkWfrCJ17D3xqFI7ytauLJXnqI5/xkbaSGWf5mVBi4s6YhHp+Vsq
         1ttyygBc5mLCPJrPZ93uhqdY0b+y68r/eX0MTvqExrILmFP+ckdDweijO1O8grEY6iuU
         X8X4ORPNRaMnZKNR3mW00/ay4x0AlQ9djk+n/X0exL22JXOsFIO9zSWukAkKW6e9IME/
         VCow==
X-Gm-Message-State: AOJu0YyvxBhcHwfNtS8PmPcd0jmu6FrgdsX0jY0DytBhhBh3V38LY8yD
	XNUUWKWKVhcMvPhJSgE2go0CJ/1zzhoKwAMj2VMJQWO8vA4UUotb7c26
X-Gm-Gg: Acq92OF9pCH0C0ZJaTJlpK5liU0Go0ilNp8caBbp+htwnhD7NJBpajX+JownyySfjFX
	yBDYFxZr/zKqWwFtNiiqlCRP2QJCvRhnD4yfKpD6T6Cfqb1khCDvpovI2f5BdkqtM8fTdvFyIe4
	nnCsOGxxPG49VWE5RqoqRj/pvLyNPMrV3CveyiXIraY6vpnb6oB0sQP0Q9EfXar+ysw+7lBW1A3
	Q9e+rq/yyjr2jSMRCEwLyDeJWeJ8kQbkV5tGzEsCl41ipO8T5WSbX44SgteVwW9Yburt3dDLYN4
	zIUse6MggaVZQ44dGs+w8xPdiUT3EzulNwymvcMz3CtpJn0e8cmILV6Rf4RnT8ZUL0Zfn7yU8CI
	Ty6KhHpYlKH5uegUZ/Zq5y5C4C7phnS8wEH2gvc8/Z1Tyr0GNjgtgOs+InNVb2ivXyyHCDhaFqV
	qhaT6DeuEmpUkg4Y3JnigD2orBzDF/Sxq6p4WGfc1X7GpeImrRDLW3oKRGBlfk5Tp+mxjXPAwy5
	TslSxQ=
X-Received: by 2002:a05:7022:ff48:b0:12a:6fb7:87e3 with SMTP id a92af1059eb24-1365fc6d7demr3181465c88.31.1779529450522;
        Sat, 23 May 2026 02:44:10 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:10 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 17/31] cxl/mem: Enforce tag-group semantics
Date: Sat, 23 May 2026 02:43:11 -0700
Message-ID: <9e1f5b0b36fd1607691c649bd39abecf2e60f8e6.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The previous commit fully-fleshed out validation for individual extents.
This commit completes tag-group validation.

Add two group-level gates to cxl_add_pending() that
cxl_validate_extent()'s per-extent view can't see:

  - Sequence integrity (cxl_check_group_seq): well-formed iff. every
    member is shared_extn_seq == 0 (non-shareable) or the sorted group
    is exactly 1..n contiguous (shareable).
  - Partition equality (cxl_check_group_partition): tagged allocations
    cannot span DC partitions; a partition's CDAT DSMAS entry is the
    unit at which shareable / writable / coherency attributes are
    described.  Skipped for the null UUID.

Each check drops the whole group on violation.  Cross-chain uniqueness
of a tag lands in a subsequent commit alongside the host-wide tag
registry.

Based on patches by John Groves.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Groves <John@Groves.net>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: split out as a separate validation step.  Cross-chain
 uniqueness moved to the dedicated "Enforce cross-region tag
 uniqueness" commit so this one only adds — no add-then-replace.]
---
 drivers/cxl/core/mbox.c | 117 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 421bd716a273..545c48c9c373 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1342,6 +1342,109 @@ static void extract_tag_group(struct list_head *pending,
 	}
 }
 
+/*
+ * Validate shared_extn_seq across a tag group already sorted ascending.
+ *
+ * A tag group is well-formed iff either every member has
+ * shared_extn_seq == 0 (non-sharable allocation) or the sorted group is
+ * exactly 1, 2, ..., n (sharable).  Anything else — mix, gap, duplicate,
+ * non-zero starting other than 1 — is a device firmware bug.
+ */
+static int cxl_check_group_seq(struct device *dev,
+			       const uuid_t *tag,
+			       const struct list_head *group)
+{
+	struct cxl_extent_list_node *pos;
+	u16 first, expected;
+
+	if (list_empty(group))
+		return 0;
+
+	pos = list_first_entry(group, struct cxl_extent_list_node, list);
+	first = le16_to_cpu(pos->extent->shared_extn_seq);
+
+	if (first == 0) {
+		list_for_each_entry(pos, group, list) {
+			if (le16_to_cpu(pos->extent->shared_extn_seq) != 0) {
+				dev_warn(dev,
+					 "Tag %pUb: shared_extn_seq mixed 0/non-zero in one allocation (firmware bug)\n",
+					 tag);
+				return -EINVAL;
+			}
+		}
+		return 0;
+	}
+
+	if (first != 1) {
+		dev_warn(dev,
+			 "Tag %pUb: shared_extn_seq starts at %u, expected 1 (firmware bug)\n",
+			 tag, first);
+		return -EINVAL;
+	}
+
+	expected = 1;
+	list_for_each_entry(pos, group, list) {
+		u16 s = le16_to_cpu(pos->extent->shared_extn_seq);
+
+		if (s != expected) {
+			dev_warn(dev,
+				 "Tag %pUb: shared_extn_seq gap/dup: expected %u got %u (firmware bug)\n",
+				 tag, expected, s);
+			return -EINVAL;
+		}
+		expected++;
+	}
+	return 0;
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
+			dev_warn(dev,
+				 "Tag %pUb: extents span DC partitions (DPA:%#llx and DPA:%#llx), firmware bug\n",
+				 tag, first_dpa, ext_range.start);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 /*
  * Drive the pending Add-Capacity records through cxl_add_extent(),
  * grouped by tag.  Per group: extract from pending, stable-sort by
@@ -1371,6 +1474,20 @@ static int cxl_add_pending(struct cxl_memdev_state *mds)
 		extract_tag_group(pending, &tag, &group);
 		list_sort(NULL, &group, extent_seq_compare);
 
+		/* Sequence-number integrity */
+		if (cxl_check_group_seq(dev, &tag, &group)) {
+			list_for_each_entry_safe(pos, tmp, &group, list)
+				delete_extent_node(pos);
+			continue;
+		}
+
+		/* Partition equality (skipped for null UUID) */
+		if (cxl_check_group_partition(mds, &tag, &group)) {
+			list_for_each_entry_safe(pos, tmp, &group, list)
+				delete_extent_node(pos);
+			continue;
+		}
+
 		/* Alignment gate — abort the group if any member fails */
 		bool aligned = true;
 		list_for_each_entry(pos, &group, list) {
-- 
2.43.0

