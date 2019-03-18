Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39640211D616E
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 15:54:18 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: update README for depmod overrides,
 ship a sample config
Date: Mon, 18 Mar 2019 16:54:13 -0600
Message-Id: <20190318225413.3196-1-vishal.l.verma@intel.com>
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

With the dax-bus reworks, the new dax_pmem module requires a depmod
override. Add it to README.md

To simplify depmod config updates, ship a sample config in contrib
(doesn't get installed by default), to make for easier updates.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 README.md                     |  2 ++
 contrib/nfit_test_depmod.conf | 11 +++++++++++
 2 files changed, 13 insertions(+)
 create mode 100644 contrib/nfit_test_depmod.conf

diff --git a/README.md b/README.md
index b4cf673..7c420d5 100644
--- a/README.md
+++ b/README.md
@@ -104,6 +104,8 @@ to /etc/depmod.d with the following contents:
 override nfit * extra
 override device_dax * extra
 override dax_pmem * extra
+override dax_pmem_core * extra
+override dax_pmem_compat * extra
 override libnvdimm * extra
 override nd_blk * extra
 override nd_btt * extra
diff --git a/contrib/nfit_test_depmod.conf b/contrib/nfit_test_depmod.conf
new file mode 100644
index 0000000..9f8498e
--- /dev/null
+++ b/contrib/nfit_test_depmod.conf
@@ -0,0 +1,11 @@
+# For nfit_test module overriding - copy to /etc/depmod.d or so
+override nfit * extra
+override device_dax * extra
+override dax_pmem * extra
+override dax_pmem_core * extra
+override dax_pmem_compat * extra
+override libnvdimm * extra
+override nd_blk * extra
+override nd_btt * extra
+override nd_e820 * extra
+override nd_pmem * extra
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
