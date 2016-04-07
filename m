Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 95D4D1A1FA7
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 18:07:55 -0700 (PDT)
Subject: [ndctl PATCH 1/5] ndctl: rebuild libndctl.h when libndctl.h.in changes
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Apr 2016 18:07:04 -0700
Message-ID: <20160407010704.30641.88286.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
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

Since libnctl.h is build via an AC_CONFIG_COMMANDS() statement we want
configure to re-run if libndctl.h.in is changed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 7de3d3c3c9eb..379f6404671f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,7 +29,9 @@ AM_LDFLAGS = \
 	-Wl,--gc-sections \
 	-Wl,--as-needed
 
-BUILT_SOURCES = $(top_srcdir)/version.m4
+BUILT_SOURCES = $(top_srcdir)/version.m4 $(top_srcdir)/lib/ndctl/libndctl.h
+$(top_srcdir)/lib/ndctl/libndctl.h: $(top_srcdir)/lib/ndctl/libndctl.h.in
+	touch $(top_srcdir)/version.m4
 $(top_srcdir)/version.m4: FORCE
 	$(AM_V_GEN)$(top_srcdir)/git-version-gen
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
