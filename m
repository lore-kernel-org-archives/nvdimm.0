Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2352C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418342; x=1672954342;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WkNyoqOkNabsNshuJHnilc0Rs1nFAMTQqMLYayXSN9Q=;
  b=JJQqhIyRavKkOhLYwBpuG82/MYYKAH0lvSgFh+Y8YGIkwSQ1ojRIYwP2
   rebhElAONaoNAqVcj1bWG//bps0DKkNQXzsVX4jRvcPnlAQ5uw0hr5nbo
   vzLTkqEul3OHSV6L1ekGScoACrungX0w17VtJ18kYpp0ampLNnS3UF3TJ
   x8UDDai5bXVMJlCVSIUQCxYUm1j0m6QA06No9/0C915xQTXezsOfpxCYK
   pf/MOR50gbf4iSFxP+O5Ec4jpsRKCzOUEyXT3cIG8tcBSDNp2pRM+r9LB
   G/YSANWfGn8euIC6dkx2XhUWpY8fF4fLrn4M+0v3Br4ZFpx+oxP2tlbul
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="241358756"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="241358756"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="574526373"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:21 -0800
Subject: [ndctl PATCH v3 08/16] ndctl/test: Fix support for missing
 dax_pmem_compat module
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:21 -0800
Message-ID: <164141834155.3990253.5388773351209410262.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The kernel is moving to drop CONFIG_DEV_DAX_PMEM_COMPAT. Update
ndctl_test_init() to not error out if dax_pmem_compat is missing. It seems
that the original implementation of support for missing dax_pmem_compat was
broken, or since that time newer versions of kmod_module_new_from_name() no
longer fail when the module is missing.

Fixes: b7991dbc22f3 ("ndctl/test: Relax dax_pmem_compat requirement")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/core.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/test/core.c b/test/core.c
index dc1405d75c49..5d1aa23723f1 100644
--- a/test/core.c
+++ b/test/core.c
@@ -120,7 +120,6 @@ int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		"nfit",
 		"device_dax",
 		"dax_pmem",
-		"dax_pmem_core",
 		"dax_pmem_compat",
 		"libnvdimm",
 		"nd_btt",
@@ -180,29 +179,27 @@ int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		/*
 		 * Skip device-dax bus-model modules on pre-v5.1
 		 */
-		if ((strcmp(name, "dax_pmem_core") == 0
-				|| strcmp(name, "dax_pmem_compat") == 0)
-				&& !ndctl_test_attempt(test,
-					KERNEL_VERSION(5, 1, 0)))
+		if ((strcmp(name, "dax_pmem_compat") == 0) &&
+		    !ndctl_test_attempt(test, KERNEL_VERSION(5, 1, 0)))
 			continue;
 
 retry:
 		rc = kmod_module_new_from_name(*ctx, name, mod);
-
-		/*
-		 * dax_pmem_compat is not required, missing is ok,
-		 * present-but-production is not ok.
-		 */
-		if (rc && strcmp(name, "dax_pmem_compat") == 0)
-			continue;
-
 		if (rc) {
-			log_err(&log_ctx, "%s.ko: missing\n", name);
+			log_err(&log_ctx, "failed to interrogate %s.ko\n",
+				name);
 			break;
 		}
 
 		path = kmod_module_get_path(*mod);
 		if (!path) {
+			/*
+			 * dax_pmem_compat is not required, missing is
+			 * ok, present-but-production is not ok.
+			 */
+			if (strcmp(name, "dax_pmem_compat") == 0)
+				continue;
+
 			if (family != NVDIMM_FAMILY_INTEL &&
 			    (strcmp(name, "nfit") == 0 ||
 			     strcmp(name, "nd_e820") == 0))

