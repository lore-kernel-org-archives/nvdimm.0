Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EC528FFCC
	for <nvdimm@lists.linux.dev>; Thu, 10 Apr 2025 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744295329; cv=none; b=IaDhBo1pUkh9hpKlRMJzVFTmkdzlwU84W1LTy7Jjwv43L77P2uZd8pMOCJi3Mze7m5AgzdB4V2DjinZa/9Kgxo3VZllMw15B7WMOBKE8jPhmdo9m1vof2I1EkDIEnMN1BgExpIS9PVjSkdW50omWaY/sBe9ddUxCARLsQhLq/v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744295329; c=relaxed/simple;
	bh=fZnaZ5GHZcfS9p6y2BQGcaUFH6wu1bBVJJP31QU4XV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fX7vWXGSz2K0fDK2qWrQ49rD9vXD7Io/qavmzpjhlWEiITaB6+7dWzHVQ+1S0dwZPTjHvr8/K12DCRk7aVuh3aOOQp8iotG4Gs98s65JuGLp0LJxEn8emiQMWL4icjfiqpe+c20Ka9ioQmt9KqeElDikc07zq4NsyWhRonxR10I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TrWlXQLQ; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TrWlXQLQ"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7c5aecec8f3so147212785a.1
        for <nvdimm@lists.linux.dev>; Thu, 10 Apr 2025 07:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1744295325; x=1744900125; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QU7b8p5X6+ipaTqnZzEvjAMW+m1ukjkOluS/etWvC10=;
        b=TrWlXQLQ+7QyawQERDNi+rx0AshQErRtCRBLK1TnSh7iQctf8LH0Sc1niEKNkCkjjJ
         jk5+LcV0THVaYH0K0klYbkDCwIIj5R9gif8k3zOaq6ZVNyzQdgODbG/Lxio/si5HqPQi
         PjDYUkFfo7tfVp3m0wIHBi4GR9teDe5UOPPfxQirwBA0AApuQVq0uvVJYQG5ydt6veIr
         lwyT71GsqbHiTBv5q0OcaXIHkbUkWOiLEOL0cvNdVl4DP5Onjpns9vON2Gk+ucbP4YrR
         JwqmI8WnWYgTKsHxOZrtmMYldjJuK+EEelKTN8Ex7qeGzMBE3zmN3tUrrBlOQ7e/6xL4
         ttfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744295325; x=1744900125;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QU7b8p5X6+ipaTqnZzEvjAMW+m1ukjkOluS/etWvC10=;
        b=ZDhByMi0LY+k87C5nu4sin5uhlzwNoB6GFu4b4tHtD0gpXqpQV7VEskPp7wwECHLVl
         gpa8wX0aCJKc1u1fi2+u54O301mfkKTEDQAQA0T9aSaGH2SN9/K1OP/jTaWR61R+XNmz
         3ba0eBLfysrzxMbaowmAtiX4cwNEZ+HXNp/g+y11cJckXKD+Keopr5J8Yo/afBkGeBDq
         pjoBBBMwknXxGPPiY2WR9d3mmObDVXFevdiCLaV8OAmUJUMMn3CGQ5lwzrWDbmmwOLRa
         1V/mrhTvOfPvYJ+HYjU/gKIVcfuII4lnWeUV2UfMmDBDHWlFfkgZBg43U+NDEs1IVJtb
         cH0w==
X-Gm-Message-State: AOJu0YxIm4ViZdPGfi4q2r2SM5jfsAOxzVkbbWs6sNwnUsj0j9Tk8LKS
	cLWLttE/tIxvuwcJPyIXqXTMEevRO2q5I0qU0yZnWdC8nyRSxvqusebRKkQscGw=
X-Gm-Gg: ASbGncvczswvSDiMS/EPuMZc1Ol1ng/Wb2n6sc11hnDOSDQ4GTLM4Qi8kYzqAey3qgd
	Txi38leUvZ7gfISW9DIw2rpO3A6yKu7czMey5tkOgpzkmCINi7inDWapk/AChH8EIn3uNy5JSGt
	gwbvwhur25u9GuAW31C7OKTVbeaS/PvuPu9H9IgV8afhAP1TI05bApaRAfVETAk8kidHpMwgfFm
	D1ItlqncZdVe7ZnjBLVfZeAUdHcfmVGIGQ3/zEc+T3im25OSJtWp6SsrN3RqoSUZDOZ8cCRfJUy
	CTorXp3JnQxAukTG2xiRjHUAFSY4A2hSa1HpBTmIkapVg70yNX+dLIWqOlU3YeH/B0T5xYhTUbH
	syAuRJtCHpAcqEfg9F64B5Q==
X-Google-Smtp-Source: AGHT+IGMVGeMyBaUbWMD2SRNc0LtssAH5A8ndxEkZnyBQsRRtZK83f0qG5vpcQnY38UUX/EqwX1CKA==
X-Received: by 2002:a05:6214:c2a:b0:6e8:fee2:aae4 with SMTP id 6a1803df08f44-6f0e5bd7058mr50446596d6.28.1744295325172;
        Thu, 10 Apr 2025 07:28:45 -0700 (PDT)
Received: from localhost.localdomain (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f0de95f8besm21567896d6.10.2025.04.10.07.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 07:28:44 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	David Hildenbrand <david@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v3] DAX: warn when kmem regions are truncated for memory block alignment.
Date: Thu, 10 Apr 2025 10:28:31 -0400
Message-ID: <20250410142831.217887-1-gourry@gourry.net>
X-Mailer: git-send-email 2.49.0
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

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index e97d47f42ee2..584c70a34b52 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -13,6 +13,7 @@
 #include <linux/mman.h>
 #include <linux/memory-tiers.h>
 #include <linux/memory_hotplug.h>
+#include <linux/string_helpers.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -68,7 +69,7 @@ static void kmem_put_memory_types(void)
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
-	unsigned long total_len = 0;
+	unsigned long total_len = 0, orig_len = 0;
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
 	int i, rc, mapped = 0;
@@ -97,6 +98,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
+		orig_len += range_len(&dev_dax->ranges[i].range);
 		rc = dax_kmem_range(dev_dax, i, &range);
 		if (rc) {
 			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
@@ -109,6 +111,12 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (!total_len) {
 		dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
 		return -EINVAL;
+	} else if (total_len != orig_len) {
+		char buf[16];
+
+		string_get_size(orig_len - total_len, 1, STRING_UNITS_2,
+				buf, sizeof(buf));
+		dev_warn(dev, "DAX region truncated by %s due to alignment\n", buf);
 	}
 
 	init_node_memory_type(numa_node, mtype);
-- 
2.49.0

