Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1763E21CF25A1
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 14:03:10 -0700 (PDT)
Subject: [PATCH] device-dax: fix 'passing zero to ERR_PTR()' warning
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Jul 2017 13:58:31 -0700
Message-ID: <149989311159.21424.6403870262398704436.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Dan Carpenter reports:

    The patch 7b6be8444e0f: "dax: refactor dax-fs into a generic provider
    of 'struct dax_device' instances" from Apr 11, 2017, leads to the
    following static checker warning:

        drivers/dax/device.c:643 devm_create_dev_dax()
        warn: passing zero to 'ERR_PTR'

Fix the case where we inadvertently leak 0 to ERR_PTR() by setting at
every error case, and make it clear that 'count' is never 0.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 12943d19bfc4..44d72e5e64cc 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -567,7 +567,10 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	struct inode *inode;
 	struct device *dev;
 	struct cdev *cdev;
-	int rc = 0, i;
+	int rc, i;
+
+	if (!count)
+		return ERR_PTR(-EINVAL);
 
 	dev_dax = kzalloc(sizeof(*dev_dax) + sizeof(*res) * count, GFP_KERNEL);
 	if (!dev_dax)
@@ -598,8 +601,10 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	 * device outside of mmap of the resulting character device.
 	 */
 	dax_dev = alloc_dax(dev_dax, NULL, NULL);
-	if (!dax_dev)
+	if (!dax_dev) {
+		rc = -ENOMEM;
 		goto err_dax;
+	}
 
 	/* from here on we're committed to teardown via dax_dev_release() */
 	dev = &dev_dax->dev;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
