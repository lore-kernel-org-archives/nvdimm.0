Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7ED4687
	for <nvdimm@lists.linux.dev>; Fri, 23 Sep 2022 22:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663970758; x=1695506758;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5RPs/JpeWjIw9SBDcGjffvbJdKw3Fxq8yxwf7Ewx05M=;
  b=PE4Z/S1yFSDSlb/+29SxPBj6UMBJ2Ou/JnyQ+qSJiAU4q4GRU3ln9ZBU
   SwYUl2MorIftTDQm9Eeg7yJ3pm6zsHtSO7OCXGXfBSvXWCZdoTn2fflf/
   CdXoj5IAW+nGzAEBaknBRpXgNeaTGOOnYHgxQvR24GLKGlOWEnvPJyrtL
   9sgKnRG264QxFW1N93fZPc+Wl+H9G1e0gbRWEjWQpLyuWK/UHNGoMMu95
   MO25XIqDukAvl/bd1JWo/lpBHc8axtI5Ow4z+WsKdW9gX651EiF9Dw6Il
   WRWbitvlrbEpo/AZVby+YLiIoGtpY4JTgrOe2tloTfQHJngng16vHIvEK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="298305641"
X-IronPort-AV: E=Sophos;i="5.93,340,1654585200"; 
   d="scan'208";a="298305641"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 15:05:57 -0700
X-IronPort-AV: E=Sophos;i="5.93,340,1654585200"; 
   d="scan'208";a="795663612"
Received: from tsellis-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.14.35])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 15:05:57 -0700
Subject: [PATCH] devdax: Fix soft-reservation memory description
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>,
 Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>,
 stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
 Omar Avelar <omar.avelar@intel.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Mark Gross <markgross@kernel.org>, linux-mm@kvack.org
Date: Fri, 23 Sep 2022 15:05:56 -0700
Message-ID: <166397075670.389916.7435722208896316387.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The "hmem" platform-devices that are created to represent the
platform-advertised "Soft Reserved" memory ranges end up inserting a
resource that causes the iomem_resource tree to look like this:

340000000-43fffffff : hmem.0
  340000000-43fffffff : Soft Reserved
    340000000-43fffffff : dax0.0

This is because insert_resource() reparents ranges when they completely
intersect an existing range.

This matters because code that uses region_intersects() to scan for a
given IORES_DESC will only check that top-level 'hmem.0' resource and
not the 'Soft Reserved' descendant.

So, to support EINJ (via einj_error_inject()) to inject errors into
memory hosted by a dax-device, be sure to describe the memory as
IORES_DESC_SOFT_RESERVED. This is a follow-on to:

commit b13a3e5fd40b ("ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP")

...that fixed EINJ support for "Soft Reserved" ranges in the first
instance.

Fixes: 262b45ae3ab4 ("x86/efi: EFI soft reservation to E820 enumeration")
Reported-by: Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>
Tested-by: Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>
Cc: <stable@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Omar Avelar <omar.avelar@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Mark Gross <markgross@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/hmem/device.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
index cb6401c9e9a4..acf31cc1dbcc 100644
--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -15,6 +15,7 @@ void hmem_register_device(int target_nid, struct resource *r)
 		.start = r->start,
 		.end = r->end,
 		.flags = IORESOURCE_MEM,
+		.desc = IORES_DESC_SOFT_RESERVED,
 	};
 	struct platform_device *pdev;
 	struct memregion_info info;

