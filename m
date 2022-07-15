Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83997460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843498; x=1689379498;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h94bX3pkhvKPJBqJBcBqsOYdL1YyxVd+P+WmQ5R1eyk=;
  b=OuLEAWuFV7rs5Z1xb/IyK0Ybd6cK961XnRNSpYVlPA+JT1wWRCN5vdjm
   Gv/3YA8MDkd75Bj8ZIIoL5oeTIZebETVVsKND5do6TW6GhSqiXMsA5dJx
   q463Xng75YIILvYMeF9mymOjEPLxqbwJZUoO3ZoZR4G4FE2K878HhpKSi
   xYpA8W8TRLF+rgjHHSpfXq5FKGKb0oHeemymOPEUmpUw5JfIxSwoLeVdy
   xz7TOMkLz6CpbG2OplZe9K7Q2O5Vhrgq3jh92JtJ5uh2ICiUH/ZfiumMv
   fgL9rhQFONfKrVzbULZwA06TQR3ESD6JCIeRAd2mI/Q1JtHCekl38BSyH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286401819"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286401819"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:47 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="772801733"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:47 -0700
Subject: [PATCH v2 22/28] cxl/acpi: Add a host-bridge index lookup mechanism
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, hch@lst.de,
 nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:02:47 -0700
Message-ID: <165784336732.1758207.3045854545395563239.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The ACPI CXL Fixed Memory Window Structure (CFMWS) defines multiple
methods to determine which host bridge provides access to a given
endpoint relative to that device's position in the interleave. The
"Interleave Arithmetic" defines either a "standard modulo" /
round-random algorithm, or "xormap" based algorithm which can be defined
as a non-linear transform. Given that there are already more options
beyond "standard modulo" and that "xormap" may turn out to be ACPI CXL
specific, provide a callback for the region provisioning code to map
endpoint positions back to expected host bridge id (cxl_dport target).

For now just support the simple modulo math case and save the xormap for
a follow-on change.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20220624041950.559155-14-dan.j.williams@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c |   16 ++++++++++++++++
 drivers/cxl/cxl.h       |    2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index bd0673821d28..2f0b47db53da 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1421,6 +1421,20 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 	return rc;
 }
 
+static struct cxl_dport *cxl_hb_modulo(struct cxl_root_decoder *cxlrd, int pos)
+{
+	struct cxl_switch_decoder *cxlsd = &cxlrd->cxlsd;
+	struct cxl_decoder *cxld = &cxlsd->cxld;
+	int iw;
+
+	iw = cxld->interleave_ways;
+	if (dev_WARN_ONCE(&cxld->dev, iw != cxlsd->nr_targets,
+			  "misconfigured root decoder\n"))
+		return NULL;
+
+	return cxlrd->cxlsd.target[pos % iw];
+}
+
 static struct lock_class_key cxl_decoder_key;
 
 /**
@@ -1510,6 +1524,8 @@ struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 		return ERR_PTR(rc);
 	}
 
+	cxlrd->calc_hb = cxl_hb_modulo;
+
 	cxld = &cxlsd->cxld;
 	cxld->dev.type = &cxl_decoder_root_type;
 	/*
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 95d74cf425a4..cd81e642e900 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -322,11 +322,13 @@ struct cxl_switch_decoder {
  * struct cxl_root_decoder - Static platform CXL address decoder
  * @res: host / parent resource for region allocations
  * @region_id: region id for next region provisioning event
+ * @calc_hb: which host bridge covers the n'th position by granularity
  * @cxlsd: base cxl switch decoder
  */
 struct cxl_root_decoder {
 	struct resource *res;
 	atomic_t region_id;
+	struct cxl_dport *(*calc_hb)(struct cxl_root_decoder *cxlrd, int pos);
 	struct cxl_switch_decoder cxlsd;
 };
 

