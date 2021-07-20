Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9E22FB9
	for <nvdimm@lists.linux.dev>; Tue, 20 Jul 2021 15:51:23 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="275086007"
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="275086007"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 08:51:22 -0700
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="510808306"
Received: from janandra-mobl.amr.corp.intel.com ([10.212.182.134])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 08:51:21 -0700
From: James Anandraj <james.sushanth.anandraj@intel.com>
To: nvdimm@lists.linux.dev,
	james.sushanth.anandraj@intel.com
Subject: [PATCH v2 1/4] Documentation/ipmregion: Add documentation for ipmregion tool and commands
Date: Tue, 20 Jul 2021 08:51:07 -0700
Message-Id: <20210720155110.14680-2-james.sushanth.anandraj@intel.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210720155110.14680-1-james.sushanth.anandraj@intel.com>
References: <20210720155110.14680-1-james.sushanth.anandraj@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>

Add man page files for ipmregion tool, ipmregion-list and
ipmregion-reconfigure-region commands. Ipmregion is a tool to
help region reconfiguration for 'nvdimm' devices.
It modifies a portion of the pcd region on 'nvdimm' devices to
reconfigure regions. The module Platform Configuration Data (PCD)
refers to a section of the PMem module that is used to store
metadata. The metadata stored in the PCD is the architected
interface between software and platform firmware to support
PMem provisioning

Signed-off-by: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>
---
 Documentation/ipmregion/Makefile.am           | 59 +++++++++++++++++++
 .../ipmregion/asciidoctor-extensions.rb       | 30 ++++++++++
 Documentation/ipmregion/ipmregion-list.txt    | 56 ++++++++++++++++++
 .../ipmregion-reconfigure-region.txt          | 51 ++++++++++++++++
 Documentation/ipmregion/ipmregion.txt         | 40 +++++++++++++
 .../ipmregion/theory-of-operation.txt         | 29 +++++++++
 Makefile.am                                   |  2 +-
 configure.ac                                  |  1 +
 8 files changed, 267 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ipmregion/Makefile.am
 create mode 100644 Documentation/ipmregion/asciidoctor-extensions.rb
 create mode 100644 Documentation/ipmregion/ipmregion-list.txt
 create mode 100644 Documentation/ipmregion/ipmregion-reconfigure-region.txt
 create mode 100644 Documentation/ipmregion/ipmregion.txt
 create mode 100644 Documentation/ipmregion/theory-of-operation.txt

diff --git a/Documentation/ipmregion/Makefile.am b/Documentation/ipmregion/Makefile.am
new file mode 100644
index 0000000..baadad5
--- /dev/null
+++ b/Documentation/ipmregion/Makefile.am
@@ -0,0 +1,59 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
+
+if USE_ASCIIDOCTOR
+
+do_subst = sed -e 's,@Utility@,Ipmregion,g' -e's,@utility@,ipmregion,g'
+CONFFILE = asciidoctor-extensions.rb
+asciidoctor-extensions.rb: ../asciidoctor-extensions.rb.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
+
+else
+
+do_subst = sed -e 's,UTILITY,ipmregion,g'
+CONFFILE = asciidoc.conf
+asciidoc.conf: ../asciidoc.conf.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
+
+endif
+
+man1_MANS = \
+	ipmregion.1 \
+	ipmregion-list.1 \
+	ipmregion-reconfigure-region.1
+
+EXTRA_DIST = $(man1_MANS)
+
+CLEANFILES = $(man1_MANS)
+
+XML_DEPS = \
+	../../version.m4 \
+	../copyright.txt \
+	Makefile \
+	$(CONFFILE)
+
+RM ?= rm -f
+
+if USE_ASCIIDOCTOR
+
+%.1: %.txt $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@+ $@ && \
+		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
+		-I. -rasciidoctor-extensions \
+		-amansource=ipmregion -amanmanual="ipmregion Manual" \
+		-andctl_version=$(VERSION) -o $@+ $< && \
+		mv $@+ $@
+
+else
+
+%.xml: %.txt $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@+ $@ && \
+		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
+		--unsafe -aipmregion_version=$(VERSION) -o $@+ $< && \
+		mv $@+ $@
+
+%.1: %.xml $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@ && \
+		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
+
+endif
diff --git a/Documentation/ipmregion/asciidoctor-extensions.rb b/Documentation/ipmregion/asciidoctor-extensions.rb
new file mode 100644
index 0000000..fa9b9f6
--- /dev/null
+++ b/Documentation/ipmregion/asciidoctor-extensions.rb
@@ -0,0 +1,30 @@
+require 'asciidoctor'
+require 'asciidoctor/extensions'
+
+module Ipmregion
+  module Documentation
+    class LinkIpmregionProcessor < Asciidoctor::Extensions::InlineMacroProcessor
+      use_dsl
+
+      named :chrome
+
+      def process(parent, target, attrs)
+        if parent.document.basebackend? 'html'
+          prefix = parent.document.attr('ipmregion-relative-html-prefix')
+          %(<a href="#{prefix}#{target}.html">#{target}(#{attrs[1]})</a>\n)
+        elsif parent.document.basebackend? 'manpage'
+          "#{target}(#{attrs[1]})"
+        elsif parent.document.basebackend? 'docbook'
+          "<citerefentry>\n" \
+            "<refentrytitle>#{target}</refentrytitle>" \
+            "<manvolnum>#{attrs[1]}</manvolnum>\n" \
+          "</citerefentry>\n"
+        end
+      end
+    end
+  end
+end
+
+Asciidoctor::Extensions.register do
+  inline_macro Ipmregion::Documentation::LinkIpmregionProcessor, :linkipmregion
+end
diff --git a/Documentation/ipmregion/ipmregion-list.txt b/Documentation/ipmregion/ipmregion-list.txt
new file mode 100644
index 0000000..799ccbb
--- /dev/null
+++ b/Documentation/ipmregion/ipmregion-list.txt
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ipmregion-list(1)
+=================
+
+NAME
+----
+ipmregion-list - dump the platform nvdimm device topology and region
+reconfiguration attributes in json.
+
+include::theory-of-operation.txt[]
+
+SYNOPSIS
+--------
+[verse]
+'ipmregion list' [<options>]
+
+Walk all the nvdimm buses in the system and list all attached devices
+along with some of their major attributes including region reconfiguration
+attributes. Region reconfiguration involves writing to the pcd region.
+followed by a platform reset. The reconfiguration attributes are obtained
+from fields in pcd region. The attributes are reconfigure_status and
+reconfigure_pending. Reconfigure_status presents a human readable status
+string for the last region reconfiguration action. Reconfigure_pending
+is a boolean that indicates if a region reconfiguration request
+has been written to the pcd region.
+
+Options can be specified to limit the output to objects of a certain
+bus.
+
+EXAMPLE
+-------
+----
+# ipmregion list
+[
+    {
+        "dev":"nmem1",
+        "id":"8089-a2-1823-00000043",
+        "handle":17,
+        "phys_id":33,
+        "reconfigure_status":"success"
+    }
+]
+----
+
+OPTIONS
+-------
+-b::
+--bus=::
+include::../ndctl/xable-bus-options.txt[]
+
+-v::
+--verbose::
+    Emit debug messages from the devices when reading pcd data.
+
+include::../copyright.txt[]
diff --git a/Documentation/ipmregion/ipmregion-reconfigure-region.txt b/Documentation/ipmregion/ipmregion-reconfigure-region.txt
new file mode 100644
index 0000000..8eab072
--- /dev/null
+++ b/Documentation/ipmregion/ipmregion-reconfigure-region.txt
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ipmregion-reconfigure-region(1)
+===============================
+
+NAME
+----
+ipmregion-reconfigure-region - reconfigure non-volatile memory device capacity
+into regions
+
+include::theory-of-operation.txt[]
+
+SYNOPSIS
+--------
+[verse]
+'ipmregion reconfigure-region' [<options>]
+
+EXAMPLES
+--------
+Request interleaved persistent memory region(s) on the default bus using
+maximum possible interleave ways to maximize bandwidth.
+[verse]
+ipmregion reconfigure-region
+
+Request non-interleaved persistent memory region(s) on the default bus.
+[verse]
+ipmregion reconfigure-region -m fault-isolation-pmem
+
+Request volatile memory region on the default bus.
+[verse]
+ipmregion reconfigure-regions –m ram
+
+OPTIONS
+-------
+-m::
+--mode::
+   Region reconfiguration request mode. Each region’s
+   capacity will be restricted to a single non-volatile memory device. The
+   possible values for this option are ram, performance-pmem and
+   fault-isolation-pmem. If this option is not specified the default is
+   fault-isolation-pmem.
+
+-b::
+--bus=::
+include::../ndctl/xable-bus-options.txt[]
+
+-v::
+--verbose::
+    Emit debug messages for the region configuration request process.
+
+include::../copyright.txt[]
diff --git a/Documentation/ipmregion/ipmregion.txt b/Documentation/ipmregion/ipmregion.txt
new file mode 100644
index 0000000..a3e10b0
--- /dev/null
+++ b/Documentation/ipmregion/ipmregion.txt
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ipmregion(1)
+============
+
+NAME
+----
+ipmregion - Provides enumeration and region reconfiguraion commands for "nvdimm"
+subsystem devices (Non-volatile Memory)
+
+include::theory-of-operation.txt[]
+
+SYNOPSIS
+--------
+[verse]
+'ipmregion' [--version] [--help] COMMAND [ARGS]
+
+OPTIONS
+-------
+-v::
+--version::
+  Display ipmregion version.
+
+-h::
+--help::
+  Run ipmregion help command.
+
+DESCRIPTION
+-----------
+The ipmregion utility provides enumeration and region reconfiguration commands for
+"nvdimm" subsystem devices (Non-volatile Memory). Operations
+supported by the tool include region reconfiguration and enumeration of the
+devices and their region reconfiguration status.
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkipmregion:ipmregion-list[1],
+linkipmregion:ipmregion-reconfigure-region[1]
diff --git a/Documentation/ipmregion/theory-of-operation.txt b/Documentation/ipmregion/theory-of-operation.txt
new file mode 100644
index 0000000..7af5267
--- /dev/null
+++ b/Documentation/ipmregion/theory-of-operation.txt
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+THEORY OF OPERATION
+-------------------
+A region is persistent memory from one or more non-volatile memory devices that
+is mapped into the system physical address (SPA) space. For some device vendors,
+reconfiguring regions is a multi-step process as follows.
+1. Generate a new region configuration request using this command.
+2. Reset the platform.
+3. Platform firmware (BIOS) processes the region configuration request and
+presents the new region configuration via ACPI NFIT tables. The status of this
+BIOS operation can be retrieved using the ipmregion-list command.
+
+Region types are as follows:
+1. Performance Persistent Memory Region (performance-pmem)
+This is a persistent memory region that utilizes hardware interleaving across
+non-volatile memory devices. This configuration maximizes bandwidth.
+2. Fault Isolation Persistent Memory Region (fault-isolation-pmem)
+This is a persistent memory region that does not utilize hardware interleaving
+across non-volatile memory devices. This configuration maximizes the isolation
+and resilency to faults in individual modules.
+3. Volatile Memory Region (ram)
+The portion of persistent memory in the system that is used in a volatile
+memory region is treated as volatile 'system-ram' to expand the overall system
+memory. This type of region is entirely managed by platform firmware (BIOS) and
+is no longer visible in 'ndctl' nor is it usable by applications as persistent
+storage. Additionally, in this mode, some portion of DRAM in the system is
+'consumed' by the platform firmware to act as a cache that fronts the
+persistent memory.
diff --git a/Makefile.am b/Makefile.am
index 60a1998..f9fec0c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,7 +3,7 @@ include Makefile.am.in
 ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
 SUBDIRS = . daxctl/lib ndctl/lib ndctl daxctl
 if ENABLE_DOCS
-SUBDIRS += Documentation/ndctl Documentation/daxctl
+SUBDIRS += Documentation/ndctl Documentation/daxctl Documentation/ipmregion
 endif
 SUBDIRS += test
 
diff --git a/configure.ac b/configure.ac
index 5ec8d2f..9f16b01 100644
--- a/configure.ac
+++ b/configure.ac
@@ -228,6 +228,7 @@ AC_CONFIG_FILES([
         test/Makefile
         Documentation/ndctl/Makefile
         Documentation/daxctl/Makefile
+        Documentation/ipmregion/Makefile
 ])
 
 AC_OUTPUT
-- 
2.20.1

