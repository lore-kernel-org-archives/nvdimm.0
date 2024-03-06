Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9884960868
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709721028; cv=none; b=tV/RrvQAbc9JjRt0L3QJVcEwNQ80+Dk5xpJRXvOXi9D0+ibooRaxztxfhmwMl6/9VpRq1FmarUWuA0eQ2F4699Mn/c3bWBTEfbeR2j++hFsa9SHXKyFBUqdhGaJfA05eOwbsr8QL7zL4PZ5PBW4aw/CrOXl0ibJl2B4U17Q5tuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709721028; c=relaxed/simple;
	bh=8m938ej88oP8CU4LRmFGqeZ2eI8zznrXHFjHuzUAi80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ix3fwvX+NDY+Z20Nr15lMp/pGNkEAGaK8X58DAgskLykvNTHVCuu0/9sRLG1ghCbnjNnFkCMS/gRWW+DzVbtbCUkACBVCX/YN2wBCRd6kpsmlw7cgMVgeGYBTkBtq0Mgfuk+N9teVJCjKgw/zt2KW4Q1jux1n4JmlkbNhxh9uAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=PwKdS9ab; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="PwKdS9ab"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709721026; x=1741257026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8m938ej88oP8CU4LRmFGqeZ2eI8zznrXHFjHuzUAi80=;
  b=PwKdS9abdjQvI8XscYmBP1eN+2/f0JlKJHSL5t4mWHi4gfr3st5r8op7
   5/LYpMMRN0O6SBrJZqtfSfuj6TjSl1V4MNKGcBQj2VbTipKr6ENnAWk+Q
   2gEMHeLK9OGMRcJFWg9HJGpgjEzNUJaxqFfvy2la5CHmEueRtEGXCa0W7
   SPIDYO43ERXElIEuWIuPgbqhaX06d+Mo6C/L35ADv8+Ydl2VRN00LXE9D
   1vwfjorxo74vnMQCf8214LU5iZVixY4TKOT7GDjH5kh4+zxh09MNYLLyu
   qqEl99OQHiFJIZnXVfiETdKRJ545NTl3woFiWqFRMXqaqZ53GRoeqvHGQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="130699032"
X-IronPort-AV: E=Sophos;i="6.06,208,1705330800"; 
   d="scan'208";a="130699032"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 19:29:13 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 2F63BEB462
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:10 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 56D53D5D17
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:09 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id C654121BD41
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:08 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id D32BA1A006D;
	Wed,  6 Mar 2024 18:29:07 +0800 (CST)
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
Subject: [PATCH v3 3/7] nvdimm: pmem: assign a parent resource for vmemmap region for the fsdax
Date: Wed,  6 Mar 2024 18:28:42 +0800
Message-Id: <20240306102846.1020868-4-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--1.564400-10.000000
X-TMASE-MatchedRID: BlFNdihulaZXk4HjwySOxykMR2LAnMRpFInyGi5rPwK4GyTmeN+AbL8F
	Hrw7frluf146W0iUu2tDc4lSgrowpWptPhjDCRug9k5nZzZVBSBULRRq00o2mZsoi2XrUn/Jn6K
	dMrRsL14qtq5d3cxkNU8XOMKR+RhSziRYTTEaxycNH0kK2Y6lBnFLca4Td9YkovbRRC+8RtSqnf
	dPSmIOZvdj0cn+WGO3HBgXAGNBpen5KWrl6H4maf8jyjqYHnMRFcUQf3Yp/ridO0/GUi4gFb0fO
	PzpgdcEKeJ/HkAZ8Is=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

When the pmem is configured as fsdax, set the vmemmap region as a child
of the namespace region so that it can be registered as a separate
resource later.

CC: Dan Williams <dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>
CC: Ira Weiny <ira.weiny@intel.com>
CC: Baoquan He <bhe@redhat.com>
CC: nvdimm@lists.linux.dev
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 drivers/nvdimm/pmem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4e8fdcb3f1c8..b2640a3fb693 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -452,7 +452,7 @@ static int pmem_attach_disk(struct device *dev,
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	int nid = dev_to_node(dev), fua;
-	struct resource *res = &nsio->res;
+	struct resource *res = &nsio->res, *parent;
 	struct range bb_range;
 	struct nd_pfn *nd_pfn = NULL;
 	struct dax_device *dax_dev;
@@ -491,12 +491,15 @@ static int pmem_attach_disk(struct device *dev,
 		fua = 0;
 	}
 
-	if (!devm_request_mem_region(dev, res->start, resource_size(res),
-				dev_name(&ndns->dev))) {
+	parent = devm_request_mem_region(dev, res->start, resource_size(res),
+				dev_name(&ndns->dev));
+	if (!res) {
 		dev_warn(dev, "could not reserve region %pR\n", res);
 		return -EBUSY;
 	}
 
+	pgmap_parent_resource(&pmem->pgmap, parent);
+
 	disk = blk_alloc_disk(nid);
 	if (!disk)
 		return -ENOMEM;
-- 
2.29.2

