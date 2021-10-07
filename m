Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F002CB3
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 08:22:02 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="249511738"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="249511738"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:58 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568555136"
Received: from abishekh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:58 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 15/17] ndctl: Add CXL packages to the RPM spec
Date: Thu,  7 Oct 2021 02:21:37 -0600
Message-Id: <20211007082139.3088615-16-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007082139.3088615-1-vishal.l.verma@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4557; i=vishal.l.verma@intel.com; h=from:subject; bh=zKOQKfuyxQ8GXGir5s5EVZtEfBTL3DKU8BtAxhe6wVs=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlx6/gF9aYbaFw4v1B/a6zep5crHtnmlAY0OnuWV2vs4L6q KTy5o5SFQYyDQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABN5sZnhn+pF7hMs/jwH+M5zmuRcaq jQTkhw8I5xr2A5vHvehuLFHxgZlr5XiMvaFuAzwcxrZuvevb/5a1X8tx0rZ+tnOPsv+VMOPwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Add CXL related packages - the cxl-cli utility, the libcxl library, and
development headers to respective RPM packages in the main spec file.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Makefile.am   |  4 ++++
 ndctl.spec.in | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index e2f6bef..fa2010a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -23,17 +23,21 @@ CLEANFILES += $(noinst_SCRIPTS)
 
 do_rhel_subst = sed -e 's,VERSION,$(VERSION),g' \
             -e 's,DAX_DNAME,daxctl-devel,g' \
+            -e 's,CXL_DNAME,cxl-devel,g' \
             -e 's,DNAME,ndctl-devel,g' \
             -e '/^%defattr.*/d' \
 	    -e 's,DAX_LNAME,daxctl-libs,g' \
+	    -e 's,CXL_LNAME,cxl-libs,g' \
 	    -e 's,LNAME,ndctl-libs,g'
 
 do_sles_subst = sed -e 's,VERSION,$(VERSION),g' \
             -e 's,DAX_DNAME,libdaxctl-devel,g' \
+            -e 's,CXL_DNAME,libcxl-devel,g' \
             -e 's,DNAME,libndctl-devel,g' \
             -e 's,%license,%doc,g' \
             -e 's,\(^License:.*GPL\)v2,\1-2.0,g' \
             -e "s,DAX_LNAME,libdaxctl$$(($(LIBDAXCTL_CURRENT) - $(LIBDAXCTL_AGE))),g" \
+            -e "s,CXL_LNAME,libcxl$$(($(LIBCXL_CURRENT) - $(LIBCXL_AGE))),g" \
             -e "s,LNAME,libndctl$$(($(LIBNDCTL_CURRENT) - $(LIBNDCTL_AGE))),g"
 
 rhel/ndctl.spec: ndctl.spec.in Makefile.am version.m4
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 0563b2d..4b08c05 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -8,6 +8,7 @@ Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{v
 
 Requires:	LNAME%{?_isa} = %{version}-%{release}
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
+Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
 BuildRequires:	autoconf
 %if 0%{?rhel} < 9
 BuildRequires:	asciidoc
@@ -54,6 +55,24 @@ the Linux kernel Device-DAX facility. This facility enables DAX mappings
 of performance / feature differentiated memory without need of a
 filesystem.
 
+%package -n cxl-cli
+Summary:	Manage CXL devices
+License:	GPLv2
+Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
+
+%description -n cxl-cli
+The cxl utility provides enumeration and provisioning commands for
+the Linux kernel CXL devices.
+
+%package -n CXL_DNAME
+Summary:	Development files for libcxl
+License:	LGPLv2
+Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
+
+%description -n CXL_DNAME
+This package contains libraries and header files for developing applications
+that use libcxl, a library for enumerating and communicating with CXL devices.
+
 %package -n DAX_DNAME
 Summary:	Development files for libdaxctl
 License:	LGPLv2
@@ -84,6 +103,13 @@ Device DAX is a facility for establishing DAX mappings of performance /
 feature-differentiated memory. DAX_LNAME provides an enumeration /
 control API for these devices.
 
+%package -n CXL_LNAME
+Summary:	Management library for CXL devices
+License:	LGPLv2
+
+%description -n CXL_LNAME
+libcxl is a library for enumerating and communicating with CXL devices.
+
 
 %prep
 %setup -q ndctl-%{version}
@@ -105,6 +131,8 @@ make check
 
 %ldconfig_scriptlets -n DAX_LNAME
 
+%ldconfig_scriptlets -n CXL_LNAME
+
 %define bashcompdir %(pkg-config --variable=completionsdir bash-completion)
 
 %files
@@ -126,6 +154,12 @@ make check
 %{_mandir}/man1/daxctl*
 %{_datadir}/daxctl/daxctl.conf
 
+%files -n cxl-cli
+%defattr(-,root,root)
+%license LICENSES/preferred/GPL-2.0 LICENSES/other/MIT LICENSES/other/CC0-1.0
+%{_bindir}/cxl
+%{_mandir}/man1/cxl*
+
 %files -n LNAME
 %defattr(-,root,root)
 %doc README.md
@@ -138,6 +172,12 @@ make check
 %license LICENSES/preferred/LGPL-2.1 LICENSES/other/MIT LICENSES/other/CC0-1.0
 %{_libdir}/libdaxctl.so.*
 
+%files -n CXL_LNAME
+%defattr(-,root,root)
+%doc README.md
+%license LICENSES/preferred/LGPL-2.1 LICENSES/other/MIT LICENSES/other/CC0-1.0
+%{_libdir}/libcxl.so.*
+
 %files -n DNAME
 %defattr(-,root,root)
 %license LICENSES/preferred/LGPL-2.1
@@ -152,6 +192,15 @@ make check
 %{_libdir}/libdaxctl.so
 %{_libdir}/pkgconfig/libdaxctl.pc
 
+%files -n CXL_DNAME
+%defattr(-,root,root)
+%license LICENSES/preferred/LGPL-2.1
+%{_includedir}/cxl/
+%{_libdir}/libcxl.so
+%{_libdir}/pkgconfig/libcxl.pc
+%{_mandir}/man3/cxl*
+%{_mandir}/man3/libcxl.3.gz
+
 
 %changelog
 * Fri May 27 2016 Dan Williams <dan.j.williams@intel.com> - 53-1
-- 
2.31.1

