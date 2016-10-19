Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B6561A1E56
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:59:14 -0700 (PDT)
Subject: [ndctl PATCH] Documentation: fix up init-labels man page
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:56:07 -0700
Message-ID: <147689616727.11460.11361379078868671546.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Delete the -o option and fix the description for --force.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-init-labels.txt |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/ndctl-init-labels.txt b/Documentation/ndctl-init-labels.txt
index c01f31b0532a..6e5cc3578efa 100644
--- a/Documentation/ndctl-init-labels.txt
+++ b/Documentation/ndctl-init-labels.txt
@@ -70,12 +70,11 @@ Create a namespace in that region:
 OPTIONS
 -------
 include::labels-options.txt[]
--o::
-	output file
 -f::
 --force::
-	parse the label data into json assuming the 'NVDIMM Namespace
-	Specification' format.
+	Force initialization of the label space even if there appears to
+	be an existing / valid namespace index.  Warning, this will
+	destroy all defined namespaces on the dimm.
 
 SEE ALSO
 --------

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
