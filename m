Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E534E2095D2C1
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 13:39:45 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, test: fix check_btt_autodetect() exit condition
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Jul 2017 13:35:05 -0700
Message-ID: <149971890518.36155.4733103499126457965.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Static analysis reports that we fail to act on a pwrite() error
initializing the info block to zero.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/test/libndctl.c b/test/libndctl.c
index e1c8ee9aabf8..9c9263930554 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -1534,6 +1534,7 @@ static int check_btt_autodetect(struct ndctl_bus *bus,
 		rc = -ENXIO;
 		fprintf(stderr, "%s: failed to overwrite btt on %s\n",
 				devname, bdev);
+		goto out;
 	}
 	rc = pwrite(fd, buf, 4096, 0);
 	if (rc < 4096) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
