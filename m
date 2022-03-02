Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447912576
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 08:29:21 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id s1so929770plg.12
        for <nvdimm@lists.linux.dev>; Wed, 02 Mar 2022 00:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eiCDiO7SeVqlcAe7b/JTkNhJRMnMslj9oR2/HG6e9n8=;
        b=cYJLK58sIMtE77DATtQlxH9dtPyPDOawr2Hs9P06tVu2j6KUemAg7S9UEgucud0DdX
         4h/Uh/mP0MROdl00Wa/vvnYHaH6Ya6dm/OxjneqryKBM8Gp6v7zc8BhA27iNEPG1yHH2
         Eojft7GBt8tz5GmBW/hk0eB/lgf+Hbk5vSPzs7SU8EZS8jxOTz8PGvLJ6crgihfH37PS
         nXcScKKh2ZkdzeEMqPdHtVBCvj2or8wIA4avGEhSTLrskKUn6QAREUoUwwRZk01wFFti
         xXOkL2PqQ9YVw97HrnKwed0fGb91eHchAYlq83PZW206GlgUEgKY4mhHqxy1QcA26b4q
         Powg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eiCDiO7SeVqlcAe7b/JTkNhJRMnMslj9oR2/HG6e9n8=;
        b=31Uht8+K5g4dIBeFwjx4hlY5PUqtTWiGfOXNAMMzgznNy9cdVUyNqk3oohzOWie9Dr
         uEapeZ7WHbXBFGnx8xxKjRvUVoOBNpgVzqHhoiXG8/LkhNk0orD8jGjMh5kK29rRMDeY
         JRhKjpVhxT4aKgDhLq1uEue1iJ9bN/Ihazwaf7GRtvcradK6LCRiS8oW6MTzaTdLvOLE
         ZGN4X8s9q669QX5GzzbvwfasMFu3j54HK9YT5I1ReinDmcJwVNust/EE0TseOdNKmG7V
         sEpXRfjrHvLrbIj64/IPdAShKI8Qw5DNnYKrJAHiIqyMoXTiZEM1mJXat4d1JlLZFWia
         pw4A==
X-Gm-Message-State: AOAM530fAOj8IYVsNiwIzBvd5HaVs0IaZEDz0WIwCkLEx2vjLYRSnkQP
	ZoeqnNmVA+fi1H8A9VSeZFzd+Q==
X-Google-Smtp-Source: ABdhPJzHW21CrBKiP5Br3BMc/q1Bt4vTHDEYHfTZ2tmAwLrCBHaS+KABg8tBrpmlUqjiIhOiEwMJWw==
X-Received: by 2002:a17:90a:550b:b0:1bd:1e3a:a407 with SMTP id b11-20020a17090a550b00b001bd1e3aa407mr19607925pji.112.1646209760828;
        Wed, 02 Mar 2022 00:29:20 -0800 (PST)
Received: from FVFYT0MHHV2J.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id a20-20020a056a000c9400b004f396b965a9sm20922228pfv.49.2022.03.02.00.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 00:29:20 -0800 (PST)
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
Subject: [PATCH v4 2/6] dax: fix cache flush on PMD-mapped pages
Date: Wed,  2 Mar 2022 16:27:14 +0800
Message-Id: <20220302082718.32268-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220302082718.32268-1-songmuchun@bytedance.com>
References: <20220302082718.32268-1-songmuchun@bytedance.com>
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

