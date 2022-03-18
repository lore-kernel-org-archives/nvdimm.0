Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0793D7B
	for <nvdimm@lists.linux.dev>; Fri, 18 Mar 2022 07:47:18 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id u17so8769559pfk.11
        for <nvdimm@lists.linux.dev>; Fri, 18 Mar 2022 00:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i2Kxzfqa17JeX6zvSFdcAC9AxQ0uSV/1LhJKBQM+dBo=;
        b=UaEE+RkmBrZgxg3Qvjtn9RTTC4YPIXWjUW3Bx10IPJLn++s9nnBXRZniYrNY6COzIK
         IWkHYHzSzSedHDyCgxfuemUSGpOTx5zN1JmXRIf53whpuiafHr/G2sS4UNAIPiCXouCX
         f7NU6IrexwNDdBmpVYRxBti1K01eoKRwavqtWnUNoWhKtBI3epsNz0UTwPO8TZNuRlwc
         rP7AVwj8FBWqc8Z4X6K04uw11sUXFWJGOw0tKuSKZ36JJTwHaE+ZqQywCT0hkJ+t3rCz
         dzFLUASMTSnQiZLWAimXIDIH94ns8HwpLb+C1q7OsjG3Mg72Y/9acnbkxQYG62WGtgNm
         i8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i2Kxzfqa17JeX6zvSFdcAC9AxQ0uSV/1LhJKBQM+dBo=;
        b=8I7QKnKlgvcKUpFWyfb+fpPxUEzORTxbWoRdhatLzrC6u+WGvCKP2jbLx/1/DLwm0C
         vsPqpz9HoPLem0jENLyileO1UArIxWp0rzYKgXoAElPvWxnYmI/QxxsIsA2tj4oFjrEj
         GZ7wCfthUEteWS/SIj6dvimL92Zt6eyMQ/L02h9n/6KVGbvHak613FMFBbigAKlCmXUX
         /wRljp3agcxIjPlxJ1jmiGLTlFFH7Pp3LnGC/k7Giv95Cr6/HoIpGD0P/eMumIfcSnlv
         gvGKM6UHHtRbRRnNTL6Sl0I+pg7IyT05zYH6mEAvqbzx8rJ/HR+J1+t99m9kLaE6CuCu
         aP2w==
X-Gm-Message-State: AOAM533FGl7g1HGg3L427Kf5EMqAkidg+8Gzf1tUiyx1Jo17y7Ol0DLl
	DZyAY7l0ECqgsVq05Y4enpIPBg==
X-Google-Smtp-Source: ABdhPJzB6PRnA27+IVJTkfrLIjmVsbIVOijMyvlx7Btwx9xnKrLpV9UgKC2XAfpJ48RfsZJJk7x5bQ==
X-Received: by 2002:a62:684:0:b0:4f7:803:d1b0 with SMTP id 126-20020a620684000000b004f70803d1b0mr8966912pfg.10.1647589638495;
        Fri, 18 Mar 2022 00:47:18 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f72acd4dadsm8770941pfx.81.2022.03.18.00.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 00:47:18 -0700 (PDT)
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
Subject: [PATCH v5 0/6] Fix some bugs related to ramp and dax
Date: Fri, 18 Mar 2022 15:45:23 +0800
Message-Id: <20220318074529.5261-1-songmuchun@bytedance.com>
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

 fs/dax.c             | 82 +++++-----------------------------------------------
 include/linux/mm.h   |  3 --
 include/linux/rmap.h |  3 ++
 mm/internal.h        | 26 +++++++++++------
 mm/memory.c          | 81 +++++++++++++++------------------------------------
 mm/page_vma_mapped.c | 16 +++++-----
 mm/rmap.c            | 68 +++++++++++++++++++++++++++++++++++--------
 7 files changed, 114 insertions(+), 165 deletions(-)

-- 
2.11.0

