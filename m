Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr
 [80.12.242.125]) (using TLSv1 with cipher AES128-SHA (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6705321E2BE3B
 for <linux-nvdimm@lists.01.org>; Sat, 26 Aug 2017 23:29:59 -0700 (PDT)
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] libnvdimm, btt: check memory allocation failure
Date: Sun, 27 Aug 2017 08:30:34 +0200
Message-Id: <20170827063034.4802-1-christophe.jaillet@wanadoo.fr>
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
To: dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Check memory allocation failures and return -ENOMEM in such cases, as
already done few lines below for another memory allocation.

This avoids NULL pointers dereference.

Fixes: 14e494542636 ("libnvdimm, btt: BTT updates for UEFI 2.7 format")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/nvdimm/btt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 60491641a8d6..607184ebcfbf 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1431,6 +1431,8 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
 	}
 
 	btt_sb = devm_kzalloc(&nd_btt->dev, sizeof(*btt_sb), GFP_KERNEL);
+	if (!btt_sb)
+		return -ENOMEM;
 
 	/*
 	 * If this returns < 0, that is ok as it just means there wasn't
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
