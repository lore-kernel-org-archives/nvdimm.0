Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADF0221165249
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 16:38:42 -0700 (PDT)
Subject: [nvdimm PATCH 2/6] nvdimm: Sanity check labeloff
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 10 Oct 2018 16:38:41 -0700
Message-ID: <20181010233830.12228.1116.stgit@localhost.localdomain>
In-Reply-To: <20181010233428.12228.26106.stgit@localhost.localdomain>
References: <20181010233428.12228.26106.stgit@localhost.localdomain>
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
To: dan.j.williams@intel.com, linux-nvdimm@lists.01.org
Cc: alexander.h.duyck@linux.intel.com, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This patch adds validation for the labeloff field in the indexes.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/nvdimm/label.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 1d28cd656536..1f5842509dbc 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -183,6 +183,13 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
 					__le64_to_cpu(nsindex[i]->otheroff));
 			continue;
 		}
+		if (__le64_to_cpu(nsindex[i]->labeloff)
+				!= 2 * sizeof_namespace_index(ndd)) {
+			dev_dbg(dev, "nsindex%d labeloff: %#llx invalid\n",
+					i, (unsigned long long)
+					__le64_to_cpu(nsindex[i]->labeloff));
+			continue;
+		}
 
 		size = __le64_to_cpu(nsindex[i]->mysize);
 		if (size > sizeof_namespace_index(ndd)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
