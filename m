Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A330358360
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781160464; cv=none; b=qdN+vgguOHaXHqFo2YJo7jtCSpx0s2tfSGjnDEseefht5KA3Kd39pWaF36dBGbZLCM4ldW3Kz5axf2Od1j1wW91Z6Azxb1NaHIRwN21LjSxePJnOKfAt9p2ajF5CorwvRc9XtGQbqIBV4w5UnWluIV+9Qr+0PCpOmmIA92bLGnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781160464; c=relaxed/simple;
	bh=NwnuO8Z0UsG+3NUpzyI9s9wy3riFEcPQ4uqsjijXHjQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2L/9bfcvSNoGJ+yeZPiGLW05n4jK3tLaY3xgyIkas5z/WJbCedtB8Wryq+Co8zY2Nk3hGVpn19aKkJkZUM0yZ8HWZdrzPP/veK3AaIouCTP1IDbQpMELfSH2lA3fuI12xh4420C5ZsloKMq++xuDaUljTlcayoHMZTb2T5X8GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbn74Ckz12NXN;
	Thu, 11 Jun 2026 14:21:41 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbn6tJgz12NXN;
	Thu, 11 Jun 2026 14:21:41 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id D585816CF;
	Thu, 11 Jun 2026 14:21:23 +0800 (CST)
Received: from hsj-2U-Workstation.hygon.cn (172.19.20.61) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:21:36 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>
CC: <surenb@google.com>, <mjguzik@gmail.com>, <liam@infradead.org>,
	<ljs@kernel.org>, <vbabka@kernel.org>, <shakeel.butt@linux.dev>,
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux@armlinux.org.uk>, <dinguyen@kernel.org>,
	<schuster.simon@siemens-energy.com>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <djbw@kernel.org>, <willy@infradead.org>,
	<peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
	<namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Date: Thu, 11 Jun 2026 14:18:57 +0800
Message-ID: <20260611061915.2354307-2-huangsj@hygon.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611061915.2354307-1-huangsj@hygon.cn>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

Use mapping_mapped() to simplify the code, make
the code tidy and clean.

Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 fs/hugetlbfs/inode.c | 4 ++--
 mm/memory.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 78d61bf2bd9b..216e1a0dd0b2 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -614,7 +614,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
-	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+	if (mapping_mapped(mapping))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
@@ -675,7 +675,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
-		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+		if (mapping_mapped(mapping))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..5335077765e2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4386,7 +4386,7 @@ void unmap_mapping_folio(struct folio *folio)
 	details.zap_flags = ZAP_FLAG_DROP_MARKER;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
@@ -4416,7 +4416,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 		last_index = ULONG_MAX;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
-- 
2.53.0


