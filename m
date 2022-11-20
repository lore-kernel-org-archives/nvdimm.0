Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5E736C
	for <nvdimm@lists.linux.dev>; Sun, 20 Nov 2022 01:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668908271; x=1700444271;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9sVjahp8+Ff3XIBZSoFFjnud1C6/9g5OJkYPdCd/D+M=;
  b=DrqFPh/U6rMu4DlIG6Kj65uBHWcLeErUVEYPKx/ccN91hxgvLnnmQN+A
   KnLhZibdWCZAAcTeC3nu/ZlnxlMgg/DFnX7bBmiY58cbYe/EOkKGdC369
   ouY0wjkCVadzFpBC4UjlsigEK5k7ONm0ZoNYac9Dk0IWsH231avC8vF1r
   56DLIDgnNWRBeY1GUmhg0XYS9MfYyalzDuqxYyRkABDAs3HAi/bWbBq6a
   xDnKdaCpXPwU1Cyk6JZDlhrYgCVJpzm6gCRmpbXNTJcxFuSeGHEVHwINs
   D5VOeQ5VyaHiFZKrKV0juqwsl53bIiKvSqT68ce70VGrE3y4A2OJanFjd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10536"; a="293747344"
X-IronPort-AV: E=Sophos;i="5.96,178,1665471600"; 
   d="scan'208";a="293747344"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2022 17:37:50 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10536"; a="815321850"
X-IronPort-AV: E=Sophos;i="5.96,178,1665471600"; 
   d="scan'208";a="815321850"
Received: from thoff-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.16.82])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2022 17:37:49 -0800
Subject: [PATCH] device-dax: Fix duplicate 'hmem' device registration
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Tallam Mahendra Kumar <tallam.mahendra.kumar@intel.com>,
 Mustafa Hajeer <mustafa.hajeer@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
Date: Sat, 19 Nov 2022 17:37:49 -0800
Message-ID: <166890823379.4183293.15333502171004313377.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

So called "soft-reserved" memory is an EFI conventional memory range
with the EFI_MEMORY_SP attribute set. That attribute indicates that the
memory is not part of the platform general purpose memory pool and may
want some consideration from the system administrator about whether to
keep that memory set aside for dedicated access through device-dax (map
a device file), or assigned to the page allocator as another general
purpose memory node target.

Absent an ACPI HMAT table the default device-dax registration creates
coarse grained devices that are delineated by EFI Memory Map entries.
With the HMAT the devices are delineated by the finer grained ranges
associated with the proximity domain of the memory target. I.e. the HMAT
describes the properties of performance differentiated memory and each
unique performance description results in a unique target proximity
domain where each memory proximity domain has an associated SRAT entry
that delineates the address range.

The intent was that SRAT-defined device-dax instances are registered
first. Then any left-over address range with the EFI_MEMORY_SP
attribute, but not covered by the SRAT, would have a coarse grained
device-dax instance established. However, the scheme to detect what
ranges are left to be assigned to a device was buggy and resulted in
multiple overlapping device-dax instances. Fix this by using explicit
tracking for which ranges have been handled.

Now, this new approach may leave memory stranded in the presence of
broken platform firmware that fails to fully describe all EFI_MEMORY_SP
ranges in the HMAT. That requires a deeper fix if it becomes a problem
in practice.

Reported-by: "Tallam Mahendra Kumar" <tallam.mahendra.kumar@intel.com>
Reported-by: Mustafa Hajeer <mustafa.hajeer@intel.com>
Debugged-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
I plan to take this through the nvdimm tree with some other dax / HMAT
related fixups.

 drivers/dax/hmem/device.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
index 97086fab698e..903325aac991 100644
--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -8,6 +8,13 @@
 static bool nohmem;
 module_param_named(disable, nohmem, bool, 0444);
 
+static struct resource hmem_active = {
+	.name = "HMEM devices",
+	.start = 0,
+	.end = -1,
+	.flags = IORESOURCE_MEM,
+};
+
 void hmem_register_device(int target_nid, struct resource *r)
 {
 	/* define a clean / non-busy resource for the platform device */
@@ -41,6 +48,12 @@ void hmem_register_device(int target_nid, struct resource *r)
 		goto out_pdev;
 	}
 
+	if (!__request_region(&hmem_active, res.start, resource_size(&res),
+			      dev_name(&pdev->dev), 0)) {
+		dev_dbg(&pdev->dev, "hmem range %pr already active\n", &res);
+		goto out_active;
+	}
+
 	pdev->dev.numa_node = numa_map_to_online_node(target_nid);
 	info = (struct memregion_info) {
 		.target_node = target_nid,
@@ -66,6 +79,8 @@ void hmem_register_device(int target_nid, struct resource *r)
 	return;
 
 out_resource:
+	__release_region(&hmem_active, res.start, resource_size(&res));
+out_active:
 	platform_device_put(pdev);
 out_pdev:
 	memregion_free(id);
@@ -73,15 +88,6 @@ void hmem_register_device(int target_nid, struct resource *r)
 
 static __init int hmem_register_one(struct resource *res, void *data)
 {
-	/*
-	 * If the resource is not a top-level resource it was already
-	 * assigned to a device by the HMAT parsing.
-	 */
-	if (res->parent != &iomem_resource) {
-		pr_info("HMEM: skip %pr, already claimed\n", res);
-		return 0;
-	}
-
 	hmem_register_device(phys_to_target_node(res->start), res);
 
 	return 0;

