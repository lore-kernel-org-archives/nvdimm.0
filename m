Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489DB2C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418353; x=1672954353;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8EsYsC8sLdmWL7CZn1enLYmo+tnnY5yU8S9zwfashtY=;
  b=KJ9w5DOWDr75kXgFbKtZGzLJy9ciWEs4dhCYlbMyw5mkAVEabhPpE30h
   VtreIBY9anZVJB4eLCNa7jUwGouAb/x29Lwn1Z19bN5D5swEQWDgQjPQv
   b4aikuQuEQZJ9NjgHGL3IKpWAfML/ZPHqtd+aDCY9h7+6CYimxOa9q0BG
   Kvs8LbfxcqQEOCmhGWhauz6Xp3FgFK+L/RHQriHkshVnQRXqPOaNEVSnT
   ytI6S58Bh3KyTUbdHQA+bzXdIrkikmdFXOYGeg8wnZLLme6f9LvF7+jdz
   AANiM3Ov3otzo2BmfRZgTB18vj1f8+AgedyAeJBJyMfJywNtpkdravC6Z
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242746703"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="242746703"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="556686657"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:32 -0800
Subject: [ndctl PATCH v3 10/16] Documentation: Drop attrs.adoc include
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:32 -0800
Message-ID: <164141835217.3990253.17678912974035740752.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for switching build systems, drop the attrs.adoc include for
communicating variables to asciidoc. Simply add the necessary variable
values to the invocation of the command using the --attribute argument.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .gitignore                                         |    1 -
 Documentation/daxctl/Makefile.am                   |   17 +++++++----------
 Documentation/daxctl/daxctl-reconfigure-device.txt |    2 --
 Documentation/ndctl/Makefile.am                    |   17 +++++++----------
 Documentation/ndctl/intel-nvdimm-security.txt      |    2 --
 Documentation/ndctl/ndctl-load-keys.txt            |    2 --
 Documentation/ndctl/ndctl-monitor.txt              |    2 --
 Documentation/ndctl/ndctl-sanitize-dimm.txt        |    2 --
 Documentation/ndctl/ndctl-setup-passphrase.txt     |    2 --
 Documentation/ndctl/ndctl-update-passphrase.txt    |    2 --
 10 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/.gitignore b/.gitignore
index 6b19d90a12f1..4ab393e71a89 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,7 +23,6 @@ Documentation/daxctl/asciidoctor-extensions.rb
 Documentation/ndctl/asciidoctor-extensions.rb
 Documentation/cxl/asciidoctor-extensions.rb
 Documentation/cxl/lib/asciidoctor-extensions.rb
-Documentation/ndctl/attrs.adoc
 .dirstamp
 daxctl/config.h
 daxctl/daxctl
diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
index 9c43e6176b28..78c47f5055c4 100644
--- a/Documentation/daxctl/Makefile.am
+++ b/Documentation/daxctl/Makefile.am
@@ -33,20 +33,11 @@ EXTRA_DIST = $(man1_MANS)
 
 CLEANFILES = $(man1_MANS)
 
-.ONESHELL:
-attrs.adoc: $(srcdir)/Makefile.am
-	$(AM_V_GEN) cat <<- EOF >$@
-		:daxctl_confdir: $(daxctl_confdir)
-		:daxctl_conf: $(daxctl_conf)
-		:ndctl_keysdir: $(ndctl_keysdir)
-		EOF
-
 XML_DEPS = \
 	../../version.m4 \
 	../copyright.txt \
 	Makefile \
-	$(CONFFILE) \
-	attrs.adoc
+	$(CONFFILE)
 
 RM ?= rm -f
 
@@ -57,6 +48,9 @@ if USE_ASCIIDOCTOR
 		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
 		-I. -rasciidoctor-extensions \
 		-amansource=daxctl -amanmanual="daxctl Manual" \
+		-adaxctl_confdir=$(daxctl_confdir) \
+		-adaxctl_conf=$(daxctl_conf) \
+		-andctl_keysdir=$(ndctl_keysdir) \
 		-andctl_version=$(VERSION) -o $@+ $< && \
 		mv $@+ $@
 
@@ -65,6 +59,9 @@ else
 %.xml: %.txt $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@+ $@ && \
 		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
+		-adaxctl_confdir=$(daxctl_confdir) \
+		-adaxctl_conf=$(daxctl_conf) \
+		-andctl_keysdir=$(ndctl_keysdir) \
 		--unsafe -adaxctl_version=$(VERSION) -o $@+ $< && \
 		mv $@+ $@
 
diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
index b2184ec862bb..385c0c53931d 100644
--- a/Documentation/daxctl/daxctl-reconfigure-device.txt
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-include::attrs.adoc[]
-
 daxctl-reconfigure-device(1)
 ============================
 
diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 37855cc0585d..203158c1dfaf 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -56,14 +56,6 @@ EXTRA_DIST = $(man1_MANS)
 
 CLEANFILES = $(man1_MANS)
 
-.ONESHELL:
-attrs.adoc: $(srcdir)/Makefile.am
-	$(AM_V_GEN) cat <<- EOF >$@
-		:ndctl_confdir: $(ndctl_confdir)
-		:ndctl_monitorconf: $(ndctl_monitorconf)
-		:ndctl_keysdir: $(ndctl_keysdir)
-		EOF
-
 XML_DEPS = \
 	../../version.m4 \
 	Makefile \
@@ -76,8 +68,7 @@ XML_DEPS = \
 	xable-namespace-options.txt \
 	ars-description.txt \
 	labels-description.txt \
-	labels-options.txt \
-	attrs.adoc
+	labels-options.txt
 
 RM ?= rm -f
 
@@ -88,6 +79,9 @@ if USE_ASCIIDOCTOR
 		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
 		-I. -rasciidoctor-extensions \
 		-amansource=ndctl -amanmanual="ndctl Manual" \
+		-andctl_confdir=$(ndctl_confdir) \
+		-andctl_monitorconf=$(ndctl_monitorconf) \
+		-andctl_keysdir=$(ndctl_keysdir) \
 		-andctl_version=$(VERSION) -o $@+ $< && \
 		mv $@+ $@
 
@@ -96,6 +90,9 @@ else
 %.xml: %.txt $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@+ $@ && \
 		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
+		-andctl_confdir=$(ndctl_confdir) \
+		-andctl_monitorconf=$(ndctl_monitorconf) \
+		-andctl_keysdir=$(ndctl_keysdir) \
 		--unsafe -andctl_version=$(VERSION) -o $@+ $< && \
 		mv $@+ $@
 
diff --git a/Documentation/ndctl/intel-nvdimm-security.txt b/Documentation/ndctl/intel-nvdimm-security.txt
index 142b4603db69..88b305b81978 100644
--- a/Documentation/ndctl/intel-nvdimm-security.txt
+++ b/Documentation/ndctl/intel-nvdimm-security.txt
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-include::attrs.adoc[]
-
 THEORY OF OPERATION
 -------------------
 The Intel Device Specific Methods (DSM) specification v1.7 and v1.8 [1]
diff --git a/Documentation/ndctl/ndctl-load-keys.txt b/Documentation/ndctl/ndctl-load-keys.txt
index a064f97fd069..70db57441820 100644
--- a/Documentation/ndctl/ndctl-load-keys.txt
+++ b/Documentation/ndctl/ndctl-load-keys.txt
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-include::attrs.adoc[]
-
 ndctl-load-keys(1)
 ==================
 
diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
index 8c8c35b41ace..eca079d56a32 100644
--- a/Documentation/ndctl/ndctl-monitor.txt
+++ b/Documentation/ndctl/ndctl-monitor.txt
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-include::attrs.adoc[]
-
 ndctl-monitor(1)
 ================
 
diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index b2e5fde9ecb3..e04467856ca4 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-include::attrs.adoc[]
-
 ndctl-sanitize-dimm(1)
 ======================
 
diff --git a/Documentation/ndctl/ndctl-setup-passphrase.txt b/Documentation/ndctl/ndctl-setup-passphrase.txt
index 1219279b4c66..96f709b468fc 100644
--- a/Documentation/ndctl/ndctl-setup-passphrase.txt
+++ b/Documentation/ndctl/ndctl-setup-passphrase.txt
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-include::attrs.adoc[]
-
 ndctl-setup-passphrase(1)
 =========================
 
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
index c7c1bfc8ab0b..591ce44ebc3e 100644
--- a/Documentation/ndctl/ndctl-update-passphrase.txt
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-include::attrs.adoc[]
-
 ndctl-update-passphrase(1)
 ==========================
 

