Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6AA33D7
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 18:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669314945; x=1700850945;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X1/XHDLEN2wAEd5II7KklSEkt1ZQ2Q0yc/NqKEg0eyA=;
  b=AH1l3Tk7cICSgSZJlJotX/K9ydMO7iITHqE4vDDE+9gxh27fUZ+7xzEm
   K9KoSxK4foEqRuwze7RrtymKXzHEiwDODa6j+V4Hhfv6SZL/B8vWOateO
   IlmPi1E2KQqHtHRq/4NwFZu1qM8F8pHdeG/6D+Gdliangpq4Xvk6g7hE0
   wTN927ZHlK//aRScgx3TQpMhCBM6b0B+dpCqIPfScgT+yEGfa/djqrhWs
   seGfquXD18y6uc6+RN5aCCif52t3L4ITlCys3BMjfyAbVSdZ+KwLe5dNO
   mKpx80X0OTHhpGauN/+OAmsAzofCHJe5TPAvogPx5UHIDlCNmlSzw9XjX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="341244515"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="341244515"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="636358365"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="636358365"
Received: from aglevin-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.65.252])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:43 -0800
Subject: [PATCH v4 12/12] cxl/acpi: Set ACPI's CXL _OSC to indicate CXL1.1
 support
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, rrichter@amd.com,
 terry.bowman@amd.com, bhelgaas@google.com, dave.jiang@intel.com,
 nvdimm@lists.linux.dev
Date: Thu, 24 Nov 2022 10:35:43 -0800
Message-ID: <166931494367.2104015.9411254827419714457.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
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

ACPI includes a CXL _OSC for the OS to communicate what it knows of CXL
device topologies. To date Linux has added support for CXL 2.0 (VH) port
topologies, hotplug, and error handling. Now that the driver also know
how to enumerate CXL 1.1 (RCH) port topologies, indicate that capability
via CXL _OSC. See CXL3.0 Table 9-26 'Interpretation of CXL _OSC Support
Field'

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[djbw: wordsmith changelog]
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

