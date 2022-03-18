Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0A94350
	for <nvdimm@lists.linux.dev>; Fri, 18 Mar 2022 07:47:53 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id t5so8822984pfg.4
        for <nvdimm@lists.linux.dev>; Fri, 18 Mar 2022 00:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lWUQux1KtYb2lW/SJw8SxLz0dcCTGFUlQsH2e++z+XY=;
        b=5bzBbr1D4egu3YxUjV6NU5rP+tmRTfoCbQCHzoz5dOiFVKlrS0cw7ippuefsHKLsCE
         fo2HvaJglETK9wm68r8dOlew9nAPqA9sQV27lJoQ/riPuNKVaTkiLydUSvyY34v/4Szx
         k2dwX1GB3beaot9LSmk0kJilr/Wox9GEY6UR+NAqpsr8eEAaPXoO62fSz6cfSarCvKXY
         9PsV2xjPoa0/pke7OOwVOG768pLYDkFnAjWM8MrCHQWxTr8R8BqWDVB6TXE2OxVtxxmv
         S2p74U/apcotkbr8QzaAIeNAWsiOhvvfleiiDpIjzQhmtA6v39V4Pp/Goz4/EHviNis0
         f85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWUQux1KtYb2lW/SJw8SxLz0dcCTGFUlQsH2e++z+XY=;
        b=CgEz49hWMoxiZEMXqPHnBmlfzMHBA0+344yo/GfzZcy+XstZ6YC0+WySQD94TmSFhN
         h4RaCLMV1HmEgtuvmMcsBj7J73tW88HNyJJSKOl8eAojvrYifNH+cmjcjTopGV+X5NFs
         oHhZ6zrq3EUw+nx51M/tzHu++rBM2+STzty79YnHWHckZYAIMaZHnzOCfuJxa+Zfq0MD
         hE7Okih48E7r8fH494JnuwH/DVd4Tpoog7yALiqZuf0ffbCXx7pzrL5z46mVn8oxm2JA
         VJA0Yp/OxyjGJZ5WQF8302crYw8k02l9/pShHiyoJWgA0wXUCOqU+oXgSw5XJqFzxxUV
         KzhQ==
X-Gm-Message-State: AOAM530ty4pAQO+i6n5siIemb29IEhYQOXsQjAm5904ZE7g+QSddYsyK
	VZaZPr/2+qF5K8+7xghk7hgkVw==
X-Google-Smtp-Source: ABdhPJxOutWrAfVqkjylZCN0QPCTtjilyzjelgGeLWhCr1Nvt3WOGLzbIbbupSf5LNvps9BtFMZI4A==
X-Received: by 2002:a63:1758:0:b0:381:effc:b48f with SMTP id 24-20020a631758000000b00381effcb48fmr6973156pgx.124.1647589673409;
        Fri, 18 Mar 2022 00:47:53 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f72acd4dadsm8770941pfx.81.2022.03.18.00.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 00:47:53 -0700 (PDT)
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
Subject: [PATCH v5 4/6] mm: pvmw: add support for walking devmap pages
Date: Fri, 18 Mar 2022 15:45:27 +0800
Message-Id: <20220318074529.5261-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220318074529.5261-1-songmuchun@bytedance.com>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
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
 mm/page_vma_mapped.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 1187f9c1ec5b..b3bf802a6435 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -210,16 +210,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		 */
 		pmde = READ_ONCE(*pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+		if (pmd_leaf(pmde) || is_pmd_migration_entry(pmde)) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
-			if (likely(pmd_trans_huge(pmde))) {
-				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
-				if (!check_pmd(pmd_pfn(pmde), pvmw))
-					return not_found(pvmw);
-				return true;
-			}
 			if (!pmd_present(pmde)) {
 				swp_entry_t entry;
 
@@ -232,6 +225,13 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 					return not_found(pvmw);
 				return true;
 			}
+			if (likely(pmd_trans_huge(pmde) || pmd_devmap(pmde))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (!check_pmd(pmd_pfn(pmde), pvmw))
+					return not_found(pvmw);
+				return true;
+			}
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
-- 
2.11.0

