Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 5CD6B1A1FB8
 for <linux-nvdimm@lists.01.org>; Wed, 30 Mar 2016 18:50:21 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: SUSE spec file fixups
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Mar 2016 18:49:13 -0700
Message-ID: <20160331014913.32880.99267.stgit@dwillia2-desk3.jf.intel.com>
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

Per recent build.opensuse.org results:

1/ The SLE_12 target still mandates use of %defattr

2/ The SUSE-rpmlint system now enforces license names from
   https://license.opensuse.org

3/ The libndctl version suffix needs to account for LIBNDCTL_AGE, not
   just LIBNDCTL_CURRENT.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am   |    6 ++++--
 ndctl.spec.in |    3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 3f7dca3d37e8..7de3d3c3c9eb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -56,12 +56,14 @@ CLEANFILES += $(noinst_SCRIPTS)
 
 do_rhel_subst = sed -e 's,VERSION,$(VERSION),g' \
             -e 's,DNAME,ndctl-devel,g' \
-            -e 's,LNAME,ndctl-libs,g'
+            -e '/^%defattr.*/d' \
+	    -e 's,LNAME,ndctl-libs,g'
 
 do_sles_subst = sed -e 's,VERSION,$(VERSION),g' \
             -e 's,DNAME,libndctl-devel,g' \
             -e 's,%license,%doc,g' \
-            -e 's,LNAME,libndctl$(LIBNDCTL_CURRENT),g'
+            -e 's,\(^License:.*GPL\)v2,\1-2.0,g' \
+            -e "s,LNAME,libndctl$$(($(LIBNDCTL_CURRENT) - $(LIBNDCTL_AGE))),g"
 
 rhel/ndctl.spec: ndctl.spec.in Makefile.am
 	$(AM_V_GEN)$(MKDIR_P) rhel; $(do_rhel_subst) < $< > $@
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 6f6e99bd743b..e24b31cc54f0 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -65,16 +65,19 @@ make check
 %postun -n LNAME -p /sbin/ldconfig
 
 %files
+%defattr(-,root,root)
 %license licenses/GPLv2 licenses/BSD-MIT licenses/CC0
 %{_bindir}/ndctl
 %{_mandir}/man1/*
 
 %files -n LNAME
+%defattr(-,root,root)
 %doc README.md
 %license COPYING licenses/BSD-MIT licenses/CC0
 %{_libdir}/libndctl.so.*
 
 %files -n DNAME
+%defattr(-,root,root)
 %license COPYING
 %{_includedir}/ndctl/
 %{_libdir}/libndctl.so

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
