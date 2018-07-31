Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FE5621BADAB2
 for <linux-nvdimm@lists.01.org>; Tue, 31 Jul 2018 07:32:50 -0700 (PDT)
From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH] device-dax: avoid hang on error before devm_memremap_pages()
Date: Tue, 31 Jul 2018 15:32:46 +0100
Message-Id: <20180731143246.16915-1-stefanha@redhat.com>
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
Cc: linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

dax_pmem_percpu_exit() waits for dax_pmem_percpu_release() to invoke the
dax_pmem->cmp completion.  Unfortunately this approach to cleaning up
the percpu_ref only works after devm_memremap_pages() was successful.

If devm_add_action_or_reset() or devm_memremap_pages() fails,
dax_pmem_percpu_release() is not invoked.  Therefore
dax_pmem_percpu_exit() hangs waiting for the completion:

  rc = devm_add_action_or_reset(dev, dax_pmem_percpu_exit,
  				&dax_pmem->ref);
  if (rc)
  	return rc;

  dax_pmem->pgmap.ref = &dax_pmem->ref;
  addr = devm_memremap_pages(dev, &dax_pmem->pgmap);

Avoid the hang by calling percpu_ref_exit() in the error paths instead
of going through dax_pmem_percpu_exit().

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
Found by code inspection.  Compile-tested only.
---
 drivers/dax/pmem.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index fd49b24fd6af..99e2aace8078 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -105,15 +105,19 @@ static int dax_pmem_probe(struct device *dev)
 	if (rc)
 		return rc;
 
-	rc = devm_add_action_or_reset(dev, dax_pmem_percpu_exit,
-							&dax_pmem->ref);
-	if (rc)
+	rc = devm_add_action(dev, dax_pmem_percpu_exit, &dax_pmem->ref);
+	if (rc) {
+		percpu_ref_exit(&dax_pmem->ref);
 		return rc;
+	}
 
 	dax_pmem->pgmap.ref = &dax_pmem->ref;
 	addr = devm_memremap_pages(dev, &dax_pmem->pgmap);
-	if (IS_ERR(addr))
+	if (IS_ERR(addr)) {
+		devm_remove_action(dev, dax_pmem_percpu_exit, &dax_pmem->ref);
+		percpu_ref_exit(&dax_pmem->ref);
 		return PTR_ERR(addr);
+	}
 
 	rc = devm_add_action_or_reset(dev, dax_pmem_percpu_kill,
 							&dax_pmem->ref);
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
