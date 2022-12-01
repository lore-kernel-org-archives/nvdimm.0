Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFAD10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930468; x=1701466468;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wKoCyssDtcqwavOv2zukFAnzixjk9MWwpqKiuN8b4Ug=;
  b=f2e6+ZWPDPvmy64YHR6EH7GvRwevedbJtWORcYXn8RjGlFItWuuf5ylh
   2EtyPj58LP1FeY0YOOqQ9bTBALjIGwj2PkHoUiPH8LDEk9LVCqw44NGT8
   hVJPizCIVp2KtEIfVJoztDTKC5YEWtQaLrhwF/3oynmyd5lDEXnJaq0da
   R3/RWMPuULdP0/YvIxQgDWylmyqgOjJfvZS/JdhmA9H2aFJHL4qJa6QQQ
   5BTmGlqHBT4fhlzeW8i8msm6T1DOg4oSjyj0fWfTDhPwyAzdMWqaOBFVC
   HLuoUq9LjUpq7bcJktU/LtkcCZWVjjAUv52xKB2UG9jytTrKfS1xBhE3L
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="313443363"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="313443363"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:34:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675594875"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="675594875"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:34:27 -0800
Subject: [PATCH v6 12/12] cxl/acpi: Set ACPI's CXL _OSC to indicate RCD mode
 support
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 alison.schofield@intel.com, rrichter@amd.com, terry.bowman@amd.com,
 bhelgaas@google.com, dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:34:27 -0800
Message-ID: <166993046717.1882361.10587956243041624761.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Terry Bowman <terry.bowman@amd.com>

ACPI uses the CXL _OSC support method to communicate the available CXL
functionality to FW. The CXL _OSC support method includes a field to
indicate the OS is capable of RCD mode. FW can potentially change it's
operation depending on the _OSC support method reported by the OS.

The ACPI driver currently only sets the ACPI _OSC support method to
indicate CXL VH mode. Change the capability reported to also include
CXL RCD mode.

[1] CXL3.0 Table 9-26 'Interpretation of CXL _OSC Support Field'

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
[rrichter@amd.com: Reworded patch description.]
Signed-off-by: Robert Richter <rrichter@amd.com>
Link: http://lore.kernel.org/r/Y4cRV/Sj0epVW7bE@rric.localdomain
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/pci_root.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 4e3db20e9cbb..b3c202d2a433 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -493,6 +493,7 @@ static u32 calculate_cxl_support(void)
 	u32 support;
 
 	support = OSC_CXL_2_0_PORT_DEV_REG_ACCESS_SUPPORT;
+	support |= OSC_CXL_1_1_PORT_REG_ACCESS_SUPPORT;
 	if (pci_aer_available())
 		support |= OSC_CXL_PROTOCOL_ERR_REPORTING_SUPPORT;
 	if (IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))

