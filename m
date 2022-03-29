Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9032565
	for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 13:49:35 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so2919880pjf.1
        for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 06:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DdqwlImXrfao84vCHBrZYdsfDtapi0otjvjw/TD7gAs=;
        b=iqmBctwaR3RnMvlGbfAY9TefMgdpgPs5uTFnScOMAg7WCye0WWGUkpPFAhBNOx6r7X
         7xbZLOsB1kf93MKkXiauUeHte6cMJQCWg8asM67oms0HaCmzDyQIXBOb84j+6oJthZNW
         NGw3IQOqZD0a3q/6QqOXLCTkJC5iXA/i1gb4icEhNapcEGT4XYNP3m4EWTCdI4dHz2Vk
         wyxu0v8qqP24AnkXN9DxEJdRfba89K846CIvOrB94f/L5wC4PKYmrr+1/BcyhjNlHdlT
         7YOMNiaENUWkeJEkji8G+ikHaeuCX17BWmjKWjOjM4F5ReBHm5idgE8oiFkBuBnH1aXZ
         yk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DdqwlImXrfao84vCHBrZYdsfDtapi0otjvjw/TD7gAs=;
        b=WN2X2QpxFz3Z8kWrCny7Tus5KHOA4+OENHG2BK8ZUEsZsfgnriq0hm3aPLbYTU8tLi
         vKbwL3W/XBCDgjCHVpmeP06GR9Ye0tl6D/TiDCL4X3WJkxQNS99RwQRawLsZHf7zs9qx
         Kkp10wvU2Rv2Ossf3CbWZwIjQqIsqgXexHsQgkx0QjMy31ytyjKzJWS1GB/wcM2o/QUp
         osiGClI2S0TesfS5rvL6M58cv4TKbqBDxe6X7c9dKZxJw6+IhrhEfklaA0SPFx8CVpwX
         oZ7XZe85leSQdxkzkGM6l8qQJPqYIpz8lnqO2B93KEqBt7iDGG77Cy0V+Qa8g+pi78Ah
         ApAQ==
X-Gm-Message-State: AOAM533zifZmZiL1A85FPod4/1vK8mxwR5c/a4NRsyOvV/N9LrzWxsRO
	BrtwvecpZnWY6hFtU4DawPIpLg==
X-Google-Smtp-Source: ABdhPJxpMRY/A3rB7g8dnvTTe8NY23xQXPqq1uhJ9JnzOsx7Vi++6ue4mirhtJluGTHkVJDk33bdkA==
X-Received: by 2002:a17:902:e5cc:b0:154:1c96:2e5b with SMTP id u12-20020a170902e5cc00b001541c962e5bmr30655333plf.94.1648561774945;
        Tue, 29 Mar 2022 06:49:34 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id o14-20020a056a0015ce00b004fab49cd65csm20911293pfu.205.2022.03.29.06.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 06:49:34 -0700 (PDT)
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
Subject: [PATCH v6 0/6] Fix some bugs related to ramp and dax
Date: Tue, 29 Mar 2022 21:48:47 +0800
Message-Id: <20220329134853.68403-1-songmuchun@bytedance.com>
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
 mm/page_vma_mapped.c | 16 ++++-----
 mm/rmap.c            | 68 +++++++++++++++++++++++++++++-------
 7 files changed, 119 insertions(+), 176 deletions(-)

-- 
2.11.0

