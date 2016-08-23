Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3E651A1E31
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 16:07:29 -0700 (PDT)
Subject: [ndctl PATCH 1/3] test: gate SMART payload verification on v4.9
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 16:05:06 -0700
Message-ID: <147199350632.5587.10454258829830826126.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147199350116.5587.2852255825958647760.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147199350116.5587.2852255825958647760.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The kernel uses the old v1 DSM payload until v4.9.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 30b78a2824f1..7c81531a03c2 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2254,8 +2254,11 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	};
 	unsigned int i, rc = 0;
 
-	/* the kernel did not start emulating smart data until 4.7 */
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
+	/*
+	 * The kernel did not start emulating v1.2 namespace spec smart data
+	 * until 4.9.
+	 */
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
 		dimm_commands &= ~((1 << ND_CMD_SMART)
 				| (1 << ND_CMD_SMART_THRESHOLD));
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
