Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1E301A1DF5
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 07:02:02 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] libnvdimm: Fix memory leak in error path.
Date: Wed,  3 Aug 2016 16:01:56 +0200
Message-Id: <1470232916-82917-1-git-send-email-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NVDIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

If either device_register() or nvdimm_bus_create_ndclt() fails we leak the
memory allocated for nvdimm_bus. Call kfree(nvdimm_bus) in the error path so
it's not leaked.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvdimm/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index be89764..8578365 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -366,6 +366,7 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 	return nvdimm_bus;
  err:
 	put_device(&nvdimm_bus->dev);
+	kfree(nvdimm_bus);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__nvdimm_bus_register);
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
