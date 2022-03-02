Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656162576
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 08:29:38 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id em10-20020a17090b014a00b001bc3071f921so4142751pjb.5
        for <nvdimm@lists.linux.dev>; Wed, 02 Mar 2022 00:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l/myAdjexodhPdxGEM0MHuk2V1UzL2hIaRiiu46o6gA=;
        b=5wCqMdPra7WU6QtB0HKKqpqInbC0mjKYJvNn1TUItnMFQQUxMLnPC8gOImTQQjrUJ6
         lxZPmTjDu1L0Q72qlAPkPaRlENO07rpX9UYXO0FAF59aYEtozl+ZKAWQZ8W3qqRE+ikr
         SlRgQWIHHhcTtdgRhGo4D22XRHAZBBeblqRndIow0K+xwrQOm5CHH/9Z9ixzQe6h7kFE
         zNljQhcoRBU9180TzWuXPS9NCuP82R0Fe0PKzpYQqkyaXnxFW5Nt5cxWBJuTk3L4oHxt
         KISVkpNb+bLAdydzsYyxsQZ+ibl5wXiET/Dx7dQOH8lcVFxHxuZfrkdIRaRw8w+oE5Al
         xSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l/myAdjexodhPdxGEM0MHuk2V1UzL2hIaRiiu46o6gA=;
        b=t/z3OUkWD9M+KhinurX5ZsmWOxLVH3wvB28jqC55JzM8D0q0fBBoMH9uqR2h8nnA0y
         +Fv7NoCKSwO2fNl8Am2BLVgFWXfUIQ1YOBxRO3jv8BUgZLt7eZWOOqZW4cT68jQ8MLgy
         kvUiTz061gV+8DKcalUTH44GqgWvOKBRPLVxIdfO6OFzHjhaTu33X7VQBfGmJVkpYp/A
         sN7JK/Wc7ngtz4MxYWF0WjO0N5NBKf077MHmH0XXepv5NufrwofJLsan3ASKeVcDJrQk
         8b8aag7XoVgQVRmIXsPeawH7rrV0/5uuTJaVATxp7QyBrnTeZpjXys43fiV5AbOv14nT
         xLDw==
X-Gm-Message-State: AOAM531KqD7bJf3zelVb1AaulDhMxjL6otC1htI0cYB/5JuXAjyDuoqv
	46bwRvwI8d+SaX2vX0LtMiQ+1Q==
X-Google-Smtp-Source: ABdhPJzT8ObZdk6+fbYovMIjQEfRPZciRdCbVZminjRSbL7HjS0V45URjs58A3iPwR4mLPclCDR1PA==
X-Received: by 2002:a17:902:e549:b0:150:2412:c94c with SMTP id n9-20020a170902e54900b001502412c94cmr26221501plf.94.1646209777959;
        Wed, 02 Mar 2022 00:29:37 -0800 (PST)
Received: from FVFYT0MHHV2J.bytedance.net ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id a20-20020a056a000c9400b004f396b965a9sm20922228pfv.49.2022.03.02.00.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 00:29:37 -0800 (PST)
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
Subject: [PATCH v4 4/6] mm: pvmw: add support for walking devmap pages
Date: Wed,  2 Mar 2022 16:27:16 +0800
Message-Id: <20220302082718.32268-5-songmuchun@bytedance.com>
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

The devmap pages can not use page_vma_mapped_walk() to check if a huge
devmap page is mapped into a vma.  Add support for walking huge devmap
pages so that DAX can use it in the next patch.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_vma_mapped.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 1187f9c1ec5b..f9ffa84adf4d 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -210,10 +210,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		 */
 		pmde = READ_ONCE(*pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+		if (pmd_trans_huge(pmde) || pmd_devmap(pmde) ||
+		    is_pmd_migration_entry(pmde)) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
-			if (likely(pmd_trans_huge(pmde))) {
+			if (likely(pmd_trans_huge(pmde) || pmd_devmap(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
 					return not_found(pvmw);
 				if (!check_pmd(pmd_pfn(pmde), pvmw))
-- 
2.11.0

