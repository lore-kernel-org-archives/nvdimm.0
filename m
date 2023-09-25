Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A45E1C295
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695653361; x=1727189361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kKM0C1N1K+zAFPffptjtDRXafSmi9wPq9IOl4rSEZ+w=;
  b=F/ezaepzUt1YjDf8xW+pc8wySNvqQwV/jdDRqTl2U7oFsZzUS9mRC9Fw
   NR4G1wtREVIeM724S7tpun3BDMGje8Dv5TVZL1hVITnvTJ2XV74FpPdZg
   4oU1CpzajRjOmV40IQOAPZqxACctgtfC08v6omEe4PLDKwYyx9/g8uwIN
   zmQVVgpM+QhS7pf0Lbv3PaxhK6BB75+PRt6dL+HCAeGyJZA5IoJg+bpp5
   OOdJCVl0USBiqi0iiK980NFQWE3pybZNuBOVt/ecPCGsczmCdGQCnmkIK
   6+2W5CHhyNereDyrskPrsywj96YNWzc+yx0WRVS+UXkiJQf3e85QrKho5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="378547989"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="378547989"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995409451"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="995409451"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 07:49:17 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: rafael.j.wysocki@intel.com,
	andriy.shevchenko@intel.com,
	lenb@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v1 2/9] docs: firmware-guide: ACPI: Clarify ACPI bus concepts
Date: Mon, 25 Sep 2023 17:48:35 +0300
Message-ID: <20230925144842.586829-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230925144842.586829-1-michal.wilczynski@intel.com>
References: <20230925144842.586829-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some devices implement ACPI driver as a way to manage devices
enumerated by the ACPI. This might be confusing as a preferred way to
implement a driver for devices not connected to any bus is a platform
driver, as stated in the documentation. Clarify relationships between
ACPI device, platform device and ACPI entries.

Suggested-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 Documentation/firmware-guide/acpi/enumeration.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/firmware-guide/acpi/enumeration.rst b/Documentation/firmware-guide/acpi/enumeration.rst
index 56d9913a3370..f56cc79a9e83 100644
--- a/Documentation/firmware-guide/acpi/enumeration.rst
+++ b/Documentation/firmware-guide/acpi/enumeration.rst
@@ -64,6 +64,19 @@ If the driver needs to perform more complex initialization like getting and
 configuring GPIOs it can get its ACPI handle and extract this information
 from ACPI tables.
 
+ACPI bus
+====================
+
+Historically some devices not connected to any bus were represented as ACPI
+devices, and had to implement ACPI driver. This is not a preferred way for new
+drivers. As explained above devices not connected to any bus should implement
+platform driver. ACPI device would be created during enumeration nonetheless,
+and would be accessible through ACPI_COMPANION() macro, and the ACPI handle would
+be accessible through ACPI_HANDLE() macro. ACPI device is meant to describe
+information related to ACPI entry e.g. handle of the ACPI entry. Think -
+ACPI device interfaces with the FW, and the platform device with the rest of
+the system.
+
 DMA support
 ===========
 
-- 
2.41.0

