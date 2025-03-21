Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F53422DF8A
	for <nvdimm@lists.linux.dev>; Fri, 21 Mar 2025 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580457; cv=none; b=r+Bwr8/4UehiZJiS/c/8RL8JsW4KhWhnvo6S25sYlee8C9scCI6B/zZ9daDvo4GIslnoDFRpn3ZFEBj/unS3tlZ+oiI5MI2Jf9i2obfZzsDt0JKBG/BYrn/cLFbbziBwNK5Fssl3E9NwYM84BBn5swEebrefWyy5rFDGqP+in3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580457; c=relaxed/simple;
	bh=47Y8hQip99iCf7c6Dmi/CZyHe8FpzUoY9ZGUEv+WWks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i8+mD5T1AdPAAtQMpp7ibi9CZpDTmaidrJFcFn1BMf6mTYryHuahNYqo7NadJBjFr/KCIIT50GVtmJd7koZAOocxF7BzWEmoZczyMr86nb3TRw2sTwaB/XeuCo/AxSA4AcJ/f/5Q0trpwBBK6Bjzu8+TgcYuoPKZkc/vBW55iuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YNygwB7t; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="YNygwB7t"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c5b8d13f73so172299985a.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Mar 2025 11:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1742580454; x=1743185254; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YLZ7c8PVq08fNJyONQLIT/0eP11NvUsx2TyTerL7XHc=;
        b=YNygwB7tZ4chpmTITHpSz4aKS9wE7I+fJ+fkD5y91fHSV+VpDTv59MwNeTXgYAp9Zb
         KtI/dzc+2QpbMrCLS0uAVHUE6YTA6c3bsMveFXC0gMl8LMjq8pr+K2RyIyP3cQxPAQXf
         KQFH57mB+uO8GkOacW8dEPRklPHD8oXJ2NqrjQpmx0H/gzafaJ6mH5+A+lvdai/r7FAC
         RU6Xcy7zMrvCCp62yCTAgPLoClyjqG4gkuuBvPs0xQOYpmH2C4cb6LR+svylrcXlkGC6
         PjTvvHfb4iXT2af9QrQmdBoRt1UjUIVLJsAOMjzzz96hGgC1Df+uJsm/uX0PJRqeOJHH
         4y8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580454; x=1743185254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YLZ7c8PVq08fNJyONQLIT/0eP11NvUsx2TyTerL7XHc=;
        b=jlH99RbI+y6RfPni6Qqegv+li9j2GJpEKd0WBgYSrk13ylCRaZJvxL+3/1ZYXVNYIV
         jgW7liO0i1GzJxIxjboExCQzgfYLkVEv+jCt2vByVz25MfsbkbcbxqPDvzEDsDvBGekR
         fHvw3jowNxgQH3K/sq2CI7OPH43LmYstHkFZV9SWaFFQD6evigGbLd4MeQFnJuKI6jTK
         8q9hVROIUa21OEwRRpQRFRv6CKcxG9xp8l4iNIZFlUf3VxapZUUL1OUnK5D5FWdpiSjM
         A50Qt6Yf/5mB2ZlzCMVAhpjbjvsS3QulhErUCiWFIFddEYgltMWv958wrZ4/3cyhWFwW
         mZmA==
X-Gm-Message-State: AOJu0YysLXFu/96LxXMAkXrbSEb4kcKzAEoepCP1JPp9kpK/z7hCCB30
	gGQZZaE4YHbttsv1ewpCjZwU3qBswSoxRPRIQ5aVg7LBSCH5E7SAsr4LA+cFCF0=
X-Gm-Gg: ASbGncvp2y4irHpvuRHBO8B+K5PakL5GPNp8uzbP3d0RmHFg6GnJp4FgPRxCtlGF+Fs
	1hDbp8Kgyeq1c/5VWG4UTVp/1NE+IoOb43F2afknS2J6FYoMl1KrIkJ8dvHoN1QDKgX2uOkeJTU
	GmyiTcEYtqyrngiCZ4YN9uGpWNrX5GMzFp/SlEdUQkCMnIgEWvW0YSro0x6qu+hzQ3syJbKsyck
	5C09yjQJPWiRnUBciJRNhC/+7PvFdVcWItS8H4ScFFUe11u+QHguAuEPWxjH4k3ZLWQNzjXfwzn
	bClkIggu3LiTnbrJer3taTq+fetv6hP1EZS9bCPNOTyifhBF4PlHRaLdOvm9qtyBliO3sjS3YW2
	Ozq8QNreIZxcDwTgkFeiewzCVLY2AVIW/
X-Google-Smtp-Source: AGHT+IFUnfQhtjCQYv7DzHsq6hKskzByzvAs8wuY7quw/aYR00Op6Rp9Y4a5IxpqPKPkNuMTQdbM5g==
X-Received: by 2002:a05:620a:269a:b0:7c5:3ca5:58fe with SMTP id af79cd13be357-7c5ba15a54emr539420085a.22.1742580454012;
        Fri, 21 Mar 2025 11:07:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5b92b2bb6sm158643885a.11.2025.03.21.11.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 11:07:33 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com
Subject: [PATCH] DAX: warn when kmem regions are truncated for memory block alignment.
Date: Fri, 21 Mar 2025 14:07:31 -0400
Message-ID: <20250321180731.568460-1-gourry@gourry.net>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Device capacity intended for use as system ram should be aligned to the
architecture-defined memory block size or that capacity will be silently
truncated and capacity stranded.

As hotplug dax memory becomes more prevelant, the memory block size
alignment becomes more important for platform and device vendors to
pay attention to - so this truncation should not be silent.

This issue is particularly relevant for CXL Dynamic Capacity devices,
whose capacity may arrive in spec-aligned but block-misaligned chunks.

Example:
 [...] kmem dax0.0: dax region truncated 2684354560 bytes - alignment
 [...] kmem dax1.0: dax region truncated 1610612736 bytes - alignment

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index e97d47f42ee2..15b6807b703d 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -28,7 +28,8 @@ static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
 static bool any_hotremove_failed;
 
-static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
+static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r,
+			  unsigned long *truncated)
 {
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
@@ -41,6 +42,9 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 		r->end = range->end;
 		return -ENOSPC;
 	}
+
+	if (truncated && (r->start != range->start || r->end != range->end))
+		*truncated = (r->start - range->start) + (range->end - r->end);
 	return 0;
 }
 
@@ -75,6 +79,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	unsigned long ttl_trunc = 0;
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -97,7 +102,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
-		rc = dax_kmem_range(dev_dax, i, &range);
+		rc = dax_kmem_range(dev_dax, i, &range, NULL);
 		if (rc) {
 			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
 					i, range.start, range.end);
@@ -130,8 +135,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct resource *res;
 		struct range range;
+		unsigned long truncated = 0;
 
-		rc = dax_kmem_range(dev_dax, i, &range);
+		rc = dax_kmem_range(dev_dax, i, &range, &truncated);
 		if (rc)
 			continue;
 
@@ -180,8 +186,12 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 				continue;
 			goto err_request_mem;
 		}
+
+		ttl_trunc += truncated;
 		mapped++;
 	}
+	if (ttl_trunc)
+		dev_warn(dev, "dax region truncated %ld bytes - alignment\n", ttl_trunc);
 
 	dev_set_drvdata(dev, data);
 
@@ -216,7 +226,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 		struct range range;
 		int rc;
 
-		rc = dax_kmem_range(dev_dax, i, &range);
+		rc = dax_kmem_range(dev_dax, i, &range, NULL);
 		if (rc)
 			continue;
 
-- 
2.48.1

