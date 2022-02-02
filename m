Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1102F29
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 14:34:19 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id a19so12988096pfx.4
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 06:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=16vqX60UmjqWNFm7zG92JTmfSodESNq7kHVS1cy34iA=;
        b=pIE1avRsIxoQ5fVb4NSUe2Fxzd41PZOYVQWoiDsv0TjH20bhHYZ6DaMZU98/la6pab
         Ys6Qj3meDpkxL4odhvTHC3NKoSceGl6HCEEbjCFCljQyHx5pq0eXnKt4rhvwLEM0WPdN
         jxHZWknT/IImkOgRBUgIUSkYo1p5IUWAten8PDNxyfwCOk0eIpxZlep6r6Cv3FkTx58R
         WtJuO/aQKel4Hjwnsn33aCyWIn6ru+9Fc/xQZ459ZpfYNxVWtVIg2Gi0IwMANRRV4wML
         QMzxLkfQltwAIg0/1hSHN0+y8MX9A61/sDEgQ5LaKetiS2+zr6uC64oWPnFzQ3mwsGs8
         mgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=16vqX60UmjqWNFm7zG92JTmfSodESNq7kHVS1cy34iA=;
        b=pnCG3IAyPMdHtrLHkNqpwPv+9iHLzulGBJf4EswyM9eqm4vp91i91h6BHHFUBV+E1Z
         pRKXaShkuLtc57n/sobrMatCqAtuWnIvfDekOgdJu1ec0XUAWlF+aaOWuLv8umEntPll
         vAMb2JxuYaJPy37MMVSK9lwtIH28A5GLxOg+PN7SDXtrqiCLaEL7gPHkjEdTcK1sMkA6
         AqryG5Ue/rXPGc3LsRcNjbBdTEkr+O0truYja7OuHKtd+V5tXuLMlx+I0okppNT7nmdZ
         BX/Ulo+nF14fopfILTj3DxmFIf+tZUXVYfAIFFpdt0S3K0/p7fVLXzXA5/1A8TuTKRXk
         tunw==
X-Gm-Message-State: AOAM5320gYFaXgC79NXbX26Q3PcwfVBPnCpjxZlv+oT/ZgVPPVWMDasc
	/wDsP5/6uddbuP5KxOKchTmghg==
X-Google-Smtp-Source: ABdhPJxOdQap8/4HoWdm4i8JqHFqRS1d4ylTDNP39+aW3pX5NvYo3r+I5ODTVwdlAGTqeidAEK+lQQ==
X-Received: by 2002:a62:7650:: with SMTP id r77mr29703773pfc.85.1643812458488;
        Wed, 02 Feb 2022 06:34:18 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id s9sm29079268pgm.76.2022.02.02.06.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 06:34:18 -0800 (PST)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 0/6] Fix some bugs related to ramp and dax
Date: Wed,  2 Feb 2022 22:33:01 +0800
Message-Id: <20220202143307.96282-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1-2 fix a cache flush bug, because subsequent patches depend on
those on those changes, there are placed in this series.  Patch 3-4
are preparation for fixing a dax bug in patch 5.  Patch 6 is code cleanup
since the previous patch remove the usage of follow_invalidate_pte().

Changes in v2:
  - Avoid the overly long line in lots of places suggested by Christoph.
  - Fix a compiler warning reported by kernel test robot since pmd_pfn()
    is not defined when !CONFIG_TRANSPARENT_HUGEPAGE on powerpc architecture.
  - Split a new patch 4 for preparation of fixing the dax bug.

Muchun Song (6):
  mm: rmap: fix cache flush on THP pages
  dax: fix cache flush on PMD-mapped pages
  mm: page_vma_mapped: support checking if a pfn is mapped into a vma
  mm: rmap: introduce pfn_mkclean_range() to cleans PTEs
  dax: fix missing writeprotect the pte entry
  mm: remove range parameter from follow_invalidate_pte()

 fs/dax.c                | 82 ++++------------------------------------------
 include/linux/mm.h      |  3 --
 include/linux/rmap.h    | 17 ++++++++--
 include/linux/swapops.h | 13 +++++---
 mm/internal.h           | 52 +++++++++++++++++++----------
 mm/memory.c             | 23 ++-----------
 mm/page_vma_mapped.c    | 68 ++++++++++++++++++++++++--------------
 mm/rmap.c               | 87 ++++++++++++++++++++++++++++++++++++++-----------
 8 files changed, 180 insertions(+), 165 deletions(-)

-- 
2.11.0

