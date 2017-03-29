Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E732C2041FBD0
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 22:06:51 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, {read,
 write}-labels: add long options for -i and -o
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 22:01:41 -0700
Message-ID: <149076370167.25786.11455901992745209762.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Without long options the bash completion code is unable to determine the
available options with "--list-opts".

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-read-labels.txt |    1 +
 ndctl/dimm.c                        |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/ndctl-read-labels.txt b/Documentation/ndctl-read-labels.txt
index 9c3acede8723..ecef164c3283 100644
--- a/Documentation/ndctl-read-labels.txt
+++ b/Documentation/ndctl-read-labels.txt
@@ -18,6 +18,7 @@ OPTIONS
 -------
 include::labels-options.txt[]
 -o::
+--output::
 	output file
 -j::
 --json::
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 4d25417fb2ae..f6a07a7f4c6e 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -790,12 +790,12 @@ OPT_STRING('b', "bus", &param.bus, "bus-id", \
 OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug")
 
 #define READ_OPTIONS() \
-OPT_STRING('o', NULL, &param.outfile, "output-file", \
+OPT_STRING('o', "output", &param.outfile, "output-file", \
 	"filename to write label area contents"), \
 OPT_BOOLEAN('j', "json", &param.json, "parse label data into json")
 
 #define WRITE_OPTIONS() \
-OPT_STRING('i', NULL, &param.infile, "input-file", \
+OPT_STRING('i', "input", &param.infile, "input-file", \
 	"filename to read label area data")
 
 #define INIT_OPTIONS() \

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
