Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20F5A2021B711
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 17:19:41 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/3] Documentation: clarify bus/dimm/region filtering
Date: Wed, 28 Aug 2019 18:17:34 -0600
Message-Id: <20190829001735.30289-3-vishal.l.verma@intel.com>
In-Reply-To: <20190829001735.30289-1-vishal.l.verma@intel.com>
References: <20190829001735.30289-1-vishal.l.verma@intel.com>
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
Cc: Steve Scargall <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Reword the option descriptions in xable-{bus,dimm,region}-options.txt to
clarify that the options are a filtering restriction rather than a
directive to perform an action on the supplied objects, especially in
case of the 'all' keyword.

Link: https://github.com/pmem/ndctl/issues/106
Cc: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Steve Scargal <steve.scargall@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/xable-bus-options.txt    | 7 ++++---
 Documentation/ndctl/xable-dimm-options.txt   | 7 ++++---
 Documentation/ndctl/xable-region-options.txt | 7 ++++---
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/Documentation/ndctl/xable-bus-options.txt b/Documentation/ndctl/xable-bus-options.txt
index 8813113..6e0435a 100644
--- a/Documentation/ndctl/xable-bus-options.txt
+++ b/Documentation/ndctl/xable-bus-options.txt
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-Enforce that the operation only be carried on devices that are
-attached to the given bus. Where 'bus' can be a provider name or a bus
-id number.
+A bus id number, or a provider string (e.g. "ACPI.NFIT"). Restrict the
+operation to the specified bus(es). The keyword 'all' can be specified
+to indicate the lack of any restriction, however this is the same as
+not supplying a --bus option at all.
diff --git a/Documentation/ndctl/xable-dimm-options.txt b/Documentation/ndctl/xable-dimm-options.txt
index 8826c2b..c5b9c8c 100644
--- a/Documentation/ndctl/xable-dimm-options.txt
+++ b/Documentation/ndctl/xable-dimm-options.txt
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-A 'nmemX' device name, or a dimm id number. The keyword 'all' can
-be specified to carry out the operation on every dimm in the system,
-optionally filtered by bus id (see --bus= option).
+A 'nmemX' device name, or a dimm id number. Restrict the operation to
+the specified dimm(s). The keyword 'all' can be specified to indicate
+the lack of any restriction, however this is the same as not supplying
+a --dimm option at all.
diff --git a/Documentation/ndctl/xable-region-options.txt b/Documentation/ndctl/xable-region-options.txt
index d5198f5..e098684 100644
--- a/Documentation/ndctl/xable-region-options.txt
+++ b/Documentation/ndctl/xable-region-options.txt
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-A 'regionX' device name, or a region id number. The keyword 'all' can
-be specified to carry out the operation on every region in the system,
-optionally filtered by bus id (see --bus= option).
+A 'regionX' device name, or a region id number. Restrict the operation to
+the specified region(s). The keyword 'all' can be specified to indicate
+the lack of any restriction, however this is the same as not supplying a
+--region option at all.
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
