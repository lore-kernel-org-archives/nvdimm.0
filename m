Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86074A3D48
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 12:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438131; cv=none; b=daQ/FUkBCjf9m0pER929UEiR5eJl0VMAZOVEB01C2lgoypVt5chlEQjUS2uouEbyepN+7Z4D0OiBEjp/uJRU46rP557FGZum3kmh08/Y/MK/gbXl+k4YdtuyJk62E4xlPdiP6Bdx7L4Ru145LfZz4janlw9EEWmKMCcN92ywHWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438131; c=relaxed/simple;
	bh=Hr4ffWVPhBSeZxC4Gy1Y+eU1zBxu0o3ECl+FjVnr0+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTJtsYANKFYPPDlFmnfqYJZP+tYwXbYsPkT/wMeXO6Nd4A0pzwFWkdYF4sqiP28Amzzz1HrGBtNNTEICXUJtVPTjjD7Yw5Dbs2La8g7RqLurIaI3lg0aR5mfvbpLddqVb9/w1JViqHKi7bPHAFeG48qgkVvUr9jftzXFlcHiZrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=i7SYNLgk; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="i7SYNLgk"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-853c947bfefso869294b3a.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Sep 2026 05:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788438123; x=1789042923; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M9z1xem6qEcuUVJMDQZaw5sCruZ2xCngKTtcTUgfBOA=;
        b=i7SYNLgkZE1wS5t1vd5GDLAIzX9PvrusRWOLI0YZPPtBhgHYy7UVziFWkqC7k2Lr9M
         7FFQkEp2/h4yiR7PYaFYVjKeRzikVV5a3fO0Hfqtf6PetUltMmrrQkVKx66Fwz29TRvW
         mcRqNCKQrk0n9EMBOKBkgonAxqK4ZzT4t6XFn9AK77DqAr+LGqujWuknnlWbUDh9C+ho
         JDIwTaHGiQBNxckZ3TQWKc4xNTCPtcyeaKFHlKLRb0PqwReLINxbzLT0ENa/SvaAD13w
         ucRxp8BOj162+Ws4AmSFPj5iwRD5S/3azKwYCEH1f9Pu87QphJFejVPvvZKME28ZTg4X
         NEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438123; x=1789042923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M9z1xem6qEcuUVJMDQZaw5sCruZ2xCngKTtcTUgfBOA=;
        b=QyqVb7Gvc0ixCbQSxY4XKw8KvaYkCnApntZw5ePuhDDRoGUnj4tXhym37ybF4j1QP5
         sd2bVzgifrbRsy47TRbB/T3665lFbJcN/TMflYfq9k5830FNgRj9+WYAHE82hSCg+/nW
         7/nj7ASf2UDfjmnEvgTDaU6Te5Agb3GlSsc2T/FYOXxnStJMHToldYf3dYgnUohv7UKH
         zL7DQAs5t4Lra3n95F65oPH4KI+ltLtBLEkChws0xJamrV9XqMxITNln6WBJmpVRoq2v
         CkQsqTZ+EMV1lAy/Ejom+KiggmKq5TZ3MNnHJeOOdlYcmU4UgiEom6+65aOsgQu0ZLGA
         BzMA==
X-Forwarded-Encrypted: i=1; AKwUvBzpb3Y+Ul+ErhksAXNCQxcc6BMYj2bP5sY/C6+iYOgn1YNJ47q2wNTkjCTnSA9XJs5+E7PWNHc=@lists.linux.dev
X-Gm-Message-State: AFuF++mRp6yoh17PD5HnQlq0zQibeoOR0MHmyDZssEVbNRQztZcb4Jcp
	C6wZ21SNslGZDDB0jlb1gQriZpJFjSY9yRBvnO0t+vMFeh2AFKlqT6SzY51zZnuR+1Y=
X-Gm-Gg: AYBFou0687OFAdpt7YBksIdgnJAA6CofaxXwnGzFj940DPQyDV8ifsAfnbyIsw5RGJT
	HwW3af1vy37rH830MeAVtJCSneYEa0PGZq0YASweq7y4hPi2go3Pp+jTHiQVHu8c9mNHjdOjPvj
	yvR0bdDckDrZ8dErexD1fGA4Vb/ii/ySM5N2YDP3kQwYwsf/+sPb4oAiCQmCoOCtLH/ujSg0eRw
	uce2LhqYVUBPXxGZ2Lya0casE2Efo2VVPNtkUKJC23oF6rOnrULA9KGK28dKgGE0+yIQsgxkjFY
	6AngY7sx+ybMTqn2GfYwUKiJ1huib6keGNPa135Kl10+d8FlgRUTrmz+rsopp734XbgaX99Lu3N
	f4noMsuQO3AckIjjAg0yIJiM1XcFPBSwpnHqXgePYshorv/mXEq1Axnw7pypZOGPP83oXI38VdW
	BN0IR31wUQ835SxFf+LWDS+KCqkDXB8+JEGGhK9IVAfIDSZCPPIE52pk8KQl1h/3Jf4SdMdfXUI
	nLsnUVyJGMFd92YoqK8Vm30uA==
X-Received: by 2002:a05:6a00:17aa:b0:84e:c851:a058 with SMTP id d2e1a72fcca58-85ffcb616aamr4808528b3a.10.1788438123307;
        Thu, 03 Sep 2026 05:22:03 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm2868126b3a.4.2026.09.03.05.21.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 05:22:02 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 4/4] fsdax: materialize pmem vmemmap metadata on faults
Date: Thu,  3 Sep 2026 20:21:27 +0800
Message-ID: <20260903122128.12264-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903122128.12264-1-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pmem FS-DAX registers the device range as ZONE_DEVICE memory, and the
kernel normally allocates and initializes vmemmap storage for every
advertised PFN up front. Sparse backing storage and workloads that only use
the DAX direct-access path may never need writable per-PFN state for most
of that range, but still pay the memory and initialization cost.

Opt pmem FS-DAX into the shared read-only vmemmap mode and materialize
private metadata before inserting a PFN into a userspace mapping. PMD
faults materialize the whole PMD-sized metadata range. PFNs that are never
faulted continue to use the shared metadata.

This shifts private vmemmap allocation from device registration to the
first DAX fault for each metadata page, so the struct page overhead tracks
the faulted DAX working set instead of the full advertised pmem device
size.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/nvdimm/pmem.c | 1 +
 fs/dax.c              | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b14f75daeda7..5530b32163d3 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -543,6 +543,7 @@ static int pmem_attach_disk(struct device *dev,
 		pmem->pgmap.nr_range = 1;
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
 		pmem->pgmap.ops = &fsdax_pagemap_ops;
+		pmem->pgmap.flags |= PGMAP_VMEMMAP_OPTIMIZATION;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		bb_range = pmem->pgmap.range;
 	} else {
diff --git a/fs/dax.c b/fs/dax.c
index 1fbba0d21c13..89377301d51b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/highmem.h>
 #include <linux/memcontrol.h>
+#include <linux/memremap.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
@@ -1877,6 +1878,10 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	if (err)
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 
+	err = vmemmap_materialize_page(pfn_to_page(pfn), pmd ? PMD_ORDER : 0);
+	if (err)
+		return dax_fault_return(err);
+
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
 
 	if (write && iomap->flags & IOMAP_F_SHARED) {
-- 
2.54.0

