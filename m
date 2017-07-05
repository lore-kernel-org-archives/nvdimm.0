Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8412921A00AC9
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 14:04:39 -0700 (PDT)
Subject: [PATCH] libnvdimm, namespace: record 'lbasize' for pmem namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Jul 2017 13:59:52 -0700
Message-ID: <149928839261.28044.16763403749209224411.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Commit f979b13c3cc5 "libnvdimm, label: honor the lba size specified in
v1.2 labels") neglected to update the 'lbasize' in the label when the
namespace sector_size attribute was written. We need this value in the
label for inter-OS / pre-OS compatibility.

Fixes: f979b13c3cc5 ("libnvdimm, label: honor the lba size specified in v1.2 labels")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 922b68718a1a..87796f840777 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -660,6 +660,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nd_label->position = __cpu_to_le16(pos);
 	nd_label->isetcookie = __cpu_to_le64(cookie);
 	nd_label->rawsize = __cpu_to_le64(resource_size(res));
+	nd_label->lbasize = __cpu_to_le64(nspm->lbasize);
 	nd_label->dpa = __cpu_to_le64(res->start);
 	nd_label->slot = __cpu_to_le32(slot);
 	if (namespace_label_has(ndd, type_guid))

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
