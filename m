Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F2EA212E258A
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:57:09 -0700 (PDT)
Subject: [ndctl PATCH v2 12/26] ndctl/namespace: Minimize label data
 transfer for autolabel
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:40:25 -0700
Message-ID: <156426362517.531577.97948221719947571.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Use the new ndctl_dimm_read_label_index() helper to minimize the amount
of label I/O needed to execute an autolabel event.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 645aa14882bb..a3963d79831a 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1029,7 +1029,7 @@ retry:
 		int num_labels, avail;
 
 		ndctl_cmd_unref(cmd_read);
-		cmd_read = ndctl_dimm_read_labels(dimm);
+		cmd_read = ndctl_dimm_read_label_index(dimm);
 		if (!cmd_read)
 			continue;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
