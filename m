Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A720E4A3875
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 12:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438114; cv=none; b=Lac7GmHxJyl7WRADC9eTB+jcLtJBX4kEIK80d49radiLCmd/cA6ai9UOw4HaeRS5cgmsFH60lj6wj825zzMB7KM0WXrRk4oPHenJpCF4uKyXVYWUg0cH43px+Ghb1Cl2l2lc8HVlTe9jpvaKC3UCHbUaK3o7cCtah6qW9DsCqCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438114; c=relaxed/simple;
	bh=1xK9WvOdopCQR3xT8/KKn1WUP9dISFUQ63DhqRI1yGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sAqnWZE3kJ9a1UvdwXCFnqsI4nfhupymdj7RvyvVj3KBBT+6yPZ3P0B1vbk2+zcf+nCL+3mNg9TYQ1IPbKepwJo7YicbFeyHPUsERkHC0pL+1GrE4kz3xYQh5MR5yB0a0KWZ/HKWW1DjK5+B/kTxHvQR6WmPfCtHNWWwe6eRcsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=D3nz9rF2; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="D3nz9rF2"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-851cbd64814so996613b3a.1
        for <nvdimm@lists.linux.dev>; Thu, 03 Sep 2026 05:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788438103; x=1789042903; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eoj/Cdya14SPLIE+VKDTIKpgRBY75qMbCQGmPe9FWn8=;
        b=D3nz9rF2lHQjt/Z7IBZMu0rzIF/y+LCukEgPxpTyboH8oTaDYSPhfIwcjT5drkuYou
         l9l7LgDm4yYKCJJaLKTjWEsxOGoX/bSzDeOgagGZhWgM1MGG5nC+If43cOD2YUnLugD0
         VFzc382PPjZvODGAcgAh2Ck2We/06XJCZLx8fcAMXAIPBOgcZ39ohWlrZ6u87Djg3kLE
         x+NZ79aBTOB7+TO/UcBxlRbLVx77Gw6F18hddyIgfq4sUQEwXoiVK+bJu//pzQXZ3rHq
         YVmrtfieRdZbrbzLZc/baE4Hal8nIuMOc5R9IVwStpDc3mlGqZHT8yXegJtOl7Aiv1Jb
         zKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438103; x=1789042903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eoj/Cdya14SPLIE+VKDTIKpgRBY75qMbCQGmPe9FWn8=;
        b=algdDKL3vSAkiODiqoXi55V0vA5w+DNiKWPJN3CX0m1+caUXSv49MELrEMox9aHsf0
         PYtvwSNt6jEBkUg6ntH/lRIV4nDsv8z9GWlhBkfHdauLc09FXzjqp5Qtxpd8BBfDSXed
         RJaVwDeip7TWyWrGY0m/kccMbxM8+LBrSGvLDDYC0O3zLOyM1bTRsnuTmT4v94AhiJfD
         kbSOfJvSyVAFe4yuW4wBkQerj129vD4sQg9xNTKqlAgX/ckL9py28Zg2/X0iq6CjIfdM
         WxM0ZUzaF3KYk+ZWa+4XCKfofQYpRR1oj7nqjqILL/7a8AxyzO52Mo3XfS8/XuNNXqxJ
         Fr9g==
X-Forwarded-Encrypted: i=1; AKwUvByS4iJLKpKtLaIKBDNjgsYaQnqGLq7Rb+d/JbVHP9DndvQG4ttdFbT68VXlBxu4K/kyWiO4NJw=@lists.linux.dev
X-Gm-Message-State: AFuF++ms67O70Bd4wgAHO8TkeJOqxstLTyl4Ou4H5EBqWFyGwcsMgmZ7
	1g5+1Nq2PbtrQgu+zOxhumPcg+U1080Dr2EznS11E7c6T37N7Nilqe/QxCnaYIBRiLM=
X-Gm-Gg: AYBFou05h+irVJNjU5v1NVqitywIgisXLgXJBf0ns0St06infhROmA02qmVrW+yvBXZ
	850sN7DQrj2rjpYVZlJOh9m7nW9649Dzsdjj1zsJV7qbV+C0rgzRdTuEPpnOeaG51pvYmjzXrTc
	rWAVIl7d+d/FIVz+BkWQ9hQ9xNoB8OJcEPjJ2saIumzlw8Hmt8IyBGKWtewvpMvNdfhy27uQ/f+
	n6yTg7p8mVjSUmcRiJbacQ+7YydDf0SDon37PUDuHuv2fNWzGmA/Q1A+YPlDRV84kZo2kzNOnQr
	q2um9VowdXLlJd9HCP3b1q3ibORgP95HJzoOexJSUpd08gpFfp0FS2kF6FzIBNuPv74EX8PBVbO
	lEoB9ERR02E18/y0KfW9BLlyIJC97SBMWL9GjlPMAFZ5atRTdoOTWtzTwBvPLRkdREJbwsiEMjX
	dv8ZuEijGKxSVWv/Cl7itw561mCgV6hKSbOQ+/z/8hL6q91YRNI67YQZDDsSJBQaRdRUk9Qytth
	irnTKGA1NRzAn47feRh++a/gw==
X-Received: by 2002:a05:6a00:c4c6:b0:85f:b00b:8760 with SMTP id d2e1a72fcca58-85fb00b8844mr9445221b3a.5.1788438103076;
        Thu, 03 Sep 2026 05:21:43 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm2868126b3a.4.2026.09.03.05.21.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 05:21:42 -0700 (PDT)
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
Subject: [PATCH 0/4] mm: Reduce struct page overhead for FS-DAX pmem
Date: Thu,  3 Sep 2026 20:21:23 +0800
Message-ID: <20260903122128.12264-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AI and code-execution services increasingly run user workloads in
short-lived sandbox VMs. These VMs are usually small, densely packed, and
backed by sparse disk images, so both memory footprint and VM startup time
matter directly for consolidation density.

Using virtio-pmem with FS-DAX for the guest filesystem is one way to
reduce that footprint. It avoids keeping a second copy of file data in the
guest page cache, and turns that cache into host-side file cache that can
be accounted and reclaimed with the host's global memory view. Host-side
page-cache reclaim is also more direct than asking the guest to drop its
page cache, waiting for the freed pages to be reported back, and then
reclaiming the memory from the host side. This makes higher overcommit
more practical for dense sandbox deployments.

The remaining problem is that virtio-pmem with FS-DAX still pays the
guest-side ZONE_DEVICE metadata cost up front. The guest registers the
whole pmem aperture and allocates and initializes struct page metadata for
every advertised PFN. The vmemmap overhead is about 1.56% of the pmem
device size, and initializing all of those struct pages can noticeably
slow down startup for lightweight VMs.

Much of that private metadata is unnecessary in common sandbox setups.
Holes in a sparse rootfs image have no host storage allocated, but the
guest still allocates struct page metadata for the corresponding pmem PFNs.
Also, many filesystem workloads access files through read(2) and write(2)
rather than mmap(2); those DAX blocks are copied through the kernel and do
not need to be inserted into userspace page tables, so they do not need
private per-PFN struct page state either.

The key observation is that when sizeof(struct page) is a power of two,
each PAGE_SIZE vmemmap page contains a naturally aligned, repeatable group
of struct page slots. For an FS-DAX pmem range at device registration time,
those slots only need the same ZONE_DEVICE and dev_pagemap state before a
PFN is exposed to userspace. The kernel mainly needs the vmemmap to resolve
the PFN back to a valid device page and its dev_pagemap. It does not need
independent writable per-PFN state for ranges that are only accessed
through the DAX direct-access path, or for ranges that are never accessed
at all.

This series takes advantage of that split by separating vmemmap population
from private metadata allocation. Device registration still gives every
advertised PFN a valid struct page representation, but the vmemmap mappings
initially point at a shared read-only vmemmap page containing the common
ZONE_DEVICE state. This avoids allocating and initializing private metadata
for PFNs that may never need it.

Private writable metadata is materialized only when it becomes necessary:
before a DAX fault inserts the PFN into a userspace mapping. At that point
the PFN can participate in the normal page-based MM paths, so the shared
vmemmap page is replaced with a private writable copy. PTE faults
materialize the corresponding vmemmap page, and PMD faults materialize the
whole PMD-sized metadata range. PFNs that are never faulted continue to use
the shared vmemmap page, avoiding both the memory cost and the struct page
initialization work.

A natural follow-up is to make this optimization reversible. Once a DAX
entry is removed from the address_space, and after all mappings, references
and pins that require private metadata are gone, the corresponding vmemmap
page could be remapped back to the shared read-only vmemmap page and the
private metadata page could be freed. With that, the guest-side struct page
overhead would track the live DAX working set rather than the full advertised
pmem device size.

Patch 1 renames the architecture opt-in for runtime vmemmap remapping so
it describes the generic capability instead of the HugeTLB user.

Patch 2 avoids touching PG_hwpoison state for clean pmem pages. This keeps
the normal clean-I/O path compatible with read-only shared metadata.

Patch 3 adds the shared read-only FS-DAX vmemmap infrastructure and the
helper that materializes a private metadata page on demand.

Patch 4 opts pmem FS-DAX mappings into the new mode and materializes the
metadata before DAX inserts a PFN into a userspace mapping.

This does not change FS-DAX data path semantics. It only changes when
private struct page metadata is allocated for pmem FS-DAX PFNs.

Muchun Song (4):
  mm: generalize vmemmap remap architecture support
  nvdimm/pmem: avoid HWPoison flag updates for clean pages
  mm: add shared read-only vmemmap support for FS-DAX
  fsdax: materialize pmem vmemmap metadata on faults

 arch/loongarch/Kconfig   |  2 +-
 arch/riscv/Kconfig       |  2 +-
 arch/x86/Kconfig         |  2 +-
 drivers/nvdimm/pmem.c    |  3 +-
 fs/Kconfig               |  2 +-
 fs/dax.c                 |  5 ++++
 include/linux/memremap.h | 11 ++++++-
 mm/Kconfig               |  6 ++--
 mm/memremap.c            | 38 ++++++++++++++++++++++--
 mm/mm_init.c             | 11 +++++++
 mm/sparse-vmemmap.c      | 64 +++++++++++++++++++++++++++++++++++++---
 11 files changed, 131 insertions(+), 15 deletions(-)


base-commit: 32b6ef9a5d0eca44f9cd91f52f4faa89f145a0de
-- 
2.54.0

