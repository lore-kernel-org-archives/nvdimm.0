Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95D2821E87962
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 20:15:31 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, spec: disable daxctl io on non-x86_64 archs
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 08 Sep 2017 20:12:00 -0700
Message-ID: <150492672007.2886.8876325161627280092.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Similar to the kernel requires CONFIG_ARCH_HAS_PMEM_API for pmem
support, userspace requires libpmem which to date is only packaged for
x86_64.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl.spec.in |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index cf0fcc3e76ea..4aa133dd70aa 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -20,7 +20,9 @@ BuildRequires:	pkgconfig(libudev)
 BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
+%ifarch x86_64
 BuildRequires:	pkgconfig(libpmem)
+%endif
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -91,7 +93,11 @@ control API for these devices.
 %build
 echo "VERSION" > version
 ./autogen.sh
+%ifarch x86_64
 %configure --disable-static --enable-local --disable-silent-rules --with-libpmem
+%else
+%configure --disable-static --enable-local --disable-silent-rules
+%endif
 make %{?_smp_mflags}
 
 %install

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
