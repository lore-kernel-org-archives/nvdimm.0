Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5113EA69
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 06:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724048485; cv=none; b=kls8FvOlvPQgyC4QPcxcJA3XWbYbKlzJRhhKP58inyr9DUfWoSuBP/dAO6uGZ55ol+7Jydna0s/0VoZbfORLr8R8yCaVwfFnUT+qpHB+A83dbPWu5mtpbga1jHAdxjBMsS+P3n5oZJWk237Y3P11NzSV2rUsWJvbF+5VWIdExrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724048485; c=relaxed/simple;
	bh=X7FvRYmMdy2hvQtnz39Ci2y1Pgv9FnRQ4AcLrxfbW9c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qiUeOhYqKJkz6P/d1pujxdmJYyVTtoeuEJFvoSzJ38i/oqZjNZEi+a7rIcbN7T7ocL6kT/2Bt6OSGzSNW81Ci0WHG9frz/nV3wECyYlTx39aszqEzQ0nVcA3Qz/v1ZATjSnnUHiERIRmS5jR4++M0itvzb/cLbztxcdqYDzgBE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=rQg0tTJ2; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="rQg0tTJ2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1724048483; x=1755584483;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X7FvRYmMdy2hvQtnz39Ci2y1Pgv9FnRQ4AcLrxfbW9c=;
  b=rQg0tTJ2WcBYuJvpNxGtqwK+OOFRxZesnVOVuw/jd/W13sHca/XKg/L4
   Wmf1pY5BsjelzltpZP5+C/A+CGQJsxLt1Q8R/Yh8Nuvprui0h2fqwvEGe
   WdegYSobBK5uVEQEl+sqkCzM6kO85rhNWZ7xyQo8fiTGoPsFFkUSzgtFK
   CyLUdeEOjH7CxaNhnRMK+DnRYfk3lHpstboHEolcSVBaN4agfaYEtxUMW
   JrMXQdVfq31iamFK4LYdhKtMWxsN6xq/gKI8+nZaDVjcxBBOMm8AG8OID
   rqj3RdzD8O71aylRRxiknLomptPGqfGi7Sr+ib3wGPKiZ0Iq3AmN3b3ya
   g==;
X-CSE-ConnectionGUID: j0MH3Pe6SbOfBq/YKvYZDg==
X-CSE-MsgGUID: gXlDWy5NTI6tm6tslJeu2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="170936663"
X-IronPort-AV: E=Sophos;i="6.10,158,1719846000"; 
   d="scan'208";a="170936663"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 15:21:13 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id CCE74C916D
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 15:21:11 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1AE08D509D
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 15:21:11 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 9790BE2A0E
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 15:21:10 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id D3EC61A000A;
	Mon, 19 Aug 2024 14:21:09 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	linux-kernel@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v3 1/2] nvdimm: Fix devs leaks in scan_labels()
Date: Mon, 19 Aug 2024 14:20:44 +0800
Message-Id: <20240819062045.1481298-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28604.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28604.005
X-TMASE-Result: 10--10.179400-10.000000
X-TMASE-MatchedRID: iX86n7+2xrs8g1fEYZ38283WPbtc5QfmmZiw53dqSN/447xhO06ewm+Q
	IyvBw2JavJSHCxH3pnR8EcmqNfqha2JZXQNDzktSdXu122+iJtoqR3z0aoe9SdMvYZEcBz1xf6O
	+FEJQpgBPvZfZHGeBcqojMMzk9xqo+BMgIVTipNspDEdiwJzEacoioCrSMgeKMoh6scCF9jHIvl
	CZY6Ax8LcTsm3NvDOfa1v7YIwuPgEv+0FNnM7lDUrOO5m0+0gENUSduuqYHDtZBaLS1HS7KtHPG
	jQ0RxWp4vM1YF6AJbbGXyXDzkRpVAtuKBGekqUpI/NGWt0UYPABFXNgM8vZz2VzKWDgeYtNhaIJ
	ZNleXUNs1HfRODIi8GmlO+ipwTmd
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

scan_labels() leaks memory when label scanning fails and it falls back
to just creating a default "seed" namespace for userspace to configure.
Root can force the kernel to leak memory.

Allocate the minimum resources unconditionally and release them when
unneeded to avoid the memory leak.

A kmemleak reports:
unreferenced object 0xffff88800dda1980 (size 16):
  comm "kworker/u10:5", pid 69, jiffies 4294671781
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    [<00000000c5dea560>] __kmalloc+0x32c/0x470
    [<000000009ed43c83>] nd_region_register_namespaces+0x6fb/0x1120 [libnvdimm]
    [<000000000e07a65c>] nd_region_probe+0xfe/0x210 [libnvdimm]
    [<000000007b79ce5f>] nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
    [<00000000a5f3da2e>] really_probe+0xc6/0x390
    [<00000000129e2a69>] __driver_probe_device+0x78/0x150
    [<000000002dfed28b>] driver_probe_device+0x1e/0x90
    [<00000000e7048de2>] __device_attach_driver+0x85/0x110
    [<0000000032dca295>] bus_for_each_drv+0x85/0xe0
    [<00000000391c5a7d>] __device_attach+0xbe/0x1e0
    [<0000000026dabec0>] bus_probe_device+0x94/0xb0
    [<00000000c590d936>] device_add+0x656/0x870
    [<000000003d69bfaa>] nd_async_device_register+0xe/0x50 [libnvdimm]
    [<000000003f4c52a4>] async_run_entry_fn+0x2e/0x110
    [<00000000e201f4b0>] process_one_work+0x1ee/0x600
    [<000000006d90d5a9>] worker_thread+0x183/0x350

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Fixes: 1b40e09a1232 ("libnvdimm: blk labels and namespace instantiation")
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
V3:
  update commit log and allocate the minimum(2 *dev) unconditionally. # Dan

V2:
  update description and comment
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 drivers/nvdimm/namespace_devs.c | 34 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index d6d558f94d6b..35d9f3cc2efa 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1937,12 +1937,16 @@ static int cmp_dpa(const void *a, const void *b)
 static struct device **scan_labels(struct nd_region *nd_region)
 {
 	int i, count = 0;
-	struct device *dev, **devs = NULL;
+	struct device *dev, **devs;
 	struct nd_label_ent *label_ent, *e;
 	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	resource_size_t map_end = nd_mapping->start + nd_mapping->size - 1;
 
+	devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
+	if (!devs)
+		return NULL;
+
 	/* "safe" because create_namespace_pmem() might list_move() label_ent */
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
 		struct nd_namespace_label *nd_label = label_ent->label;
@@ -1961,12 +1965,14 @@ static struct device **scan_labels(struct nd_region *nd_region)
 			goto err;
 		if (i < count)
 			continue;
-		__devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
-		if (!__devs)
-			goto err;
-		memcpy(__devs, devs, sizeof(dev) * count);
-		kfree(devs);
-		devs = __devs;
+		if (count) {
+			__devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
+			if (!__devs)
+				goto err;
+			memcpy(__devs, devs, sizeof(dev) * count);
+			kfree(devs);
+			devs = __devs;
+		}
 
 		dev = create_namespace_pmem(nd_region, nd_mapping, nd_label);
 		if (IS_ERR(dev)) {
@@ -1993,11 +1999,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 		/* Publish a zero-sized namespace for userspace to configure. */
 		nd_mapping_free_labels(nd_mapping);
-
-		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
-		if (!devs)
-			goto err;
-
 		nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
 		if (!nspm)
 			goto err;
@@ -2036,11 +2037,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	return devs;
 
  err:
-	if (devs) {
-		for (i = 0; devs[i]; i++)
-			namespace_pmem_release(devs[i]);
-		kfree(devs);
-	}
+	for (i = 0; devs[i]; i++)
+		namespace_pmem_release(devs[i]);
+	kfree(devs);
+
 	return NULL;
 }
 
-- 
2.29.2

