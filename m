Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id A9DB81A1F74
 for <linux-nvdimm@lists.01.org>; Mon, 16 May 2016 11:31:46 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: filter out unit tests from command list
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 May 2016 11:30:55 -0700
Message-ID: <146342345578.22015.9381479390986560627.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Don't provide autocomplete help for unit test commands that are not
meant to be invoked in typical usage.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ndctl.c b/ndctl.c
index 6db1b2ffa0c0..bf0754cb454c 100644
--- a/ndctl.c
+++ b/ndctl.c
@@ -74,6 +74,14 @@ static int handle_options(const char ***argv, int *argc)
 
 			for (i = 0; i < ARRAY_SIZE(commands); i++) {
 				struct cmd_struct *p = commands+i;
+
+				/* filter out commands from auto-complete */
+				if (strcmp(p->cmd, "create-nfit") == 0)
+					continue;
+				if (strcmp(p->cmd, "test") == 0)
+					continue;
+				if (strcmp(p->cmd, "bat") == 0)
+					continue;
 				printf("%s\n", p->cmd);
 			}
 			exit(0);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
