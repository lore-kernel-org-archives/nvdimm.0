Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D621C1A1F30
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 08:54:11 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [ndctl PATCH] ndctl: Bail out with unkown command in case of an
 unknown command
Date: Mon, 14 Mar 2016 16:53:36 +0100
Message-Id: <1457970816-5625-1-git-send-email-jthumshirn@suse.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

handle_internal_command() only returns to main if it doesn't find the
specified command and does not set an errno.

When running an unknown command you get the following error message:
$ ./ndctl asd
Failed to run command 'asd': Success

Instead of a more appropriate:
$ ./ndctl asd
Unknown command: 'asd'

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 ndctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ndctl.c b/ndctl.c
index ded1588..18b5dc6 100644
--- a/ndctl.c
+++ b/ndctl.c
@@ -159,8 +159,7 @@ int main(int argc, const char **argv)
 		goto out;
 	}
 	handle_internal_command(argc, argv);
-	fprintf(stderr, "Failed to run command '%s': %s\n",
-		argv[0], strerror(errno));
+	fprintf(stderr, "Unknown command: '%s'\n", argv[0]);
 out:
 	return 1;
 }
-- 
2.7.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
