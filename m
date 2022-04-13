Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C374723CA
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829726; x=1681365726;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=77GSFBA3SxqE/U83sHJwXKlAMeIpvS0DlqeYvtg365o=;
  b=Um1qom6eEpsQbdqB85Nv2d8DdoLy5LIdte31OSVJEWrEaZCdPv48/em0
   OK627o4/GtiJ0BR1H1VVwsGm7K2mv8hIGdjuAwWwTuQoqTKxV9lYO7ySy
   Mkz4WEe062Qlm7ILnFPYAXwiNkl/r44VKZlqgp8dUcw+IPjY5lgLDWFfo
   Mig+eZB11HPLbPfts567TrgjPHyxTr0glF/s4ypaiHt6kVVf/1oRKlADe
   VacbxSwRDhLcSIEC4rYIvuaL535KUIcD5hphNDzV4oo1eAnDUiv5wo31L
   QaJhOGT31hXf08v/z6XOkeUcZy5cGNyCH6I+MTO51oaaTdUxYh7/nS3a0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262763159"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262763159"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="660799955"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:05 -0700
Subject: [PATCH v2 07/12] cxl/acpi: Add a device_lock() lock class for the
 root platform device
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Ben Widawsky <ben.widawsky@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, peterz@infradead.org,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:02:05 -0700
Message-ID: <164982972569.684294.15140338434944364472.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that the device-core can start validating lockdep usage after the
device has been added, use that capability to validate usage of
device_lock() against the ACPI0017 device relative to other subsystem
locks.

The 'enum cxl_lock_class' definition moves outside of the ifdef guard to
support device_set_lock_class() called from cxl_acpi_probe().

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c |    1 +
 drivers/cxl/cxl.h  |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index d15a6aec0331..ef5c3252bdb2 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -283,6 +283,7 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	struct acpi_device *adev = ACPI_COMPANION(host);
 	struct cxl_cfmws_context ctx;
 
+	device_set_lock_class(&pdev->dev, CXL_ROOT_LOCK);
 	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
 	if (IS_ERR(root_port))
 		return PTR_ERR(root_port);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index fddbcb380e84..05dc4c081ad2 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -405,9 +405,9 @@ struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd);
 #define __mock static
 #endif
 
-#ifdef CONFIG_PROVE_CXL_LOCKING
 enum cxl_lock_class {
 	CXL_ANON_LOCK,
+	CXL_ROOT_LOCK,
 	CXL_NVDIMM_LOCK,
 	CXL_NVDIMM_BRIDGE_LOCK,
 	/*
@@ -423,6 +423,7 @@ enum cxl_lock_class {
 	 */
 };
 
+#ifdef CONFIG_PROVE_CXL_LOCKING
 static inline int clamp_lock_class(struct device *dev, int lock_class)
 {
 	if (lock_class >= MAX_LOCKDEP_SUBCLASSES) {

