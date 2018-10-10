Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DE572116524E
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 16:38:56 -0700 (PDT)
Subject: [nvdimm PATCH 3/6] nvdimm: Clarify comment in sizeof_namespace_index
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 10 Oct 2018 16:38:55 -0700
Message-ID: <20181010233847.12228.24818.stgit@localhost.localdomain>
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

When working on the label code I found it rather confusing to see several
spots that reference a minimum label size of 256 while working with labels
that are 128 bytes in size.

This patch is meant to provide a clarification on one of the comments that
was at the heart of the issue. Specifically for version 1.2 and later of
the namespace specification the minimum label size is 256, prior to that
the minimum label size was 128. So we should state that as such to avoid
confusion.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/nvdimm/label.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 1f5842509dbc..bb813b8e8ace 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -75,7 +75,8 @@ size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd)
 	/*
 	 * Per UEFI 2.7, the minimum size of the Label Storage Area is large
 	 * enough to hold 2 index blocks and 2 labels.  The minimum index
-	 * block size is 256 bytes, and the minimum label size is 256 bytes.
+	 * block size is 256 bytes. The label size is 128 for namespaces
+	 * prior to version 1.2 and at minimum 256 for version 1.2 and later.
 	 */
 	nslot = nvdimm_num_label_slots(ndd);
 	space = ndd->nsarea.config_size - nslot * sizeof_namespace_label(ndd);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
