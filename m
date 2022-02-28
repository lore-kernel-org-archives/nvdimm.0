Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553A4512D
	for <nvdimm@lists.linux.dev>; Mon, 28 Feb 2022 06:36:24 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id v4so10252245pjh.2
        for <nvdimm@lists.linux.dev>; Sun, 27 Feb 2022 22:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6i31CSY3Duk9LeOLZiT7NizPvWf1K5PHZdMP52ume4=;
        b=2ZOfoGu1/MFgeEOp7l9nzx855BOTpf6KmEjvuBGsADCtnylUZoSMJkf7HBr0NUjbQ9
         FlhYhNEd4W5SrEIiQ7jg9pl2rVCIkXOJKHRwFeG3u/8LgbAMoYAh2GVHOzyKc/+4/1Pe
         AcKWPJSazVveDRPEU7EgvojmP1Zm0cKZ0d6u8ilffoSTMBoRW7RIPHu52Y/4AUNV8yYj
         hO2CjE3SbcHqQODlmF4mfEv3grvZmXIeChJBgAFFy8elF3DSzVmcs7AN2G3pduRvj9eR
         WS0/wAt6k2rcLiw6rPhq36STduyHRutBHeIuwRZDbZQbqtgw3ZqKOIiJEQmN5M7MF9JW
         aRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6i31CSY3Duk9LeOLZiT7NizPvWf1K5PHZdMP52ume4=;
        b=OEBIvYLhi9X/CagYRDqocfy8SJSR6ciscB/LajfxyEkyuLs/j+ZG+7/hTRPU4kpYHJ
         CiOjHxl1vKjtEd/o2aZXxd30lU9O8sW+dLtfjs1QAOyohtWj/vcDK1mkiDCszmxrZ5BT
         MsLf+PL5Si52zbJWIAFGa/diFbU1ColTw4Jn4LWtNguNwp03cSKEYCJhYDyiIjq03RHr
         bc83aY+CYp1relWsGi0KAm1YBLVDznPOEBBNVUUx34W4Rk15+uUv0p9DxTZhX7Z9+8Ir
         v49KnA/nCkugtsZR5n/ESJskbxWoFB2SVElSqsCQOs11TaevgsLqabqYYGmMPFEIOaaI
         BD+g==
X-Gm-Message-State: AOAM532UJl6AzUVYhUEBsisFzWKKaMzgSi+EkF7l92+UKN5xvax7uf/0
	NUnqY8EBfBacJDDntYycucuqNg==
X-Google-Smtp-Source: ABdhPJxsMZqyRAFflkcZZDVJv843JKnWfi3iHw1GFs0mIeO4WlE4MNK7MLekTr+M8I6YkaLXWVfsNA==
X-Received: by 2002:a17:902:c944:b0:151:3829:a917 with SMTP id i4-20020a170902c94400b001513829a917mr13578398pla.144.1646030183943;
        Sun, 27 Feb 2022 22:36:23 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7960d000000b004f13804c100sm11126472pfg.165.2022.02.27.22.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 22:36:23 -0800 (PST)
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
Subject: [PATCH v3 4/6] mm: pvmw: add support for walking devmap pages
Date: Mon, 28 Feb 2022 14:35:34 +0800
Message-Id: <20220228063536.24911-5-songmuchun@bytedance.com>
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

The devmap pages can not use page_vma_mapped_walk() to check if a huge
devmap page is mapped into a vma.  Add support for walking huge devmap
pages so that DAX can use it in the next patch.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/page_vma_mapped.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 1187f9c1ec5b..3f337e4e7f5f 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -210,10 +210,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		 */
 		pmde = READ_ONCE(*pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
+		if (pmd_leaf(pmde) || is_pmd_migration_entry(pmde)) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
-			if (likely(pmd_trans_huge(pmde))) {
+			if (likely(pmd_leaf(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
 					return not_found(pvmw);
 				if (!check_pmd(pmd_pfn(pmde), pvmw))
-- 
2.11.0

