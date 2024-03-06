Received: from esa11.hc1455-7.c3s2.iphmx.com (esa11.hc1455-7.c3s2.iphmx.com [207.54.90.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2520D604AF
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 10:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709720965; cv=none; b=g4NnvzNLAzQHVqOi5G7swE2ceEk9TPHi1rTMjyL9sU8icvl7SkiW/b3EvyJilsjU7TqZcPtjHgt/KxIhqwECij1nGmLwiz+RHc8D+KDSwggsczKTuAxRbpmhQloNGkXy/Q2fP/6FSelFo+8rCZmYSz8MVxh3KCnZrGvb7lVzr68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709720965; c=relaxed/simple;
	bh=ZoN1+liG2Aek8I+8vh1JTxN3rQPUF7ESoET6QRxJG2I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ivAoT7HL4vfOzGeYuAIDQ7IKghO/WxWwHFwSrstd+1GIOdU2GVfEvwj680WrnZPN73mMT0fg3aDpDZgttZuKIXOxMdj3J/a+s5+xlhUUdVaz2nJmDAu0oKU5f5rcBypFGvBQBQVsrM0fS578RjYzDmGwLddFUzwddo33ikijhN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=JvML1jsU; arc=none smtp.client-ip=207.54.90.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="JvML1jsU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709720964; x=1741256964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZoN1+liG2Aek8I+8vh1JTxN3rQPUF7ESoET6QRxJG2I=;
  b=JvML1jsU/9R/DklI4dtt0iUQiMbXrBuK1nOHvch6cM7Oj057eFgLgz0t
   s0t6SZR9AhLAyLfo5iIJDfn+NN4FbReFkk6bc5KgMe1HzNuO6j6Tbm6oD
   i/DN9njyvNJvk0VrEgUW/hO7kBvZP++F3QMwlNXOhD1h01788CibxZHUc
   holAxt6vwGuGgUQ/Jca84kJY94qjTxQudNp1iOAK913fn53Iv5U/+xFuK
   nIhiRy/LMVEUtIL8EEm4dMzf8ME1BzoUfp9neVzfrnGutNjGeR+8CrKhg
   wRAumm2N7bKj+mIx+APN546rvkCsPUMfvDkUwA3emC6ShC5GSDYHq5t+C
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="130783553"
X-IronPort-AV: E=Sophos;i="6.06,208,1705330800"; 
   d="scan'208";a="130783553"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa11.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 19:29:13 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 97D40D3EA9
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:08 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id C1761D5603
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:07 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 261E82030C7E2
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:07 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 30EC21A006D;
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
Subject: [PATCH v3 1/7] mm: memremap: register/unregister altmap region to a separate resource
Date: Wed,  6 Mar 2024 18:28:40 +0800
Message-Id: <20240306102846.1020868-2-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--10.470700-10.000000
X-TMASE-MatchedRID: 1qLRYaNAGIjSQ8oIxmHtSPSG/+sPtZVkP9kI+hf1EuqeEPi9wVyFrt3m
	9tpwPB13LMZCJmSjFZdnvY9hxB9vc68zfGxMvR+8KQxHYsCcxGkJlr1xKkE5ucC5DTEMxpeQlAz
	5vo1rYQ0JVj6hwZFNaEK3WEb5CMhwJSdQTuiG7Ijjpxdo/JwVm/NYQxCOihTN6hUULKzHRgQTgt
	4grpaSCoXqHVXA333ceUDb3nIq9HleMBK5dsaSGQKDWtq/hHcNqLpXV8E1T7zozDhGeQC9EvdyG
	0dzM6lz4vM1YF6AJbbCCfuIMF6xLSAHAopEd76vccmxpuUeZs/EDQ/FH4CdWBWn6lb2OMp5WsRb
	K4+hKATe8vYowW/wKQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

The elfcorehdr descirbes the dumpable region in PT_LOADs.

Generally, an iomem resource registered with flags
(IORESOURCE_SYSTEM_RAM | IORESOUCE_BUSY) will be added to PT_LOADs by
kexe_file_load(2). An iomem resource with name prefix "System RAM" will
be added to PT_LOADs in kexec-tools by calling kexe_load(2).

So a simple way to make the altmap dumpable is to register altmap region
as a separate resource with the proper name and resource flags.

Here naming it as "Device Backed Vmemmap" plus resource flags
(IORESOURCE_DEVICE_BACKED_VMEMMAP and IORESOUCE_BUSY) to make it work first.

A /proc/iomem example is as following:
$ sudo cat /proc/iomem
...
fffc0000-ffffffff : Reserved
100000000-13fffffff : Persistent Memory
  100000000-10fffffff : namespace0.0
    100000000-1005fffff : Device Backed Vmemmap  # fsdax
a80000000-b7fffffff : CXL Window 0
  a80000000-affffffff : Persistent Memory
    a80000000-affffffff : region1
      a80000000-a811fffff : namespace1.0
        a80000000-a811fffff : Device Backed Vmemmap # devdax
      a81200000-abfffffff : dax1.0
b80000000-c7fffffff : CXL Window 1
c80000000-147fffffff : PCI Bus 0000:00
  c80000000-c801fffff : PCI Bus 0000:01
...

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Baoquan He <bhe@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: linux-mm@kvack.org
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 include/linux/ioport.h   |  1 +
 include/linux/memremap.h |  3 +++
 mm/memremap.c            | 23 ++++++++++++++++++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index db7fe25f3370..3b59e924f531 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -69,6 +69,7 @@ struct resource {
 #define IORESOURCE_UNSET	0x20000000	/* No address assigned yet */
 #define IORESOURCE_AUTO		0x40000000
 #define IORESOURCE_BUSY		0x80000000	/* Driver has marked this resource busy */
+#define IORESOURCE_DEVICE_BACKED_VMEMMAP 0xa0000000	/* device backed vmemmap resource */
 
 /* I/O resource extended types */
 #define IORESOURCE_SYSTEM_RAM		(IORESOURCE_MEM|IORESOURCE_SYSRAM)
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 744c830f4b13..ca1f12353008 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -17,6 +17,8 @@ struct device;
  * @free: free pages set aside in the mapping for memmap storage
  * @align: pages reserved to meet allocation alignments
  * @alloc: track pages consumed, private to vmemmap_populate()
+ * @parent: the parent resource that altmap region belongs to
+ * @res: altmap region resource
  */
 struct vmem_altmap {
 	unsigned long base_pfn;
@@ -25,6 +27,7 @@ struct vmem_altmap {
 	unsigned long free;
 	unsigned long align;
 	unsigned long alloc;
+	struct resource *parent, *res;
 };
 
 /*
diff --git a/mm/memremap.c b/mm/memremap.c
index 9e9fb1972fff..78047157b0ee 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -157,7 +157,17 @@ EXPORT_SYMBOL_GPL(memunmap_pages);
 
 static void devm_memremap_pages_release(void *data)
 {
-	memunmap_pages(data);
+	struct dev_pagemap *pgmap = data;
+
+	if (pgmap->flags & PGMAP_ALTMAP_VALID && pgmap->altmap.res) {
+		resource_size_t start = pgmap->altmap.res->start;
+		resource_size_t size = pgmap->altmap.res->end -
+				       pgmap->altmap.res->start + 1;
+
+		__release_region(pgmap->altmap.parent, start, size);
+	}
+
+	memunmap_pages(pgmap);
 }
 
 static void dev_pagemap_percpu_release(struct percpu_ref *ref)
@@ -404,11 +414,22 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 {
 	int error;
 	void *ret;
+	struct vmem_altmap *altmap = &pgmap->altmap;
 
 	ret = memremap_pages(pgmap, dev_to_node(dev));
 	if (IS_ERR(ret))
 		return ret;
 
+	if (pgmap->flags & PGMAP_ALTMAP_VALID && altmap->parent) {
+		unsigned long start = altmap->base_pfn << PAGE_SHIFT;
+		unsigned long size = vmem_altmap_offset(altmap) << PAGE_SHIFT;
+		int flags = IORESOURCE_DEVICE_BACKED_VMEMMAP | IORESOURCE_BUSY;
+
+		altmap->res = __request_region(altmap->parent, start, size,
+					      "Device Backed Vmemmap", flags);
+		pr_debug("Insert a separate resource for altmap, %lx-%lx\n",
+			 start, start + size);
+	}
 	error = devm_add_action_or_reset(dev, devm_memremap_pages_release,
 			pgmap);
 	if (error)
-- 
2.29.2

