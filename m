Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D181121309DC0
 for <linux-nvdimm@lists.01.org>; Thu,  8 Aug 2019 10:59:40 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] Documentation/namespace-description: Clarify
 label-less restrictions
Date: Thu,  8 Aug 2019 11:57:07 -0600
Message-Id: <20190808175707.9089-1-vishal.l.verma@intel.com>
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

In the ndctl-create-namespace (and related) man pages, add a
clarification note regarding some of the restrictions a user may see
when operating on label-less namespaces.

Link: https://github.com/pmem/ndctl/issues/52
Reported-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

v2:
- Remove the part about an address abstraction mechanism; It didn't add
  any value (Jeff)
- Add an additional sentence about space reclamation semantics (Dan)

 Documentation/ndctl/namespace-description.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/ndctl/namespace-description.txt b/Documentation/ndctl/namespace-description.txt
index 94999e5..c59fbef 100644
--- a/Documentation/ndctl/namespace-description.txt
+++ b/Documentation/ndctl/namespace-description.txt
@@ -18,6 +18,15 @@ the kernel's 'memmap=ss!nn' command line option (see the nvdimm wiki on
 kernel.org), or NVDIMMs without a valid 'namespace index' in their label
 area.
 
+NOTE: Label-less namespaces lack many of the features of their label-rich
+cousins. For example, their size cannot be modified, or they cannot be
+fully 'destroyed' (i.e. the space reclaimed). A destroy operation will
+zero any mode-specific metadata. Finally, for create-namespace operations
+on label-less namespaces, ndctl bypasses the region capacity availability
+checks, and always satisfies the request using the full region capacity.
+The only reconfiguration operation supported on a label-less namespace
+is changing its 'mode'.
+
 A namespace can be provisioned to operate in one of 4 modes, 'fsdax',
 'devdax', 'sector', and 'raw'. Here are the expected usage models for
 these modes:
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
