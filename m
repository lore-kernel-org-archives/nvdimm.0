Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CFA21A1E08
 for <linux-nvdimm@lists.01.org>; Fri,  2 Sep 2016 10:01:18 -0700 (PDT)
Subject: [PATCH] ndctl: fixup recommended unit test build procedure
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 02 Sep 2016 09:58:55 -0700
Message-ID: <147283553552.36008.1894782621608987887.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Yilong Ren <yilongx.ren@intel.com>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

When building with -O and -C Yilong found the following build error:

    make[2]: *** No rule to make target
	'tools/testing/nvdimm//config_check.o', needed by
	'tools/testing/nvdimm//dax.o'.

It is addressed by dropping the trailing '/' off of the
"M=tools/testing/nvdimm" option passed to kbuild.

Reported-by: Yilong Ren <yilongx.ren@intel.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 README.md |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/README.md b/README.md
index a3def786f188..7256c2f15e20 100644
--- a/README.md
+++ b/README.md
@@ -49,8 +49,8 @@ git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git`
 4. Build and install the unit test enabled libnvdimm modules in the
    following order.  The unit test modules need to be in place prior to
    the `depmod` that runs during the final `modules_install`  
-`make M=tools/testing/nvdimm/`  
-`sudo make M=tools/testing/nvdimm/ modules_install`  
+`make M=tools/testing/nvdimm`  
+`sudo make M=tools/testing/nvdimm modules_install`  
 `sudo make modules_install`
 
 5. Now run `make check` in the ndctl source directory, or `ndctl test`,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
