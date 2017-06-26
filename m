Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 694252095A6D4
 for <linux-nvdimm@lists.01.org>; Mon, 26 Jun 2017 11:57:53 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, check-namespace: fix resource leak
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Jun 2017 11:52:56 -0700
Message-ID: <149850317639.1029.4272990186528265578.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Static analysis points out that we leak 'bttc' in namespace_check().

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/check.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ndctl/check.c b/ndctl/check.c
index 3775c2ed4a3a..2d913cf5a4c2 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -898,7 +898,8 @@ int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
 
 	if (sigaction(SIGBUS, &act, 0)) {
 		err(bttc, "Unable to set sigaction\n");
-		return -errno;
+		rc = -errno;
+		goto out_bttc;
 	}
 
 	bttc->opts = opts;
@@ -912,7 +913,7 @@ int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
 		if (opts->force) {
 			rc = ndctl_namespace_disable_safe(ndns);
 			if (rc)
-				return rc;
+				goto out_bttc;
 			disabled_flag = 1;
 		} else {
 			err(bttc, "%s: check aborted, namespace online\n",

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
