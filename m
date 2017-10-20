Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3386D20347175
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 08:43:51 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [ndctl patch] dax_io: fix unknown parameter handling
Date: Fri, 20 Oct 2017 11:47:28 -0400
Message-ID: <x49po9hes8f.fsf@segfault.boston.devel.redhat.com>
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
To: Dave Jiang <dave.jiang@intel.com>, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The for loop will not loop more than once due to the return statement.
What's more, the following code, which prints out the usage, also won't
run.  Let's change this to look more like other commands.  Print out
invalid options and then print out the usage.  usage_with_options will
exit, so no need for a return there.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/daxctl/io.c b/daxctl/io.c
index 27e7463..2f8cb4a 100644
--- a/daxctl/io.c
+++ b/daxctl/io.c
@@ -526,15 +526,11 @@ int cmd_io(int argc, const char **argv, void *daxctl_ctx)
 	struct ndctl_ctx *ndctl_ctx;
 
 	argc = parse_options(argc, argv, options, u, 0);
-	for (i = 0; i < argc; i++) {
+	for (i = 0; i < argc; i++)
 		fail("Unknown parameter \"%s\"\n", argv[i]);
-		return -EINVAL;
-	}
 
-	if (argc) {
+	if (argc)
 		usage_with_options(u, options);
-		return 0;
-	}
 
 	if (!io.dev[0].parm_path && !io.dev[1].parm_path) {
 		usage_with_options(u, options);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
