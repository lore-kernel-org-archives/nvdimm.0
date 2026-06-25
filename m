Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B1B3DB32C
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386931; cv=none; b=tkbdlJCL6jXbErsrIYHyh3rapcjZf1IOkPtjN96rzPkzHkHBaByWDrsgWESlL8hxtnaci/UI1iXm9dTyWJxe0K0pmXmMoEmM5W42oDAugrH9cpbXXOVVVYxcOHZO7WYkd577PD/H2WIltJ8Fsu71RHsBoRxTVaPpCn65BpxiMFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386931; c=relaxed/simple;
	bh=IXDugotFWJ037YWrPcTKOkqIsc2DQseGutfKgWc9iZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=It2NmZ7TX8plPM0+a/j7fVC+SIIacM2dFE5N+c+uAwjWMxCVJje7fUs9bC8fRwkGN41ZBiG12kPnjeXzOe6K4bEPYcJSbHT9zC6VeOWnFYMTBsO1JgwI+LLgmxqy85M6gKwQdIoRfThiyh50wyr7PT5NYZ9eWl2wwOVOU/snaZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I+LRkHRj; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+LRkHRj"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3078e0dcd67so3100013eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386929; x=1782991729; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YYLI7SpEOi9lLbLlJZViwohpLtIvOa38YASL+E8l91g=;
        b=I+LRkHRjaZ/w73NB9GwOGj/qM+pmTpXihu+bqQEImYH6D+4MxWDLPFyQRSBzUUO3bg
         Y3RKxeU03k01RlvLGNwb+W1b69COM/B+l1KDEHCgQkiMPYcOdheVMO0aNajYGlfngJ8k
         EJWih86lSaalQxu0HWRiZC2p6qM+WmIhBNrpInKGATCyKFk4Z2YHQSv0FK2gZrIlhhzj
         D0XMys3jYDnN0jzgaBa/hW8irA/Z/U0frBXGOVTQm5gMUA0OLbD9Y+UooSwU9to6zaQ1
         vhUPoRlHvYqcGPHHtsWGFFIsb52pxrMNIm2lZsjjW19/prtnEyNSQLULXdeCva5PW84n
         bz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386929; x=1782991729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YYLI7SpEOi9lLbLlJZViwohpLtIvOa38YASL+E8l91g=;
        b=MrtQ3JHjCw3mrwyZ1ZeDDQ9PXO0KpTQUmogERs6OmFwax0xhez+Dt/6kTG5vyzc7bQ
         Lgt38QCsfh/17iwY9VH5a4BDY1iF4SE8PnGTplhJ3JuiVO03Nrj6fgzIakrC/fbnSXsF
         nhqE61or7cdOSg4W+jwRC3tA+qZPCvRbK44PtcyDBCI+EtXbIrvt90ZoTwru1dy64LtB
         XwXuY+z5hfJVcucSabBJHNLo63ZVzln/bm5JPNJyHCFWEh6MSYul2rao1PwbG4L5fj1f
         A+LeEswGH2jBBq2UR41DEI9BDQy3KDqLulUJzFfeAZhUpqrkAarLWluMJcB+dDVlpJoy
         5Xww==
X-Gm-Message-State: AOJu0Yx2pWaBDYqjiZLtd4cTThEAZnBEmqAUVmXmd8LX2MgsAIapbkZH
	izzignIp/bfvt5U20YD/Anb3nMM/d+IjZqqhs6hu3Dg6/K+HN54IVT3D
X-Gm-Gg: AfdE7cm3iuHeRHqQxXmh/RoXheOY1UgFoXgbwRMFaCDoGM6TAwMGzGa1u33vFNHxi0J
	g6SoPi+cKRZoN/O0bFB5dgOWlQTgCcFPpbiPN/IAEWgAr7SFqvlWdyl4+hCl2K5nJJUJjkkklA5
	ENh7R9gAdAS1MIdy+lVJqIebsuJDMF91GMu3sDOD6kP1n64Kjk3M96nFc2P3wBFZN1Zhyxmw8oO
	plqCpWZpDtfCxu+29QDRR/dqnIoymfua3jQl5/JtBBLHDdXe+n8zn9t0s+Qo2FB521d5zCQbTEu
	9VWh3A6ANAAGeG6bqr56BXxB5TBywGSqHQsGISBmn3QhZ1AHmRHXgNg5YQjV7Izm8v0zMeHpzyn
	P/fs6YvViBQlZg7RDCup4pdewjq8u2snDDEZ0LMcLDl4alR8nLBtwKrXpQCEc7Okzr7glC6BA2G
	WoodDZiFJaZPS3MT/y0WfoTQPVymY4RpUbHOMPjlcGH4yybLrIHEoShSvuPqXypEc9G0AzI9Zc7
	YuyStw=
X-Received: by 2002:a05:7300:7242:b0:304:dd1c:737e with SMTP id 5a478bee46e88-30c84d0e939mr2525531eec.16.1782386928578;
        Thu, 25 Jun 2026 04:28:48 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:48 -0700 (PDT)
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
Subject: [PATCH v11 15/31] cxl/mem: Drop misaligned DCD extent groups
Date: Thu, 25 Jun 2026 04:04:52 -0700
Message-ID: <20260625112638.550691-16-anisa.su@samsung.com>
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

Add an alignment gate to cxl_add_pending(): every extent in a tag group
must have its start_dpa and length aligned to the dax region's mapping
granularity.  A misaligned extent makes the resulting dax device unusable,
so drop the whole group rather than accept a partial allocation that would
surface a broken dax_resource.

Based on patches by John Groves.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: John Groves <John@Groves.net>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: gate on the dax region's actual mapping alignment (PMD_SIZE)
	instead of a hardcoded SZ_2M]
---
 drivers/cxl/core/mbox.c | 51 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 08f51b8807c0..14ba263044f0 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -7,6 +7,8 @@
 #include <linux/unaligned.h>
 #include <linux/list.h>
 #include <linux/list_sort.h>
+#include <linux/pgtable.h>
+#include <linux/sizes.h>
 #include <cxlpci.h>
 #include <cxlmem.h>
 #include <cxl.h>
@@ -1295,6 +1297,19 @@ static int add_to_pending_list(struct list_head *pending_list,
 	return 0;
 }
 
+/*
+ * Extents need to be aligned to dax region's mapping granularity.
+ * Use PMD_SIZE, since cxl_dax_region_probe() calls alloc_dax_region with
+ * PMD_SIZE for the 'align' parameter.
+ */
+static bool cxl_extent_dcd_aligned(const struct cxl_extent *extent)
+{
+	u64 start = le64_to_cpu(extent->start_dpa);
+	u64 len = le64_to_cpu(extent->length);
+
+	return IS_ALIGNED(start, PMD_SIZE) && IS_ALIGNED(len, PMD_SIZE);
+}
+
 /*
  * Compare two extents by shared_extn_seq (ascending).  list_sort is
  * stable, so extents with equal keys keep their arrival order from
@@ -1395,11 +1410,38 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
 	return group_cnt;
 }
 
+/*
+ * Validate a tag @group before realizing it.  Returns 0 if the group may be
+ * added, or a negative errno if it must be dropped.  Further gates layer in
+ * here in later commits.
+ */
+static int cxl_validate_group(struct cxl_memdev_state *mds, const uuid_t *tag,
+			      struct list_head *group)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_extent_list_node *pos;
+
+	/* Alignment gate — drop the group if any member fails */
+	list_for_each_entry(pos, group, list) {
+		if (!cxl_extent_dcd_aligned(pos->extent)) {
+			dev_warn(dev,
+				 "Tag %pUb: dropping group, extent DPA:%#llx LEN:%#llx not %#llx-aligned\n",
+				 tag,
+				 le64_to_cpu(pos->extent->start_dpa),
+				 le64_to_cpu(pos->extent->length),
+				 (u64)PMD_SIZE);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Drive the pending Add-Capacity records through cxl_realize_group(),
  * grouped by tag.  Per group: extract from pending, stable-sort by
- * shared_extn_seq, realize the group, and on success move it onto the
- * accepted list.  Validation gates layer onto this loop in later commits.
+ * shared_extn_seq, validate, realize the group, and on success move it onto
+ * the accepted list.
  */
 static int cxl_add_pending(struct cxl_memdev_state *mds, bool existing)
 {
@@ -1425,6 +1467,11 @@ static int cxl_add_pending(struct cxl_memdev_state *mds, bool existing)
 		 */
 		list_sort(NULL, &group, extent_seq_compare);
 
+		if (cxl_validate_group(mds, &tag, &group)) {
+			drop_extent_group(&group);
+			continue;
+		}
+
 		cnt = cxl_realize_group(mds, &tag, &group, existing);
 		if (cnt < 0) {
 			drop_extent_group(&group);
-- 
2.43.0

