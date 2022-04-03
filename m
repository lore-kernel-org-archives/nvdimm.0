Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C851FBD
	for <nvdimm@lists.linux.dev>; Sun,  3 Apr 2022 05:41:39 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id f3so6129422pfe.2
        for <nvdimm@lists.linux.dev>; Sat, 02 Apr 2022 22:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P/G4cY6LA4u6yV/b8BGhElOxrEr7wa4Csrvtb+Y6qso=;
        b=7jSVQ79b+01y0a3OIt4mIy3OD3Bmy88FmGcA/qn97f2Sw2HTM5zHt5Z3vf6eSa05O5
         8KATfUa7aPdV9idYkmMFpQa7avLXAeGK7o21AsI+a/FVKxiqlZmHorgTTju6bnHLfHt6
         oWLIAHsD4cxl82X558HPB6VNb45Uomwcmk9+JIZ0QfXDwex0bJnDmMai6OsLpPpHWteC
         2QezqEXHY1peozS+If4seb5mEfpnvno/EA2OzdmWprY8lmLKDdKzXeOOvxPeQCKg3YuH
         Z4f9zEjIPoK+mkeSx70BhARKhSvGBE+qygkzwVs/Nr7nirXqN0f33JPXiYNKA5gZjZdA
         LCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P/G4cY6LA4u6yV/b8BGhElOxrEr7wa4Csrvtb+Y6qso=;
        b=eIxvae7CQr01FlGJIEBJiz8GpnDmoQguSYsFOMmL0Km1qfEFj/1bQNVRA6wbx/NINb
         /Co04enX3LJgY47iCm3jqAmf4Rse4uZOhgp76yxUP3hXKp5sCFLFdgdoqZ6ky47kzixq
         vP5GyDSJCFseLolU0kqNgTFKD6qWupYQMLPkUFkojpEFOUNTnG/ZPMTEt16zlcdmDlww
         E1LS/tMsxR2+5L7tyfHuuH+ZTqouvXj7ajiUy1+50rk5+O/qITvxhUEFCMuTskBx4stU
         rMFLItbe5+Y0eUmhwMO9dJ+5ZpNOTPORJmqHKKfcPpiWrG829Gqo7PiH0V6tsNg1R/DI
         1H7g==
X-Gm-Message-State: AOAM532RnrilEdGK0rvjAr6oqDxPoQ1gqPGT+0bLhDe5caSz0V3WpSwK
	qNQfw/b57eoY3Nn3pfBuuCk5DA==
X-Google-Smtp-Source: ABdhPJxGOROIqTOKId5F4JMIrbX834xDIMvBWzvSxSoC7uaCqPhyXCkc5AknFgZY3po9EwZFzgLsfQ==
X-Received: by 2002:a65:6e82:0:b0:381:71c9:9856 with SMTP id bm2-20020a656e82000000b0038171c99856mr21437599pgb.316.1648964498579;
        Sat, 02 Apr 2022 22:41:38 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.245])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm8262479pfx.34.2022.04.02.22.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 22:41:38 -0700 (PDT)
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
Subject: [PATCH v7 4/6] mm: pvmw: add support for walking devmap pages
Date: Sun,  3 Apr 2022 13:39:55 +0800
Message-Id: <20220403053957.10770-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220403053957.10770-1-songmuchun@bytedance.com>
References: <20220403053957.10770-1-songmuchun@bytedance.com>
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
 mm/page_vma_mapped.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 1187f9c1ec5b..3da82bf65de8 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -210,16 +210,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		 */
 		pmde = READ_ONCE(*pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde) ||
+		    (pmd_present(pmde) && pmd_devmap(pmde))) {
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
 
@@ -232,6 +226,13 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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

