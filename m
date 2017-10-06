Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10D2C21EA15BD
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 18:52:49 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/8] ndctl,
 list: move the --human description to an include
Date: Thu,  5 Oct 2017 19:53:59 -0600
Message-Id: <20171006015405.29908-3-vishal.l.verma@intel.com>
In-Reply-To: <20171006015405.29908-1-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for inject-error, move the --human option description
to a file that can be included. Reword the description improving
the grammar, and making it more generic.

The example in the list man page for --human was also missing a [verse]
keyword, making the --human part of the example appear in a single line
rather than formatted json - fix that.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/human-option.txt | 5 +++++
 Documentation/ndctl/ndctl-list.txt   | 8 ++------
 2 files changed, 7 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ndctl/human-option.txt

diff --git a/Documentation/ndctl/human-option.txt b/Documentation/ndctl/human-option.txt
new file mode 100644
index 0000000..ce2fefa
--- /dev/null
+++ b/Documentation/ndctl/human-option.txt
@@ -0,0 +1,5 @@
+-u::
+--human::
+	Format numbers representing storage sizes, or offsets as human
+	readable strings with units instead of the default machine-friendly
+	raw-integer data. Convert other numeric fields into hexadecimal strings.
diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index cdcf238..e19ded8 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -180,12 +180,7 @@ include::xable-region-options.txt[]
   ]
 }
 
--u::
---human::
-	By default 'ndctl list' will output machine-friendly raw-integer
-	data. Instead, with this flag, numbers representing storage size
-	will be formatted as human readable strings with units, other
-	fields are converted to hexadecimal strings.  Example:
+include::human-option.txt[]
 
 [verse]
 # ndctl list --region=7
@@ -198,6 +193,7 @@ include::xable-region-options.txt[]
   "badblock_count":8
 }
 
+[verse]
 # ndctl list --human --region=7
 {
   "dev":"region7",
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
