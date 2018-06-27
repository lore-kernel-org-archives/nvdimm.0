Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17C8021B02845
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 16:19:12 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: Add CONTRIBUTING.md
Date: Wed, 27 Jun 2018 17:19:05 -0600
Message-Id: <20180627231905.771-1-vishal.l.verma@intel.com>
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

We were missing a CONTRIBUTING file to help new contributors follow the
expected guidelines. Add one that refers to the Linux Kernel for most of
these things, such as Coding style, Submitting Patches, and the DCO.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 CONTRIBUTING.md | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 CONTRIBUTING.md

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
new file mode 100644
index 0000000..aa9e78d
--- /dev/null
+++ b/CONTRIBUTING.md
@@ -0,0 +1,31 @@
+# Contributing to ndctl
+
+Thanks for taking the time to contribute to ndctl.
+
+The following is a set of guidelines that we adhere to, and request that
+contributors follow.
+
+1. The libnvdimm (kernel subsystem) and ndctl developers primarily use
+   the [linux-nvdimm](https://lists.01.org/mailman/listinfo/linux-nvdimm)
+   mailing list for discussions as well as posting patches.
+1. Github [issues](https://github.com/pmem/ndctl/issues) are an acceptable
+   way to report a problem, but if you just have a question,
+   [email](mailto:linux-nvdimm@lists.01.org) the above list.
+1. We follow the Linux Kernel [Coding Style Guide][cs] as applicable.
+
+   [cs]: https://www.kernel.org/doc/html/latest/process/coding-style.html
+
+1. We follow the Linux Kernel [Submitting Patches Guide][sp] as applicable.
+
+   [sp]: https://www.kernel.org/doc/html/latest/process/submitting-patches.html
+
+1. We follow the Linux Kernel [DCO][dco] (Developer Certificate of Origin).
+   The DCO is an attestation attached to every contribution made by every
+   developer. In the commit message of the contribution, the developer simply
+   adds a Signed-off-by statement and thereby agrees to the DCO.
+
+   [dco]: https://developercertificate.org/
+
+1. Github Pull Requests are acceptable, but won't be merged directly, as
+   Github doesn't allow for the kernel style flow of patches where a maintainer
+   also signs off on the patches they apply.
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
