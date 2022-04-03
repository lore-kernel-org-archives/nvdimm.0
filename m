Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D2469A
	for <nvdimm@lists.linux.dev>; Sun,  3 Apr 2022 05:41:10 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id nt14-20020a17090b248e00b001ca601046a4so2090596pjb.0
        for <nvdimm@lists.linux.dev>; Sat, 02 Apr 2022 22:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wvujdoj+rXf8TntjDreBsLKKbh2J4gp+Ud8xZlie1p0=;
        b=TCwPLuOIkV9+38cDLkpS9nuHTn65VZXSagGE6TWoOmUkruIu5+qF3NuNmWAfItBIZD
         sXdedXicM713G2Gaq+ubx4DWik03Qcj/3gAF0jV7yUwqCGnR/cGdjiNUTr5HBiMoaWBL
         l5HMCf7TtzZK2fclBrR9rIhfV7zRzydnFm0chT0bjmPlqWlnmz3pul9UnvWP7EAVQBK9
         fgIeSdi7V8f0YcbmyjkPmQRNFerDaidkAzMo5vRBGQcwx+qxsDNJPpCWnY8wbDTmNV1j
         f9YLHSrBCv8R2lu/h1BrOd9a342SdGQ7Ase0xNRvLlS+K3/Kjnk33gdqXgNMhoNeZrLX
         T9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wvujdoj+rXf8TntjDreBsLKKbh2J4gp+Ud8xZlie1p0=;
        b=Tpk5j4IhbCwCHIU+KiH4AvkGtipJnOupUWtKIm6MUHQd5Xvni32Rl8gHSx4gUaQ8j7
         AUsf+pF7lYvbIWtMioiou64uuDMrD+CzmLoAq/lQarIMHLfvWo4QdgFZejAJ2x388OmF
         USydSJ5cuxxiP/MCcjVeyF0GlNm0l6DCBqcBsfxc7dycOSdZNPTucoi4aQxXRAQ3BV9U
         O7hcA5s5LWHJo+WpfiMU+uUJbgNB2PJFDP2wYGgVWnla5dsxbE1eHr/SxC+4N7jpBihk
         IegPhPOwyr6rqZOhLalVhq6g/cGkHk6mWgBzEaNJ/HyU6XmTBfIv9wA+Cr228EOhelwp
         DqSg==
X-Gm-Message-State: AOAM533V6TLfuCMoHHE+Eb2mpH878BBJZzS34DNcYQdDJ6ITh0/MroZb
	25spKxsYT67wGNV6h5FDIAlHiQ==
X-Google-Smtp-Source: ABdhPJyUkVA34KXhqdWAtjVviE8uqiNT/qpXOuafZYF1Nio1ft2L3/3huAbiQqZd1DwmC0Hw+XJQHQ==
X-Received: by 2002:a17:90b:3447:b0:1c6:fe01:675c with SMTP id lj7-20020a17090b344700b001c6fe01675cmr19568783pjb.59.1648964469978;
        Sat, 02 Apr 2022 22:41:09 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.245])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm8262479pfx.34.2022.04.02.22.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 22:41:09 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	shy828301@gmail.com,
	rcampbell@nvidia.com,
	hughd@google.com,
	xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com,
	zwisler@kernel.org,
	hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	duanxiongchun@bytedance.com,
	smuchun@gmail.com,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v7 0/6] Fix some bugs related to ramp and dax
Date: Sun,  3 Apr 2022 13:39:51 +0800
Message-Id: <20220403053957.10770-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is based on next-20220225.

Patch 1-2 fix a cache flush bug, because subsequent patches depend on
those on those changes, there are placed in this series.  Patch 3-4
are preparation for fixing a dax bug in patch 5.  Patch 6 is code cleanup
since the previous patch remove the usage of follow_invalidate_pte().

v7:
- Remove redurant "*" above vma_address() reported by Christoph.
- Fix oops (reported by Qian) on arm64 by using "pmd_present() && pmd_devmap()"
  to workaround the bug in pmd_leaf() on arm64, which is fixed in another
  patch [1].

[1] https://lore.kernel.org/all/20220403024928.4125-1-songmuchun@bytedance.com/

v6:
- Collect Reviewed-by from Christoph Hellwig.
- Fold dax_entry_mkclean() into dax_writeback_one().

v5:
- Collect Reviewed-by from Dan Williams.
- Fix panic reported by kernel test robot <oliver.sang@intel.com>.
- Remove pmdpp parameter from follow_invalidate_pte() and fold it into follow_pte().

v4:
- Fix compilation error on riscv.

v3:
- Based on next-20220225.

v2:
- Avoid the overly long line in lots of places suggested by Christoph.
- Fix a compiler warning reported by kernel test robot since pmd_pfn()
  is not defined when !CONFIG_TRANSPARENT_HUGEPAGE on powerpc architecture.
- Split a new patch 4 for preparation of fixing the dax bug.

Muchun Song (6):
  mm: rmap: fix cache flush on THP pages
  dax: fix cache flush on PMD-mapped pages
  mm: rmap: introduce pfn_mkclean_range() to cleans PTEs
  mm: pvmw: add support for walking devmap pages
  dax: fix missing writeprotect the pte entry
  mm: simplify follow_invalidate_pte()

 fs/dax.c             | 98 +++++++---------------------------------------------
 include/linux/mm.h   |  3 --
 include/linux/rmap.h |  3 ++
 mm/internal.h        | 26 +++++++++-----
 mm/memory.c          | 81 ++++++++++++-------------------------------
 mm/page_vma_mapped.c | 17 ++++-----
 mm/rmap.c            | 68 +++++++++++++++++++++++++++++-------
 7 files changed, 120 insertions(+), 176 deletions(-)

-- 
2.11.0

