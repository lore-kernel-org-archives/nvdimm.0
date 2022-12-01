Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479D910782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930435; x=1701466435;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TegZIsam1nSMAQmPeHmk/pxm0gQ3ZGqOoamFiUvGsRo=;
  b=Ok2AV7Y3VDfGKR5WYud8zOv8vO9b3rX6YrsdL/yCFxBMk1qB6s4I23ob
   K3A25h1NDRwe3+uFKy778P6xOw/+6wAqcSetIjoiJNV3RXk5+kKXn/XdR
   YppQ8Zldy7Rc9qh5XzyYM3JiM+L6O8AAR4ueFsnfNZ46oHCIS2U71Ahvf
   auiF8z0MxqN62BYZlVg9R+ohmP+p7MQD/34ezOI33mvzVNeT+qZgLR3Wm
   v4J7y5eEbhWo7xXntaxqu0G9I65yRR5uSVlAuU09CBTg0tLKADU2KhzpY
   TTwnbEXUhwi3WDZTn2aftvuJIUAlJBPg/IYZddM6HKxMw+9l5CJW5OoCg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="313443227"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="313443227"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675594776"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="675594776"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:54 -0800
Subject: [PATCH v6 06/12] tools/testing/cxl: Make mock CEDT parsing more
 robust
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Robert Richter <rrichter@amd.com>, rrichter@amd.com, terry.bowman@amd.com,
 bhelgaas@google.com, dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:33:54 -0800
Message-ID: <166993043433.1882361.17651413716599606118.stgit@dwillia2-xfh.jf.intel.com>
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

Accept any cxl_test topology device as the first argument in
cxl_chbs_context.

This is in preparation for reworking the detection of the component
registers across VH and RCH topologies. Move
mock_acpi_table_parse_cedt() beneath the definition of is_mock_port()
and use is_mock_port() instead of the explicit mock cxl_acpi device
check.

Acked-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/cxl.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index facfcd11cb67..8acf52b7dab2 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -320,10 +320,12 @@ static int populate_cedt(void)
 	return 0;
 }
 
+static bool is_mock_port(struct device *dev);
+
 /*
- * WARNING, this hack assumes the format of 'struct
- * cxl_cfmws_context' and 'struct cxl_chbs_context' share the property that
- * the first struct member is the device being probed by the cxl_acpi
+ * WARNING, this hack assumes the format of 'struct cxl_cfmws_context'
+ * and 'struct cxl_chbs_context' share the property that the first
+ * struct member is cxl_test device being probed by the cxl_acpi
  * driver.
  */
 struct cxl_cedt_context {
@@ -340,7 +342,7 @@ static int mock_acpi_table_parse_cedt(enum acpi_cedt_type id,
 	unsigned long end;
 	int i;
 
-	if (dev != &cxl_acpi->dev)
+	if (!is_mock_port(dev) && !is_mock_dev(dev))
 		return acpi_table_parse_cedt(id, handler_arg, arg);
 
 	if (id == ACPI_CEDT_TYPE_CHBS)

