Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52B4820359A87
 for <linux-nvdimm@lists.01.org>; Sat, 11 Nov 2017 16:03:55 -0800 (PST)
Subject: [ndctl PATCH] ndctl, {create,
 destroy}-namespace: clarify --force option
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Nov 2017 15:59:44 -0800
Message-ID: <151044478495.16188.2552320697320244821.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jeff Balk <jeff.balk@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

When 'destroy-namespace' or 'create-namespace --reconfig' operations
encounter a namespace that is mounted, the operation will always fail.
The '--force' option only forces continuation when the namespace is
active and not mounted. If the namespace is mounted then even --force
will fail.

Reported-by: Jeff Balk <jeff.balk@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/ndctl-create-namespace.txt  |   11 +++++++----
 Documentation/ndctl/ndctl-destroy-namespace.txt |    5 ++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 85d1f8db792f..4f1f9849207f 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -133,10 +133,13 @@ OPTIONS
 
 -f::
 --force::
-	Unless this option is specified a 'reconfigure
-	namespace' operation will fail if the namespace is presently
-	active.  Specifying --force causes the namespace to be disabled
-	before reconfiguring.
+	Unless this option is specified the 'reconfigure namespace'
+	operation will fail if the namespace is presently active.
+	Specifying --force causes the namespace to be disabled before
+	the operation is attempted. However, if the namespace is
+	mounted then the 'disable namespace' and 'reconfigure
+	namespace' operations will be aborted.  The namespace must be
+	unmounted before being reconfigured.
 
 -v::
 --verbose::
diff --git a/Documentation/ndctl/ndctl-destroy-namespace.txt b/Documentation/ndctl/ndctl-destroy-namespace.txt
index 8130b2156452..7078c0b21929 100644
--- a/Documentation/ndctl/ndctl-destroy-namespace.txt
+++ b/Documentation/ndctl/ndctl-destroy-namespace.txt
@@ -20,7 +20,10 @@ include::xable-namespace-options.txt[]
 	Unless this option is specified the 'destroy namespace'
 	operation will fail if the namespace is presently active.
 	Specifying --force causes the namespace to be disabled before
-	the operation is attempted.
+	the operation is attempted. However, if the namespace is
+	mounted then the 'disable namespace' and 'destroy
+	namespace' operations will be aborted.  The namespace must be
+	unmounted before being destroyed.
 
 COPYRIGHT
 ---------

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
