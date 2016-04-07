Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 0542B1A1F6C
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 18:08:05 -0700 (PDT)
Subject: [ndctl PATCH 3/5] ndctl, list: clean up default behavior
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Apr 2016 18:07:14 -0700
Message-ID: <20160407010714.30641.19033.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
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

Only list namespaces by default when no other option is specified.
Otherwise, to limit the listing to dimm info a user would need to run:

	ndctl list --dimms --no-namespaces

...with the change this is reduced to:

	ndctl list --dimms

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-list.txt |    2 +-
 builtin-list.c               |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index abf3ff07cfa9..806548196118 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -79,7 +79,7 @@ include::xable-region-options.txt[]
 -N::
 --namespaces::
 	Include namespace info in the listing.  Namespace info is
-	included by default, specify '--no-namespaces' to omit.
+	listed by default if no other options are specified to the command.
 
 -i::
 --idle::
diff --git a/builtin-list.c b/builtin-list.c
index 413b36ac0208..df0871ab544a 100644
--- a/builtin-list.c
+++ b/builtin-list.c
@@ -22,9 +22,7 @@ static struct {
 	bool regions;
 	bool namespaces;
 	bool idle;
-} list = {
-	.namespaces = true,
-};
+} list;
 
 static struct {
 	const char *bus;
@@ -222,6 +220,9 @@ int cmd_list(int argc, const char **argv)
 	unsigned int type = 0;
 	int i, rc;
 
+	if (argc == 1)
+		list.namespaces = true;
+
         argc = parse_options(argc, argv, options, u, 0);
 	for (i = 0; i < argc; i++)
 		error("unknown parameter \"%s\"\n", argv[i]);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
