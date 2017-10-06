Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D3CC21FC7476
 for <linux-nvdimm@lists.01.org>; Fri,  6 Oct 2017 15:39:12 -0700 (PDT)
Subject: [PATCH v7 10/12] device-dax: wire up ->lease_direct()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Oct 2017 15:36:11 -0700
Message-ID: <150732937143.22363.13161962109863846755.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-rdma@vger.kernel.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The only event that will break a lease_direct lease in the device-dax
case is the device shutdown path where the physical pages might get
assigned to another device.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c      |    4 ++++
 fs/Kconfig                |    4 ++++
 fs/Makefile               |    3 ++-
 include/linux/mapdirect.h |    2 +-
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index e9f3b3e4bbf4..fa75004185c4 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -10,6 +10,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/mapdirect.h>
 #include <linux/pagemap.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -430,6 +431,7 @@ static int dev_dax_fault(struct vm_fault *vmf)
 static const struct vm_operations_struct dax_vm_ops = {
 	.fault = dev_dax_fault,
 	.huge_fault = dev_dax_huge_fault,
+	.lease_direct = map_direct_lease,
 };
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
@@ -540,8 +542,10 @@ static void kill_dev_dax(struct dev_dax *dev_dax)
 {
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct inode *inode = dax_inode(dax_dev);
+	const bool wait = true;
 
 	kill_dax(dax_dev);
+	break_layout(inode, wait);
 	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
 }
 
diff --git a/fs/Kconfig b/fs/Kconfig
index 7aee6d699fd6..2e3784ae1bc4 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -58,6 +58,10 @@ config FS_DAX_PMD
 	depends on ZONE_DEVICE
 	depends on TRANSPARENT_HUGEPAGE
 
+config DAX_MAP_DIRECT
+	bool
+	default FS_DAX || DEV_DAX
+
 endif # BLOCK
 
 # Posix ACL utility routines
diff --git a/fs/Makefile b/fs/Makefile
index c0e791d235d8..21b8fb104656 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -29,7 +29,8 @@ obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_USERFAULTFD)	+= userfaultfd.o
 obj-$(CONFIG_AIO)               += aio.o
-obj-$(CONFIG_FS_DAX)		+= dax.o mapdirect.o
+obj-$(CONFIG_FS_DAX)		+= dax.o
+obj-$(CONFIG_DAX_MAP_DIRECT)	+= mapdirect.o
 obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
diff --git a/include/linux/mapdirect.h b/include/linux/mapdirect.h
index dc4d4ba677d0..bafa78a6085f 100644
--- a/include/linux/mapdirect.h
+++ b/include/linux/mapdirect.h
@@ -26,7 +26,7 @@ struct lease_direct {
 	struct lease_direct_state *lds;
 };
 
-#if IS_ENABLED(CONFIG_FS_DAX)
+#if IS_ENABLED(CONFIG_DAX_MAP_DIRECT)
 struct map_direct_state *map_direct_register(int fd, struct vm_area_struct *vma);
 int put_map_direct_vma(struct map_direct_state *mds);
 void get_map_direct_vma(struct map_direct_state *mds);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
