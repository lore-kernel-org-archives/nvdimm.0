Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833375;
	b=Lw01nv+EAsxf2gbHtF+MvpN9FcI/MFmtjTavxjbH4kNSGSd2dmPJj/Vi3TVHp7M0ycKb
	 6hejbZTtI3ho2nweGcm1FVtFFL4mfIvA5ALPqM78oXpeob03GzMaAszMJPtteosEWUu3j
	 +qLYiFxtqIAW2lAfB3eVWEImvYhPHKx8wldySKSsoGVvTufv2JTOea2MZ0NKW7aH1RZ3b
	 6ZM3sLac0FfxZPGQvH8OU1F0wzC8OeWez/6g1lruL/9z2Lgg52ac0jX17/aGbDefIdkb8
	 t3/nKxby0YoE83jAmAwZyGksSLWiSIPnrJdwqfRy526lB7e8Q3UuD2niZ+a7qoamqoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833375;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=JjAyaGZls9f5VsEm6NTVGb8BE0iRo4CKaOU62Z44t6A=;
	b=EW7xfePcSOChrwutHTNJf8hNogz2Nlr2QEbmVNRZd9zP+j8FfNwOIkMoCaIqk8EniX6V
	 jiG2z4uIeTBmM9z9hgq7MRvMfZN7TU2bPtEbIbTvcKUwTPUV9B8QS2WOxUhErsoWSmBG1
	 +jTgfscQQcMqcnYLm2g+6xPNzGEpoqQA06q4n3ZJV8u+ypS5hMBCr7XtdV7k5LalbHfFk
	 RfUjCiDdfUHjWpkPTyH975WzY6ETjunpmHgPK26QxwtLPjh8lg0i+Y+JSHRZyfGTjFmJ8
	 GtCNqcfP9ia6bitBJlE1jy4wBt1Iki1BTwSl31hV87wGvmBA1SKdKf1P9owCmEXFD1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="eFr3Fi/T";
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4E86082BDB
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:02:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C4E86082BDB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eFr3Fi/T
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ed06b725fdso575615ad.0
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833374; x=1794438174; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JjAyaGZls9f5VsEm6NTVGb8BE0iRo4CKaOU62Z44t6A=;
        b=eFr3Fi/TNd9nQBPVGC++wN5z1AI0FCKJ8brnKsnTKQFNuu8+EkUkF/zpX79xQyq9fg
         56Mwhxb3Eeddug93cQT4+vwQ4Li3Zk6hd1q5VFFjAt/LcJPthUyYgpBvHILAW+JXt/Rm
         uInEORGG7lrB8Ccz+0plzdpcwdgaDejM2ReVn9XNNqT3aHV2B98kxoPmwk0R4XaP/Leo
         SX63C3bUuwnsGGZQh9o2EpUy0LKzLZ7yiyVk9gxkhmEqDILBjFgUcKD7LQh0sKF7DaCG
         fNr/YCMbyxQQV2QMu/4Ca4QPlaQNYFQzaIZDO4Ksyds1ECVE8W3G5GWgYSey7oJH4MpZ
         b9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833374; x=1794438174;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JjAyaGZls9f5VsEm6NTVGb8BE0iRo4CKaOU62Z44t6A=;
        b=TYkegCGn/sGjC4Xx4VIJeJ6ZbcKRMbvwlhsABeXiBmsFwqRkL3sALiVDDGy0L0UChW
         tn9VXIJKQpmGTcKIAweY0P4ZI1+GyrV7P9zDvgO41ZCnl+QIUj09J+C5vRwTk+Q1yjhv
         QryoHw1d+rIDKXOYlUvJGxx1EETt5xPDWnblXPJBG9J5TfuVCUB3cmY7nJ+dzLhuQhdg
         DwSxzhIlgvYdkfJSCeNxnJjpJeat1LQp3xcUmT9lDbNaiFD1Wvx04xL/dJQM/JOSEG1+
         pMYs+IPlxXWIV8SOVA79klZs/AnhH2LLA8pipm6+cPC3pglnc6cEH3gUmZ3QQKVqFgii
         I30Q==
X-Gm-Message-State: APuU4Z/OkXjBjKeXW9auzTzQifj6vrSacCgNUHsDqEtn8xV/Jauqteld
	40MrU03qtoI/e9sPvpAI+M/povqTnxqAqu96+6JEjHRGJhHZ2GQpVbeQ
X-Gm-Gg: AYBFou3/UG855QuckEFWDEwyYyx8jjOmjdrW3oJ/IpHmcwUjZqgsikhZcj+ymTznRM2
	Izgb47RVIwzQpSIeSB1Z62XgoqGsviQS9kPynhdkKrs/nUNp6dKEyocy5hv07uhVLFOtTEBrf0z
	/g4Ly6bqM+C+Q+EHCgBSyl7CwaDNzsyBCKo72DT6a8F3kxW9lBKO1xgA+hysKKtkK22aK/VgNAd
	pL2SxRqrOjp1wRJLNC+lSanlyVQP0zAytSOeaSTzW9ARcTq6AycVxgcs1uO9BsIlHFUc2gtoXpl
	oOflJZvmPfyyuWjmdSsCB02wyo4AN2fE1LyYVCvS4Tw7OU5ZfXAckQqoF8uTdcWNPswNm6X75in
	Ijedpi/Rb9ikSXHBHCXWu8At5G3bik9KCkEz4M9Jc+2suLpmhGz99kc6LB+9qTg3oGlmT7wD0qQ
	9OKwODdypj5cdw4wWAwGu4BDLwxzD0NUK20IQBPAF3/1YxXT+Crl+tOrpUDTWDrPYGl+tnyWLS+
	2oyL1IxBzuH8ta69F6MhR+1vZQXkQC+bbdL3rCRRO3Ahp+2wjGDarhWw6BIt2viKKYE6wso3vHh
	Uas2gqdqT3hEiQc3yv3LSFFoLCLKPA==
X-Received: by 2002:a17:902:eb8b:b0:2e9:6333:fba8 with SMTP id d9443c01a7336-2ed23ef99d9mr5080245ad.16.1793833374462;
        Wed, 04 Nov 2026 15:02:54 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:02:53 -0800 (PST)
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
Subject: [PATCH v1 07/14] cxl/mem: Drop misaligned DCD extent groups
Date: Thu,  5 Nov 2026 08:02:31 +0900
Message-ID: <20261104230445.66625-8-anisa.su@samsung.com>
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

From: Ira Weiny <iweiny@kernel.org>

Add an alignment gate, cxl_validate_group(), that cxl_add_pending() runs
before realizing a tag group: every extent in the group must have its
start_dpa and length aligned to the dax region's mapping granularity.
A misaligned extent makes the resulting dax device unusable, so drop
the whole group rather than accept a partial allocation that would
surface a broken dax_resource.

Based on patches by John Groves.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: John Groves <John@Groves.net>
Signed-off-by: John Groves <John@Groves.net>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 drivers/cxl/core/mbox.c | 46 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 18044f216de5..a605ffc4c64f 100644
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
@@ -1395,6 +1397,19 @@ static int stage_pending_extent(struct list_head *pending,
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
@@ -1497,6 +1512,32 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
 	return rc;
 }
 
+/*
+ * Validate a tag @group before realizing it.  Returns 0 if the group may be
+ * added, or a negative errno if it must be dropped.
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
+			dev_warn_ratelimited(dev,
+					     "Tag %pUb: dropping group, extent DPA:%#llx LEN:%#llx not %#llx-aligned\n",
+					     tag,
+					     le64_to_cpu(pos->extent->start_dpa),
+					     le64_to_cpu(pos->extent->length),
+					     (u64)PMD_SIZE);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Drive the pending Add-Capacity records through cxl_realize_group() one
  * tag group at a time, moving each group that realizes onto the accepted
@@ -1541,6 +1582,11 @@ static int cxl_add_pending(struct cxl_memdev_state *mds,
 		 */
 		list_sort(NULL, &group, extent_seq_compare);
 
+		if (cxl_validate_group(mds, &tag, &group)) {
+			drop_extent_group(&group);
+			continue;
+		}
+
 		cnt = cxl_realize_group(mds, &tag, &group);
 		if (cnt < 0) {
 			drop_extent_group(&group);
-- 
2.43.0

