Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 5F8641A1E04
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 11:39:00 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: delete duplicate -v on "ndctl
 destroy-namespace --help" page
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Jun 2016 11:37:43 -0700
Message-ID: <146705266321.37678.11072958328083418796.stgit@dwillia2-desk3.amr.corp.intel.com>
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

"xable-namespace-options.txt" already includes a -v description, so
delete the local one.

Reported-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-destroy-namespace.txt |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/ndctl-destroy-namespace.txt b/Documentation/ndctl-destroy-namespace.txt
index ea6d2856107a..623820533cec 100644
--- a/Documentation/ndctl-destroy-namespace.txt
+++ b/Documentation/ndctl-destroy-namespace.txt
@@ -22,11 +22,6 @@ include::xable-namespace-options.txt[]
 	Specifying --force causes the namespace to be disabled before
 	the operation is attempted.
 
--v::
---verbose::
-	Emit debug messages for the namespace destruction operation
-
-
 SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1]

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
