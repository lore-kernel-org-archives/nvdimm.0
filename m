Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02A8121B02822
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 16:39:06 -0700 (PDT)
Subject: [nvdimm PATCH 4/6] nvdimm: Remove empty if statement
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 10 Oct 2018 16:39:06 -0700
Message-ID: <20181010233901.12228.21705.stgit@localhost.localdomain>
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

This patch removes an empty statement from an if expression and promotes
the else statement to the if expression with the expression logic reversed.

I feel this is more readable as the empty statement can lead to issues if
any additional logic was ever added.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/nvdimm/label.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index bb813b8e8ace..43bad0d5bdb6 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -261,9 +261,8 @@ int nd_label_validate(struct nvdimm_drvdata *ndd)
 void nd_label_copy(struct nvdimm_drvdata *ndd, struct nd_namespace_index *dst,
 		struct nd_namespace_index *src)
 {
-	if (dst && src)
-		/* pass */;
-	else
+	/* just exit if either destination or source is NULL */
+	if (!dst || !src)
 		return;
 
 	memcpy(dst, src, sizeof_namespace_index(ndd));

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
