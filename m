Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EEF5CB8
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 02:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721354405; cv=none; b=tzv/x8rr5Iah2Lj7WunmI0wiad5ZMUWYGZvO0fKpBRkaSJ0BHb+ouObnIlXx50cyxRsWAX/3pWwMXrr66JjHVenq/h/uQqxBUwS8rMysqGzWyUlmOGCVbcjAtLKR+2XG8Q+HhwaeQFikcVBcHx1+0Fe9Foq/d8FGxFM+M3Iq+0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721354405; c=relaxed/simple;
	bh=58Y3vyvD7o/Gyv/i7iX8ymNRhJNiJ1tiQspFJs27nQU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nQ3pe+RE50VTp/Qj0l7zuncetgtrlTFYPWmpqpEWtYYQPgvD/SvMC3sKlDgI3+4MRFUKjW9ZooQA1VgMRxzfzpCB4NQ58lihpCuF8iB/A0aQs4iP3unBp9Y+cUt29vydwm7QS5Hs1FuYxmspjd+JJ4mdVebREy55u5s0mJ+Y6wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Pf3dVt1J; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Pf3dVt1J"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1721354403; x=1752890403;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=58Y3vyvD7o/Gyv/i7iX8ymNRhJNiJ1tiQspFJs27nQU=;
  b=Pf3dVt1J9uyWNb9gNPJnOe8pjJYlcL7UIz2OWRTnNUL5EPLyCIVY7M0T
   5nTLZNyJHlqMxdxD+MTJcVbaaG0HUsAz5wNcYGyz+kNzFXB3SBthjT7X6
   Zn0lj7X4QoLN2th+gV7DZyBEOm2Al2yKZmj9cn/CFm1U2JoxN55kWiG10
   8Qxb3i0UPPd/95/RrFuBNH+7z2i+eBWkL4989lRR7hJIfiFHfOoVpTp6U
   KwDxZjNGb/7WNEmOKbUZ7kw1ajTjal+pgUkASNbqEez9d+8SKzaBnaMwZ
   imeJy+2sorE8krijXARqJAhd1FrVZokUOs2SBt7vfjAuk9KJMHoXVpq7K
   w==;
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="146844932"
X-IronPort-AV: E=Sophos;i="6.09,219,1716217200"; 
   d="scan'208";a="146844932"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 10:58:51 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com [192.168.83.66])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id EE141DB3C7
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 10:58:48 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 4145BD981E
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 10:58:48 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id B91FF220E7B
	for <nvdimm@lists.linux.dev>; Fri, 19 Jul 2024 10:58:47 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id DD1AD1A0002;
	Fri, 19 Jul 2024 09:58:46 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	linux-kernel@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Date: Fri, 19 Jul 2024 09:58:35 +0800
Message-Id: <20240719015836.1060677-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28538.002
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28538.002
X-TMASE-Result: 10--5.722900-10.000000
X-TMASE-MatchedRID: z2BzWfwZiWtXk4HjwySOx7Px3rO+jk2QjlRp8uau9oaOD/YpR7I+IiG+
	TaaivvuawkL7nAwIDMBi3n4ncgiU3iFhER5AQz1JEzEoOqAAVLNBHuVYxc8DW7cvZo9bqxPSqTs
	2lKky4qsE3IKYiiiTR+yhJ9iC97W/RFXsL2iM5nXN+qWlu2ZxaBNnKUypNkHDmbc4hVJ/g/lJm/
	74z/sK4ZQvyqZH9InnWsM13eQX96sB90FcL1q4MBF4zyLyne+AL+b2NWLzKm5jtMlSv+S5nMqbf
	FkwjxPow80nXtCNZGCAMuqetGVetksDkkP3zIjq3QfwsVk0UbtuRXh7bFKB7pZtaXUfXhkJbhOd
	qiAhfk3csDUYrdw0Z1xj6GM6eW4tNkUSDDq742k=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

The leakage would happend when create_namespace_pmem() meets an invalid
label which gets failure in validating isetcookie.

Try to resuse the devs that may have already been allocated with size
(2 * sizeof(dev)) previously.

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
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---

Cc: Ira Weiny <ira.weiny@intel.com>
> From what I can tell create_namespace_pmem() must be returning EAGAIN
> which leaves devs allocated but fails to increment count.  Thus there are
> no valid labels but devs was not free'ed.

> Can you trace the error you are seeing a bit more to see if this is the
> case?
  Hi Ira, Sorry for the late reply. I have reproduced it these days.
  Yeah, the LSA is containing a label in which the isetcookie is invalid.

V2:
  update description and comment
---
 drivers/nvdimm/namespace_devs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index d6d558f94d6b..28c9afc01dca 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1994,7 +1994,13 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		/* Publish a zero-sized namespace for userspace to configure. */
 		nd_mapping_free_labels(nd_mapping);
 
-		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
+		/*
+		 * Try to use the devs that may have already been allocated
+		 * above first. This would happend when create_namespace_pmem()
+		 * meets an invalid label.
+		 */
+		if (!devs)
+			devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
 		if (!devs)
 			goto err;
 
-- 
2.29.2

