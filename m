Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 97D2821DFA7BA
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 16:19:17 -0700 (PDT)
Subject: [ndctl PATCH 3/6] Documentation, list: add --mode,
 -m description to man page
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 16:14:07 -0700
Message-ID: <149074284741.18735.94167498313502915.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Document the new option added in commit b17f21f7fae7 "ndctl, list: add
option to filter namespace by mode".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-list.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index bb7db47e7af8..444a6f998f19 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -78,6 +78,11 @@ include::xable-region-options.txt[]
 --type=::
 	Filter listing by region type ('pmem' or 'blk')
 
+-m::
+--mode=::
+	Filter listing by the mode ('raw', 'memory', 'sector' or 'dax')
+	of the namespace(s).
+
 -B::
 --buses::
 	Include bus info in the listing

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
