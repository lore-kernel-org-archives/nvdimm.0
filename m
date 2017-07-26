Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2E1B21D09186
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 13:00:24 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, create-namespace: fix size alignment validation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 12:56:02 -0700
Message-ID: <150109896285.13943.15686058156974485950.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Linda reports:

    I was creating a namespace on a 4-way interleave set and got an error
    I didn't expect:

    $ sudo ndctl create-namespace -m sector -s 10G -n number2
      Error: '--size=' must align to interleave-width: 4 and alignment: 2097152
      did you intend --size=12G?

    What's happening is that since I specified my size in units of G,
    the function wants the namespace to be 1G * 4 aligned rather than
    2M * 4 aligned.

Fix this by using the base "align * interleave_ways" for the alignment
check, and later calculate a 'friendly' recommended size value that
takes into account the units specified for --size.

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 73a422633a0f..c4d70c39c6c4 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -557,8 +557,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 	/* (re-)validate that the size satisfies the alignment */
 	ways = ndctl_region_get_interleave_ways(region);
-	size_align = max(units, size_align) * ways;
-	if (p->size % size_align) {
+	if (p->size % (size_align * ways)) {
 		char *suffix = "";
 
 		if (units == SZ_1K)
@@ -570,6 +569,12 @@ static int validate_namespace_options(struct ndctl_region *region,
 		else if (units == SZ_1T)
 			suffix = "T";
 
+		/*
+		 * Make the recommendation in the units of the '--size'
+		 * option
+		 */
+		size_align = max(units, size_align) * ways;
+
 		p->size /= size_align;
 		p->size++;
 		p->size *= size_align;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
