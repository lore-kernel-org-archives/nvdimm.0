Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 773C81A1F4D
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 10:55:47 -0800 (PST)
Subject: [ndctl PATCH] ndctl: fix unit test build instructions
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 09 Mar 2016 10:55:06 -0800
Message-ID: <20160309185506.21843.92160.stgit@dwillia2-desk3.jf.intel.com>
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

Use "M=tools/testing/nvdimm" from the kernel build directory rather than
"-C tools/testing/nvdimm".  This arranges for the unit test modules to
honor a "localversion" file like the one distributed by the -next tree.
Also switch from 'install' to 'modules_install' to trigger depmod to run
after the modules are installed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 README.md |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/README.md b/README.md
index 3f62adce2f92..af2d7881ec51 100644
--- a/README.md
+++ b/README.md
@@ -40,12 +40,9 @@ This will be used to emulate DAX.
 `CONFIG_ND_BLK=m`  
 `CONFIG_ND_BTT=m`  
 
-4. Build and install the unit test enabled libnvdimm modules in the
-   following order.  The unit test modules need to be in place prior to
-   the `depmod` that runs during the final `modules_install`  
-`make -C tools/testing/nvdimm/`  
-`sudo make -C tools/testing/nvdimm/ install`  
-`sudo make modules_install`
+4. Build and install the unit test enabled libnvdimm modules.
+`make M=tools/testing/nvdimm/`  
+`sudo make M=tools/testing/nvdimm/ modules_install`  
 
 5. Now run `make check` in the ndctl source directory, or `ndctl test`,
    if ndctl was built with `--enable-test`.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
