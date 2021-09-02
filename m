Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9047D3FD5
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 20:43:28 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="219300529"
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="219300529"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 13:43:28 -0700
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="691676454"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 13:43:27 -0700
Subject: [ndctl PATCH v2 5/6] build: Add meson build infrastructure
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, vishal.l.verma@intel.com,
 linux-cxl@vger.kernel.org
Date: Thu, 02 Sep 2021 13:43:27 -0700
Message-ID: <163061540739.1943957.16160705686052773753.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Build times improve from 10s of seconds to sub-second builds especially
when ccache gets involved and the only change is a git version bump. Recall
that every time the version changes with autotools it does a reconfigure.
With meson only the objects that depend on the version string are rebuilt.
So the primary motivation is to make the ndctl project more enjoyable to
develop.

Tools, libraries, documentation, and tests all seem to be working. The
remaining work is to redo the rpm build infrastructure, and validate that
installation is working as expected.

Given the long standing momentum on the old build system it is still kept
functional for now. The only compatibility hack when moving from an
autotools build to a meson build is to delete the config.h files generated
by the old system in favor of the unified configuration header build from
the config.h.meson template.

Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .gitignore                        |    5 +
 Documentation/cxl/lib/meson.build |   79 +++++++++++
 Documentation/cxl/meson.build     |   84 ++++++++++++
 Documentation/daxctl/meson.build  |   88 ++++++++++++
 Documentation/ndctl/meson.build   |  124 +++++++++++++++++
 clean_config.sh                   |    2 
 config.h.meson                    |  149 ++++++++++++++++++++
 contrib/meson.build               |   16 ++
 cxl/lib/meson.build               |   35 +++++
 cxl/meson.build                   |   25 +++
 daxctl/lib/meson.build            |   44 ++++++
 daxctl/meson.build                |   27 ++++
 meson.build                       |  269 +++++++++++++++++++++++++++++++++++++
 meson_options.txt                 |   23 +++
 ndctl/lib/meson.build             |   48 +++++++
 ndctl/meson.build                 |   85 ++++++++++++
 test/meson.build                  |  262 ++++++++++++++++++++++++++++++++++++
 tools/meson-vcs-tag.sh            |   18 ++
 util/meson.build                  |   15 ++
 version.h.in                      |    2 
 20 files changed, 1399 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/lib/meson.build
 create mode 100644 Documentation/cxl/meson.build
 create mode 100644 Documentation/daxctl/meson.build
 create mode 100644 Documentation/ndctl/meson.build
 create mode 100755 clean_config.sh
 create mode 100644 config.h.meson
 create mode 100644 contrib/meson.build
 create mode 100644 cxl/lib/meson.build
 create mode 100644 cxl/meson.build
 create mode 100644 daxctl/lib/meson.build
 create mode 100644 daxctl/meson.build
 create mode 100644 meson.build
 create mode 100644 meson_options.txt
 create mode 100644 ndctl/lib/meson.build
 create mode 100644 ndctl/meson.build
 create mode 100644 test/meson.build
 create mode 100755 tools/meson-vcs-tag.sh
 create mode 100644 util/meson.build
 create mode 100644 version.h.in

diff --git a/.gitignore b/.gitignore
index 6468c7a91f06..4cb232519e72 100644
--- a/.gitignore
+++ b/.gitignore
@@ -9,7 +9,9 @@ Makefile.in
 /aclocal.m4
 /autom4te.cache
 /build-aux
-/config.*
+/config.h
+/config.log
+/config.status
 /configure
 /libtool
 /stamp-h1
@@ -25,6 +27,7 @@ Documentation/cxl/asciidoctor-extensions.rb
 Documentation/cxl/lib/asciidoctor-extensions.rb
 Documentation/ndctl/attrs.adoc
 .dirstamp
+build/
 daxctl/config.h
 daxctl/daxctl
 daxctl/lib/libdaxctl.la
diff --git a/Documentation/cxl/lib/meson.build b/Documentation/cxl/lib/meson.build
new file mode 100644
index 000000000000..fbfd776b4dcb
--- /dev/null
+++ b/Documentation/cxl/lib/meson.build
@@ -0,0 +1,79 @@
+if get_option('asciidoctor').enabled()
+  asciidoc_conf = custom_target('asciidoctor-extensions.rb',
+    command : [
+      'sed', '-e', 's,@Utility@,libcxl,g', '-e', 's,@utility@,cxl,g', '@INPUT@'
+    ],
+    input : '../../asciidoctor-extensions.rb.in',
+    output : 'asciidoctor-extensions.rb',
+    capture : true,
+  )
+else
+  asciidoc_conf = custom_target('asciidoc.conf',
+    command : [
+      'sed', '-e', 's,UTILITY,libcxl,g',
+    ],
+    input : '../../asciidoc.conf.in',
+    output : 'asciidoc.conf',
+    capture : true,
+  )
+endif
+
+filedeps = [
+        '../../copyright.txt',
+]
+
+libcxl_manpages = [
+  'libcxl.txt',
+  'cxl_new.txt',
+]
+
+foreach man : libcxl_manpages
+  name = man.split('.')[0]
+  output = name + '.3'
+  output_xml = name + '.xml'
+  if get_option('asciidoctor').enabled()
+    custom_target(name,
+      command : [
+        asciidoc,
+        '-b', 'manpage', '-d', 'manpage', '-acompat-mode', '-I', '@OUTDIR@',
+        '-rasciidoctor-extensions', '-amansource=libcxl',
+        '-amanmanual=libcxl Manual',
+        '-andctl_version=@0@'.format(meson.project_version()),
+        '-o', '@OUTPUT@', '@INPUT@'
+      ],
+      input : man,
+      output : output,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man3'),
+    )
+  else
+    xml = custom_target(output_xml,
+      command : [
+        asciidoc,
+	'-b', 'docbook', '-d', 'manpage', '-f', asciidoc_conf, '--unsafe',
+	'-andctl_version=@0@'.format(meson.project_version()),
+	'-o', '@OUTPUT@', '@INPUT@',
+      ],
+      input : man,
+      output : output_xml,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+    )
+
+    xsl = files('../../manpage-normal.xsl')
+
+    custom_target(name,
+      command : [
+        xmlto, '-o', '@OUTDIR@', '-m', xsl, 'man', '@INPUT@'
+      ],
+      depends : xml,
+      depend_files : xsl,
+      input : xml,
+      output : output,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man3'),
+    )
+  endif
+endforeach
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
new file mode 100644
index 000000000000..da4e44edafe5
--- /dev/null
+++ b/Documentation/cxl/meson.build
@@ -0,0 +1,84 @@
+if get_option('asciidoctor').enabled()
+  asciidoc_conf = custom_target('asciidoctor-extensions.rb',
+    command : [
+      'sed', '-e', 's,@Utility@,cxl,g', '-e', 's,@utility@,cxl,g', '@INPUT@'
+    ],
+    input : '../asciidoctor-extensions.rb.in',
+    output : 'asciidoctor-extensions.rb',
+    capture : true,
+  )
+else
+  asciidoc_conf = custom_target('asciidoc.conf',
+    command : [
+      'sed', '-e', 's,UTILITY,cxl,g',
+    ],
+    input : '../asciidoc.conf.in',
+    output : 'asciidoc.conf',
+    capture : true,
+  )
+endif
+
+filedeps = [
+        '../copyright.txt',
+]
+
+cxl_manpages = [
+  'cxl.txt',
+  'cxl-list.txt',
+  'cxl-read-labels.txt',
+  'cxl-write-labels.txt',
+  'cxl-zero-labels.txt',
+]
+
+foreach man : cxl_manpages
+  name = man.split('.')[0]
+  output = name + '.1'
+  output_xml = name + '.xml'
+  if get_option('asciidoctor').enabled()
+    custom_target(name,
+      command : [
+        asciidoc,
+        '-b', 'manpage', '-d', 'manpage', '-acompat-mode', '-I', '@OUTDIR@',
+        '-rasciidoctor-extensions', '-amansource=cxl',
+        '-amanmanual=cxl Manual',
+        '-andctl_version=@0@'.format(meson.project_version()),
+        '-o', '@OUTPUT@', '@INPUT@'
+      ],
+      input : man,
+      output : output,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  else
+    xml = custom_target(output_xml,
+      command : [
+        asciidoc,
+	'-b', 'docbook', '-d', 'manpage', '-f', asciidoc_conf, '--unsafe',
+	'-andctl_version=@0@'.format(meson.project_version()),
+	'-o', '@OUTPUT@', '@INPUT@',
+      ],
+      input : man,
+      output : output_xml,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+    )
+
+    xsl = files('../manpage-normal.xsl')
+
+    custom_target(name,
+      command : [
+        xmlto, '-o', '@OUTDIR@', '-m', xsl, 'man', '@INPUT@'
+      ],
+      depends : xml,
+      depend_files : xsl,
+      input : xml,
+      output : output,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  endif
+endforeach
+
+subdir('lib')
diff --git a/Documentation/daxctl/meson.build b/Documentation/daxctl/meson.build
new file mode 100644
index 000000000000..4a80ecb98a9f
--- /dev/null
+++ b/Documentation/daxctl/meson.build
@@ -0,0 +1,88 @@
+if get_option('asciidoctor').enabled()
+  asciidoc_conf = custom_target('asciidoctor-extensions.rb',
+    command : [
+      'sed', '-e', 's,@Utility@,Daxctl,g', '-e', 's,@utility@,daxctl,g', '@INPUT@'
+    ],
+    input : '../asciidoctor-extensions.rb.in',
+    output : 'asciidoctor-extensions.rb',
+    capture : true,
+  )
+else
+  asciidoc_conf = custom_target('asciidoc.conf',
+    command : [
+      'sed', '-e', 's,UTILITY,daxctl,g',
+    ],
+    input : '../asciidoc.conf.in',
+    output : 'asciidoc.conf',
+    capture : true,
+  )
+endif
+
+filedeps = [
+	'human-option.txt',
+        '../copyright.txt',
+]
+
+daxctl_manpages = [
+  'daxctl.txt',
+  'daxctl-list.txt',
+  'daxctl-migrate-device-model.txt',
+  'daxctl-reconfigure-device.txt',
+  'daxctl-online-memory.txt',
+  'daxctl-offline-memory.txt',
+  'daxctl-disable-device.txt',
+  'daxctl-enable-device.txt',
+  'daxctl-create-device.txt',
+  'daxctl-destroy-device.txt',
+]
+
+foreach man : daxctl_manpages
+  name = man.split('.')[0]
+  output = name + '.1'
+  output_xml = name + '.xml'
+  if get_option('asciidoctor').enabled()
+    custom_target(name,
+      command : [
+        asciidoc,
+        '-b', 'manpage', '-d', 'manpage', '-acompat-mode', '-I', '@OUTDIR@',
+        '-rasciidoctor-extensions', '-amansource=daxctl',
+        '-amanmanual=daxctl Manual',
+        '-andctl_version=@0@'.format(meson.project_version()),
+        '-o', '@OUTPUT@', '@INPUT@'
+      ],
+      input : man,
+      output : output,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  else
+    xml = custom_target(output_xml,
+      command : [
+        asciidoc,
+	'-b', 'docbook', '-d', 'manpage', '-f', asciidoc_conf, '--unsafe',
+	'-andctl_version=@0@'.format(meson.project_version()),
+	'-o', '@OUTPUT@', '@INPUT@',
+      ],
+      input : man,
+      output : output_xml,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+    )
+
+    xsl = files('../manpage-normal.xsl')
+
+    custom_target(name,
+      command : [
+        xmlto, '-o', '@OUTDIR@', '-m', xsl, 'man', '@INPUT@'
+      ],
+      depends : xml,
+      depend_files : xsl,
+      input : xml,
+      output : output,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  endif
+endforeach
diff --git a/Documentation/ndctl/meson.build b/Documentation/ndctl/meson.build
new file mode 100644
index 000000000000..9e16eb399fa3
--- /dev/null
+++ b/Documentation/ndctl/meson.build
@@ -0,0 +1,124 @@
+if get_option('asciidoctor').enabled()
+  asciidoc_conf = custom_target('asciidoctor-extensions.rb',
+    command : [
+      'sed', '-e', 's,@Utility@,Ndctl,g', '-e', 's,@utility@,ndctl,g', '@INPUT@'
+    ],
+    input : '../asciidoctor-extensions.rb.in',
+    output : 'asciidoctor-extensions.rb',
+    capture : true,
+  )
+else
+  asciidoc_conf = custom_target('asciidoc.conf',
+    command : [
+      'sed', '-e', 's,UTILITY,ndctl,g',
+    ],
+    input : '../asciidoc.conf.in',
+    output : 'asciidoc.conf',
+    capture : true,
+  )
+endif
+
+filedeps = [
+        '../copyright.txt',
+        'region-description.txt',
+        'xable-region-options.txt',
+        'dimm-description.txt',
+        'xable-dimm-options.txt',
+        'xable-namespace-options.txt',
+        'ars-description.txt',
+        'labels-description.txt',
+        'labels-options.txt',
+]
+
+ndctl_manpages = [
+  'ndctl.txt',
+  'ndctl-wait-scrub.txt',
+  'ndctl-start-scrub.txt',
+  'ndctl-zero-labels.txt',
+  'ndctl-read-labels.txt',
+  'ndctl-write-labels.txt',
+  'ndctl-init-labels.txt',
+  'ndctl-check-labels.txt',
+  'ndctl-enable-region.txt',
+  'ndctl-disable-region.txt',
+  'ndctl-enable-dimm.txt',
+  'ndctl-disable-dimm.txt',
+  'ndctl-enable-namespace.txt',
+  'ndctl-disable-namespace.txt',
+  'ndctl-create-namespace.txt',
+  'ndctl-destroy-namespace.txt',
+  'ndctl-check-namespace.txt',
+  'ndctl-clear-errors.txt',
+  'ndctl-inject-error.txt',
+  'ndctl-inject-smart.txt',
+  'ndctl-update-firmware.txt',
+  'ndctl-list.txt',
+  'ndctl-monitor.txt',
+  'ndctl-setup-passphrase.txt',
+  'ndctl-update-passphrase.txt',
+  'ndctl-remove-passphrase.txt',
+  'ndctl-freeze-security.txt',
+  'ndctl-sanitize-dimm.txt',
+  'ndctl-load-keys.txt',
+  'ndctl-wait-overwrite.txt',
+  'ndctl-read-infoblock.txt',
+  'ndctl-write-infoblock.txt',
+  'ndctl-activate-firmware.txt',
+]
+
+foreach man : ndctl_manpages
+  name = man.split('.')[0]
+  output = name + '.1'
+  output_xml = name + '.xml'
+  if get_option('asciidoctor').enabled()
+    custom_target(name,
+      command : [
+        asciidoc,
+        '-b', 'manpage', '-d', 'manpage', '-acompat-mode', '-I', '@OUTDIR@',
+        '-rasciidoctor-extensions', '-amansource=ndctl',
+        '-amanmanual=ndctl Manual',
+	'-andctl_monitorconfdir=@0@'.format(ndctlconf_dir),
+	'-andctl_monitorconf=@0@'.format(ndctlconf),
+	'-andctl_keysdir=@0@'.format(ndctlkeys_dir),
+        '-andctl_version=@0@'.format(meson.project_version()),
+        '-o', '@OUTPUT@', '@INPUT@'
+      ],
+      input : man,
+      output : output,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  else
+    xml = custom_target(output_xml,
+      command : [
+        asciidoc,
+	'-b', 'docbook', '-d', 'manpage', '-f', asciidoc_conf, '--unsafe',
+	'-andctl_version=@0@'.format(meson.project_version()),
+	'-andctl_monitorconfdir=@0@'.format(ndctlconf_dir),
+	'-andctl_monitorconf=@0@'.format(ndctlconf),
+	'-andctl_keysdir=@0@'.format(ndctlkeys_dir),
+	'-o', '@OUTPUT@', '@INPUT@',
+      ],
+      input : man,
+      output : output_xml,
+      depend_files : filedeps,
+      depends : asciidoc_conf,
+    )
+
+    xsl = files('../manpage-normal.xsl')
+
+    custom_target(name,
+      command : [
+        xmlto, '-o', '@OUTDIR@', '-m', xsl, 'man', '@INPUT@'
+      ],
+      depends : xml,
+      depend_files : xsl,
+      input : xml,
+      output : output,
+      install : get_option('docs').enabled(),
+      install_dir : join_paths(get_option('mandir'), 'man1'),
+    )
+  endif
+endforeach
diff --git a/clean_config.sh b/clean_config.sh
new file mode 100755
index 000000000000..03ec04c5554b
--- /dev/null
+++ b/clean_config.sh
@@ -0,0 +1,2 @@
+#!/bin/bash
+git ls-files -o --exclude build | grep config.h\$ | xargs rm
diff --git a/config.h.meson b/config.h.meson
new file mode 100644
index 000000000000..4796ea67b0db
--- /dev/null
+++ b/config.h.meson
@@ -0,0 +1,149 @@
+/* Debug messages. */
+#mesondefine ENABLE_DEBUG
+
+/* destructive functional tests support */
+#mesondefine ENABLE_DESTRUCTIVE
+
+/* Documentation / man pages. */
+#mesondefine ENABLE_DOCS
+
+/* Enable keyutils support */
+#mesondefine ENABLE_KEYUTILS
+
+/* System logging. */
+#mesondefine ENABLE_LOGGING
+
+/* ndctl test poison support */
+#mesondefine ENABLE_POISON
+
+/* ndctl test support */
+#mesondefine ENABLE_TEST
+
+/* Define to 1 if big-endian-arch */
+#mesondefine HAVE_BIG_ENDIAN
+
+/* Define to 1 if you have the declaration of `BUS_MCEERR_AR', and to 0 if you
+   don't. */
+#mesondefine HAVE_DECL_BUS_MCEERR_AR
+
+/* Define to 1 if you have the declaration of `MAP_SHARED_VALIDATE', and to 0
+   if you don't. */
+#mesondefine HAVE_DECL_MAP_SHARED_VALIDATE
+
+/* Define to 1 if you have the declaration of `MAP_SYNC', and to 0 if you
+   don't. */
+#mesondefine HAVE_DECL_MAP_SYNC
+
+/* Define to 1 if you have the <dlfcn.h> header file. */
+#mesondefine HAVE_DLFCN_H
+
+/* Define to 1 if you have the <inttypes.h> header file. */
+#mesondefine HAVE_INTTYPES_H
+
+/* Define to 1 if you have the <keyutils.h> header file. */
+#mesondefine HAVE_KEYUTILS_H
+
+/* Define to 1 if you have the <linux/version.h> header file. */
+#mesondefine HAVE_LINUX_VERSION_H
+
+/* Define to 1 if little-endian-arch */
+#mesondefine HAVE_LITTLE_ENDIAN
+
+/* Define to 1 if you have the <memory.h> header file. */
+#mesondefine HAVE_MEMORY_H
+
+/* Define to 1 if you have the `secure_getenv' function. */
+#mesondefine HAVE_SECURE_GETENV
+
+/* Define to 1 if you have statement expressions. */
+#mesondefine HAVE_STATEMENT_EXPR
+
+/* Define to 1 if you have the <stdint.h> header file. */
+#mesondefine HAVE_STDINT_H
+
+/* Define to 1 if you have the <stdlib.h> header file. */
+#mesondefine HAVE_STDLIB_H
+
+/* Define to 1 if you have the <strings.h> header file. */
+#mesondefine HAVE_STRINGS_H
+
+/* Define to 1 if you have the <string.h> header file. */
+#mesondefine HAVE_STRING_H
+
+/* Define to 1 if you have the <sys/stat.h> header file. */
+#mesondefine HAVE_SYS_STAT_H
+
+/* Define to 1 if you have the <sys/types.h> header file. */
+#mesondefine HAVE_SYS_TYPES_H
+
+/* Define to 1 if typeof works with your compiler. */
+#mesondefine HAVE_TYPEOF
+
+/* Define to 1 if you have the <unistd.h> header file. */
+#mesondefine HAVE_UNISTD_H
+
+/* Define to 1 if using libuuid */
+#mesondefine HAVE_UUID
+
+/* Define to 1 if you have the `__secure_getenv' function. */
+#mesondefine HAVE___SECURE_GETENV
+
+/* Define to the sub-directory where libtool stores uninstalled libraries. */
+#mesondefine LT_OBJDIR
+
+/* Name of package */
+#mesondefine PACKAGE
+
+/* Define to the address where bug reports for this package should be sent. */
+#mesondefine PACKAGE_BUGREPORT
+
+/* Define to the full name of this package. */
+#mesondefine PACKAGE_NAME
+
+/* Define to the full name and version of this package. */
+#mesondefine PACKAGE_STRING
+
+/* Define to the one symbol short name of this package. */
+#mesondefine PACKAGE_TARNAME
+
+/* Define to the home page for this package. */
+#mesondefine PACKAGE_URL
+
+/* Define to the version of this package. */
+#mesondefine PACKAGE_VERSION
+
+/* Define to 1 if you have the ANSI C header files. */
+#mesondefine STDC_HEADERS
+
+/* Version number of package */
+#mesondefine VERSION
+
+/* Number of bits in a file offset, on hosts where this is settable. */
+#mesondefine _FILE_OFFSET_BITS
+
+/* Define for large files, on AIX-style hosts. */
+#mesondefine _LARGE_FILES
+
+/* Define to 1 if on MINIX. */
+#mesondefine _MINIX
+
+/* Define to 2 if the system does not provide POSIX.1 features except with
+   this defined. */
+#mesondefine _POSIX_1_SOURCE
+
+/* Define to 1 if you need to in order for `stat' and other things to work. */
+#mesondefine _POSIX_SOURCE
+
+/* Define to __typeof__ if your compiler spells it that way. */
+#mesondefine typeof
+
+/* Define to enable GNU Source Extensions */
+#mesondefine _GNU_SOURCE
+
+/* Locations to install configuration files, key config, man pages, etc.. */
+#mesondefine NDCTL_CONF_FILE
+#mesondefine NDCTL_KEYS_DIR
+#mesondefine NDCTL_MAN_PATH
+#mesondefine DAXCTL_MODPROBE_DATA
+#mesondefine DAXCTL_MODPROBE_INSTALL
+#mesondefine PREFIX
diff --git a/contrib/meson.build b/contrib/meson.build
new file mode 100644
index 000000000000..a6505d58cea4
--- /dev/null
+++ b/contrib/meson.build
@@ -0,0 +1,16 @@
+bashcompletiondir = get_option('bashcompletiondir')
+if bashcompletiondir == ''
+  bash_completion = dependency('bash-completion', required : false)
+  if bash_completion.found()
+      bashcompletiondir = bash_completion.get_pkgconfig_variable('completionsdir')
+  else
+    bashcompletiondir = datadir / 'bash-completion/completions'
+  endif
+endif
+
+if bashcompletiondir != 'no'
+  install_data('ndctl', install_dir : bashcompletiondir)
+endif
+
+modprobedatadir = get_option('sysconfdir') + '/modprobe.d/'
+install_data('nvdimm-security.conf', install_dir : modprobedatadir)
diff --git a/cxl/lib/meson.build b/cxl/lib/meson.build
new file mode 100644
index 000000000000..eba0ce7278e7
--- /dev/null
+++ b/cxl/lib/meson.build
@@ -0,0 +1,35 @@
+libcxl_version = '@0@.@1@.@2@'.format(
+  LIBCXL_CURRENT - LIBCXL_AGE,
+  LIBCXL_REVISION,
+  LIBCXL_AGE)
+
+mapfile = files('libcxl.sym')
+vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+
+cxl = library('cxl',
+  '../../util/sysfs.c',
+  '../../util/log.c',
+  '../../util/log.h',
+  'libcxl.c',
+  include_directories : root_inc,
+  dependencies : [
+    uuid,
+    kmod,
+  ],
+  version : libcxl_version,
+  install : true,
+  install_dir : rootlibdir,
+  link_args : vflag,
+  link_depends : mapfile,
+)
+cxl_dep = declare_dependency(link_with : cxl)
+
+custom_target(
+  'libcxl.pc',
+  command : pkgconfig_script + [ '@INPUT@' ],
+  input : 'libcxl.pc.in',
+  output : 'libcxl.pc',
+  capture : true,
+  install : true,
+  install_dir : pkgconfiglibdir,
+)
diff --git a/cxl/meson.build b/cxl/meson.build
new file mode 100644
index 000000000000..146c8493330e
--- /dev/null
+++ b/cxl/meson.build
@@ -0,0 +1,25 @@
+cxl_src = [
+  'cxl.c',
+  'list.c',
+  'memdev.c',
+  '../util/json.c',
+  'json.c',
+  'filter.c',
+]
+
+cxl_tool = executable('cxl',
+  cxl_src,
+  include_directories : root_inc,
+  dependencies : [
+    versiondep,
+    cxl_dep,
+    util_dep,
+    uuid,
+    kmod,
+    json,
+  ],
+  install : true,
+  install_dir : rootbindir,
+)
+
+install_headers('libcxl.h', subdir : 'cxl')
diff --git a/daxctl/lib/meson.build b/daxctl/lib/meson.build
new file mode 100644
index 000000000000..b79c6e591945
--- /dev/null
+++ b/daxctl/lib/meson.build
@@ -0,0 +1,44 @@
+libdaxctl_version = '@0@.@1@.@2@'.format(
+  LIBDAXCTL_CURRENT - LIBDAXCTL_AGE,
+  LIBDAXCTL_REVISION,
+  LIBDAXCTL_AGE,
+)
+
+mapfile = files('libdaxctl.sym')
+vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+
+libdaxctl_src = [
+  '../../util/iomem.c',
+  '../../util/sysfs.c',
+  '../../util/log.c',
+  'libdaxctl.c',
+]
+
+daxctl = library(
+ 'daxctl',
+  libdaxctl_src,
+  version : libdaxctl_version,
+  include_directories : root_inc,
+  dependencies : [
+    uuid,
+    kmod,
+  ],
+  install : true,
+  install_dir : rootlibdir,
+  link_args : vflag,
+  link_depends : mapfile,
+)
+
+daxctl_dep = declare_dependency(link_with : daxctl)
+
+custom_target(
+  'libdaxctl.pc',
+  command : pkgconfig_script + [ '@INPUT@' ],
+  input : 'libdaxctl.pc.in',
+  output : 'libdaxctl.pc',
+  capture : true,
+  install : true,
+  install_dir : pkgconfiglibdir,
+)
+
+install_data('daxctl.conf', install_dir : datadir / 'daxctl')
diff --git a/daxctl/meson.build b/daxctl/meson.build
new file mode 100644
index 000000000000..c6738743b5d1
--- /dev/null
+++ b/daxctl/meson.build
@@ -0,0 +1,27 @@
+daxctl_src = [
+  'daxctl.c',
+  'acpi.c',
+  'list.c',
+  'migrate.c',
+  'device.c',
+  '../util/json.c',
+  'json.c',
+  'filter.c',
+]
+
+daxctl_tool = executable('daxctl',
+  daxctl_src,
+  include_directories : root_inc,
+  dependencies : [
+    versiondep,
+    daxctl_dep,
+    util_dep,
+    uuid,
+    kmod,
+    json,
+  ],
+  install : true,
+  install_dir : rootbindir,
+)
+
+install_headers('libdaxctl.h', subdir : 'daxctl')
diff --git a/meson.build b/meson.build
new file mode 100644
index 000000000000..746408948e4d
--- /dev/null
+++ b/meson.build
@@ -0,0 +1,269 @@
+project('ndctl', 'c',
+  version : '71',
+  license : [
+    'GPL-2.0',
+    'LGPL-2.1',
+    'CC0-1.0',
+    'MIT',
+  ],
+  default_options : [
+    'c_std=gnu99',
+    'prefix=/usr',
+    'sysconfdir=/etc',
+    'localstatedir=/var',
+  ],
+)
+
+# rootprefixdir and rootlibdir setup copied from systemd:
+rootprefixdir = get_option('rootprefix')
+rootprefix_default = '/usr'
+if rootprefixdir == ''
+        rootprefixdir = rootprefix_default
+endif
+rootbindir = join_paths(rootprefixdir, 'bin')
+
+# join_paths ignores the preceding arguments if an absolute component is
+# encountered, so this should canonicalize various paths when they are
+# absolute or relative.
+prefixdir = get_option('prefix')
+if not prefixdir.startswith('/')
+        error('Prefix is not absolute: "@0@"'.format(prefixdir))
+endif
+if prefixdir != rootprefixdir and rootprefixdir != '/' and not prefixdir.strip('/').startswith(rootprefixdir.strip('/') + '/')
+  error('Prefix is not below root prefix (now rootprefix=@0@ prefix=@1@)'.format(
+	rootprefixdir, prefixdir))
+endif
+
+libdir = join_paths(prefixdir, get_option('libdir'))
+rootlibdir = get_option('rootlibdir')
+if rootlibdir == ''
+  rootlibdir = join_paths(rootprefixdir, libdir.split('/')[-1])
+endif
+datadir = prefixdir / get_option('datadir')
+includedir = prefixdir / get_option('includedir')
+
+pkgconfiglibdir = get_option('pkgconfiglibdir') != '' ? get_option('pkgconfiglibdir') : libdir / 'pkgconfig'
+
+datadir = prefixdir / get_option('datadir')
+includedir = prefixdir / get_option('includedir')
+sysconfdir =  get_option('sysconfdir')
+
+pkgconfig_script = '''
+sed -e s,@VERSION@,@0@,g
+    -e s,@prefix@,@1@,g
+    -e s,@exec_prefix@,@1@,g
+    -e s,@libdir@,@2@,g
+    -e s,@includedir@,@3@,g
+'''.format(meson.project_version(), prefixdir, libdir, includedir).split()
+
+cc_flags = [
+  '-Wall',
+  '-Wchar-subscripts',
+  '-Wformat-security',
+  '-Wmissing-declarations',
+  '-Wmissing-prototypes',
+  '-Wnested-externs ',
+  '-Wshadow',
+  '-Wsign-compare',
+  '-Wstrict-prototypes',
+  '-Wtype-limits',
+  '-Wmaybe-uninitialized',
+  '-Wdeclaration-after-statement',
+  '-Wunused-result',
+  '-D_FORTIFY_SOURCE=2',
+  '-O2',
+]
+cc = meson.get_compiler('c')
+add_project_arguments(cc.get_supported_arguments(cc_flags), language : 'c')
+
+project_source_root = meson.current_source_dir()
+
+# Remove this after the conversion to meson has been completed
+# Cleanup the leftover config.h files to avoid conflicts with the meson
+# generated config.h
+git = find_program('git', required : false)
+if git.found()
+  run_command('clean_config.sh',
+    env : 'GIT_DIR=@0@/.git'.format(project_source_root),
+  )
+endif
+
+version_tag = get_option('version-tag')
+if version_tag != ''
+  vcs_data = configuration_data()
+  vcs_data.set('VCS_TAG', version_tag)
+  version_h = configure_file(
+    configuration : vcs_data,
+    input : 'version.h.in',
+    output : 'version.h'
+  )
+else
+  vcs_tagger = [
+    project_source_root + '/tools/meson-vcs-tag.sh',
+    project_source_root,
+    meson.project_version()
+  ]
+
+  version_h = vcs_tag(
+      input : 'version.h.in',
+      output : 'version.h',
+      command: vcs_tagger
+  )
+endif
+add_project_arguments('-include', 'version.h', language : 'c')
+
+versiondep = declare_dependency(sources: version_h)
+
+kmod = dependency('libkmod')
+udev = dependency('libudev')
+uuid = dependency('uuid')
+json = dependency('json-c')
+if get_option('docs').enabled()
+  if get_option('asciidoctor').enabled()
+    asciidoc = find_program('asciidoctor', required : true)
+  else
+    asciidoc = find_program('asciidoc', required : true)
+    xmlto = find_program('xmlto', required : true)
+  endif
+endif
+
+if get_option('systemd').enabled()
+  systemd = dependency('systemd', required : true)
+  systemdunitdir = systemd.get_pkgconfig_variable('systemd_system_unit_dir')
+endif
+
+cc = meson.get_compiler('c')
+
+# keyutils lacks pkgconfig
+keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
+
+conf = configuration_data()
+check_headers = [
+  ['HAVE_DLFCN_H', 'dlfcn.h'],
+  ['HAVE_INTTYPES_H', 'inttypes.h'],
+  ['HAVE_KEYUTILS_H', 'keyutils.h'],
+  ['HAVE_LINUX_VERSION_H', 'linux/version.h'],
+  ['HAVE_MEMORY_H', 'memory.h'],
+  ['HAVE_STDINT_H', 'stdint.h'],
+  ['HAVE_STDLIB_H', 'stdlib.h'],
+  ['HAVE_STRINGS_H', 'strings.h'],
+  ['HAVE_STRING_H', 'string.h'],
+  ['HAVE_SYS_STAT_H', 'sys/stat.h'],
+  ['HAVE_SYS_TYPES_H', 'sys/types.h'],
+  ['HAVE_UNISTD_H', 'unistd.h'],
+]
+
+foreach h : check_headers
+  if cc.has_header(h.get(1))
+    conf.set(h.get(0), 1)
+  endif
+endforeach
+
+map_sync_symbols = [
+  [ 'signal.h', 'BUS_MCEERR_AR' ],
+  [ 'linux/mman.h', 'MAP_SHARED_VALIDATE' ],
+  [ 'linux/mman.h', 'MAP_SYNC' ],
+]
+
+count = 0
+foreach symbol : map_sync_symbols
+  if cc.has_header_symbol(symbol[0], symbol[1])
+    conf.set('HAVE_DECL_@0@'.format(symbol[1].to_upper()), 1)
+    count = count + 1
+  endif
+endforeach
+
+poison_enabled = false
+if get_option('poison').enabled() and count == 3
+  poison_enabled = true
+endif
+
+conf.set('ENABLE_POISON', poison_enabled)
+conf.set('ENABLE_KEYUTILS', get_option('keyutils').enabled())
+conf.set('ENABLE_TEST', get_option('test').enabled())
+conf.set('ENABLE_DESTRUCTIVE', get_option('destructive').enabled())
+conf.set('ENABLE_LOGGING', get_option('logging').enabled())
+
+typeof = cc.run('''
+  int main() {
+    struct {
+      char a[16];
+    } x;
+    typeof(x) y;
+
+    return sizeof(x) == sizeof(y);
+  }
+  '''
+)
+
+if typeof.compiled() and typeof.returncode() == 1
+  conf.set('HAVE_TYPEOF', 1)
+  conf.set('HAVE_STATEMENT_EXPR', 1)
+endif
+
+if target_machine.endian() == 'big'
+  conf.set('HAVE_BIG_ENDIAN', 1)
+else
+  conf.set('HAVE_LITTLE_ENDIAN', 1)
+endif
+
+conf.set('_GNU_SOURCE', true)
+conf.set_quoted('PREFIX', get_option('prefix'))
+conf.set_quoted('NDCTL_MAN_PATH', get_option('mandir'))
+
+foreach ident : ['secure_getenv', '__secure_getenv']
+  conf.set10('HAVE_' + ident.to_upper(), cc.has_function(ident))
+endforeach
+
+
+ndctlconf_dir = sysconfdir / 'ndctl'
+ndctlconf = ndctlconf_dir / 'monitor.conf'
+conf.set_quoted('NDCTL_CONF_FILE', ndctlconf)
+
+ndctlkeys_dir = sysconfdir / 'ndctl'
+ndctlkeys = ndctlkeys_dir / 'keys'
+conf.set_quoted('NDCTL_KEYS_DIR', ndctlkeys)
+
+conf.set_quoted('DAXCTL_MODPROBE_DATA', datadir / 'daxctl/daxctl.conf')
+conf.set_quoted('DAXCTL_MODPROBE_INSTALL', sysconfdir / 'modprobe.d/daxctl.conf')
+
+config_h = configure_file(
+  input : 'config.h.meson',
+  output : 'config.h',
+  configuration : conf
+)
+add_project_arguments('-include', 'config.h', language : 'c')
+
+LIBNDCTL_CURRENT=25
+LIBNDCTL_REVISION=1
+LIBNDCTL_AGE=19
+
+LIBDAXCTL_CURRENT=6
+LIBDAXCTL_REVISION=0
+LIBDAXCTL_AGE=5
+
+LIBCXL_CURRENT=1
+LIBCXL_REVISION=0
+LIBCXL_AGE=0
+
+root_inc = include_directories(['.', 'ndctl', ])
+
+ccan = static_library('ccan',
+  [ 'ccan/str/str.c', 'ccan/list/list.c' ],
+)
+ccan_dep = declare_dependency(link_with : ccan)
+
+subdir('daxctl/lib')
+subdir('ndctl/lib')
+subdir('cxl/lib')
+subdir('util')
+subdir('ndctl')
+subdir('daxctl')
+subdir('cxl')
+if get_option('docs').enabled()
+  subdir('Documentation/ndctl')
+  subdir('Documentation/daxctl')
+  subdir('Documentation/cxl')
+endif
+subdir('test')
+subdir('contrib')
diff --git a/meson_options.txt b/meson_options.txt
new file mode 100644
index 000000000000..5ccbf1230b55
--- /dev/null
+++ b/meson_options.txt
@@ -0,0 +1,23 @@
+option('version-tag', type : 'string',
+       description : 'override the git version string')
+option('docs', type : 'feature', value : 'enabled')
+option('asciidoctor', type : 'feature', value : 'disabled')
+option('systemd', type : 'feature', value : 'enabled')
+option('keyutils', type : 'feature', value : 'enabled',
+  description : 'enable nvdimm device passphrase management')
+option('test', type : 'feature', value : 'disabled',
+  description : 'enable shipping tests in ndctl')
+option('destructive', type : 'feature', value : 'disabled',
+  description : 'enable tests that may clobber live system resources')
+option('poison', type : 'feature', value : 'enabled',
+  description : 'enable tests that inject poison / memory-failure')
+option('logging', type : 'feature', value : 'enabled',
+  description : 'enable log infrastructure')
+option('rootprefix', type : 'string',
+       description : '''override the root prefix [default '/' if split-usr and '/usr' otherwise]''')
+option('rootlibdir', type : 'string',
+       description : '''[/usr]/lib/x86_64-linux-gnu or such''')
+option('pkgconfiglibdir', type : 'string', value : '',
+       description : 'directory for standard pkg-config files')
+option('bashcompletiondir', type : 'string',
+       description : '''${datadir}/bash-completion/completions''')
diff --git a/ndctl/lib/meson.build b/ndctl/lib/meson.build
new file mode 100644
index 000000000000..fa46ea381cd4
--- /dev/null
+++ b/ndctl/lib/meson.build
@@ -0,0 +1,48 @@
+libndctl_version = '@0@.@1@.@2@'.format(
+  LIBNDCTL_CURRENT - LIBNDCTL_AGE,
+  LIBNDCTL_REVISION,
+  LIBNDCTL_AGE)
+
+mapfile = files('libndctl.sym')
+vflag = '-Wl,--version-script,@0@/@1@'.format(project_source_root, mapfile[0])
+
+ndctl = library(
+ 'ndctl',
+  '../../util/log.c',
+  '../../util/sysfs.c',
+  'dimm.c',
+  'inject.c',
+  'nfit.c',
+  'smart.c',
+  'intel.c',
+  'hpe1.c',
+  'msft.c',
+  'hyperv.c',
+  'papr.c',
+  'ars.c',
+  'firmware.c',
+  'libndctl.c',
+  dependencies : [
+    daxctl_dep,
+    udev,
+    uuid,
+    kmod,
+  ],
+  include_directories : root_inc,
+  version : libndctl_version,
+  install : true,
+  install_dir : rootlibdir,
+  link_args : vflag,
+  link_depends : mapfile,
+)
+ndctl_dep = declare_dependency(link_with : ndctl)
+
+custom_target(
+  'libndctl.pc',
+  command : pkgconfig_script + [ '@INPUT@' ],
+  input : 'libndctl.pc.in',
+  output : 'libndctl.pc',
+  capture : true,
+  install : true,
+  install_dir : pkgconfiglibdir,
+)
diff --git a/ndctl/meson.build b/ndctl/meson.build
new file mode 100644
index 000000000000..86b8c8f7abf3
--- /dev/null
+++ b/ndctl/meson.build
@@ -0,0 +1,85 @@
+ndctl_src = [
+  'ndctl.c',
+  'bus.c',
+  'create-nfit.c',
+  'namespace.c',
+  'check.c',
+  'region.c',
+  'dimm.c',
+  '../util/log.c',
+  '../daxctl/filter.c',
+  'filter.c',
+  'list.c',
+  '../util/json.c',
+  '../daxctl/json.c',
+  'json.c',
+  'json-smart.c',
+  'inject-error.c',
+  'inject-smart.c',
+  'monitor.c',
+]
+
+deps = [
+  versiondep,
+  util_dep,
+  ndctl_dep,
+  daxctl_dep,
+  cxl_dep,
+  uuid,
+  kmod,
+  json,
+]
+
+if get_option('keyutils').enabled()
+  ndctl_src += [
+    'keys.c',
+    'load-keys.c',
+  ]
+  deps += keyutils
+endif
+
+if get_option('test').enabled()
+  ndctl_src += [
+  '../test/libndctl.c',
+  '../test/dsm-fail.c',
+  '../util/sysfs.c',
+  '../test/dpa-alloc.c',
+  '../test/parent-uuid.c',
+  '../test/multi-pmem.c',
+  '../test/core.c',
+  'test.c',
+]
+endif
+
+if get_option('destructive').enabled()
+  if get_option('test').disabled()
+    error('destrive option requires -Dtest=enabled')
+  endif
+  ndctl_src += [
+    '../test/blk_namespaces.c',
+    '../test/pmem_namespaces.c',
+    'bat.c',
+  ]
+endif
+
+if get_option('systemd').enabled()
+  install_data('ndctl-monitor.service', install_dir : systemdunitdir)
+endif
+install_data('monitor.conf', install_dir : ndctlconf_dir)
+ndctlconfkeys_dir = ndctlconf_dir / 'keys/'
+install_data('keys.readme', install_dir : ndctlconfkeys_dir)
+
+ndctl_tool = executable('ndctl', ndctl_src,
+  dependencies : deps,
+  install : true,
+  install_dir : rootbindir,
+  include_directories : root_inc,
+)
+
+install_headers(
+  [
+    'libndctl.h',
+    'ndctl.h'
+  ],
+  subdir : 'ndctl'
+)
diff --git a/test/meson.build b/test/meson.build
new file mode 100644
index 000000000000..2c9d5b954331
--- /dev/null
+++ b/test/meson.build
@@ -0,0 +1,262 @@
+testcore = [
+  'core.c',
+  '../util/log.c',
+  '../util/sysfs.c',
+  '../util/hexdump.c',
+]
+
+libndctl_deps = [
+  ndctl_dep,
+  daxctl_dep,
+  uuid,
+  kmod,
+]
+
+ndctl_deps = libndctl_deps + [
+  json,
+  util_dep,
+]
+
+libndctl = executable('libndctl', testcore + [ 'libndctl.c'],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+namespace_core = [
+  '../ndctl/namespace.c',
+  '../ndctl/filter.c',
+  '../ndctl/check.c',
+  '../util/json.c',
+  '../ndctl/json.c',
+  '../daxctl/filter.c',
+  '../daxctl/json.c',
+]
+
+dsm_fail = executable('dsm-fail', testcore + namespace_core + [ 'dsm-fail.c' ],
+  dependencies : ndctl_deps,
+  include_directories : root_inc,
+)
+
+dpa_alloc = executable('dpa-alloc', testcore + [ 'dpa-alloc.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+parent_uuid = executable('parent-uuid', testcore + [ 'parent-uuid.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+multi_pmem = executable('multi-pmem', testcore + namespace_core
+    + [ 'multi-pmem.c' ],
+  dependencies : ndctl_deps,
+  include_directories : root_inc,
+)
+
+hugetlb_src = testcore + [ 'hugetlb.c', 'dax-pmd.c' ]
+if poison_enabled
+  hugetlb_src += [ 'dax-poison.c' ]
+endif
+hugetlb = executable('hugetlb', hugetlb_src,
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+ack_shutdown_count = executable('ack-shutdown-count-set',
+  testcore + [ 'ack-shutdown-count-set.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+dax_errors = executable('dax-errors', 'dax-errors.c')
+
+smart_notify = executable('smart-notify', 'smart-notify.c',
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+smart_listen = executable('smart-listen', 'smart-listen.c',
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+daxdev_errors = executable('daxdev-errors', [
+    'daxdev-errors.c',
+    '../util/log.c',
+    '../util/sysfs.c',
+  ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+list_smart_dimm = executable('list-smart-dimm', [
+    'list-smart-dimm.c',
+    '../ndctl/filter.c',
+    '../util/json.c',
+    '../ndctl/json.c',
+    '../daxctl/json.c',
+    '../daxctl/filter.c',
+  ],
+  dependencies : ndctl_deps,
+  include_directories : root_inc,
+)
+
+blk_ns = executable('blk-ns', testcore + [ 'blk_namespaces.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+pmem_ns = executable('pmem-ns', testcore + [ 'pmem_namespaces.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+dax_dev = executable('dax-dev', testcore + [ 'dax-dev.c' ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+dax_pmd_src = testcore + [ 'dax-pmd.c' ]
+if poison_enabled
+  dax_pmd_src += [ 'dax-poison.c' ]
+endif
+
+dax_pmd = executable('dax-pmd', dax_pmd_src,
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+device_dax_src = testcore + namespace_core + [
+  'device-dax.c',
+  'dax-dev.c',
+  'dax-pmd.c',
+]
+
+if poison_enabled
+  device_dax_src += 'dax-poison.c'
+endif
+
+device_dax = executable('device-dax', device_dax_src,
+  dependencies : ndctl_deps,
+  include_directories : root_inc,
+)
+
+revoke_devmem = executable('revoke_devmem', testcore + [
+    'revoke-devmem.c',
+    'dax-dev.c',
+  ],
+  dependencies : libndctl_deps,
+  include_directories : root_inc,
+)
+
+mmap = executable('mmap', 'mmap.c')
+
+create = find_program('create.sh')
+clear = find_program('clear.sh')
+pmem_errors = find_program('pmem-errors.sh')
+daxdev_errors_sh = find_program('daxdev-errors.sh')
+multi_dax = find_program('multi-dax.sh')
+btt_check = find_program('btt-check.sh')
+label_compat = find_program('label-compat.sh')
+blk_exhaust = find_program('blk-exhaust.sh')
+sector_mode = find_program('sector-mode.sh')
+inject_error = find_program('inject-error.sh')
+btt_errors = find_program('btt-errors.sh')
+btt_pad_compat = find_program('btt-pad-compat.sh')
+firmware_update = find_program('firmware-update.sh')
+rescan_partitions = find_program('rescan-partitions.sh')
+inject_smart = find_program('inject-smart.sh')
+monitor = find_program('monitor.sh')
+max_extent = find_program('max_available_extent_ns.sh')
+pfn_meta_errors = find_program('pfn-meta-errors.sh')
+track_uuid = find_program('track-uuid.sh')
+
+tests = [
+  [ 'libndctl',               libndctl ],
+  [ 'dsm-fail',               dsm_fail ],
+  [ 'dpa-alloc',              dpa_alloc ],
+  [ 'parent-uuid',            parent_uuid ],
+  [ 'multi-pmem',             multi_pmem ],
+  [ 'create.sh',              create ],
+  [ 'clear.sh',               clear ],
+  [ 'pmem-errors.sh',         pmem_errors ],
+  [ 'daxdev-errors.sh',       daxdev_errors_sh ],
+  [ 'multi-dax.sh',           multi_dax ],
+  [ 'btt-check.sh',           btt_check ],
+  [ 'label-compat.sh',        label_compat ],
+  [ 'blk-exhaust.sh',         blk_exhaust ],
+  [ 'sector-mode.sh',         sector_mode ],
+  [ 'inject-error.sh',        inject_error ],
+  [ 'btt-errors.sh',          btt_errors ],
+  [ 'hugetlb',                hugetlb ],
+  [ 'btt-pad-compat.sh',      btt_pad_compat ],
+  [ 'firmware-update.sh',     firmware_update ],
+  [ 'ack-shutdown-count-set', ack_shutdown_count ],
+  [ 'rescan-partitions.sh',   rescan_partitions ],
+  [ 'inject-smart.sh',        inject_smart ],
+  [ 'monitor.sh',             monitor ],
+  [ 'max_extent_ns',          max_extent ],
+  [ 'pfn-meta-errors.sh',     pfn_meta_errors ],
+  [ 'track-uuid.sh',          track_uuid ],
+]
+
+if get_option('destructive').enabled()
+  sub_section = find_program('sub-section.sh')
+  dax_ext4 = find_program('dax-ext4.sh')
+  dax_xfs = find_program('dax-xfs.sh')
+  align = find_program('align.sh')
+  device_dax_fio = find_program('device-dax-fio.sh')
+  daxctl_devices = find_program('daxctl-devices.sh')
+  daxctl_create = find_program('daxctl-create.sh')
+  dm = find_program('dm.sh')
+  mmap_test = find_program('mmap.sh')
+
+  tests += [
+    [ 'blk-ns',            blk_ns ],
+    [ 'pmem-ns',           pmem_ns ],
+    [ 'sub-section.sh',    sub_section ],
+    [ 'dax-dev',           dax_dev ],
+    [ 'dax-ext4.sh',       dax_ext4 ],
+    [ 'dax-xfs.sh',        dax_xfs ],
+    [ 'align.sh',          align ],
+    [ 'device-dax',        device_dax ],
+    [ 'revoke-devmem',     revoke_devmem ],
+    [ 'device-dax-fio.sh', device_dax_fio ],
+    [ 'daxctl-devices.sh', daxctl_devices ],
+    [ 'daxctl-create.sh',  daxctl_create ],
+    [ 'dm.sh',             dm ],
+    [ 'mmap.sh',           mmap_test ],
+  ]
+endif
+
+if get_option('keyutils').enabled()
+  security = find_program('security.sh')
+  tests += [
+    [ 'security.sh', security ]
+  ]
+endif
+
+foreach t : tests
+  test(t[0], t[1],
+    is_parallel : false,
+    depends : [
+      ndctl_tool,
+      daxctl_tool,
+      cxl_tool,
+      smart_notify,
+      list_smart_dimm,
+      dax_pmd,
+      dax_errors,
+      daxdev_errors,
+      dax_dev,
+      mmap,
+    ],
+    timeout : 0,
+    env : [
+      'NDCTL=@0@'.format(ndctl_tool.full_path()),
+      'DAXCTL=@0@'.format(daxctl_tool.full_path()),
+      'TEST_PATH=@0@'.format(meson.current_build_dir()),
+      'DATA_PATH=@0@'.format(meson.current_source_dir()),
+    ],
+  )
+endforeach
diff --git a/tools/meson-vcs-tag.sh b/tools/meson-vcs-tag.sh
new file mode 100755
index 000000000000..9f21c37b7d26
--- /dev/null
+++ b/tools/meson-vcs-tag.sh
@@ -0,0 +1,18 @@
+#!/usr/bin/env bash
+# SPDX-License-Identifier: LGPL-2.1-or-later
+
+set -eu
+set -o pipefail
+
+dir="${1:?}"
+fallback="${2:?}"
+
+# Apparently git describe has a bug where it always considers the work-tree
+# dirty when invoked with --git-dir (even though 'git status' is happy). Work
+# around this issue by cd-ing to the source directory.
+cd "$dir"
+# Check that we have either .git/ (a normal clone) or a .git file (a work-tree)
+# and that we don't get confused if a tarball is extracted in a higher-level
+# git repository.
+[ -e .git ] && git describe --abbrev=7 --dirty=+ 2>/dev/null | \
+	sed -e 's/^v//' -e 's/-/./g' || echo "$fallback"
diff --git a/util/meson.build b/util/meson.build
new file mode 100644
index 000000000000..15726bb1e6f5
--- /dev/null
+++ b/util/meson.build
@@ -0,0 +1,15 @@
+util = static_library('util', [
+  'parse-options.c',
+  'usage.c',
+  'size.c',
+  'main.c',
+  'help.c',
+  'strbuf.c',
+  'wrapper.c',
+  'bitmap.c',
+  'abspath.c',
+  'iomem.c',
+  ],
+  include_directories : root_inc,
+)
+util_dep = declare_dependency(link_with : util)
diff --git a/version.h.in b/version.h.in
new file mode 100644
index 000000000000..dedbaf95caf7
--- /dev/null
+++ b/version.h.in
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+#define VERSION "@VCS_TAG@"

