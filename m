Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F9751A1E28
 for <linux-nvdimm@lists.01.org>; Thu, 27 Oct 2016 17:21:04 -0700 (PDT)
Subject: [PATCH] device-dax: fix percpu_ref_exit ordering
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Oct 2016 17:18:02 -0700
Message-ID: <147761388212.10087.4433175969243569236.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We need to wait until the percpu_ref is released before exit. Otherwise,
we sometimes lose the race and trigger this new warning that was added
in v4.9 (commit a67823c1ed10 "percpu-refcount: init ->confirm_switch
member properly"):

 WARNING: CPU: 0 PID: 3629 at lib/percpu-refcount.c:107 percpu_ref_exit+0x51/0x60
 [..]
 Call Trace:
  [<ffffffff814bf093>] dump_stack+0x85/0xc2
  [<ffffffff810b15db>] __warn+0xcb/0xf0
  [<ffffffff810b170d>] warn_slowpath_null+0x1d/0x20
  [<ffffffff814d70c1>] percpu_ref_exit+0x51/0x60
  [<ffffffffa005706a>] dax_pmem_percpu_exit+0x1a/0x50 [dax_pmem]
  [<ffffffff81615f1f>] devm_action_release+0xf/0x20

Cc: <stable@vger.kernel.org>
Fixes: ab68f2622136 ("/dev/dax, pmem: direct access to persistent memory")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/pmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 9630d8837ba9..4a15fa5df98b 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -44,7 +44,6 @@ static void dax_pmem_percpu_exit(void *data)
 
 	dev_dbg(dax_pmem->dev, "%s\n", __func__);
 	percpu_ref_exit(ref);
-	wait_for_completion(&dax_pmem->cmp);
 }
 
 static void dax_pmem_percpu_kill(void *data)
@@ -54,6 +53,7 @@ static void dax_pmem_percpu_kill(void *data)
 
 	dev_dbg(dax_pmem->dev, "%s\n", __func__);
 	percpu_ref_kill(ref);
+	wait_for_completion(&dax_pmem->cmp);
 }
 
 static int dax_pmem_probe(struct device *dev)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
