Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id EC2281A1E00
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 11:38:54 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: update readme for vmalloc() based nfit_test
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Jun 2016 11:37:38 -0700
Message-ID: <146705265796.37678.13860374642984087356.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

In v4.8 when we have vmalloc() based nfit_test the test configuration no
longer requires a CMA allocation.  While we're updating the document,
also refresh the configuration variables.

Reported-by: Yigal Korman <yigal@plexistor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 README.md |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/README.md b/README.md
index 76f93dafe4cb..a3def786f188 100644
--- a/README.md
+++ b/README.md
@@ -26,19 +26,25 @@ loaded.  To build and install nfit_test.ko:
 `git clone -b libnvdimm-for-next
 git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git`  
 
-2. Configure the kernel to make some memory available to CMA (contiguous
-   memory allocator).
-This will be used to emulate DAX.  
+2. Skip to step 3 if the kernel version is >= v4.8.  Otherwise, for
+   kernel versions < v4.8, configure the kernel to make some memory
+   available to CMA (contiguous memory allocator). This will be used to
+   emulate DAX.  
 `CONFIG_DMA_CMA=y`  
 `CONFIG_CMA_SIZE_MBYTES=200`  
 **or**  
 `cma=200M` on the kernel command line.  
 
-3. Compile all components of the libnvdimm sub-system as modules:  
+3. Compile the libnvdimm sub-system as a module, make sure "zone device"
+   memory is enabled, and enable the btt, pfn, and dax features of the
+   sub-system:  
+`CONFIG_ZONE_DEVICE=y`  
 `CONFIG_LIBNVDIMM=m`  
 `CONFIG_BLK_DEV_PMEM=m`  
 `CONFIG_ND_BLK=m`  
-`CONFIG_ND_BTT=m`  
+`CONFIG_BTT=y`  
+`CONFIG_NVDIMM_PFN=y`  
+`CONFIG_NVDIMM_DAX=y`  
 
 4. Build and install the unit test enabled libnvdimm modules in the
    following order.  The unit test modules need to be in place prior to

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
