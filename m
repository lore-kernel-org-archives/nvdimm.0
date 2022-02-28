Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47841512D
	for <nvdimm@lists.linux.dev>; Mon, 28 Feb 2022 06:36:11 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id bd1so9831298plb.13
        for <nvdimm@lists.linux.dev>; Sun, 27 Feb 2022 22:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eiCDiO7SeVqlcAe7b/JTkNhJRMnMslj9oR2/HG6e9n8=;
        b=hNvJJ0ezpU6tq5crtKQjZkvHgC7+HknHsNaTEEdgZR8JxxtwLFGoDAyD7x5IwET35y
         ZPRng5dZP2a5eK9ia13pSI2xguMnF9Za8S99u0xgEEo87HHYB2P4Xej2LVHL7eH+AKct
         xrxdslSfTa0qiPzYYh9Uj7RiCdwmZhmN4QcvdcS4l0U5en87upCMi2dRj4MX+zYpyYdE
         9bx2sftxHiohg9+NFs058WNmeoDpjma0q+zV41eABj5OLtmklp0RsU+byN9O8I5+y/Bh
         tS+HxIBYiIWT8UFKIb4XxBS4fOT1yRMgLmmi9yUSb3Xpk4yxR/XN6G6R+JLCWfBCibNi
         H5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eiCDiO7SeVqlcAe7b/JTkNhJRMnMslj9oR2/HG6e9n8=;
        b=G6q+g4BcGpsxjmeVVNNUeFKfQGo/4AWFT74VIHYMDKthBILEm5IxkTxPcLDo4KLvdI
         Ml/EcLEG1dxPrmvf1ZtjAzLnOJRrH0iws4uSpHZjM3prWtfZA9xl1nKF6RO1WDG4zOHK
         qGFZfdRehbYg5La/vAZM6RcuXAQgoDP4bohbyQF3qWfyAQB3Jl2cLTPdS4qna02g/d6y
         rkwKEtWXr4cCIObKxoASgrAksqJZeTDguObNFjOJYy2+t30DT8F7uhWuvvPmBYy8VQKS
         9WHYQp4whan5G/dQGMt+6kaElZgCI0dszvv3+iJGldiUPlBcVzsjHFn+04e+742XqB/d
         xU5A==
X-Gm-Message-State: AOAM5314C80x7SMGTlr184SN5ncD4gdqRGFa+GSUOKYeVl+jzjwOxaJK
	AHqWzigUXymCl7Ay6RgS92kcLg==
X-Google-Smtp-Source: ABdhPJzWNg+jqXhXX9lmsTizHuYtvGyPT0fg3+W582PsfWEVtMonxYeOPpLeTi3y6GAcOQpWl4KCZw==
X-Received: by 2002:a17:902:ce8d:b0:150:1d25:694 with SMTP id f13-20020a170902ce8d00b001501d250694mr17105506plg.36.1646030170821;
        Sun, 27 Feb 2022 22:36:10 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7960d000000b004f13804c100sm11126472pfg.165.2022.02.27.22.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 22:36:10 -0800 (PST)
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
Subject: [PATCH v3 2/6] dax: fix cache flush on PMD-mapped pages
Date: Mon, 28 Feb 2022 14:35:32 +0800
Message-Id: <20220228063536.24911-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220228063536.24911-1-songmuchun@bytedance.com>
References: <20220228063536.24911-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
However, it does not cover the full pages in a THP except a head page.
Replace it with flush_cache_range() to fix this issue.

Fixes: f729c8c9b24f ("dax: wrprotect pmd_t in dax_mapping_entry_mkclean")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 67a08a32fccb..a372304c9695 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -845,7 +845,8 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
 				goto unlock_pmd;
 
-			flush_cache_page(vma, address, pfn);
+			flush_cache_range(vma, address,
+					  address + HPAGE_PMD_SIZE);
 			pmd = pmdp_invalidate(vma, address, pmdp);
 			pmd = pmd_wrprotect(pmd);
 			pmd = pmd_mkclean(pmd);
-- 
2.11.0

