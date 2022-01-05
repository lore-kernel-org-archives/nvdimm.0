Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BC62C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418383; x=1672954383;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uPkAE9MY5lMISgIYJ40E2L1wjf93kUPIKI7IvjoLoyA=;
  b=TNegDuT5EndJ0BCy3T7QI0RzNo3jZoDLLVr8+BomNwXYTXA642Q4pawe
   2Q283UZf/iuJtaCwb0R6RARiVAaIAwOgPAp8zgipd6D6F6LUZCADPJYFi
   n6ZscqJX4YTwXrmYr+WAQ5BanYc/AyJ2LitvkaAC3KCgOqIdfZC9131rj
   6MB6KBb0+Bx1fsyQcl7KyRsbxd/sjs3lRuo3FBV6vR9l3H5xy+YuMawdG
   Ny2f2MQk/CoNK7oRY1UYoJbQB2P31DPr1kUkCtntjtkltSmlBgUq6vmv2
   sNdWzvWM3i0HkKNYJXUAwqdOOPKkeZ5crpeZ1trAuN0yQXJ2M02sb3ndu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229354153"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="229354153"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:33:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="513148391"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:33:03 -0800
Subject: [ndctl PATCH v3 16/16] ndctl: Jettison autotools
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:33:03 -0800
Message-ID: <164141838349.3990253.14745993061779737304.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Similar to several other projects, ndctl has run its course with autotools
and sees a better path forward with Meson. Now that the Meson conversion is
complete, remove the autotools infrastructure.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .gitignore                        |   58 --------
 Documentation/cxl/Makefile.am     |   61 --------
 Documentation/cxl/lib/Makefile.am |   58 --------
 Documentation/daxctl/Makefile.am  |   72 ----------
 Documentation/ndctl/Makefile.am   |  103 --------------
 Makefile.am                       |  104 --------------
 Makefile.am.in                    |   46 ------
 autogen.sh                        |   28 ----
 configure.ac                      |  270 -------------------------------------
 cxl/Makefile.am                   |   25 ---
 cxl/lib/Makefile.am               |   32 ----
 daxctl/Makefile.am                |   45 ------
 daxctl/lib/Makefile.am            |   42 ------
 ndctl.spec.in                     |   28 ----
 ndctl/Makefile.am                 |   86 ------------
 ndctl/lib/Makefile.am             |   58 --------
 rhel/meson.build                  |    3 
 sles/meson.build                  |    3 
 test/Makefile.am                  |  169 -----------------------
 19 files changed, 4 insertions(+), 1287 deletions(-)
 delete mode 100644 Documentation/cxl/Makefile.am
 delete mode 100644 Documentation/cxl/lib/Makefile.am
 delete mode 100644 Documentation/daxctl/Makefile.am
 delete mode 100644 Documentation/ndctl/Makefile.am
 delete mode 100644 Makefile.am
 delete mode 100644 Makefile.am.in
 delete mode 100755 autogen.sh
 delete mode 100644 configure.ac
 delete mode 100644 cxl/Makefile.am
 delete mode 100644 cxl/lib/Makefile.am
 delete mode 100644 daxctl/Makefile.am
 delete mode 100644 daxctl/lib/Makefile.am
 delete mode 100644 ndctl/Makefile.am
 delete mode 100644 ndctl/lib/Makefile.am
 delete mode 100644 test/Makefile.am

diff --git a/.gitignore b/.gitignore
index df8245dc10d8..aa0ce8e400c1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,63 +1,5 @@
-*.o
-*.lo
-*.xml
-.deps/
-.libs/
-Makefile
-!contrib/Makefile
-Makefile.in
-/aclocal.m4
-/autom4te.cache
-/build-aux
-/config.h
-/config.log
-/config.status
-/configure
-/libtool
-/stamp-h1
-*.1
-*.3
-Documentation/daxctl/asciidoc.conf
-Documentation/ndctl/asciidoc.conf
-Documentation/cxl/asciidoc.conf
-Documentation/cxl/lib/asciidoc.conf
-Documentation/daxctl/asciidoctor-extensions.rb
-Documentation/ndctl/asciidoctor-extensions.rb
-Documentation/cxl/asciidoctor-extensions.rb
-Documentation/cxl/lib/asciidoctor-extensions.rb
-.dirstamp
 build/
-daxctl/config.h
-daxctl/daxctl
-daxctl/lib/libdaxctl.la
-daxctl/lib/libdaxctl.pc
-*.a
-ndctl/config.h
-ndctl/lib/libndctl.pc
-ndctl/ndctl
 rhel/ndctl.spec
 sles/ndctl.spec
-version.m4
 *.swp
-cscope.files
-cscope*.out
 tags
-test/*.log
-test/*.trs
-test/dax-dev
-test/dax-errors
-test/dax-pmd
-test/daxdev-errors
-test/device-dax
-test/dsm-fail
-test/hugetlb
-test/image
-test/libndctl
-test/mmap
-test/pmem-ns
-test/smart-listen
-test/smart-notify
-test/fio.job
-test/local-write-0-verify.state
-test/ack-shutdown-count-set
-test/list-smart-dimm
diff --git a/Documentation/cxl/Makefile.am b/Documentation/cxl/Makefile.am
deleted file mode 100644
index efabaa37027f..000000000000
--- a/Documentation/cxl/Makefile.am
+++ /dev/null
@@ -1,61 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2020-2021 Intel Corporation. All rights reserved.
-
-if USE_ASCIIDOCTOR
-
-do_subst = sed -e 's,@Utility@,Cxl,g' -e's,@utility@,cxl,g'
-CONFFILE = asciidoctor-extensions.rb
-asciidoctor-extensions.rb: ../asciidoctor-extensions.rb.in
-	$(AM_V_GEN) $(do_subst) < $< > $@
-
-else
-
-do_subst = sed -e 's,UTILITY,cxl,g'
-CONFFILE = asciidoc.conf
-asciidoc.conf: ../asciidoc.conf.in
-	$(AM_V_GEN) $(do_subst) < $< > $@
-
-endif
-
-man1_MANS = \
-	cxl.1 \
-	cxl-list.1 \
-	cxl-read-labels.1 \
-	cxl-write-labels.1 \
-	cxl-zero-labels.1
-
-EXTRA_DIST = $(man1_MANS)
-
-CLEANFILES = $(man1_MANS)
-
-XML_DEPS = \
-	../../version.m4 \
-	../copyright.txt \
-	Makefile \
-	$(CONFFILE)
-
-RM ?= rm -f
-
-if USE_ASCIIDOCTOR
-
-%.1: %.txt $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
-		-I. -rasciidoctor-extensions \
-		-amansource=cxl -amanmanual="cxl Manual" \
-		-andctl_version=$(VERSION) -o $@+ $< && \
-		mv $@+ $@
-
-else
-
-%.xml: %.txt $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
-		--unsafe -acxl_version=$(VERSION) -o $@+ $< && \
-		mv $@+ $@
-
-%.1: %.xml $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@ && \
-		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
-
-endif
diff --git a/Documentation/cxl/lib/Makefile.am b/Documentation/cxl/lib/Makefile.am
deleted file mode 100644
index 41e3a5fc02b6..000000000000
--- a/Documentation/cxl/lib/Makefile.am
+++ /dev/null
@@ -1,58 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2020-2021 Intel Corporation. All rights reserved.
-
-if USE_ASCIIDOCTOR
-
-do_subst = sed -e 's,@Utility@,Libcxl,g' -e's,@utility@,libcxl,g'
-CONFFILE = asciidoctor-extensions.rb
-asciidoctor-extensions.rb: ../../asciidoctor-extensions.rb.in
-	$(AM_V_GEN) $(do_subst) < $< > $@
-
-else
-
-do_subst = sed -e 's,UTILITY,libcxl,g'
-CONFFILE = asciidoc.conf
-asciidoc.conf: ../../asciidoc.conf.in
-	$(AM_V_GEN) $(do_subst) < $< > $@
-
-endif
-
-man3_MANS = \
-	libcxl.3 \
-	cxl_new.3
-
-EXTRA_DIST = $(man3_MANS)
-
-CLEANFILES = $(man3_MANS)
-
-XML_DEPS = \
-	../../../version.m4 \
-	../../copyright.txt \
-	Makefile \
-	$(CONFFILE)
-
-RM ?= rm -f
-
-if USE_ASCIIDOCTOR
-
-%.3: %.txt $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
-		-I. -rasciidoctor-extensions \
-		-amansource=libcxl -amanmanual="libcxl Manual" \
-		-andctl_version=$(VERSION) -o $@+ $< && \
-		mv $@+ $@
-
-else
-
-%.xml: %.txt $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
-		--unsafe -alibcxl_version=$(VERSION) -o $@+ $< && \
-		mv $@+ $@
-
-%.3: %.xml $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@ && \
-		$(XMLTO) -o . -m ../../manpage-normal.xsl man $<
-
-endif
diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
deleted file mode 100644
index 78c47f5055c4..000000000000
--- a/Documentation/daxctl/Makefile.am
+++ /dev/null
@@ -1,72 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
-
-if USE_ASCIIDOCTOR
-
-do_subst = sed -e 's,@Utility@,Daxctl,g' -e's,@utility@,daxctl,g'
-CONFFILE = asciidoctor-extensions.rb
-asciidoctor-extensions.rb: ../asciidoctor-extensions.rb.in
-	$(AM_V_GEN) $(do_subst) < $< > $@
-
-else
-
-do_subst = sed -e 's,UTILITY,daxctl,g'
-CONFFILE = asciidoc.conf
-asciidoc.conf: ../asciidoc.conf.in
-	$(AM_V_GEN) $(do_subst) < $< > $@
-
-endif
-
-man1_MANS = \
-	daxctl.1 \
-	daxctl-list.1 \
-	daxctl-migrate-device-model.1 \
-	daxctl-reconfigure-device.1 \
-	daxctl-online-memory.1 \
-	daxctl-offline-memory.1 \
-	daxctl-disable-device.1 \
-	daxctl-enable-device.1 \
-	daxctl-create-device.1 \
-	daxctl-destroy-device.1
-
-EXTRA_DIST = $(man1_MANS)
-
-CLEANFILES = $(man1_MANS)
-
-XML_DEPS = \
-	../../version.m4 \
-	../copyright.txt \
-	Makefile \
-	$(CONFFILE)
-
-RM ?= rm -f
-
-if USE_ASCIIDOCTOR
-
-%.1: %.txt $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
-		-I. -rasciidoctor-extensions \
-		-amansource=daxctl -amanmanual="daxctl Manual" \
-		-adaxctl_confdir=$(daxctl_confdir) \
-		-adaxctl_conf=$(daxctl_conf) \
-		-andctl_keysdir=$(ndctl_keysdir) \
-		-andctl_version=$(VERSION) -o $@+ $< && \
-		mv $@+ $@
-
-else
-
-%.xml: %.txt $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
-		-adaxctl_confdir=$(daxctl_confdir) \
-		-adaxctl_conf=$(daxctl_conf) \
-		-andctl_keysdir=$(ndctl_keysdir) \
-		--unsafe -adaxctl_version=$(VERSION) -o $@+ $< && \
-		mv $@+ $@
-
-%.1: %.xml $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@ && \
-		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
-
-endif
diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
deleted file mode 100644
index 203158c1dfaf..000000000000
--- a/Documentation/ndctl/Makefile.am
+++ /dev/null
@@ -1,103 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
-
-if USE_ASCIIDOCTOR
-
-do_subst = sed -e 's,@Utility@,Ndctl,g' -e's,@utility@,ndctl,g'
-CONFFILE = asciidoctor-extensions.rb
-asciidoctor-extensions.rb: ../asciidoctor-extensions.rb.in
-	$(AM_V_GEN) $(do_subst) < $< > $@
-
-else
-
-do_subst = sed -e 's,UTILITY,ndctl,g'
-CONFFILE = asciidoc.conf
-asciidoc.conf: ../asciidoc.conf.in
-	$(AM_V_GEN) $(do_subst) < $< > $@
-
-endif
-
-man1_MANS = \
-	ndctl.1 \
-	ndctl-wait-scrub.1 \
-	ndctl-start-scrub.1 \
-	ndctl-zero-labels.1 \
-	ndctl-read-labels.1 \
-	ndctl-write-labels.1 \
-	ndctl-init-labels.1 \
-	ndctl-check-labels.1 \
-	ndctl-enable-region.1 \
-	ndctl-disable-region.1 \
-	ndctl-enable-dimm.1 \
-	ndctl-disable-dimm.1 \
-	ndctl-enable-namespace.1 \
-	ndctl-disable-namespace.1 \
-	ndctl-create-namespace.1 \
-	ndctl-destroy-namespace.1 \
-	ndctl-check-namespace.1 \
-	ndctl-clear-errors.1 \
-	ndctl-inject-error.1 \
-	ndctl-inject-smart.1 \
-	ndctl-update-firmware.1 \
-	ndctl-list.1 \
-	ndctl-monitor.1 \
-	ndctl-setup-passphrase.1 \
-	ndctl-update-passphrase.1 \
-	ndctl-remove-passphrase.1 \
-	ndctl-freeze-security.1 \
-	ndctl-sanitize-dimm.1 \
-	ndctl-load-keys.1 \
-	ndctl-wait-overwrite.1 \
-	ndctl-read-infoblock.1 \
-	ndctl-write-infoblock.1 \
-	ndctl-activate-firmware.1
-
-EXTRA_DIST = $(man1_MANS)
-
-CLEANFILES = $(man1_MANS)
-
-XML_DEPS = \
-	../../version.m4 \
-	Makefile \
-	$(CONFFILE) \
-	../copyright.txt \
-	region-description.txt \
-	xable-region-options.txt \
-	dimm-description.txt \
-	xable-dimm-options.txt \
-	xable-namespace-options.txt \
-	ars-description.txt \
-	labels-description.txt \
-	labels-options.txt
-
-RM ?= rm -f
-
-if USE_ASCIIDOCTOR
-
-%.1: %.txt $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
-		-I. -rasciidoctor-extensions \
-		-amansource=ndctl -amanmanual="ndctl Manual" \
-		-andctl_confdir=$(ndctl_confdir) \
-		-andctl_monitorconf=$(ndctl_monitorconf) \
-		-andctl_keysdir=$(ndctl_keysdir) \
-		-andctl_version=$(VERSION) -o $@+ $< && \
-		mv $@+ $@
-
-else
-
-%.xml: %.txt $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
-		-andctl_confdir=$(ndctl_confdir) \
-		-andctl_monitorconf=$(ndctl_monitorconf) \
-		-andctl_keysdir=$(ndctl_keysdir) \
-		--unsafe -andctl_version=$(VERSION) -o $@+ $< && \
-		mv $@+ $@
-
-%.1: %.xml $(XML_DEPS)
-	$(AM_V_GEN)$(RM) $@ && \
-		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
-
-endif
diff --git a/Makefile.am b/Makefile.am
deleted file mode 100644
index b78059b0b364..000000000000
--- a/Makefile.am
+++ /dev/null
@@ -1,104 +0,0 @@
-include Makefile.am.in
-
-ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
-SUBDIRS = . cxl/lib daxctl/lib ndctl/lib cxl ndctl daxctl
-if ENABLE_DOCS
-SUBDIRS += Documentation/ndctl Documentation/daxctl Documentation/cxl
-SUBDIRS += Documentation/cxl/lib
-endif
-SUBDIRS += test
-
-BUILT_SOURCES = version.m4
-version.m4: FORCE
-	$(AM_V_GEN)$(top_srcdir)/git-version-gen
-
-FORCE:
-
-EXTRA_DIST += ndctl.spec.in \
-		sles/header \
-		contrib/nvdimm-security.conf
-
-noinst_SCRIPTS = rhel/ndctl.spec sles/ndctl.spec
-CLEANFILES += $(noinst_SCRIPTS)
-
-do_rhel_subst = sed -e 's,VERSION,$(VERSION),g' \
-            -e 's,MESON,0,g' \
-            -e 's,DAX_DNAME,daxctl-devel,g' \
-            -e 's,CXL_DNAME,cxl-devel,g' \
-            -e 's,DNAME,ndctl-devel,g' \
-            -e '/^%defattr.*/d' \
-	    -e 's,DAX_LNAME,daxctl-libs,g' \
-	    -e 's,CXL_LNAME,cxl-libs,g' \
-	    -e 's,LNAME,ndctl-libs,g'
-
-do_sles_subst = sed -e 's,VERSION,$(VERSION),g' \
-            -e 's,MESON,0,g' \
-            -e 's,DAX_DNAME,libdaxctl-devel,g' \
-            -e 's,CXL_DNAME,libcxl-devel,g' \
-            -e 's,DNAME,libndctl-devel,g' \
-            -e 's,%license,%doc,g' \
-            -e 's,\(^License:.*GPL\)v2,\1-2.0,g' \
-            -e "s,DAX_LNAME,libdaxctl$$(($(LIBDAXCTL_CURRENT) - $(LIBDAXCTL_AGE))),g" \
-            -e "s,CXL_LNAME,libcxl$$(($(LIBCXL_CURRENT) - $(LIBCXL_AGE))),g" \
-            -e "s,LNAME,libndctl$$(($(LIBNDCTL_CURRENT) - $(LIBNDCTL_AGE))),g"
-
-rhel/ndctl.spec: ndctl.spec.in Makefile.am version.m4
-	$(AM_V_GEN)$(MKDIR_P) rhel; $(do_rhel_subst) < $< > $@
-
-sles/ndctl.spec: sles/header ndctl.spec.in Makefile.am version.m4
-	$(AM_V_GEN)$(MKDIR_P) sles; cat sles/header $< | $(do_sles_subst) > $@
-
-if ENABLE_BASH_COMPLETION
-bashcompletiondir = $(BASH_COMPLETION_DIR)
-dist_bashcompletion_DATA = contrib/ndctl
-install-data-hook:
-	$(LN_S) -f $(BASH_COMPLETION_DIR)/ndctl $(DESTDIR)/$(BASH_COMPLETION_DIR)/daxctl
-	$(LN_S) -f $(BASH_COMPLETION_DIR)/ndctl $(DESTDIR)/$(BASH_COMPLETION_DIR)/cxl
-endif
-
-modprobe_file = contrib/nvdimm-security.conf
-modprobedir = $(sysconfdir)/modprobe.d/
-modprobe_DATA = $(modprobe_file)
-
-noinst_LIBRARIES = libccan.a
-libccan_a_SOURCES = \
-	ccan/str/str.h \
-	ccan/str/str_debug.h \
-	ccan/str/str.c \
-	ccan/str/debug.c \
-	ccan/list/list.h \
-	ccan/list/list.c \
-	ccan/container_of/container_of.h \
-	ccan/check_type/check_type.h \
-	ccan/build_assert/build_assert.h \
-	ccan/array_size/array_size.h \
-	ccan/minmax/minmax.h \
-	ccan/short_types/short_types.h \
-	ccan/endian/endian.h
-
-noinst_LIBRARIES += libutil.a
-libutil_a_SOURCES = \
-	util/parse-options.c \
-	util/parse-options.h \
-	util/parse-configs.c \
-	util/parse-configs.h \
-	util/usage.c \
-	util/size.c \
-	util/main.c \
-	util/help.c \
-	util/strbuf.c \
-	util/wrapper.c \
-	util/bitmap.c \
-	util/abspath.c \
-	util/iomem.c \
-	util/util.h \
-	util/strbuf.h \
-	util/size.h \
-	util/main.h \
-	util/filter.h \
-	util/bitmap.h
-
-nobase_include_HEADERS = \
-	daxctl/libdaxctl.h \
-	cxl/libcxl.h \
-	cxl/cxl_mem.h
diff --git a/Makefile.am.in b/Makefile.am.in
deleted file mode 100644
index d6b126986bb4..000000000000
--- a/Makefile.am.in
+++ /dev/null
@@ -1,46 +0,0 @@
-EXTRA_DIST =
-CLEANFILES =
-
-AM_MAKEFLAGS = --no-print-directory
-
-AM_CPPFLAGS = \
-	-include $(top_builddir)/config.h \
-	-DSYSCONFDIR=\""$(sysconfdir)"\" \
-	-DLIBEXECDIR=\""$(libexecdir)"\" \
-	-DPREFIX=\""$(prefix)"\" \
-	-DNDCTL_MAN_PATH=\""$(mandir)"\" \
-	-I${top_srcdir}/ \
-	$(KMOD_CFLAGS) \
-	$(UDEV_CFLAGS) \
-	$(UUID_CFLAGS) \
-	$(JSON_CFLAGS)
-
-AM_CFLAGS = ${my_CFLAGS} \
-	-fvisibility=hidden \
-	-ffunction-sections \
-	-fdata-sections
-
-AM_LDFLAGS = \
-	-Wl,--gc-sections \
-	-Wl,--as-needed
-
-SED_PROCESS = \
-	$(AM_V_GEN)$(MKDIR_P) $(dir $@) && $(SED) \
-	-e 's,@VERSION\@,$(VERSION),g' \
-	-e 's,@prefix\@,$(prefix),g' \
-	-e 's,@exec_prefix\@,$(exec_prefix),g' \
-	-e 's,@libdir\@,$(libdir),g' \
-	-e 's,@includedir\@,$(includedir),g' \
-	< $< > $@ || rm $@
-
-LIBNDCTL_CURRENT=26
-LIBNDCTL_REVISION=1
-LIBNDCTL_AGE=20
-
-LIBDAXCTL_CURRENT=7
-LIBDAXCTL_REVISION=0
-LIBDAXCTL_AGE=6
-
-LIBCXL_CURRENT=1
-LIBCXL_REVISION=0
-LIBCXL_AGE=0
diff --git a/autogen.sh b/autogen.sh
deleted file mode 100755
index 2a52688bb403..000000000000
--- a/autogen.sh
+++ /dev/null
@@ -1,28 +0,0 @@
-#!/bin/sh -e
-
-if [ -f .git/hooks/pre-commit.sample -a ! -f .git/hooks/pre-commit ] ; then
-        cp -p .git/hooks/pre-commit.sample .git/hooks/pre-commit && \
-        chmod +x .git/hooks/pre-commit && \
-        echo "Activated pre-commit hook."
-fi
-
-$(dirname $0)/git-version-gen
-reconf_args=''
-[ -n "$*" ] && reconf_args="$*"
-autoreconf --install --symlink $reconf_args
-
-libdir() {
-        echo $(cd $1/$(gcc -print-multi-os-directory); pwd)
-}
-
-args="--prefix=/usr \
---sysconfdir=/etc \
---libdir=$(libdir /usr/lib)"
-
-echo
-echo "----------------------------------------------------------------"
-echo "Initialized build system. For a common configuration please run:"
-echo "----------------------------------------------------------------"
-echo
-echo "./configure CFLAGS='-g -O2' $args"
-echo
diff --git a/configure.ac b/configure.ac
deleted file mode 100644
index 1b18ed755c98..000000000000
--- a/configure.ac
+++ /dev/null
@@ -1,270 +0,0 @@
-AC_PREREQ(2.60)
-m4_include([version.m4])
-AC_INIT([ndctl],
-        GIT_VERSION,
-        [nvdimm@lists.linux.dev],
-        [ndctl],
-        [https://github.com/pmem/ndctl])
-AC_CONFIG_SRCDIR([ndctl/lib/libndctl.c])
-AC_CONFIG_AUX_DIR([build-aux])
-AM_INIT_AUTOMAKE([
-	foreign
-	1.11
-	-Wall
-	-Wno-portability
-	silent-rules
-	tar-pax
-	no-dist-gzip
-	dist-xz
-	subdir-objects
-])
-AC_PROG_CC_STDC
-AC_USE_SYSTEM_EXTENSIONS
-AC_SYS_LARGEFILE
-AC_CONFIG_MACRO_DIR([m4])
-AM_SILENT_RULES([yes])
-LT_INIT([
-	disable-static
-	pic-only
-])
-AC_PREFIX_DEFAULT([/usr])
-
-AC_PROG_SED
-AC_PROG_MKDIR_P
-AC_PROG_LN_S
-
-AC_ARG_ENABLE([docs],
-        AS_HELP_STRING([--disable-docs],
-	[disable documentation build @<:@default=enabled@:>@]),
-        [], enable_docs=yes)
-AS_IF([test "x$enable_docs" = "xyes"], [
-        AC_DEFINE(ENABLE_DOCS, [1], [Documentation / man pages.])
-])
-AM_CONDITIONAL([ENABLE_DOCS], [test "x$enable_docs" = "xyes"])
-
-AC_ARG_ENABLE([asciidoctor],
-	AS_HELP_STRING([--enable-asciidoctor],
-	[use asciidoctor for documentation build]),
-	[], enable_asciidoctor=yes)
-AM_CONDITIONAL([USE_ASCIIDOCTOR], [test "x$enable_asciidoctor" = "xyes"])
-if test "x$enable_asciidoctor" = "xyes"; then
-	asciidoc="asciidoctor"
-else
-	asciidoc="asciidoc"
-fi
-AC_CHECK_PROG(ASCIIDOC, [$asciidoc], [$(which $asciidoc)], [missing])
-if test "x$ASCIIDOC" = xmissing -a "x$enable_docs" = "xyes"; then
-	AC_MSG_ERROR([$asciidoc needed to build documentation])
-fi
-AC_SUBST([ASCIIDOC])
-
-if test x"$asciidoc" = x"asciidoc"; then
-AC_CHECK_PROG(XMLTO, [xmlto], [$(which xmlto)], [missing])
-if test "x$XMLTO" = xmissing -a "x$enable_docs" = "xyes"; then
-       AC_MSG_ERROR([xmlto needed to build documentation])
-fi
-AC_SUBST([XMLTO])
-fi
-
-AC_C_TYPEOF
-AC_DEFINE([HAVE_STATEMENT_EXPR], 1, [Define to 1 if you have statement expressions.])
-
-AC_C_BIGENDIAN(
-	AC_DEFINE(HAVE_BIG_ENDIAN, 1, [Define to 1 if big-endian-arch]),
-	AC_DEFINE(HAVE_LITTLE_ENDIAN, 1, [Define to 1 if little-endian-arch]),
-	[], [])
-
-AC_ARG_ENABLE([logging],
-        AS_HELP_STRING([--disable-logging], [disable system logging @<:@default=enabled@:>@]),
-        [], enable_logging=yes)
-AS_IF([test "x$enable_logging" = "xyes"], [
-        AC_DEFINE(ENABLE_LOGGING, [1], [System logging.])
-])
-
-AC_ARG_ENABLE([debug],
-        AS_HELP_STRING([--enable-debug], [enable debug messages @<:@default=disabled@:>@]),
-        [], [enable_debug=no])
-AS_IF([test "x$enable_debug" = "xyes"], [
-        AC_DEFINE(ENABLE_DEBUG, [1], [Debug messages.])
-])
-
-AC_ARG_ENABLE([destructive],
-        AS_HELP_STRING([--enable-destructive], [enable destructive functional tests @<:@default=disabled@:>@]),
-        [], [enable_destructive=no])
-AS_IF([test "x$enable_destructive" = "xyes"],
-	[AC_DEFINE([ENABLE_DESTRUCTIVE], [1], [destructive functional tests support])])
-AM_CONDITIONAL([ENABLE_DESTRUCTIVE], [test "x$enable_destructive" = "xyes"])
-
-AC_ARG_ENABLE([test],
-        AS_HELP_STRING([--enable-test], [enable ndctl test command @<:@default=disabled@:>@]),
-        [], [enable_test=$enable_destructive])
-AS_IF([test "x$enable_test" = "xyes"],
-	[AC_DEFINE([ENABLE_TEST], [1], [ndctl test support])])
-AM_CONDITIONAL([ENABLE_TEST], [test "x$enable_test" = "xyes"])
-
-AC_CHECK_DECLS([BUS_MCEERR_AR], [enable_bus_mc_err=yes], [], [[#include <signal.h>]])
-AC_CHECK_DECLS([MAP_SHARED_VALIDATE], [kernel_map_shared_validate=yes], [], [[#include <linux/mman.h>]])
-AC_CHECK_DECLS([MAP_SYNC], [kernel_map_sync=yes], [], [[#include <linux/mman.h>]])
-AS_UNSET([ac_cv_have_decl_MAP_SHARED_VALIDATE])
-AS_UNSET([ac_cv_have_decl_MAP_SYNC])
-AC_CHECK_DECLS([MAP_SHARED_VALIDATE], [enable_map_shared_validate=yes], [], [[#include <sys/mman.h>]])
-AC_CHECK_DECLS([MAP_SYNC], [enable_map_sync=yes], [], [[#include <sys/mman.h>]])
-
-if test "x$kernel_map_shared_validate" = "xyes" -a "x$enable_map_shared_validate" != "xyes" ; then
-	AC_MSG_WARN([MAP_SHARED_VALIDATE supported by kernel but not by <sys/mman.h>, consider installing glibc-2.28 or later.])
-fi
-if test "x$kernel_map_shared_validate" != "xyes" -a "x$enable_map_shared_validate" != "xyes" ; then
-	AC_MSG_WARN([MAP_SHARED_VALIDATE not supported by kernel, consider installing kernel-4.15 or later.])
-fi
-if test "x$kernel_map_sync" = "xyes" -a "x$enable_map_sync" != "xyes" ; then
-	AC_MSG_WARN([MAP_SYNC supported by kernel but not by <sys/mman.h>, consider installing glibc-2.28 or later.])
-fi
-if test "x$kernel_map_sync" != "xyes" -a "x$enable_map_sync" != "xyes" ; then
-	AC_MSG_WARN([MAP_SYNC not supported by kernel or architecture, consider installing kernel-4.15 or later.])
-fi
-
-AS_IF([test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes" -a "x$enable_map_shared_validate" = "xyes"],
-	[AC_DEFINE([ENABLE_POISON], [1], [ndctl test poison support])])
-AM_CONDITIONAL([ENABLE_POISON],
-	[test "x$enable_bus_mc_err" = "xyes" -a "x$enable_map_sync" = "xyes" -a "x$enable_map_shared_validate" = "xyes"])
-
-PKG_CHECK_MODULES([KMOD], [libkmod])
-PKG_CHECK_MODULES([UDEV], [libudev])
-PKG_CHECK_MODULES([UUID], [uuid],
-	[AC_DEFINE([HAVE_UUID], [1], [Define to 1 if using libuuid])])
-PKG_CHECK_MODULES([JSON], [json-c])
-
-AC_ARG_WITH([bash],
-	AS_HELP_STRING([--with-bash],
-		[Enable bash auto-completion. @<:@default=yes@:>@]),
-	[],
-	[with_bash=yes])
-
-if test "x$with_bash" = "xyes"; then
-	PKG_CHECK_MODULES([BASH_COMPLETION], [bash-completion >= 2.0],
-		[BASH_COMPLETION_DIR=$($PKG_CONFIG --variable=completionsdir bash-completion)], [])
-fi
-
-AC_SUBST([BASH_COMPLETION_DIR])
-AM_CONDITIONAL([ENABLE_BASH_COMPLETION], [test "x$with_bash" = "xyes"])
-
-AC_ARG_ENABLE([local],
-        AS_HELP_STRING([--disable-local], [build against kernel ndctl.h @<:@default=system@:>@]),
-        [], [enable_local=yes])
-
-AC_CHECK_HEADERS_ONCE([linux/version.h])
-
-AC_CHECK_FUNCS([ \
-	__secure_getenv \
-	secure_getenv\
-])
-
-AC_ARG_WITH([systemd],
-	AS_HELP_STRING([--with-systemd],
-		[Enable systemd functionality. @<:@default=yes@:>@]),
-	[], [with_systemd=yes])
-
-if test "x$with_systemd" = "xyes"; then
-	PKG_CHECK_MODULES([SYSTEMD], [systemd],
-	[systemd_unitdir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd)], [])
-fi
-
-AC_SUBST([systemd_unitdir])
-AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
-
-ndctl_confdir=${sysconfdir}/ndctl.conf.d
-ndctl_conf=ndctl.conf
-ndctl_monitorconf=monitor.conf
-AC_SUBST([ndctl_confdir])
-AC_SUBST([ndctl_conf])
-AC_SUBST([ndctl_monitorconf])
-
-daxctl_confdir=${sysconfdir}/daxctl.conf.d
-AC_SUBST([daxctl_confdir])
-
-daxctl_modprobe_datadir=${datadir}/daxctl
-daxctl_modprobe_data=daxctl.conf
-AC_SUBST([daxctl_modprobe_datadir])
-AC_SUBST([daxctl_modprobe_data])
-
-AC_ARG_WITH(udevrulesdir,
-    [AS_HELP_STRING([--with-udevrulesdir=DIR], [udev rules.d directory])],
-    [UDEVRULESDIR="$withval"],
-    [UDEVRULESDIR='${prefix}/lib/udev/rules.d']
-)
-AC_SUBST(UDEVRULESDIR)
-
-AC_ARG_WITH([keyutils],
-	    AS_HELP_STRING([--with-keyutils],
-			[Enable keyutils functionality (security).  @<:@default=yes@:>@]), [], [with_keyutils=yes])
-
-if test "x$with_keyutils" = "xyes"; then
-	AC_CHECK_HEADERS([keyutils.h],,[
-		AC_MSG_ERROR([keyutils.h not found, consider installing the keyutils library development package (variously named keyutils-libs-devel, keyutils-devel, or libkeyutils-dev).])
-		])
-fi
-AS_IF([test "x$with_keyutils" = "xyes"],
-	[AC_DEFINE([ENABLE_KEYUTILS], [1], [Enable keyutils support])])
-AM_CONDITIONAL([ENABLE_KEYUTILS], [test "x$with_keyutils" = "xyes"])
-
-ndctl_keysdir=${sysconfdir}/ndctl/keys
-ndctl_keysreadme=keys.readme
-AC_SUBST([ndctl_keysdir])
-AC_SUBST([ndctl_keysreadme])
-
-AC_CHECK_HEADERS([iniparser.h],,[
-		  AC_MSG_ERROR([iniparser.h not found, install iniparser-devel, libiniparser-dev, or so])
-		 ])
-
-my_CFLAGS="\
--Wall \
--Wchar-subscripts \
--Wformat-security \
--Wmissing-declarations \
--Wmissing-prototypes \
--Wnested-externs \
--Wshadow \
--Wsign-compare \
--Wstrict-prototypes \
--Wtype-limits \
--Wmaybe-uninitialized \
--Wdeclaration-after-statement \
--Wunused-result \
--D_FORTIFY_SOURCE=2 \
--O2
-"
-AC_SUBST([my_CFLAGS])
-
-AC_CONFIG_HEADERS(config.h)
-AC_CONFIG_FILES([
-        Makefile
-        daxctl/lib/Makefile
-        cxl/lib/Makefile
-        ndctl/lib/Makefile
-        ndctl/Makefile
-        daxctl/Makefile
-        cxl/Makefile
-        test/Makefile
-        Documentation/ndctl/Makefile
-        Documentation/daxctl/Makefile
-        Documentation/cxl/Makefile
-        Documentation/cxl/lib/Makefile
-])
-
-AC_OUTPUT
-AC_MSG_RESULT([
-        $PACKAGE $VERSION
-        =====
-
-        prefix:                 ${prefix}
-        sysconfdir:             ${sysconfdir}
-        libdir:                 ${libdir}
-        includedir:             ${includedir}
-
-        compiler:               ${CC}
-        cflags:                 ${CFLAGS}
-        ldflags:                ${LDFLAGS}
-
-        logging:                ${enable_logging}
-        debug:                  ${enable_debug}
-])
diff --git a/cxl/Makefile.am b/cxl/Makefile.am
deleted file mode 100644
index ee8488900a3b..000000000000
--- a/cxl/Makefile.am
+++ /dev/null
@@ -1,25 +0,0 @@
-include $(top_srcdir)/Makefile.am.in
-
-bin_PROGRAMS = cxl
-
-DISTCLEANFILES = config.h
-BUILT_SOURCES = config.h
-config.h: $(srcdir)/Makefile.am
-	$(AM_V_GEN) echo "/* Autogenerated by cxl/Makefile.am */" >$@
-
-cxl_SOURCES =\
-		cxl.c \
-		list.c \
-		memdev.c \
-		../util/json.c \
-		json.c \
-		filter.c \
-		filter.h \
-		builtin.h
-
-cxl_LDADD =\
-	lib/libcxl.la \
-	../libutil.a \
-	$(UUID_LIBS) \
-	$(KMOD_LIBS) \
-	$(JSON_LIBS)
diff --git a/cxl/lib/Makefile.am b/cxl/lib/Makefile.am
deleted file mode 100644
index 72c9ccdc3c49..000000000000
--- a/cxl/lib/Makefile.am
+++ /dev/null
@@ -1,32 +0,0 @@
-include $(top_srcdir)/Makefile.am.in
-
-%.pc: %.pc.in Makefile
-	$(SED_PROCESS)
-
-pkginclude_HEADERS = ../libcxl.h ../cxl_mem.h
-lib_LTLIBRARIES = libcxl.la
-
-libcxl_la_SOURCES =\
-	../libcxl.h \
-	private.h \
-	../../util/sysfs.c \
-	../../util/sysfs.h \
-	../../util/log.c \
-	../../util/log.h \
-	libcxl.c
-
-libcxl_la_LIBADD =\
-	$(UUID_LIBS) \
-	$(KMOD_LIBS)
-
-EXTRA_DIST += libcxl.sym
-
-libcxl_la_LDFLAGS = $(AM_LDFLAGS) \
-	-version-info $(LIBCXL_CURRENT):$(LIBCXL_REVISION):$(LIBCXL_AGE) \
-	-Wl,--version-script=$(top_srcdir)/cxl/lib/libcxl.sym
-libcxl_la_DEPENDENCIES = libcxl.sym
-
-pkgconfigdir = $(libdir)/pkgconfig
-pkgconfig_DATA = libcxl.pc
-EXTRA_DIST += libcxl.pc.in
-CLEANFILES += libcxl.pc
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
deleted file mode 100644
index bbf764f8081f..000000000000
--- a/daxctl/Makefile.am
+++ /dev/null
@@ -1,45 +0,0 @@
-include $(top_srcdir)/Makefile.am.in
-
-bin_PROGRAMS = daxctl
-
-DISTCLEANFILES = config.h
-BUILT_SOURCES = config.h
-config.h: $(srcdir)/Makefile.am
-	$(AM_V_GEN) echo "/* Autogenerated by daxctl/Makefile.am */" >$@ && \
-	echo '#define DAXCTL_MODPROBE_DATA \
-		"$(daxctl_modprobe_datadir)/$(daxctl_modprobe_data)"' >>$@ && \
-	echo '#define DAXCTL_MODPROBE_INSTALL \
-		"$(sysconfdir)/modprobe.d/$(daxctl_modprobe_data)"' >>$@
-
-daxctl_SOURCES =\
-		daxctl.c \
-		acpi.c \
-		list.c \
-		migrate.c \
-		device.c \
-		../util/json.c \
-		../util/json.h \
-		json.c \
-		json.h \
-		filter.c \
-		filter.h \
-		builtin.h
-
-daxctl_LDADD =\
-	lib/libdaxctl.la \
-	../ndctl/lib/libndctl.la \
-	../libutil.a \
-	$(UUID_LIBS) \
-	$(KMOD_LIBS) \
-	$(JSON_LIBS) \
-	-liniparser
-
-udevrulesdir = $(UDEVRULESDIR)
-udevrules_DATA = 90-daxctl-device.rules
-
-daxctl_configdir = $(daxctl_confdir)
-daxctl_config_DATA = daxctl.example.conf
-
-if ENABLE_SYSTEMD_UNITS
-systemd_unit_DATA = daxdev-reconfigure@.service
-endif
diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am
deleted file mode 100644
index 3c47a4bbe580..000000000000
--- a/daxctl/lib/Makefile.am
+++ /dev/null
@@ -1,42 +0,0 @@
-include $(top_srcdir)/Makefile.am.in
-
-%.pc: %.pc.in Makefile
-	$(SED_PROCESS)
-
-DISTCLEANFILES = config.h
-BUILT_SOURCES = config.h
-config.h: $(srcdir)/Makefile.am
-	$(AM_V_GEN) echo "/* Autogenerated by daxctl/Makefile.am */" >$@ && \
-		echo '#define DAXCTL_CONF_DIR  "$(daxctl_confdir)"' >>$@
-
-pkginclude_HEADERS = ../libdaxctl.h
-lib_LTLIBRARIES = libdaxctl.la
-
-libdaxctl_la_SOURCES =\
-	../libdaxctl.h \
-	libdaxctl-private.h \
-	../../util/iomem.c \
-	../../util/iomem.h \
-	../../util/sysfs.c \
-	../../util/sysfs.h \
-	../../util/log.c \
-	../../util/log.h \
-	libdaxctl.c
-
-libdaxctl_la_LIBADD =\
-	$(UUID_LIBS) \
-	$(KMOD_LIBS)
-
-daxctl_modprobe_data_DATA = daxctl.conf
-
-EXTRA_DIST += libdaxctl.sym daxctl.conf
-
-libdaxctl_la_LDFLAGS = $(AM_LDFLAGS) \
-	-version-info $(LIBDAXCTL_CURRENT):$(LIBDAXCTL_REVISION):$(LIBDAXCTL_AGE) \
-	-Wl,--version-script=$(top_srcdir)/daxctl/lib/libdaxctl.sym
-libdaxctl_la_DEPENDENCIES = libdaxctl.sym
-
-pkgconfigdir = $(libdir)/pkgconfig
-pkgconfig_DATA = libdaxctl.pc
-EXTRA_DIST += libdaxctl.pc.in
-CLEANFILES += libdaxctl.pc
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 9447267839d2..7e838f4bf199 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -6,21 +6,16 @@ License:	GPLv2
 Url:		https://github.com/pmem/ndctl
 Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
 
-%define with_meson MESON
 Requires:	LNAME%{?_isa} = %{version}-%{release}
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
 BuildRequires:	autoconf
 %if 0%{?rhel} < 9
 BuildRequires:	asciidoc
-%if !%{with_meson}
-%define asciidoc --disable-asciidoctor
-%endif
+%define asciidoctor -Dasciidoctor=disabled
 %else
-%if %{with_meson}
-%define asciidoctor -Dasciidoctor=enabled
-%endif
 BuildRequires:	rubygem-asciidoctor
+%define asciidoctor -Dasciidoctor=enabled
 %endif
 BuildRequires:	xmlto
 BuildRequires:	automake
@@ -35,10 +30,7 @@ BuildRequires:	pkgconfig(systemd)
 BuildRequires:	keyutils-libs-devel
 BuildRequires:	systemd-rpm-macros
 BuildRequires:	iniparser-devel
-
-%if %{with_meson}
 BuildRequires:	meson
-%endif
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -127,30 +119,14 @@ libcxl is a library for enumerating and communicating with CXL devices.
 %setup -q ndctl-%{version}
 
 %build
-%if %{with_meson}
 %meson %{?asciidoctor} -Dversion-tag=%{version}
 %meson_build
-%else
-echo %{version} > version
-./autogen.sh
-%configure --disable-static --disable-silent-rules %{?asciidoc}
-make %{?_smp_mflags}
-%endif
 
 %install
-%if %{with_meson}
 %meson_install
-%else
-%make_install
-find $RPM_BUILD_ROOT -name '*.la' -exec rm -f {} ';'
-%endif
 
 %check
-%if %{with_meson}
 %meson_test
-%else
-make check
-%endif
 
 %ldconfig_scriptlets -n LNAME
 
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
deleted file mode 100644
index 5d5b1cacda9d..000000000000
--- a/ndctl/Makefile.am
+++ /dev/null
@@ -1,86 +0,0 @@
-include $(top_srcdir)/Makefile.am.in
-
-bin_PROGRAMS = ndctl
-
-DISTCLEANFILES = config.h
-BUILT_SOURCES = config.h
-config.h: $(srcdir)/Makefile.am
-	$(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@ && \
-	echo '#define NDCTL_CONF_FILE \
-		"$(ndctl_confdir)/$(ndctl_monitorconf)"' >>$@
-	$(AM_V_GEN) echo '#define NDCTL_KEYS_DIR  "$(ndctl_keysdir)"' >>$@
-
-ndctl_SOURCES = ndctl.c \
-		builtin.h \
-		bus.c \
-		create-nfit.c \
-		namespace.c \
-		check.c \
-		region.c \
-		dimm.c \
-		../util/log.c \
-		../daxctl/filter.c \
-		../daxctl/filter.h \
-		filter.c \
-		filter.h \
-		list.c \
-		../util/json.c \
-		../util/json.h \
-		../daxctl/json.c \
-		../daxctl/json.h \
-		json.c \
-		json.h \
-		json-smart.c \
-		keys.h \
-		inject-error.c \
-		inject-smart.c \
-		monitor.c \
-		namespace.h \
-		action.h \
-		../nfit.h \
-		../test.h \
-		firmware-update.h
-
-if ENABLE_KEYUTILS
-ndctl_SOURCES += keys.c \
-		load-keys.c
-keys_configdir = $(ndctl_keysdir)
-keys_config_DATA = $(ndctl_keysreadme)
-endif
-
-EXTRA_DIST += keys.readme monitor.conf ndctl-monitor.service ndctl.conf
-
-if ENABLE_DESTRUCTIVE
-ndctl_SOURCES += ../test/pmem_namespaces.c
-ndctl_SOURCES += bat.c
-endif
-
-ndctl_LDADD =\
-	lib/libndctl.la \
-	../daxctl/lib/libdaxctl.la \
-	../libutil.a \
-	$(UUID_LIBS) \
-	$(KMOD_LIBS) \
-	$(JSON_LIBS) \
-	-liniparser
-
-if ENABLE_KEYUTILS
-ndctl_LDADD += -lkeyutils
-endif
-
-if ENABLE_TEST
-ndctl_SOURCES += ../test/libndctl.c \
-		 ../test/dsm-fail.c \
-		 ../util/sysfs.c \
-		 ../test/core.c \
-		 test.c
-endif
-
-ndctl_configdir = $(ndctl_confdir)
-ndctl_config_DATA = $(ndctl_conf)
-monitor_configdir = $(ndctl_confdir)
-monitor_config_DATA = $(ndctl_monitorconf)
-
-if ENABLE_SYSTEMD_UNITS
-systemd_unit_DATA = ndctl-monitor.service
-endif
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
deleted file mode 100644
index 0a52c01da347..000000000000
--- a/ndctl/lib/Makefile.am
+++ /dev/null
@@ -1,58 +0,0 @@
-include $(top_srcdir)/Makefile.am.in
-
-%.pc: %.pc.in Makefile
-	$(SED_PROCESS)
-
-DISTCLEANFILES = config.h
-BUILT_SOURCES = config.h
-config.h: $(srcdir)/Makefile.am
-	$(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@ && \
-		echo '#define NDCTL_CONF_DIR  "$(ndctl_confdir)"' >>$@
-
-pkginclude_HEADERS = ../libndctl.h ../ndctl.h
-lib_LTLIBRARIES = libndctl.la
-
-libndctl_la_SOURCES =\
-	../libndctl.h \
-	private.h \
-	../../util/list.h \
-	../../util/log.c \
-	../../util/log.h \
-	../../util/sysfs.c \
-	../../util/sysfs.h \
-	../../util/fletcher.h \
-	dimm.c \
-	inject.c \
-	nfit.c \
-	smart.c \
-	intel.c \
-	hpe1.c \
-	msft.c \
-	hyperv.c \
-	papr.c \
-	ars.c \
-	firmware.c \
-	libndctl.c \
-	intel.h \
-	hpe1.h \
-	msft.h \
-	hyperv.h \
-	../../ndctl/libndctl-nfit.h
-
-libndctl_la_LIBADD =\
-	../../daxctl/lib/libdaxctl.la \
-	$(UDEV_LIBS) \
-	$(UUID_LIBS) \
-	$(KMOD_LIBS)
-
-EXTRA_DIST += libndctl.sym
-
-libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
-	-version-info $(LIBNDCTL_CURRENT):$(LIBNDCTL_REVISION):$(LIBNDCTL_AGE) \
-	-Wl,--version-script=$(top_srcdir)/ndctl/lib/libndctl.sym
-libndctl_la_DEPENDENCIES = libndctl.sym
-
-pkgconfigdir = $(libdir)/pkgconfig
-pkgconfig_DATA = libndctl.pc
-EXTRA_DIST += libndctl.pc.in
-CLEANFILES += libndctl.pc
diff --git a/rhel/meson.build b/rhel/meson.build
index 8672098d84e1..85b47bcd485a 100644
--- a/rhel/meson.build
+++ b/rhel/meson.build
@@ -7,8 +7,7 @@ rhel_spec1 = vcs_tag(
 
 rhel_spec2 = custom_target('ndctl.spec',
   command : [
-    'sed', '-e', 's,MESON,1,g',
-	   '-e', 's,DAX_DNAME,daxctl-devel,g',
+    'sed', '-e', 's,DAX_DNAME,daxctl-devel,g',
 	   '-e', 's,CXL_DNAME,cxl-devel,g',
 	   '-e', 's,DNAME,ndctl-devel,g',
 	   '-e', '/^%defattr.*/d',
diff --git a/sles/meson.build b/sles/meson.build
index 21c72cb4f5ec..8512774b6d20 100644
--- a/sles/meson.build
+++ b/sles/meson.build
@@ -18,8 +18,7 @@ sles_spec2 = custom_target('ndctl.spec.in',
 
 sles_spec3 = custom_target('ndctl.spec',
   command : [
-    'sed', '-e', 's,MESON,1,g',
-           '-e', 's,DAX_DNAME,libdaxctl-devel,g',
+    'sed', '-e', 's,DAX_DNAME,libdaxctl-devel,g',
            '-e', 's,CXL_DNAME,libcxl-devel,g',
            '-e', 's,DNAME,libndctl-devel,g',
            '-e', 's,%license,%doc,g',
diff --git a/test/Makefile.am b/test/Makefile.am
deleted file mode 100644
index a2a4ee4a4335..000000000000
--- a/test/Makefile.am
+++ /dev/null
@@ -1,169 +0,0 @@
-include $(top_srcdir)/Makefile.am.in
-
-TESTS =\
-	libndctl \
-	dsm-fail \
-	create.sh \
-	clear.sh \
-	pmem-errors.sh \
-	daxdev-errors.sh \
-	multi-dax.sh \
-	btt-check.sh \
-	label-compat.sh \
-	sector-mode.sh \
-	inject-error.sh \
-	btt-errors.sh \
-	hugetlb \
-	btt-pad-compat.sh \
-	firmware-update.sh \
-	ack-shutdown-count-set \
-	rescan-partitions.sh \
-	inject-smart.sh \
-	monitor.sh \
-	max_available_extent_ns.sh \
-	pfn-meta-errors.sh \
-	track-uuid.sh
-
-EXTRA_DIST += $(TESTS) common \
-		btt-pad-compat.xxd \
-		nmem1.bin nmem2.bin nmem3.bin nmem4.bin
-
-check_PROGRAMS =\
-	libndctl \
-	dsm-fail \
-	dax-errors \
-	smart-notify \
-	smart-listen \
-	hugetlb \
-	daxdev-errors \
-	ack-shutdown-count-set \
-	list-smart-dimm
-
-if ENABLE_DESTRUCTIVE
-TESTS +=\
-	pmem-ns \
-	sub-section.sh \
-	dax-dev \
-	dax-ext4.sh \
-	dax-xfs.sh \
-	align.sh \
-	device-dax \
-	revoke-devmem \
-	device-dax-fio.sh \
-	daxctl-devices.sh \
-	daxctl-create.sh \
-	dm.sh \
-	mmap.sh
-
-if ENABLE_KEYUTILS
-TESTS += security.sh
-endif
-
-check_PROGRAMS +=\
-	pmem-ns \
-	dax-dev \
-	dax-pmd \
-	device-dax \
-	revoke-devmem \
-	mmap
-endif
-
-LIBNDCTL_LIB =\
-       ../ndctl/lib/libndctl.la \
-       ../daxctl/lib/libdaxctl.la
-
-testcore =\
-	core.c \
-	../util/log.c \
-	../util/sysfs.c
-
-libndctl_SOURCES = libndctl.c $(testcore)
-libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
-
-namespace_core =\
-	../ndctl/namespace.c \
-	../ndctl/filter.c \
-	../ndctl/check.c \
-	../util/json.c \
-	../ndctl/json.c \
-	../daxctl/filter.c \
-	../daxctl/json.c
-
-dsm_fail_SOURCES =\
-	dsm-fail.c \
-	$(testcore) \
-	$(namespace_core)
-
-dsm_fail_LDADD = $(LIBNDCTL_LIB) \
-		$(KMOD_LIBS) \
-		$(JSON_LIBS) \
-		$(UUID_LIBS) \
-		../libutil.a
-
-ack_shutdown_count_set_SOURCES =\
-	ack-shutdown-count-set.c \
-	$(testcore)
-
-ack_shutdown_count_set_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
-
-pmem_ns_SOURCES = pmem_namespaces.c $(testcore)
-pmem_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS) $(UUID_LIBS)
-
-dax_dev_SOURCES = dax-dev.c $(testcore)
-dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
-
-dax_pmd_SOURCES = dax-pmd.c \
-		$(testcore)
-
-hugetlb_SOURCES = hugetlb.c \
-		  dax-pmd.c
-
-mmap_SOURCES = mmap.c
-dax_errors_SOURCES = dax-errors.c
-daxdev_errors_SOURCES = daxdev-errors.c \
-			../util/log.c \
-			../util/sysfs.c
-daxdev_errors_LDADD = $(LIBNDCTL_LIB)
-device_dax_SOURCES = \
-		device-dax.c \
-		dax-dev.c \
-		dax-pmd.c \
-		$(testcore) \
-		$(namespace_core)
-
-if ENABLE_POISON
-dax_pmd_SOURCES += dax-poison.c
-hugetlb_SOURCES += dax-poison.c
-device_dax_SOURCES += dax-poison.c
-endif
-
-device_dax_LDADD = \
-		$(LIBNDCTL_LIB) \
-		$(KMOD_LIBS) \
-		$(JSON_LIBS) \
-                $(UUID_LIBS) \
-		../libutil.a
-
-revoke_devmem_SOURCES = \
-		revoke-devmem.c \
-		dax-dev.c \
-		$(testcore)
-
-revoke_devmem_LDADD = $(LIBNDCTL_LIB)
-
-smart_notify_SOURCES = smart-notify.c
-smart_notify_LDADD = $(LIBNDCTL_LIB)
-smart_listen_SOURCES = smart-listen.c
-smart_listen_LDADD = $(LIBNDCTL_LIB)
-
-list_smart_dimm_SOURCES = \
-		list-smart-dimm.c \
-		../ndctl/filter.c \
-		../util/json.c \
-		../ndctl/json.c
-
-list_smart_dimm_LDADD = \
-		$(LIBNDCTL_LIB) \
-		$(JSON_LIBS) \
-		$(UUID_LIBS) \
-		../libutil.a

