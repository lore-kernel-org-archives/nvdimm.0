Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13463605AD
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709721031; cv=none; b=Qcwq0CQikeAoV+6GsrRwFoZylmP8W5vMCgK2WokdJ5GmaM0Dyjgj2WdVx4JD+ff6OmGWun1NFg4ThUbjFzXSb+/PTY7yBb0QbOB1zLnDuEa98eJ79MPwhTbIr4O0oQ4iBlY00yvynXYMvUXoBR931zAuu+lkWXU9pUnRNXsOvmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709721031; c=relaxed/simple;
	bh=ZZY/OmJnWGlv4sXJ9ctR7zLIBkL6jlFxWOynKDfrnCI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mX+XOAGIodPI+9jpucExv5/rY4FxeIP2ls9+FqoJKL1RA5x8QfNuULgXF84lgbqwQl+yi626xD5D3T6o3L+2x+//GnoSrWCKwG/camLaUqqWjJ9mIImuq6i1NvigR6G0jaPVnbamwE8p91Ajn10iLd0+Rk1rVVj3jzbBCwGXEhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=USDkrBey; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="USDkrBey"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709721029; x=1741257029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZZY/OmJnWGlv4sXJ9ctR7zLIBkL6jlFxWOynKDfrnCI=;
  b=USDkrBeyM/u5t5bpnLjTvq/B8dvTz8DIuNhGwCefFlHi3CzUoGHC3MMw
   Rdzzqtj58pk1nwAVpZoDl9iR6+PurNz83xJV+c2i8QDAEH6l4r/gzNWmL
   z7h4GA5AfNrF5GWokIfFgY+Q2xzpucMvIu7Y+N0nCk9dJHmwC7zo9aZCe
   QnaU8VTBdBk1qMMB4Ypkq8gLEOGYa/w1+Ik4Ya/tiDAEoBW4j81a9neJs
   4MRuLpso6b99sgWw3NC3OosSZm44LYH3rhBt5g002x3hMR7he+bcnVK3/
   TFXX/SXUK+njrN+d/3M7cGgNLfeE8Jy3qPLYijxsm1bhZFiBSVNFz6kPH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="130699034"
X-IronPort-AV: E=Sophos;i="6.06,208,1705330800"; 
   d="scan'208";a="130699034"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 19:29:15 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id DF4E25EA65
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:10 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 277E6D21CB
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:10 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 938BE6BED0
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:09 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id A5E001A006A;
	Wed,  6 Mar 2024 18:29:08 +0800 (CST)
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
Subject: [PATCH v3 4/7] dax: pmem: assign a parent resource for vmemmap region for the devdax
Date: Wed,  6 Mar 2024 18:28:43 +0800
Message-Id: <20240306102846.1020868-5-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--5.083400-10.000000
X-TMASE-MatchedRID: Q3OJUoK6MKVXk4HjwySOxykMR2LAnMRpFInyGi5rPwK4GyTmeN+AbD13
	GoPFA1HFIvrftAIhWmLy9zcRSkKatS9AD6DbcToHEVuC0eNRYvKZIt4iAQN6P6oDeu6wu7bqj26
	lKB/EzKHoHOpl9ZcDR4Ay6p60ZV62fJ5/bZ6npdg7AFczfjr/7Cf8pL7Z+mamZiZ008tHBX0M7U
	m3uTFNcAFzvFI3lI92rZlDJo+ExYU=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

When the pmem is configured as devdax, set the vmemmap region as a child
of the namespace region so that it can be registered as a separate
resource later.

CC: Dan Williams <dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>
CC: Baoquan He <bhe@redhat.com>
CC: nvdimm@lists.linux.dev
CC: linux-cxl@vger.kernel.org
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 drivers/dax/pmem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index f3c6c67b8412..6ffeb81e6c7c 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -21,6 +21,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 	struct nd_dax *nd_dax = to_nd_dax(dev);
 	struct nd_pfn *nd_pfn = &nd_dax->nd_pfn;
 	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct resource *parent;
 
 	ndns = nvdimm_namespace_common_probe(dev);
 	if (IS_ERR(ndns))
@@ -39,8 +40,9 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 	pfn_sb = nd_pfn->pfn_sb;
 	offset = le64_to_cpu(pfn_sb->dataoff);
 	nsio = to_nd_namespace_io(&ndns->dev);
-	if (!devm_request_mem_region(dev, nsio->res.start, offset,
-				dev_name(&ndns->dev))) {
+	parent = devm_request_mem_region(dev, nsio->res.start, offset,
+				dev_name(&ndns->dev));
+	if (!parent) {
 		dev_warn(dev, "could not reserve metadata\n");
 		return ERR_PTR(-EBUSY);
 	}
@@ -66,6 +68,8 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 		.memmap_on_memory = false,
 	};
 
+	pgmap_parent_resource(&pgmap, parent);
+
 	return devm_create_dev_dax(&data);
 }
 
-- 
2.29.2

