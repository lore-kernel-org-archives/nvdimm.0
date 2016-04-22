Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id A407D1A20D1
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 12:48:17 -0700 (PDT)
Subject: [ndctl PATCH 5/8] ndctl,
 xaction-namespace: make 'verbose' option available in all sub-commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2016 12:47:28 -0700
Message-ID: <146135444838.4228.16562355726281815141.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Rather than limiting the -v option to create-namespace, enable it for
all xaction-namespace commands i.e. {enable, disable, create,
destroy}-namespace.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-destroy-namespace.txt |    5 +++++
 Documentation/xable-namespace-options.txt |    4 ++++
 builtin-xaction-namespace.c               |    6 +++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/ndctl-destroy-namespace.txt b/Documentation/ndctl-destroy-namespace.txt
index 623820533cec..ea6d2856107a 100644
--- a/Documentation/ndctl-destroy-namespace.txt
+++ b/Documentation/ndctl-destroy-namespace.txt
@@ -22,6 +22,11 @@ include::xable-namespace-options.txt[]
 	Specifying --force causes the namespace to be disabled before
 	the operation is attempted.
 
+-v::
+--verbose::
+	Emit debug messages for the namespace destruction operation
+
+
 SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1]
diff --git a/Documentation/xable-namespace-options.txt b/Documentation/xable-namespace-options.txt
index a5c876180c91..cb24c2d61328 100644
--- a/Documentation/xable-namespace-options.txt
+++ b/Documentation/xable-namespace-options.txt
@@ -6,3 +6,7 @@ the operation on every namespace in the system, optionally filtered by region
 -r::
 --region=::
 include::xable-region-options.txt[]
+
+-v::
+--verbose::
+	Emit debug messages for the namespace operation
diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index e2e6d518c64d..23b38ad0b73b 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -71,7 +71,8 @@ struct parsed_parameters {
 OPT_STRING('b', "bus", &param.bus, "bus-id", \
 	"limit namespace to a bus with an id or provider of <bus-id>"), \
 OPT_STRING('r', "region", &param.region, "region-id", \
-	"limit namespace to a region with an id or name of <region-id>")
+	"limit namespace to a region with an id or name of <region-id>"), \
+OPT_BOOLEAN('v', "verbose", &verbose, "emit extra debug messages to stderr")
 
 #define CREATE_OPTIONS() \
 OPT_STRING('e', "reconfig", &param.reconfig, "reconfig namespace", \
@@ -90,8 +91,7 @@ OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
 	"specify the logical sector size in bytes"), \
 OPT_STRING('t', "type", &param.type, "type", \
 	"specify the type of namespace to create 'pmem' or 'blk'"), \
-OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active"), \
-OPT_BOOLEAN('v', "verbose", &verbose, "emit extra debug messages to stderr")
+OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active")
 
 static const struct option base_options[] = {
 	BASE_OPTIONS(),

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
