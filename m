Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84852211B5A27
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 17:41:12 -0800 (PST)
Subject: [PATCH] nfit_test: fix security state pull for nvdimm security
 nfit_test
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 14 Jan 2019 18:41:04 -0700
Message-ID: <154751646417.72343.12638206613671735039.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The override status function needs to be updated to use the proper
request parameter in order to get the security state.

Fixes: 3c13e2ac74 ("tools/testing/nvdimm: Add test support for Intel nvdimm
security DSMs")

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/nvdimm/dimm_devs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/dimm_devs.c b/tools/testing/nvdimm/dimm_devs.c
index e75238404555..2d4baf57822f 100644
--- a/tools/testing/nvdimm/dimm_devs.c
+++ b/tools/testing/nvdimm/dimm_devs.c
@@ -18,8 +18,8 @@ ssize_t security_show(struct device *dev,
 	 * For the test version we need to poll the "hardware" in order
 	 * to get the updated status for unlock testing.
 	 */
-	nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
-	nvdimm->sec.ext_state = nvdimm_security_state(nvdimm, true);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
+	nvdimm->sec.ext_state = nvdimm_security_state(nvdimm, NVDIMM_MASTER);
 
 	switch (nvdimm->sec.state) {
 	case NVDIMM_SECURITY_DISABLED:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
