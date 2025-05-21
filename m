Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2D0171D2
	for <nvdimm@lists.linux.dev>; Wed, 21 May 2025 00:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747787232; cv=none; b=dLkiwJCaHnv/zsUIsioUsC3unL/EcmgECG21/NiAlvVbigt/R5ThIDK/f1DPHY31DcrTdJYG+uIa2BTYI3G0P/weCXNvbTCq657zl2mmQnXIae7+2rb6KnqbxN3iusaXeUB2J9V9b1B4s9tDALOhXym6u18b5MLC7Eo8xAJaNSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747787232; c=relaxed/simple;
	bh=Ktv9DK5iRo3vUhSGhSEgO2PdNalAk3bDCT9ExI6NPRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJVq+FgA7YTITQXnXt9qj6Cq+RwIzjpOH7KyMSuXmCBILKDZgZeW0TovfSVp/R4cnh22arYGjRzD6698/5UXgpD0bZzjFwsoiPBola/T0xMzZEo+eVxanVbETajnKDY7JggWnTMlyf6mawbsn01rPoznKlVWw37DcbxOG4AzmA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jmPKyn43; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jmPKyn43"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747787232; x=1779323232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ktv9DK5iRo3vUhSGhSEgO2PdNalAk3bDCT9ExI6NPRY=;
  b=jmPKyn43foL6gHRWdx5pI6BwfeCBzHaVHDjHerGEpPB/UFQd5BDobbTq
   bk3ODUhiYbTa6hfImtus34AJ6cx7ZSmpVM1oMDGe9YNc7TjmImL7VLFaC
   3vVCEH+SmXzESoBAIgMA58sEKzc+dinzgB/t7wfJIzN0kpJpDszwIJKsU
   W7sseBdLx02xBvAoGiNMh8WUQgMxNKZ5aHCMz8evWw9fjzrBx00Mgqw5C
   IBG7pTtKAi/Otm7NSZJN62DRpl+SjSZ3ax6gn2gjmkz8u2Iski8fLb2fn
   GmNUVlxl+Q5U6v7fA2ZEbmI8K2MrREh9S3uE9w+g7Ere9xFcy93KsMsln
   A==;
X-CSE-ConnectionGUID: oa8EyHymTiGfISXDZjrBDw==
X-CSE-MsgGUID: EkuHTLCdS4S2AHqJ1OxG1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="49645895"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="49645895"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 17:27:11 -0700
X-CSE-ConnectionGUID: lSd65/H1Q4mQtwpPbslOgQ==
X-CSE-MsgGUID: EN1rq+cwQI2bQX+IXYji5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="144735092"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 17:27:10 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	alison.schofield@intel.com,
	dan.j.williams@intel.com
Cc: Marc Herbert <marc.herbert@linux.intel.com>
Subject: [ndctl PATCH 2/2] README.md: add CONFIG_s missing to pass CXL tests
Date: Wed, 21 May 2025 00:26:40 +0000
Message-ID: <20250521002640.1700283-2-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521002640.1700283-1-marc.herbert@linux.intel.com>
References: <20250521002640.1700283-1-marc.herbert@linux.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Herbert <marc.herbert@linux.intel.com>

Found by trial and error. As of kernel v6.15, the CONFIG_s in this
version are enough to give to ./scripts/kconfig/merge_config.sh and pass
`meson test --suite=cxl`.

This fragment is being regularly tested in
https://github.com/pmem/run_qemu/actions with `make defconfig
ARCH=x86_64` as a starting point. This is admittedly incomplete test
coverage but still a massively better starting point for other ARCHs and
a time-saver. There's a good chance it's enough for other ARCHs too.

Link: https://lore.kernel.org/nvdimm/aed71134-1029-4b88-ab20-8dfa527a7438@linux.intel.com/
Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 README.md | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/README.md b/README.md
index a37991ccefa2..c4c499f803af 100644
--- a/README.md
+++ b/README.md
@@ -103,17 +103,26 @@ loaded.  To build and install nfit_test.ko:
    Obtain the CXL kernel source(optional).  For example,
    `git clone -b pending git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git`
 
-   Enable CXL-related kernel configuration options.
+   Enable configuration options required by CXL tests:
    ```
    CONFIG_CXL_BUS=m
    CONFIG_CXL_PCI=m
    CONFIG_CXL_ACPI=m
+   CONFIG_LIBNVDIMM=m
    CONFIG_CXL_PMEM=m
    CONFIG_CXL_MEM=m
    CONFIG_CXL_PORT=m
    CONFIG_CXL_REGION=y
    CONFIG_CXL_REGION_INVALIDATION_TEST=y
+   CONFIG_DAX=m
+   CONFIG_TRANSPARENT_HUGEPAGE=y
+   CONFIG_DEV_DAX=m
    CONFIG_DEV_DAX_CXL=m
+   CONFIG_MEMORY_HOTPLUG=y
+   CONFIG_MEMORY_HOTREMOVE=y
+   CONFIG_NVDIMM_SECURITY_TEST=y
+   CONFIG_ENCRYPTED_KEYS=y
+   CONFIG_NVDIMM_KEYS=y
    ```
 1. Install cxl_test and related mock modules.
    ```
-- 
2.49.0

