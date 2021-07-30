Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55913481
	for <nvdimm@lists.linux.dev>; Fri, 30 Jul 2021 20:00:25 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10061"; a="200365513"
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="200365513"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 13:00:22 -0700
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="508342000"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 13:00:22 -0700
Subject: [PATCH] tools/testing/nvdimm: Fix missing 'fallthrough' warning
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Fri, 30 Jul 2021 13:00:20 -0700
Message-ID: <162767522046.3313209.14767278726893995797.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Use "fallthrough;" to address:

tools/testing/nvdimm/test/nfit.c: In function ‘nd_intel_test_finish_query’:
tools/testing/nvdimm/test/nfit.c:436:37: warning: this statement may
	fall through [-Wimplicit-fallthrough=]
  436 |                 fw->missed_activate = false;
      |                 ~~~~~~~~~~~~~~~~~~~~^~~~~~~
tools/testing/nvdimm/test/nfit.c:438:9: note: here
  438 |         case FW_STATE_UPDATED:
      |         ^~~~

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 54f367cbadae..b1bff5fb0f65 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -434,7 +434,7 @@ static int nd_intel_test_finish_query(struct nfit_test *t,
 		dev_dbg(dev, "%s: transition out verify\n", __func__);
 		fw->state = FW_STATE_UPDATED;
 		fw->missed_activate = false;
-		/* fall through */
+		fallthrough;
 	case FW_STATE_UPDATED:
 		nd_cmd->status = 0;
 		/* bogus test version */

