Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 471201A1F1A
 for <linux-nvdimm@lists.01.org>; Fri, 25 Mar 2016 13:16:32 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: use %doc instead of %license for older SUSE
 environments
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Mar 2016 13:15:25 -0700
Message-ID: <20160325201520.21639.84689.stgit@dwillia2-desk3.jf.intel.com>
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

Per build.opensuse.org build failures, the SLE_12 target wants %doc
instead of %license since /usr/share/license does not exist in that
environment.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile.am b/Makefile.am
index eaf544a96284..3cd2f707f88f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -60,6 +60,7 @@ do_rhel_subst = sed -e 's,VERSION,$(VERSION),g' \
 
 do_sles_subst = sed -e 's,VERSION,$(VERSION),g' \
             -e 's,DNAME,libndctl-devel,g' \
+            -e 's,%license,%doc,g' \
             -e 's,LNAME,libndctl$(LIBNDCTL_CURRENT),g'
 
 rhel/ndctl.spec: ndctl.spec.in Makefile.am

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
