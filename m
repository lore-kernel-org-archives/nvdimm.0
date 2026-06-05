Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32453BFE5A
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 21:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780694359; cv=none; b=H/0U9nNnH8A0synEAJ45rCRisP+eDS8iz14d/qB3/Q2RymCimhSwNHq9OP8IQe7D+LjvFRoL6r0pCNyuv1kDCEdP4s7BJaeXNMjpzF822i2uW0YF2sLI0UxKFv36YNerE9qFmfeiQB2DbTQERLfWHYDkSGFO8zq1TXsBIxSPqKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780694359; c=relaxed/simple;
	bh=YJUG2rEhZbZqBSQUXpRy6AdNHxz+6J4JkjRoL4CcAe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip9K0n4e0Bs/cb7iigOZP/uHIO98dRcPbNOQViy0APvZvdMdVgX+jgbjlsVrkMA4cmHIuw3M9/idcgdQqQoNBCkq8hCWrhsKEPMC+WDjHYSdA1d4kVg5ULBjiy9+vIDqS3RkLOKJidwJmjYRZZUTGVIB07kLiy9I63UCjdh92UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RAt/3/zu; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RAt/3/zu"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ce9df4732cso23916936d6.1
        for <nvdimm@lists.linux.dev>; Fri, 05 Jun 2026 14:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694357; x=1781299157; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f8jLd2zqvW28XOaQQClXDDIz8D3hNjBgUh/nqgs8cgE=;
        b=RAt/3/zuErhYLNbIiBeAXiqoQ82JWYUArLpFAkcjJuTdhn9wDDNqtpapHd78OEPL/s
         Y0oZwEQcPRh+PVjMpayl6uKbp6dPwr/q5TCfBu/6ySMafoXuR0dRPhwHWGQUvh6dmbwg
         qlW+VCimXGvWKLdwGpefhf23/467Qo+Up56QQg8IOJhazUi+QloiEwylEbVJBFt+Fa3F
         Y9kjRbBXEzD7JAJtEsWZ78229qcM1I4d286KVT3rFGHi38L9TheMcyGpZ6h3e1J0CV5g
         PljjnbAXhaJZNxWDgkteQIPNEvGOBsygxPVEY89aeb+Bu2THUQAfz4/VcHHHLwr8Jy9u
         +k9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694357; x=1781299157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f8jLd2zqvW28XOaQQClXDDIz8D3hNjBgUh/nqgs8cgE=;
        b=F4wbtJa9XOTvDUvKx3mj9MUng4PE/H59RSwPENURk+wgiVOpIWhGOChaAclvrxruZw
         kCfSXFaByabemQ9nJ5F424QWAe1t04rcYdvple/8fzQaFahVIL1p6KnnsAJSgDrblLi7
         X0Q0OQfH3GQh7sY05vmUJYYY9VBvvwFjcz9qSWjFaIRsis6DmTGgXNtKyH4qh7/wLJxZ
         yuvYm7kxCgNbnn0WCg5xbvowoYfhIqfByLLSXEe+mDX2hZw6mKjMDVY6D+xPl6R0wIIv
         37miNYAiF1RtT1TxnIdqcLQoZD1quCNOQDfaHaSv3WTBmkI6wNHA9GU6aN1XDmVf+1sL
         Gz+g==
X-Forwarded-Encrypted: i=1; AFNElJ8VoilR0QXlYuTwczOFb8T9HNxeuVLkYjqb8wgUMz6z6ShZXgjoyI1GDwFnlEAnywB62UeBhHI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+qRMme3ZVc5QRdJ7/49enMlkLUxW5pKqd1Ni4yYE2Jq/CXotA
	sh2PIE2nC/Djx1qeNMmtvkQ+gSHI5ZEERwi2YwhB8jtxo9NEcUJLC6u5Zj/09CAe0s8lDSSVHwb
	zGmnhqX59rQ==
X-Gm-Gg: Acq92OHgbJhh+5HJNGYoa7C8pmfB4lRO9XYrbz+buEta7g6h5wwyTMdaZUXP+hJQwrU
	y6loazEmZ6xC2IK0EhHXgb/NClQ1ju+aeApsJpxYYkpxLsKAgq1dG0K3aktdicC/IUXcA14+K8u
	gM/lGFs2ZyUokLk8wK2ojDiecTOUK4yAkRMjyBNv4bbqdohZvseWW6BpsBTNpzMeFbO4ms1kB7I
	hZQgQmttf2xLxNtXxm+Tm1Axsjszq5hJJhNQz+LjGP8YqE80ulleUk8Vd8LZgWgmSY1yYky7wYs
	99an/AznrIoOKxQha4MJSldBm6tXPIVDAWdNSZml6KSoMNimTlccldj2wZTOpwC4Ei2ENwCye9G
	9DRW1Eo2r+3bn6zqu35SdfNXnN51EjackI0MU04n9qfZRwUn5fW+ZqCJzjTzqK8YrZULLgKkJyK
	t5UnR6gt1na9nbUi7RarYWDROUVJPnHgOO7D1H942+O3UurHMaKTTBdnCMbHknw0KnNbseCejdf
	bWOS8rgKEqc2mdMqOz+4zI=
X-Received: by 2002:ad4:560e:0:b0:8cc:f88e:2703 with SMTP id 6a1803df08f44-8cee5fe4e30mr72255516d6.12.1780694356950;
        Fri, 05 Jun 2026 14:19:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:16 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 1/9] mm/memory: add memory_block_aligned_range() helper
Date: Fri,  5 Jun 2026 22:19:03 +0100
Message-ID: <20260605211911.2160954-2-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_aligned_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.

Update dax/kmem to use this helper.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a18e2b968e4d..592171ec10f4 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
 
-	/* memory-block align the hotplug range */
-	r->start = ALIGN(range->start, memory_block_size_bytes());
-	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	*r = memory_block_aligned_range(range);
 	if (r->start >= r->end) {
 		r->start = range->start;
 		r->end = range->end;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 463dc02f6cff..9f5ef0309f77 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
+#include <linux/range.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -100,6 +101,27 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
+/**
+ * memory_block_aligned_range - align a physical address range to memory blocks
+ * @range: the input range to align
+ *
+ * Aligns the start address up and the end address down to memory block
+ * boundaries. This is required for memory hotplug operations which must
+ * operate on memory-block aligned ranges.
+ *
+ * Returns the aligned range. Callers should check that the returned
+ * range is valid (aligned.start < aligned.end) before using it.
+ */
+static inline struct range memory_block_aligned_range(const struct range *range)
+{
+	struct range aligned;
+
+	aligned.start = ALIGN(range->start, memory_block_size_bytes());
+	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+
+	return aligned;
+}
+
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-- 
2.54.0

