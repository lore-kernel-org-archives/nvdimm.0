Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52DA2576
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 08:29:05 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id s1so929251plg.12
        for <nvdimm@lists.linux.dev>; Wed, 02 Mar 2022 00:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nhj2UYDv6lhlSNPLYeAs8t7voAVPXKimrviFdjCHzWM=;
        b=DApuqsEmjJNLujancfXfCthOkTnRIUPq28/r6tOxkHmRYgOlkugPPK0h8zAh8enpIU
         HfkQBBHhLbFz8qxRq7E2RLuHrElDGGUHS9Y244UdqIirJhWbIHaCrn4YF7xafhgTecpu
         x6OH95W7ts5LUCdSkrPRN+VLxTqzK7oKM7OtnhOIOVkuakDHhP+07oAY8HWOUrVKWwpS
         DnRwLDlUAcWgA1CnWdFtO0QOL8kLiRQ+vjGLe4BEgo4v9XJAX76t8Q0sNmUSx1tdL1/b
         w7Y2MRd1la+tiYmu/lVxcH6LXEof0W4BIhpWEx+hwGiQJUbmqWHEmQaFjYs8VD1Hu04i
         l7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nhj2UYDv6lhlSNPLYeAs8t7voAVPXKimrviFdjCHzWM=;
        b=ipIfgatApCZwOPAC5Fb5hOL0NjrxlMIxEQ90QnyK0b4hOdmG1hFNAEwQlowZ9j9Sbg
         XdpfxWK3t2l1iNki0pg4x+gsAnaUZdGwgiMnVBfPLWddfThgomwn3dTCpNXTMBcfy/Ne
         FOZfo3EC/wpEpgh9+sTCMALSuh6ffq2IiulyFl8RlqqnqsEBPcfVgg1peG+L4OQhn4Xv
         QgEu6OZH+SM78Bx194OzkCWDFWWpT+zpx+7GNBFsYDo2RjQSfsVGU1v/Wzpxmi7TANHh
         OS2gf6wKTDGuUAb/ooN/5cuzi7GQEXnWaI7UYbx/uuxRLIKH8nYdSxUD34bBDnJt+XlH
         3zYQ==
X-Gm-Message-State: AOAM5308oj/1jdXNPRS6PQY5p0fcijYwt20m4eSAi5esJ02F66PwRPm9
	9WgOYtjUcsbNvB9wYCwhFhFoFw==
X-Google-Smtp-Source: ABdhPJw2Snc+gQoBgYJzFskUkuKAvbAT2RF7i6kPMEQuXqdEKU1ZjuWSi3E8iJ7UVQPqE+7d8aedhQ==
X-Received: by 2002:a17:902:e5c4:b0:151:9bf6:f47f with SMTP id u4-20020a170902e5c400b001519bf6f47fmr635388plf.110.1646209745090;
        Wed, 02 Mar 2022 00:29:05 -0800 (PST)
Received: from FVFYT0MHHV2J.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id a20-20020a056a000c9400b004f396b965a9sm20922228pfv.49.2022.03.02.00.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 00:29:04 -0800 (PST)
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
Subject: [PATCH v4 0/6] Fix some bugs related to ramp and dax
Date: Wed,  2 Mar 2022 16:27:12 +0800
Message-Id: <20220302082718.32268-1-songmuchun@bytedance.com>
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
  mm: remove range parameter from follow_invalidate_pte()

 fs/dax.c             | 82 +++++-----------------------------------------------
 include/linux/mm.h   |  3 --
 include/linux/rmap.h |  3 ++
 mm/internal.h        | 26 +++++++++++------
 mm/memory.c          | 23 ++-------------
 mm/page_vma_mapped.c |  5 ++--
 mm/rmap.c            | 68 +++++++++++++++++++++++++++++++++++--------
 7 files changed, 89 insertions(+), 121 deletions(-)

-- 
2.11.0

