Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C39C21A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:29:05 -0800 (PST)
Subject: [ndctl PATCH 09/17] ndctl, region: cleanup error message
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:17 -0800
Message-ID: <151217071761.28402.13957732677246404516.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The general parameter parsing error message in parse_region_options()
was copied from the initial "disable-region" command implementation. Fix
it up to be more general and valid for all region commands.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/region.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/region.c b/ndctl/region.c
index 1402a7548be8..9fc90808e338 100644
--- a/ndctl/region.c
+++ b/ndctl/region.c
@@ -44,7 +44,7 @@ static const char *parse_region_options(int argc, const char **argv,
         argc = parse_options(argc, argv, region_options, u, 0);
 
 	if (argc == 0)
-		error("specify a region to delete, or \"all\"\n");
+		error("specify a specific region id to act on, or \"all\"\n");
 	for (i = 1; i < argc; i++)
 		error("unknown extra parameter \"%s\"\n", argv[i]);
 	if (argc == 0 || argc > 1) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
