Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB585F848
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 10:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709720964; cv=none; b=m1W2+rhbspvW4SjqNZPoi/MS9AiSUHm6gstDA4c5D3SZGXeCQl6rvfsiTdyErU6hRsD/GA5ha/QWMZKotvEXWbgnFN+22K1jL5rw2mWh5TnetmOIru3pfEH9y1kh4f/vxmqV5hsnqGT7Z+yG/xDVc1CkzP+TMiKLxSJ3ucjygN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709720964; c=relaxed/simple;
	bh=qPTXg1j60dmCKgrUxhmFd4z9be0Rjp54MJE3FLxdEQM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SpDZBRhTyFWsp5C6NTMfdoPnNfWfWzfOiKpa0wsNUAMOCc15gPqXVUmU1eA01B3M04V03V3DA35DDfwCT0MByR9hkE+O120PayH7FSeaj7iSy1cwjr80RZsge3Qzzj990Df0ZYFQ6lj43VPN5kVcXdWEAvRUinx31SoHxZeZs+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=lGOsgFSu; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="lGOsgFSu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709720963; x=1741256963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qPTXg1j60dmCKgrUxhmFd4z9be0Rjp54MJE3FLxdEQM=;
  b=lGOsgFSuoAiXNpP5Y9RAN4XbNTumBMibnuZhhEaiTuXRM4W6f0LtQTu8
   qjf5Y23x0trILLJxDNBXxE468SSENqKCmqgzPvsf0nv+32mloxCqbl6PP
   P0FlfQUtquE96IBM6LBj4O514sBrcgVVPvSiHtoabJwYh7jMo3zynYCfG
   mYTnL3iINz04yFdbEGE2/VBQKddRAB4iIX8NGGjFjBKtHjs2f5/C9LTvV
   +9JwPyq7zx3sNq3cZd5VKPMQxxNhlLFKLyn0/iqCEQFvGpwMQmLKfFzR7
   YPgrkuPOWBtWk7Rr4G1E+7YP3BeY/YB+yiO2H3y8owa8eZQGQIM8qNaUq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="151260033"
X-IronPort-AV: E=Sophos;i="6.06,208,1705330800"; 
   d="scan'208";a="151260033"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 19:29:12 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 355A112E239
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:09 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 6B94DBF3C9
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:08 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id F208D202CB587
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:07 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 08E3D1A006A;
	Wed,  6 Mar 2024 18:29:06 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: y-goto@fujitsu.com,
	Alison Schofield <alison.schofield@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	hpa@zytor.com,
	Ingo Molnar <mingo@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-cxl@vger.kernel.org,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	x86@kernel.org,
	kexec@lists.infradead.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v3 2/7] mm: memremap: add pgmap_parent_resource() helper
Date: Wed,  6 Mar 2024 18:28:41 +0800
Message-Id: <20240306102846.1020868-3-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240306102846.1020868-1-lizhijian@fujitsu.com>
References: <20240306102846.1020868-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28234.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28234.006
X-TMASE-Result: 10-1.178600-10.000000
X-TMASE-MatchedRID: a4Q7dosAlP6Po+6vQMop+ikMR2LAnMRpCZa9cSpBObnAuQ0xDMaXkH4q
	tYI9sRE/7qN2AY1LBYfX/4cXJB77G82IoAvAG8Cytw+xHnsmQjMRKrbwgeEU4psoi2XrUn/Jn6K
	dMrRsL14qtq5d3cxkNePDdA+sPJoJpIWVq2FPrVRC8PbPp9VJvAwE3szHrU0AtN2HcZBPqwdFSR
	N53IQttjRtl6ZG50f040PXgYNLw2sECcFYp/ZlI4xrU96OxkmsFcUQf3Yp/ridO0/GUi4gFb0fO
	PzpgdcEKeJ/HkAZ8Is=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

It's a helper to set the parent resource for the altmap of a given pgmap

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Baoquan He <bhe@redhat.com>
CC: linux-mm@kvack.org
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 include/linux/memremap.h | 1 +
 mm/memremap.c            | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index ca1f12353008..1e8b25352f7c 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -193,6 +193,7 @@ static inline bool folio_is_device_coherent(const struct folio *folio)
 void zone_device_page_init(struct page *page);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
+void pgmap_parent_resource(struct dev_pagemap *pgmap, struct resource *res);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
diff --git a/mm/memremap.c b/mm/memremap.c
index 78047157b0ee..0bbf163d4817 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -390,6 +390,13 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 }
 EXPORT_SYMBOL_GPL(memremap_pages);
 
+void pgmap_parent_resource(struct dev_pagemap *pgmap, struct resource *res)
+{
+	if (pgmap && res)
+		pgmap->altmap.parent = res;
+}
+EXPORT_SYMBOL_GPL(pgmap_parent_resource);
+
 /**
  * devm_memremap_pages - remap and provide memmap backing for the given resource
  * @dev: hosting device for @res
-- 
2.29.2

