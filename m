Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 3E12B1A1E13
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 20:27:59 -0700 (PDT)
Subject: [PATCH 7/7] dax: unmap/truncate on device shutdown
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 20:25:35 -0700
Message-ID: <147131793557.13727.4080875938782302791.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

Invalidate all mappings of a device-dax instance when the device is
unregistered.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index e8b9319aeadb..0a7899d5c65c 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -550,6 +550,7 @@ static void unregister_dax_dev(void *dev)
 	 */
 	dax_dev->alive = false;
 	synchronize_rcu();
+	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
 	cdev_del(cdev);
 	device_unregister(dev);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
