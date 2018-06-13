Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBF812128DD4D
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jun 2018 12:01:04 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: Update README.md for code blocks
Date: Wed, 13 Jun 2018 13:00:56 -0600
Message-Id: <20180613190056.2984-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

README.md had inline code blocks for various config lines, but one of
them, "override device_dax * extra", was missing the two spaces at the
end causing the markdown renderer to put the next line adjacent to it
instead of below. This caused depmod to be misconfigured if one
copy-pasted from the github landing page.

Fix this by replacing multi-line code blocks using the "```" block
markers everywhere. Also add the kernel.org wiki URL to the
Documentation section, and fix list numbering.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 README.md | 102 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 41 deletions(-)

diff --git a/README.md b/README.md
index e0bc5b7..b4cf673 100644
--- a/README.md
+++ b/README.md
@@ -5,11 +5,14 @@ sub-system in the Linux kernel
 
 Build
 =====
-`./autogen.sh`  
-`./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64`  
-`make`  
-`make check`  
-`sudo make install`  
+
+```
+./autogen.sh
+./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64
+make
+make check
+sudo make install
+```
 
 There are a number of packages required for the build steps that may not
 be installed by default.   For information about the required packages,
@@ -23,45 +26,56 @@ See the latest documentation for the NVDIMM kernel sub-system here:
   
 https://git.kernel.org/cgit/linux/kernel/git/nvdimm/nvdimm.git/tree/Documentation/nvdimm/nvdimm.txt?h=libnvdimm-for-next
 
+A getting started guide is also available on the kernel.org nvdimm wiki:
+
+https://nvdimm.wiki.kernel.org/start
+
 Unit Tests
 ==========
 The unit tests run by `make check` require the nfit_test.ko module to be
 loaded.  To build and install nfit_test.ko:
 
 1. Obtain the kernel source.  For example,  
-`git clone -b libnvdimm-for-next
-git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git`  
+   `git clone -b libnvdimm-for-next git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git`  
 
-2. Skip to step 3 if the kernel version is >= v4.8.  Otherwise, for
+1. Skip to step 3 if the kernel version is >= v4.8.  Otherwise, for
    kernel versions < v4.8, configure the kernel to make some memory
    available to CMA (contiguous memory allocator). This will be used to
    emulate DAX.  
-`CONFIG_DMA_CMA=y`  
-`CONFIG_CMA_SIZE_MBYTES=200`  
-**or**  
-`cma=200M` on the kernel command line.  
+   ```
+   CONFIG_DMA_CMA=y
+   CONFIG_CMA_SIZE_MBYTES=200
+   ```
+   **or**  
+   `cma=200M` on the kernel command line.  
 
-3. Compile the libnvdimm sub-system as a module, make sure "zone device"
+1. Compile the libnvdimm sub-system as a module, make sure "zone device"
    memory is enabled, and enable the btt, pfn, and dax features of the
    sub-system:  
-`CONFIG_X86_PMEM_LEGACY=m`  
-`CONFIG_ZONE_DEVICE=y`  
-`CONFIG_LIBNVDIMM=m`  
-`CONFIG_BLK_DEV_PMEM=m`  
-`CONFIG_ND_BLK=m`  
-`CONFIG_BTT=y`  
-`CONFIG_NVDIMM_PFN=y`  
-`CONFIG_NVDIMM_DAX=y`  
-`CONFIG_DEV_DAX_PMEM=m`
-
-4. Build and install the unit test enabled libnvdimm modules in the
+
+   ```
+   CONFIG_X86_PMEM_LEGACY=m
+   CONFIG_ZONE_DEVICE=y
+   CONFIG_LIBNVDIMM=m
+   CONFIG_BLK_DEV_PMEM=m
+   CONFIG_ND_BLK=m
+   CONFIG_BTT=y
+   CONFIG_NVDIMM_PFN=y
+   CONFIG_NVDIMM_DAX=y
+   CONFIG_DEV_DAX_PMEM=m
+   ```
+
+1. Build and install the unit test enabled libnvdimm modules in the
    following order.  The unit test modules need to be in place prior to
    the `depmod` that runs during the final `modules_install`  
-`make M=tools/testing/nvdimm`  
-`sudo make M=tools/testing/nvdimm modules_install`  
-`sudo make modules_install`
 
-5. Now run `make check` in the ndctl source directory, or `ndctl test`,
+   ```
+   make M=tools/testing/nvdimm
+   sudo make M=tools/testing/nvdimm modules_install
+   sudo make modules_install
+   ```
+
+1. Now run `make check` in the ndctl source directory, or `ndctl test`,
    if ndctl was built with `--enable-test`.
 
 Troubleshooting
@@ -73,23 +87,29 @@ test modules are not available, or the test versions of the modules are
 superseded by the "in-tree/production" version of the modules `make
 check` will skip tests and report a message like the following in
 test/test-suite.log:  
-`SKIP: libndctl`  
-`==============`  
-`test/init: nfit_test_init: nfit.ko: appears to be production version: /lib/modules/4.8.8-200.fc24.x86_64/kernel/drivers/acpi/nfit/nfit.ko.xz`  
-`__ndctl_test_skip: explicit skip test_libndctl:2684`  
-`nfit_test unavailable skipping tests`  
+
+```
+SKIP: libndctl
+==============
+test/init: nfit_test_init: nfit.ko: appears to be production version: /lib/modules/4.8.8-200.fc24.x86_64/kernel/drivers/acpi/nfit/nfit.ko.xz
+__ndctl_test_skip: explicit skip test_libndctl:2684
+nfit_test unavailable skipping tests
+```
 
 If the unit test modules are indeed available in the modules 'extra'
 directory the default depmod policy can be overridden by adding a file
 to /etc/depmod.d with the following contents:  
-`override nfit * extra`  
-`override device_dax * extra`
-`override dax_pmem * extra`  
-`override libnvdimm * extra`  
-`override nd_blk * extra`  
-`override nd_btt * extra`  
-`override nd_e820 * extra`  
-`override nd_pmem * extra`  
+
+```
+override nfit * extra
+override device_dax * extra
+override dax_pmem * extra
+override libnvdimm * extra
+override nd_blk * extra
+override nd_btt * extra
+override nd_e820 * extra
+override nd_pmem * extra
+```
 
 The nfit_test module emulates pmem with memory allocated via vmalloc().
 One of the side effects is that this breaks 'physically contiguous'
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
