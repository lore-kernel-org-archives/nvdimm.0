Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6AB12D7DD4
	for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 02:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791943491; cv=none; b=jSrYI43ZB1WXcHw5cqHJpO4jvnwl3WtH7zbM2VCNVRCW6+Wgm7VUz/fjT2UPRrJgAuWPJAJCn81gWb8NIKcv5Ru4j3Il5U5Xc3xYd6vakZVnjBe7hGBQ/8YKSuDeKVoOvv545E1d3Mx2xdnhsgVE4eSz7Ey8RKBVD5zTeo2aPoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791943491; c=relaxed/simple;
	bh=sn6HwpxnbG9Lp5ytnNeizauo3pC/1sm15AlIxGPdkEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=orcA9CnU4S4iolR6Zt0tiKoBG4d/VSpsHS8KrULsWWiVL1zJu7p66gJIbshXWK5Q3uusjtaQ2ZcDfQyzwSjDxz0LB0vYU1Vkmr/r6PDq+heBKsk1b6CfgNLY0yd1F6HOsutK6PTK1pF5atICuY15k2s4+EgkcZbLNpwuamnekrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Gf72OYwY; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Gf72OYwY"
Received: from thinkpad-p16sg1.. (unknown [154.20.139.108])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0CE6220B7168;
	Tue, 13 Oct 2026 19:04:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0CE6220B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791943485;
	bh=FGJmm0D8CfbG8q4cdnHz8yqPp2hg+xNZFZP2H/avS60=;
	h=From:To:Cc:Subject:Date:From;
	b=Gf72OYwYtuYmR+dm6ABzh/0u+jthVEmW2lkxFeU1iz//F2zu8bWCwnq+sN//PqLFd
	 Yd1rtZ8kni+jnvZW3J1aO6xe3vA7Svirr2qmCLDNAS2/q8HEQYL9Qv8GcTXNzt3bgX
	 etJ3xkRwGWX4/dNPeofCJ2GGTsXPc8gzMKm5cnVM=
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	iweiny@kernel.org,
	tgopinath@linux.microsoft.com,
	bboscaccy@linux.microsoft.com,
	srivatsa@csail.mit.edu
Subject: [RFC PATCH] drivers: nvdimm: validate dataoffset
Date: Tue, 13 Oct 2026 19:04:30 -0700
Message-ID: <20261014020430.295282-1-shyamsaini@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On some platforms cold reboot may not zero out DRAM and
as a consequence, the next kernel boot with a new pmem layout
change may end up using stale superblocks. This can cause
altmap to run out of memory and consequently the pmem drivers
may fail to probe.

    failed to free all reserved pages
   [trimmed]
    Call trace:
     memunmap_pages+0x2f8/0x358
     memremap_pages+0x590/0x728
     devm_memremap_pages+0x30/0x88
     pmem_attach_disk+0x178/0x488
     nd_pmem_probe+0x60/0xe0
     nvdimm_bus_probe+0xec/0x208
     really_probe+0xc0/0x2e8
     __driver_probe_device+0xc4/0x168
     driver_probe_device+0x48/0x218
     __device_attach_driver+0x130/0x160
     bus_for_each_drv+0x94/0xf0
     __device_attach+0xfc/0x1a0
     device_initial_probe+0x18/0x28
     bus_probe_device+0x40/0xa0
     device_add+0x270/0x498
     nd_async_device_register+0x20/0x70
     async_run_entry_fn+0x30/0x158
     process_scheduled_works+0x248/0x4b0
     worker_thread+0x284/0x3a0
     kthread+0xe0/0x180
     ret_from_fork+0x10/0x20
    ---[ end trace 0000000000000000 ]---
    nd_pmem: probe of pfnX.1 failed with error -12

Fix this by discarding superblock if there is a mismatch b/w
dataoffset value from the preserved superblock and the
dataoffset from the resource.

While this fix is not robust but it can be combined with userspace
namespace destruction and recreation to remove all the stale pmems
metadata and reconfigure the fresh data using ndctl

Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
---
 drivers/nvdimm/pfn_devs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 8fa9c16aba7ea..667115ce88e40 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -439,12 +439,12 @@ static bool nd_supported_alignment(unsigned long align)
  */
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
-	u64 checksum, offset;
+	u64 checksum, offset, offset_res;
 	struct resource *res;
 	enum nd_pfn_mode mode;
-	resource_size_t res_size;
+	resource_size_t res_start, res_size;
 	struct nd_namespace_io *nsio;
-	unsigned long align, start_pad, end_trunc;
+	unsigned long align, start_pad, end_trunc, npfns;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	const uuid_t *parent_uuid = nd_dev_to_uuid(&ndns->dev);
@@ -577,6 +577,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	nsio = to_nd_namespace_io(&ndns->dev);
 	res = &nsio->res;
 	res_size = resource_size(res);
+	res_start = res->start;
+	npfns = PHYS_PFN(res_size - SZ_8K);
+	offset_res = ALIGN(res_start + SZ_8K + (MAX_STRUCT_PAGE_SIZE * npfns), align) - res_start;
+	if ((mode == PFN_MODE_PMEM) && offset_res != offset)
+		return -ENODEV;
+
 	if (offset >= res_size) {
 		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
 				dev_name(&ndns->dev));
-- 
2.43.0

