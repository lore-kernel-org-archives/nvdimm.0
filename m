Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00D723D0;
	Fri, 24 Jun 2022 04:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044418; x=1687580418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CdACGDCijg9t0Ev44Lk+HSkwOEGVx5BxX7nqS1WZRvY=;
  b=UZhGtgnVmKSUtbXNumDY8PNSAmIU6ENe+IA3f9QPb+KULELU20UzY3qJ
   7DetHe0CTa6sMVR7zg0Y3aCemerZgxnxL86ZXJlnq855KPkExQ/ywLD4e
   gM6kjgbrDPYt0jEWlgBnWEF3ktgHMiwYPtEu6kTpWJAsyJITEAXbCSwxK
   a6tN3qaf0/c5JbZqHjsbrnLxMVws8TOyToL22shOyXqzqzlTfJjfvtUV+
   3JVe7A/iChCalUYhGwI9xmbJ90/eQ+Pk0DijzW1E66KTFE7I6EPKOaoSq
   miJNXeZafljvZQAHm26azo9P5BRJY3fLLHcJKKqn3ywtvdJipGmXo152j
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912804"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912804"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092947"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:13 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 39/46] cxl/acpi: Add a host-bridge index lookup mechanism
Date: Thu, 23 Jun 2022 21:19:43 -0700
Message-Id: <20220624041950.559155-14-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c | 15 +++++++++++++++
 drivers/cxl/cxl.h       |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 562a6453249b..7756409d0a58 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1422,6 +1422,20 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
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
@@ -1466,6 +1480,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 				if (rc < 0)
 					goto err;
 				atomic_set(&cxlrd->region_id, rc);
+				cxlrd->calc_hb = cxl_hb_modulo;
 			} else
 				cxlsd = NULL;
 		} else {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 9340deccad4f..30227348f768 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -315,11 +315,13 @@ struct cxl_switch_decoder {
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
 
-- 
2.36.1

