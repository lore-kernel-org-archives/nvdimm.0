Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052B62C80
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 05:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643174644; x=1674710644;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jikdn5aUxL1fQVhM2z1NpcZFt/8C4df5jyvo0XW+XDA=;
  b=j6zPS03wa+S4FFlCBGVTwGSDM0NPaQp7jMzLUXyxTw0XFUtOoAj8/hz4
   LDYdL6JlxgcQdUz9ImuxSU/0HLh9tLLUPgV7Ic35fGrpM7eVEHosWyeJa
   II79gzBPw10ASOVslmwMrXldSp/dDU0QiseSN5vVND89XtBsEpoBXzt7x
   VUL5YoAqGKCAQW+0dyQbfVUNPua/iSSqB55+VRUPHBp8N2YqFdEW1jcv7
   6ftFOATbtohB+Z2bDmiPMo8NFmE4ppKPH9ZDrB5hceC2iuQDaTzyn48w6
   ZF86x41ZKl9bUiJC7UW9O7wvbj1DFJc2hE35Mt8ge8QbdVYSwxvzqahvJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="270934538"
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="270934538"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 21:24:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="563305708"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 21:24:04 -0800
Subject: [PATCH 1/2] cxl/core/port: Fix / relax decoder target enumeration
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev, ben.widawsky@intel.com
Date: Tue, 25 Jan 2022 21:24:04 -0800
Message-ID: <164317464406.3438644.6609329492458460242.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164317463887.3438644.4087819721493502301.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164317463887.3438644.4087819721493502301.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

If the decoder is not presently active the target_list may not be
accurate. Perform a best effort mapping and assume that it will be fixed
up when the decoder is enabled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c      |    2 +-
 drivers/cxl/core/port.c |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index df6691d0a6d0..f64d98bfcb3b 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -15,7 +15,7 @@
 
 static unsigned long cfmws_to_decoder_flags(int restrictions)
 {
-	unsigned long flags = 0;
+	unsigned long flags = CXL_DECODER_F_ENABLE;
 
 	if (restrictions & ACPI_CEDT_CFMWS_RESTRICT_TYPE2)
 		flags |= CXL_DECODER_F_TYPE2;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 224a4853a33e..e75e0d4fb894 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1263,8 +1263,11 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
 	port = to_cxl_port(cxld->dev.parent);
 	if (!is_endpoint_decoder(dev)) {
 		rc = decoder_populate_targets(cxld, port, target_map);
-		if (rc)
+		if (rc && (cxld->flags & CXL_DECODER_F_ENABLE)) {
+			dev_err(&port->dev,
+				"Failed to populate active decoder targets\n");
 			return rc;
+		}
 	}
 
 	rc = dev_set_name(dev, "decoder%d.%d", port->id, cxld->id);

