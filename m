Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id CEBA91A1E20
 for <linux-nvdimm@lists.01.org>; Sat, 21 May 2016 14:56:19 -0700 (PDT)
Subject: [ndctl PATCH 3/5] test: fix 'pfn alignment too big' checks
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 21 May 2016 14:55:25 -0700
Message-ID: <146386772584.1884.14928714720506804854.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146386771020.1884.14405221977201209581.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146386771020.1884.14405221977201209581.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The unit test properly detects when ndctl_pfn_enable() should fail, but
it then fails to abort the test.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index fb4a2eac74f9..16072fbc8819 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -615,7 +615,7 @@ static int __check_pfn_create(struct ndctl_region *region,
 		if (rc == 0) {
 			fprintf(stderr, "%s: expected pfn enable failure with align: %lx\n",
 					devname, align);
-			return rc;
+			return -ENXIO;
 		}
 		ndctl_pfn_delete(pfn);
 		return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
