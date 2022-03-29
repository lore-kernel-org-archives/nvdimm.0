Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C742565
	for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 13:49:42 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so2915639pjo.2
        for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 06:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xp6qCxwTnE0C1FxChih956SdBv3W6L+dQXT7C0J3Dts=;
        b=7dvqFGIZamDh6z2A7HqI+S0QNO4F3ZMglCOrx6y5hhx5QhuJeI8ofBVTiND7e6IZ2V
         m3lUYzObTIB/gdTZFA4KQD4DVsVBtwZ8tSMWVw+36xNQvtuPiVUrYb0u+Y3+2lro1C/F
         zPYEz7Vt8YKGhinn+4PXZ3dukjN0B1MbiKgtAlv1rGMO4ZQpvr71RTKO76fB44QtchOm
         abY0vvsDPKb/HSm86BzJ17VHR5e2mrLwsVZuC/1Ttk6sY1o74EUfeVjNCyd0bQ7PiVCl
         3BXyud3hnwNvDSI2kGuWLZy+j235vtliI5g0/WHD/uaa16qqBriGcKHkz9VNYKXowtrs
         NR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xp6qCxwTnE0C1FxChih956SdBv3W6L+dQXT7C0J3Dts=;
        b=NJVa3KJgVuW7IoUcHtnp+gQYKf6ZVCNXFNkjF8IWnta73PCS3VPVJl0nAIyxK+6SaM
         ZmQyOcqwCcX5xAXbAFwDSd8HkF8BK4UXadVTNYwPnr1QyK9ZsDRnr9oa3Z3JdvZtjoeJ
         2W2D+g1Edl4Y7pp1z2I8dIt9DMy0OaclFbxfai75jb6y8ReD67RauGqMYK1mRwN2R+7I
         EfIUKRf9QsehhW9mwAFGHjVE/qmz4Mo3EAAWsAdHxBfqvw/k5uXOEEEFTJaym78YpiDm
         jR9/eSvzUHDbDE5xOAIX0NgC4VzmAg7ATECxpF7oEZyGvvrCWA7aUXmbw9isyTMarJ9q
         qSQw==
X-Gm-Message-State: AOAM533YmRZ4d96gRaH9O6OXh0Dhs098dmtTVu/hirO2hIUABk9m2PQO
	IJCXVh0hzOeuMT2vRIYP0gvpPw==
X-Google-Smtp-Source: ABdhPJzL1DT1WGANxca1cudkBoNvw0RQh0wE19/V2uhTvOrIsqwOC1l/X6irJPErT8PhUYtRlg0EqQ==
X-Received: by 2002:a17:903:32c7:b0:154:19dd:fd43 with SMTP id i7-20020a17090332c700b0015419ddfd43mr31879012plr.150.1648561782107;
        Tue, 29 Mar 2022 06:49:42 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id o14-20020a056a0015ce00b004fab49cd65csm20911293pfu.205.2022.03.29.06.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 06:49:41 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 1/6] mm: rmap: fix cache flush on THP pages
Date: Tue, 29 Mar 2022 21:48:48 +0800
Message-Id: <20220329134853.68403-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220329134853.68403-1-songmuchun@bytedance.com>
References: <20220329134853.68403-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page.
Replace it with flush_cache_range() to fix this issue. At least, no
problems were found due to this. Maybe because the architectures that
have virtual indexed caches is less.

Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/rmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index fc46a3d7b704..723682ddb9e8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -970,7 +970,8 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
 				continue;
 
-			flush_cache_page(vma, address, folio_pfn(folio));
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			entry = pmdp_invalidate(vma, address, pmd);
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
-- 
2.11.0

