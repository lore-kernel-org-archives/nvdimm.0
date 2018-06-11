Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B9252211B8184
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 06:47:24 -0700 (PDT)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] libnvdimm, namespace: Replace kmemdup() with kstrndup()
Date: Mon, 11 Jun 2018 16:47:21 +0300
Message-Id: <20180611134721.5862-1-andriy.shevchenko@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

kstrndup() takes care of '\0' terminator for the strings.

Use it here instead of kmemdup() + explicit terminating the input string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 28afdd668905..19525f025539 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -270,11 +270,10 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
 	if (dev->driver || to_ndns(dev)->claim)
 		return -EBUSY;
 
-	input = kmemdup(buf, len + 1, GFP_KERNEL);
+	input = kstrndup(buf, len, GFP_KERNEL);
 	if (!input)
 		return -ENOMEM;
 
-	input[len] = '\0';
 	pos = strim(input);
 	if (strlen(pos) + 1 > NSLABEL_NAME_LEN) {
 		rc = -EINVAL;
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
