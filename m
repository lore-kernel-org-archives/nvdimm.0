Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E2A78185E
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jan 2017 12:01:49 -0800 (PST)
Subject: [ndctl PATCH] test: document workaround for unit-test-module load
 priority
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 05 Jan 2017 11:57:42 -0800
Message-ID: <148364626246.6839.10068069759763418193.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On some distributions it appears the recommended kernel build procedure
can sometimes prefer the in-tree module over an out-of-tree module of
the same name in the /lib/modules/<kver>/extra directory. This can be
worked around with an explicit depmod.d policy. Document how to setup
this workaround.

Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 README.md |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/README.md b/README.md
index e9dec67a0ea2..38fc050210c3 100644
--- a/README.md
+++ b/README.md
@@ -56,3 +56,29 @@ git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git`
 5. Now run `make check` in the ndctl source directory, or `ndctl test`,
    if ndctl was built with `--enable-test`.
 
+Troubleshooting
+===============
+
+The unit tests will validate that the environment is set up correctly
+before they try to run. If the platform is misconfigured, i.e. the unit
+test modules are not available, or the test versions of the modules are
+superseded by the "in-tree/production" version of the modules `make
+check` will skip tests and report a message like the following in
+test/test-suite.log:  
+`SKIP: libndctl`  
+`==============`  
+`test/init: nfit_test_init: nfit.ko: appears to be production version: /lib/modules/4.8.8-200.fc24.x86_64/kernel/drivers/acpi/nfit/nfit.ko.xz`  
+`__ndctl_test_skip: explicit skip test_libndctl:2684`  
+`nfit_test unavailable skipping tests`  
+
+If the unit test modules are indeed available in the modules 'extra'
+directory the default depmod policy can be overridden by adding a file
+to /etc/depmod.d with the following contents:  
+`override nfit * extra`  
+`override dax * extra`  
+`override dax_pmem * extra`  
+`override libnvdimm * extra`  
+`override nd_blk * extra`  
+`override nd_btt * extra`  
+`override nd_e820 * extra`  
+`override nd_pmem * extra`  

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
