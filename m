Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAD52C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984191; x=1674520191;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7bx4hQdaKAqoB0jDsKP6kI7Q4BWHrNEOmOPbSXrpGTo=;
  b=RMCeS6DaFIq9zNxOh3Uebff0WnlCqXlOXHkS64msewUaxSaOjHEx2II6
   1DNp4AXj6yVWqL9znlcUtPWFjN3rR5aqiypGp1/uk8sW5RtKdsK+WJhkH
   1UfeBSkaJb5fEYzX9cs5rmYZYFnGP1nm1LmHkx6PSaRREdB64B4jghfy5
   +8dnDilk0seOJ7Y717WKsAWyHD1WIAxhs1O9v30xb19PuCWzI6w12cKiQ
   2xiBm7D8W04R2ToF0MRMgSlXRr3KxTGnMN6vBmkL9jv/S9tLxKjg65mMj
   lMWMEY0gyeXke7aLnUumOZ6o3THvsgCwRrrTpL9XWcQz5gU0HmC5VPgsb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="233292350"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="233292350"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="766230157"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:29:48 -0800
Subject: [PATCH v3 13/40] cxl/core/port: Make passthrough decoder init
 implicit
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:29:47 -0800
Message-ID: <164298418778.3018233.13573986275832546547.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Ben Widawsky <ben.widawsky@intel.com>

Unused CXL decoders, or ports which use a passthrough decoder (no HDM
decoder registers) are expected to be initialized in a specific way.
Since upcoming drivers will want the same initialization, and it was
already a requirement to have consumers of the API configure the decoder
specific to their needs, initialize to this passthrough state by
default.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c      |    5 -----
 drivers/cxl/core/port.c |    9 ++++++++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 0b267eabb15e..4e8086525edc 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -264,11 +264,6 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 	if (IS_ERR(cxld))
 		return PTR_ERR(cxld);
 
-	cxld->interleave_ways = 1;
-	cxld->interleave_granularity = PAGE_SIZE;
-	cxld->target_type = CXL_DECODER_EXPANDER;
-	cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
-
 	device_lock(&port->dev);
 	dport = list_first_entry(&port->dports, typeof(*dport), list);
 	device_unlock(&port->dev);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 2910c36a0e58..826b300ba950 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -505,7 +505,8 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
  * some address space for CXL.mem utilization. A decoder is expected to be
  * configured by the caller before registering.
  *
- * Return: A new cxl decoder to be registered by cxl_decoder_add()
+ * Return: A new cxl decoder to be registered by cxl_decoder_add(). The decoder
+ *	   is initialized to be a "passthrough" decoder.
  */
 static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 					     unsigned int nr_targets)
@@ -537,6 +538,12 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	else
 		cxld->dev.type = &cxl_decoder_switch_type;
 
+	/* Pre initialize an "empty" decoder */
+	cxld->interleave_ways = 1;
+	cxld->interleave_granularity = PAGE_SIZE;
+	cxld->target_type = CXL_DECODER_EXPANDER;
+	cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
+
 	return cxld;
 err:
 	kfree(cxld);

