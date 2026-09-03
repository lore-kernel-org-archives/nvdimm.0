Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27F4963D2
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 12:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788438119; cv=none; b=b4XpaeWU0ApGDSDBkv/e9JxIQm+nGTu/SX8N1FJ/QU3i5cpxXGa3Y9HhWY+mcYujLrNDEDRk8sdvgRaDM13A+dNAdw2pSuuJDXn6/1AK0YAGWrQrGB4gZheXckA0VcwyL0KWQbib1G4XupsK5WERnlaezxnwXVuzseoaDg7OAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788438119; c=relaxed/simple;
	bh=iUjs+EiXrSNpfuKC5pykyao7Ehz6dcFc1lBNJ06asU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fM5b8scbPb1IA7Svk1ohqshkonsdrPgd8izdolQuFy1VOp9WJ9cT9lCykvB3z2L6vXRYMe/KO62HRBMnWzX3jX31f9Xcil6zM95XMNfOV0cy6Sz/Iu89oALkWYJuG6O+Q/bREtjgN4ql12WanPkK3gP18q+aIjRJlNjKx6eMzlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=K19HImJx; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="K19HImJx"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8535a9be75eso1892459b3a.2
        for <nvdimm@lists.linux.dev>; Thu, 03 Sep 2026 05:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788438113; x=1789042913; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8wCVi0RPQ/1w5scAtdtuQVBMayOKGUht0GU0fLrik4o=;
        b=K19HImJx8KyYVGl6/vVngx7fxHRbpFL0UQdWIAS2BlOZI8IbZovu2ScDwv5IJD6QSu
         wzLEJ+FSwzpRDKLKSiWow2TU697lK4JRKQkARnuGit6fXZ0RVlAs09kYsEub1JeA9Lf6
         KZWMxRd7H2EUJK8M/q8nXMAKFx9gqnDlO7Qhxfr54FHZA7MwisUJ4zRwz99adAGJ3rF0
         X5OrT7ZmegfbPephTWb6qOUmAyIdd8qsMgbkGqcfxG16KtjTwbjXChtjQ8Grfw4DiEFh
         ekgsV/BniZvFylbGdZIso4m3QxGAnfp7xinqvGut4l1NPrew1ZVTkLHnTe23DsHnT0r1
         tP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438113; x=1789042913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8wCVi0RPQ/1w5scAtdtuQVBMayOKGUht0GU0fLrik4o=;
        b=R8L8gsppyt4YTuoC9ZXESpMUCnWSEwgQuC+fjFJpxkpSdskD0OamryKrHVL7j9fBBO
         XJjLcqH3Lj4MhpnNQIGaPXWxc3Fgoe7pPsTVTdyDwVqDzV5b/oN3D7bqKms6aa3FiEye
         BOd6Dr2PVnNfOQcSMSa+HOc7g9QUF/Om/6w2Ll7XstZqXAv9x7LZFkY8SSTgxgbF0vUE
         0iyZAhkAEZIhknzLAd7fj+2AXaNOd/U0dBiVze+pWeMvc85hp5oFYxFfh1TYWXHo7R9M
         QzsH/vYam7ADYq5ME6aEVqOxBR7PqBi69ARM7iXoSrTDQVn2gDFiIFB4Ed2pZ5vdPvfe
         PXKA==
X-Forwarded-Encrypted: i=1; AKwUvByJfFYJ5KnQHz5ZVvyJV5zQhDRWep8PlSRcqwo55uXpv4iB51PKFlBHKDEPoW+fgiDGjAf9jQQ=@lists.linux.dev
X-Gm-Message-State: AFuF++mriVb1yZm1uZHRdNjZwH+LD2slVIak9APFgAkGQSQ6swW0yqRq
	/WSs2FoPy2LuyG95HTZqnzz8IZhzhbfqpoef4AuG1GpBCB8Wholwv5MUCwXO5muDTXc=
X-Gm-Gg: AYBFou0CE9wsb9lTY/LhuLJX5YtkffEp/12oQp1q3Clmyd77upXPoP36MDN88BX/BE2
	pdrv9g25Fo6Z3FFiJMA3dv4q4Bf4nRug7V/szI93OVeag7NB77yisoMjhuh/BlJ2VMDtAPUaA1d
	FyzbO88fG8qJHvTXYZnwSYpXe56yKzOaJkGmasu0m2t6/wBs6MKGlrtaoGDUWENvGUFvM06/akM
	kTnkB+Ts8MNm4NQCnL9immONWwgzHJODqQvPvEZWsqlbh0mRZ2SBNWy+25P/nOfG/YCeJjtq0jX
	mmtMqf0vVZUIvkd2tFXs/MInklgbu1AUaS4PzBIuRMceSz/ocqwzC69UxjKadzKb2oCttEyoVbf
	yP49ljclwUNzwRkIAgobQhI+R6R7doisTV+cr+b3N1/Eq34AvXtVXZZ8zfr6OdO7lOpyhp+ZvA+
	GKyC9bUwHRP6VJcfjbLeBqY195CMY3iQPPcDHpb7UJF889c5GlK3r0W+AggKSDp0+rR4adE7oks
	705ZQJ5M+8JnPZx9gqJlg0+1w==
X-Received: by 2002:a05:6a00:e8f:b0:857:72f8:dc91 with SMTP id d2e1a72fcca58-85ed850a6d7mr17640794b3a.18.1788438112769;
        Thu, 03 Sep 2026 05:21:52 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm2868126b3a.4.2026.09.03.05.21.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 05:21:52 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 2/4] nvdimm/pmem: avoid HWPoison flag updates for clean pages
Date: Thu,  3 Sep 2026 20:21:25 +0800
Message-ID: <20260903122128.12264-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903122128.12264-1-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pmem_mkpage_present() is called after persistent-memory poison has been
cleared. It only needs to clear PG_hwpoison and undo the MCE nospec state
for PFNs that are still marked poisoned.

For clean PFNs, test_and_clear_pmem_poison() has no semantic effect, but it
still performs an atomic clear operation against struct page flags. That is
unnecessary today and conflicts with the FS-DAX vmemmap optimization added
later in the series, where clean PFNs may be backed by shared read-only
metadata.

Check PageHWPoison() first so only poisoned PFNs update the page state.
Poison recovery keeps the same behavior, while clean PFNs no longer require
writable per-PFN metadata.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/nvdimm/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 30a51c365ce8..b14f75daeda7 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
 		 * here since we're in the driver I/O path and
 		 * outstanding I/O requests pin the dev_pagemap.
 		 */
-		if (test_and_clear_pmem_poison(page))
+		if (PageHWPoison(page) && test_and_clear_pmem_poison(page))
 			clear_mce_nospec(pfn);
 	}
 }
-- 
2.54.0

