Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41B5581FBB
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 21:09:32 -0800 (PST)
Subject: [PATCH] daxctl: add libuuid to the build
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Feb 2017 21:05:27 -0800
Message-ID: <148704872715.1063.10397645808975705401.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Yilong Ren <yilongx.ren@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

daxctl does have dependencies on the uuid library via util/json.c, but
the build only seems to fail in a Debian build environment. Fix this up.

Reported-by: Yilong Ren <yilongx.ren@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/Makefile.am |    1 +
 1 file changed, 1 insertion(+)

diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index 9153c418cdaf..fe467d030c38 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -10,4 +10,5 @@ daxctl_SOURCES =\
 daxctl_LDADD =\
 	lib/libdaxctl.la \
 	../libutil.a \
+	$(UUID_LIBS) \
 	$(JSON_LIBS)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
