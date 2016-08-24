Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 968A11A1E3E
 for <linux-nvdimm@lists.01.org>; Wed, 24 Aug 2016 12:42:38 -0700 (PDT)
Subject: [ndctl PATCH] test, device-dax: validate MAP_PRIVATE attempts fail
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Aug 2016 12:40:15 -0700
Message-ID: <147206761508.20661.1862644673812635246.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Device-DAX explicitly disallows MAP_PRIVATE mappings.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/device-dax.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/test/device-dax.c b/test/device-dax.c
index 34ca284f2ef5..a14e2a95db7e 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -113,6 +113,12 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 		return -ENXIO;
 	}
 
+	buf = mmap(NULL, 2UL << 20, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (buf != MAP_FAILED) {
+		fprintf(stderr, "%s: expected MAP_PRIVATE failure\n", path);
+		return -ENXIO;
+	}
+
 	buf = mmap(NULL, 2UL << 20, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
 	p = (int *) (buf + (1UL << 20));
 	*p = 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
