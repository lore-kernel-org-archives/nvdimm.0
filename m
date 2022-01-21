Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1158E2CA7
	for <nvdimm@lists.linux.dev>; Fri, 21 Jan 2022 07:56:35 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id d5so6251598pjk.5
        for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 23:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g85iyBrbQfGIa6oI3cy0UnhFSe/ynzyb0z74yUFTllk=;
        b=W4ZdDO/SKqbmtzYR/fK+Rrxosm61hwItSMOkaFU/2YX7icv3gLM22PlkNp8St7zagA
         UoHLQimZ796bnmN3njyvgHwul7SoNkSBEdJ9IG/MbFpKSoA2CAaUyjBax2geIygUt1g9
         5ndWslIKU0n0WHiQQDf0T3KGUCK5lyBYsNRJj5bZ5/Hk/R8x7Des5mPQavrM+bQFF06Q
         yKfhRzFP1c0jCTWn8WNdLEm/dtLo6ZXu5MP+c19NS1mQPYcIl83IWtXuJrZLPJyFofHE
         oKTVP4jynRsJO4b7OajRDhEO6MGTZJHDYgYjZu38f6inX6lzKJNTofnei2qpVdCJ6XfQ
         /YKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g85iyBrbQfGIa6oI3cy0UnhFSe/ynzyb0z74yUFTllk=;
        b=b7H07ceIbKUOSOVB2l9ENjQOr91d4Tnlm9EyLqyK7oGOE5wtf4fwcSxM/HrV/bb04d
         nikow5gkQhGAGXkyGWjFVPK3uGekQzztUbvknctdFeX/+7hB2NXKf1d9tEwOZyKP8OLq
         yogmTzP086TjjDWXMHpRIJ6RESN016+fQ22BFTXPSkhrw/FeETsL5lIv+rg7ev85KAwu
         1RqBTZkGiacEezxX2VypRI6kgSD0XeS3e5pkH/aruNKR1drJOl+16/QcnH63K+cNoGue
         ZCDojbAJ3NsX+qek5+K3S2xL0dr6ctBZm8yxXgoeQjH0d0pl1mY5IBp543vK5+HZ1dMb
         C7cA==
X-Gm-Message-State: AOAM530WkT5qkFATHuN2YKIfJCTZTiQLKY1SIG6LkCStF+m6EqFfJA1v
	E7NaHLBE9+H3RMT1whKdL8xckg==
X-Google-Smtp-Source: ABdhPJz6D9O2uvj40X0dQzDK5rSPcYK0+vGHyAMFzHzrHrk7fEsv1fTssN4tSehxXfv9S9hqt076Kg==
X-Received: by 2002:a17:902:9894:b0:149:8a72:98ae with SMTP id s20-20020a170902989400b001498a7298aemr2720829plp.132.1642751795469;
        Thu, 20 Jan 2022 23:56:35 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id t15sm10778178pjy.17.2022.01.20.23.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 23:56:35 -0800 (PST)
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
	zwisler@kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 2/5] dax: fix cache flush on PMD-mapped pages
Date: Fri, 21 Jan 2022 15:55:12 +0800
Message-Id: <20220121075515.79311-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220121075515.79311-1-songmuchun@bytedance.com>
References: <20220121075515.79311-1-songmuchun@bytedance.com>
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
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 88be1c02a151..2955ec65eb65 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -857,7 +857,7 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
 				goto unlock_pmd;
 
-			flush_cache_page(vma, address, pfn);
+			flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
 			pmd = pmdp_invalidate(vma, address, pmdp);
 			pmd = pmd_wrprotect(pmd);
 			pmd = pmd_mkclean(pmd);
-- 
2.11.0

