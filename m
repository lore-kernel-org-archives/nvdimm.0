Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B370B2F29
	for <nvdimm@lists.linux.dev>; Mon, 28 Feb 2022 06:35:57 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id p8so10202006pfh.8
        for <nvdimm@lists.linux.dev>; Sun, 27 Feb 2022 22:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gir+3TzfRrR4lUGuNtpX6IanjDHuvIa4YBDHCeSrYTM=;
        b=U4WTDdkDu/m+18FZjAfoYKwWYSJgf2GebNR7tlo2J5Ws/MwDCFwh7rMXQx5q917ATJ
         Jh07wWkQO93U72bllHBrmsBQ6RJEd7VhhRdaHI+FhN2hPsYXosIZbd8EpBNACQeM4TsR
         P2XJgmJ6qtHKjNspVx3ECmiH3cUlA81aFGBo2+D0pztKHxbDuNdfWP72LyPgSB/d9k6P
         qCW/oe8t2+gdYmCj3hiNeSENb3ZGV+dLl8PIq1SDghR3oQvZd6Fv5wURkt0b1Jq85RQw
         k1sfseZYkW/L04DkmzQ8tv4Odm5PA+uN9diNyRVqnxNgYOaofM2G3IPfKok2I2CG73sG
         7WYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gir+3TzfRrR4lUGuNtpX6IanjDHuvIa4YBDHCeSrYTM=;
        b=gHnT3MBPyIu7pY0UJUfXw/6ximPuIaakFoi/X2JDrCWJigkBHtdIm20VPLaY44CTQv
         0BgA1YY1Y0OnZqA+eKwmZsjroTb7ErjgVvR+mUxVRLMxbBaY85ew3YKy4mJE7fesAJPK
         W43LxqJx0bMaRSvj2p1pdm9VVyvmRSgKSYAR3/fC7K6KNemHnPR5bPDWHRfQKoJoIICz
         jrx+QagvfvXXt4f24IBEsZppW7utXt5I+T+inrMJIrnAou1P9Dq61uFz8z27hDmnxoQL
         KdjEpdY1DaGAUj5NJYX4stE3nI8p6k7hc0BX0fDotR4vCfa3iDhkNo32FW5JmAoV4oZe
         gN8w==
X-Gm-Message-State: AOAM530jmRXM1CWKcSI4jzfqYom4ap4+7aZa3Oe5y4Px1txkIMwFP711
	UDZqFxj0gVtmA9WVdLnVbvb6ZQ==
X-Google-Smtp-Source: ABdhPJwmHsIW4ie8Q+S5U3vmmxqNz17eiRrlLlRl8QPqeQV/CdrZCVTHPizyx7mRkra580xz4wWnuA==
X-Received: by 2002:a63:517:0:b0:36c:6d37:55ae with SMTP id 23-20020a630517000000b0036c6d3755aemr16179228pgf.424.1646030157059;
        Sun, 27 Feb 2022 22:35:57 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7960d000000b004f13804c100sm11126472pfg.165.2022.02.27.22.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 22:35:56 -0800 (PST)
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
Subject: [PATCH v3 0/6] Fix some bugs related to ramp and dax
Date: Mon, 28 Feb 2022 14:35:30 +0800
Message-Id: <20220228063536.24911-1-songmuchun@bytedance.com>
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
 mm/page_vma_mapped.c |  4 +--
 mm/rmap.c            | 68 +++++++++++++++++++++++++++++++++++--------
 7 files changed, 88 insertions(+), 121 deletions(-)

-- 
2.11.0

