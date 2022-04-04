Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7777C
	for <nvdimm@lists.linux.dev>; Mon,  4 Apr 2022 03:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649042387; x=1680578387;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UPciVpTPSOmssEd4xKm+q2jToSDJvNxjDhyQleEFCqg=;
  b=I0C6/3gWfxW3R10uTipBW473KKuyBXuL6M4MtV324/oLDA0wjUzEpJr4
   ALiL5tSTStTgQVx83jgyMh7sWWsnETR1DI2QvR/qksxcADGxT8ZrFErsm
   S6amyL3xMKlDl0JuEvdraFpZKXwzsyVn1hU9oPnjzjmD871VliVyGOuSE
   0xxnUAIQ9cNwvOz7cDLGbnMDXRUDZRl/MGFRnw54zqr+IYcHh/3ptNb9f
   H+7bhCvEZEVsdZdKNuqQ/SUvL2CVkLGZHG204fJmRxMNPcWQFQGox3qHW
   wLLUKVAMQTpHglQRn0+QoAl2xnzjjU8mQdLguHbmMjddt2205+2766Fs8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="260609152"
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="260609152"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 20:19:46 -0700
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="657339753"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 20:19:46 -0700
Subject: [PATCH] tools/testing/nvdimm: Fix security_init() symbol collision
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Kajol Jain <kjain@linux.ibm.com>
Date: Sun, 03 Apr 2022 20:19:46 -0700
Message-ID: <164904238610.1330275.1889212115373993727.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Starting with the new perf-event support in the nvdimm core, the
nfit_test mock module stops compiling. Rename its security_init() to
nfit_security_init().

tools/testing/nvdimm/test/nfit.c:1845:13: error: conflicting types for ‘security_init’; have ‘void(struct nfit_test *)’
 1845 | static void security_init(struct nfit_test *t)
      |             ^~~~~~~~~~~~~
In file included from ./include/linux/perf_event.h:61,
                 from ./include/linux/nd.h:11,
                 from ./drivers/nvdimm/nd-core.h:11,
                 from tools/testing/nvdimm/test/nfit.c:19:

Fixes: 9a61d0838cd0 ("drivers/nvdimm: Add nvdimm pmu structure")
Cc: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 65dbdda3a054..1da76ccde448 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1842,7 +1842,7 @@ static int nfit_test_dimm_init(struct nfit_test *t)
 	return 0;
 }
 
-static void security_init(struct nfit_test *t)
+static void nfit_security_init(struct nfit_test *t)
 {
 	int i;
 
@@ -1938,7 +1938,7 @@ static int nfit_test0_alloc(struct nfit_test *t)
 	if (nfit_test_dimm_init(t))
 		return -ENOMEM;
 	smart_init(t);
-	security_init(t);
+	nfit_security_init(t);
 	return ars_state_init(&t->pdev.dev, &t->ars_state);
 }
 

