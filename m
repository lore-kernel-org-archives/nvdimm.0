Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55FE3FDB
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 20:43:33 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="217381912"
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="217381912"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 13:43:33 -0700
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="689297058"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 13:43:33 -0700
Subject: [ndctl PATCH v2 6/6] build: Add meson rpmbuild support
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org
Date: Thu, 02 Sep 2021 13:43:33 -0700
Message-ID: <163061541299.1943957.16202191465635771045.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163061537869.1943957.8491829881215255815.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163061537869.1943957.8491829881215255815.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Beyond being a prerequisite for removing autotools support, this capability
served as validation that the meson conversion generated all the same files
as autotools and installed them to the same expected locations.

The procedure to use the rpmbuild.sh script is:

    meson setup build
    meson compile -C build rhel/ndctl.spec
    ./rpmbuild.sh build/rhel/ndctl.spec

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .gitignore       |    2 +-
 Makefile.am      |    2 ++
 meson.build      |    6 ++++++
 ndctl.spec.in    |   22 ++++++++++++++++++++++
 rhel/meson.build |   23 +++++++++++++++++++++++
 rpmbuild.sh      |    5 ++++-
 sles/meson.build |   36 ++++++++++++++++++++++++++++++++++++
 7 files changed, 94 insertions(+), 2 deletions(-)
 create mode 100644 rhel/meson.build
 create mode 100644 sles/meson.build

diff --git a/.gitignore b/.gitignore
index 4cb232519e72..68c55c1af80e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -36,7 +36,7 @@ daxctl/lib/libdaxctl.pc
 ndctl/config.h
 ndctl/lib/libndctl.pc
 ndctl/ndctl
-rhel/
+rhel/ndctl.spec
 sles/ndctl.spec
 version.m4
 *.swp
diff --git a/Makefile.am b/Makefile.am
index 75d80fc24095..909c2699af47 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -22,6 +22,7 @@ noinst_SCRIPTS = rhel/ndctl.spec sles/ndctl.spec
 CLEANFILES += $(noinst_SCRIPTS)
 
 do_rhel_subst = sed -e 's,VERSION,$(VERSION),g' \
+            -e 's,MESON,0,g' \
             -e 's,DAX_DNAME,daxctl-devel,g' \
             -e 's,CXL_DNAME,cxl-devel,g' \
             -e 's,DNAME,ndctl-devel,g' \
@@ -31,6 +32,7 @@ do_rhel_subst = sed -e 's,VERSION,$(VERSION),g' \
 	    -e 's,LNAME,ndctl-libs,g'
 
 do_sles_subst = sed -e 's,VERSION,$(VERSION),g' \
+            -e 's,MESON,0,g' \
             -e 's,DAX_DNAME,libdaxctl-devel,g' \
             -e 's,CXL_DNAME,libcxl-devel,g' \
             -e 's,DNAME,libndctl-devel,g' \
diff --git a/meson.build b/meson.build
index 746408948e4d..a94bbd740ef0 100644
--- a/meson.build
+++ b/meson.build
@@ -267,3 +267,9 @@ if get_option('docs').enabled()
 endif
 subdir('test')
 subdir('contrib')
+
+# only support spec file generation from git builds
+if version_tag == ''
+  subdir('rhel')
+  subdir('sles')
+endif
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 4b08c05719c9..fd517317b943 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -6,14 +6,20 @@ License:	GPLv2
 Url:		https://github.com/pmem/ndctl
 Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
 
+%define with_meson MESON
 Requires:	LNAME%{?_isa} = %{version}-%{release}
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
 BuildRequires:	autoconf
 %if 0%{?rhel} < 9
 BuildRequires:	asciidoc
+%if !%{with_meson}
 %define asciidoc --disable-asciidoctor
+%endif
 %else
+%if %{with_meson}
+%define asciidoctor -Dasciidoctor=enabled
+%endif
 BuildRequires:	rubygem-asciidoctor
 %endif
 BuildRequires:	xmlto
@@ -27,6 +33,9 @@ BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
 BuildRequires:	pkgconfig(systemd)
 BuildRequires:	keyutils-libs-devel
+%if %{with_meson}
+BuildRequires:	meson
+%endif
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -115,17 +124,30 @@ libcxl is a library for enumerating and communicating with CXL devices.
 %setup -q ndctl-%{version}
 
 %build
+%if %{with_meson}
+%meson %{?asciidoctor} -Dversion-tag=%{version}
+%meson_build
+%else
 echo %{version} > version
 ./autogen.sh
 %configure --disable-static --disable-silent-rules %{?asciidoc}
 make %{?_smp_mflags}
+%endif
 
 %install
+%if %{with_meson}
+%meson_install
+%else
 %make_install
 find $RPM_BUILD_ROOT -name '*.la' -exec rm -f {} ';'
+%endif
 
 %check
+%if %{with_meson}
+%meson_test
+%else
 make check
+%endif
 
 %ldconfig_scriptlets -n LNAME
 
diff --git a/rhel/meson.build b/rhel/meson.build
new file mode 100644
index 000000000000..8672098d84e1
--- /dev/null
+++ b/rhel/meson.build
@@ -0,0 +1,23 @@
+rhel_spec1 = vcs_tag(
+    input : '../ndctl.spec.in',
+    output : 'ndctl.spec.in',
+    command: vcs_tagger,
+    replace_string : 'VERSION',
+)
+
+rhel_spec2 = custom_target('ndctl.spec',
+  command : [
+    'sed', '-e', 's,MESON,1,g',
+	   '-e', 's,DAX_DNAME,daxctl-devel,g',
+	   '-e', 's,CXL_DNAME,cxl-devel,g',
+	   '-e', 's,DNAME,ndctl-devel,g',
+	   '-e', '/^%defattr.*/d',
+	   '-e', 's,DAX_LNAME,daxctl-libs,g',
+	   '-e', 's,CXL_LNAME,cxl-libs,g',
+	   '-e', 's,LNAME,ndctl-libs,g',
+	   '@INPUT@'
+  ],
+  input : rhel_spec1,
+  output : 'ndctl.spec',
+  capture : true,
+)
diff --git a/rpmbuild.sh b/rpmbuild.sh
index fe4154b6be9f..b1f4d9e5c0f3 100755
--- a/rpmbuild.sh
+++ b/rpmbuild.sh
@@ -1,6 +1,9 @@
 #!/bin/bash
+
+spec=${1:-$(dirname $0)/rhel/ndctl.spec)}
+
 pushd $(dirname $0) >/dev/null
 [ ! -d ~/rpmbuild/SOURCES ] && echo "rpmdev tree not found" && exit 1
 ./make-git-snapshot.sh
 popd > /dev/null
-rpmbuild -ba $(dirname $0)/rhel/ndctl.spec
+rpmbuild --nocheck -ba $spec
diff --git a/sles/meson.build b/sles/meson.build
new file mode 100644
index 000000000000..21c72cb4f5ec
--- /dev/null
+++ b/sles/meson.build
@@ -0,0 +1,36 @@
+sles_spec1 = vcs_tag(
+    input : '../ndctl.spec.in',
+    output : 'ndctl.spec.sles.in',
+    command: vcs_tagger,
+    replace_string : 'VERSION',
+)
+
+header = files('header')
+
+sles_spec2 = custom_target('ndctl.spec.in',
+  command : [
+    'cat', header, '@INPUT@',
+  ],
+  input : sles_spec1,
+  output : 'ndctl.spec.in',
+  capture : true,
+)
+
+sles_spec3 = custom_target('ndctl.spec',
+  command : [
+    'sed', '-e', 's,MESON,1,g',
+           '-e', 's,DAX_DNAME,libdaxctl-devel,g',
+           '-e', 's,CXL_DNAME,libcxl-devel,g',
+           '-e', 's,DNAME,libndctl-devel,g',
+           '-e', 's,%license,%doc,g',
+           '-e', 's,\(^License:.*GPL\)v2,\1-2.0,g',
+           '-e', 's,DAX_LNAME,libdaxctl@0@,g'.format(LIBDAXCTL_CURRENT - LIBDAXCTL_AGE),
+           '-e', 's,CXL_LNAME,libcxl@0@,g'.format(LIBCXL_CURRENT - LIBCXL_AGE),
+           '-e', 's,LNAME,libndctl@0@,g'.format(LIBNDCTL_CURRENT - LIBNDCTL_AGE),
+	   '@INPUT@'
+  ],
+
+  input : sles_spec2,
+  output : 'ndctl.spec',
+  capture : true,
+)

