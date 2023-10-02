Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E58B15E97
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696254905; x=1727790905;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7CvkNllIdMRaFkXGmuu4g9r5sHV6wrnsOajfayAqkbY=;
  b=SYI8+LdnwMPUKRY3rOqsgiQhH+VGFt5U2TOs+gFPqUZtg8brNl9rV01q
   0x6GBsopQWfBQxG/bkbxdKvVXd7jiphPl//VWNNRbZsGztcHQF+L+kEjU
   +kbBwnqlrfZpdmo6qdXEcLCeOSYj4yEGGCFiH74/4bzv5w8bWahaucS/f
   Hfz3YJrvrYNgklDuiNTdu2RuehS1UWzAwh82YMby1EjXqC7vhhaXtidHl
   wSZ5Ky2HRa13sCutoeBJJWKICG771dZxm7g5/LOjE09m4LdfJpHkQi0DV
   zPo5Y94rotH1EMLvf+k+06lyFgn9z8Df3IdtdP9RmTI8ZpXhWBoE9K3LO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="362911944"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="362911944"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 06:55:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="785782513"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="785782513"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 02 Oct 2023 06:55:01 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 9CE6A14AF; Mon,  2 Oct 2023 16:54:59 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Michal Wilczynski <michal.wilczynski@intel.com>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] ACPI: NFIT: Switch to use acpi_evaluate_dsm_typed()
Date: Mon,  2 Oct 2023 16:54:58 +0300
Message-Id: <20231002135458.2603293-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.40.0.1.gaa8946217a0b
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The acpi_evaluate_dsm_typed() provides a way to check the type of the
object evaluated by _DSM call. Use it instead of open coded variant.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/acpi/nfit/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f96bf32cd368..280da408c02c 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1737,9 +1737,8 @@ __weak void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
 	if ((nfit_mem->dsm_mask & (1 << func)) == 0)
 		return;
 
-	out_obj = acpi_evaluate_dsm(handle, guid, revid, func, &in_obj);
-	if (!out_obj || out_obj->type != ACPI_TYPE_BUFFER
-			|| out_obj->buffer.length < sizeof(smart)) {
+	out_obj = acpi_evaluate_dsm_typed(handle, guid, revid, func, &in_obj, ACPI_TYPE_BUFFER);
+	if (!out_obj || out_obj->buffer.length < sizeof(smart)) {
 		dev_dbg(dev->parent, "%s: failed to retrieve initial health\n",
 				dev_name(dev));
 		ACPI_FREE(out_obj);
-- 
2.40.0.1.gaa8946217a0b

