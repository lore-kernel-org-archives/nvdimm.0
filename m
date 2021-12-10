Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0822CB5
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175694; x=1670711694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y+8XReiicifM/uB1sM5khsM42aItFHtjInKCWoe5u7o=;
  b=MpFoOQo4APQPebh86hGmyF1Ecb/JFwyosyPj1lzaEkEcArcEpoCGjhqP
   5xJivEx40hZXmqtg0GaIOtvHAXoOoCYrz0SjITMswKiQnZVawDgrW7l3q
   O/u1h5LIjQo+S55WUtPiiqE3S9Ric7A3O43VzBROL2XUPu+XEB2BHJ1ok
   7B9iwDNf7Zx52isS/spq4EdOlJQAjlIpg5nKkKi86Rm00xhqAegfqAIRJ
   tcvI+YLS1JTXjLMo79XgW+MQ1e/zAxTyB2dGfdCzR7k18ih7TiPfZVWJY
   BGq3QXgJ51QsbeLG/m21wVLNKIrHiff9fCAVqbpO+2t7DuzKWmoIqFxWt
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843368"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843368"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:47 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113676"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:46 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v3 07/11] daxctl: add basic config parsing support
Date: Fri, 10 Dec 2021 15:34:36 -0700
Message-Id: <20211210223440.3946603-8-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5927; h=from:subject; bh=y+8XReiicifM/uB1sM5khsM42aItFHtjInKCWoe5u7o=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr/4vaLyc8Fvk/Kpj0WG3ttk+v+5VPZVj3nyvbee0HE+9 mvT7fUcpC4MYF4OsmCLL3z0fGY/Jbc/nCUxwhJnDygQyhIGLUwAm4uDMyDBnWdIO8dy1AfzGsfFKGY /1Avc9j5LXi7mmuvvezgf/Fi5g+GcZ4/Oaf26y6/mK73t5Z8b+PH3lw1bfiJa/orO7d6/acpsVAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add support similar to ndctl and libndctl for parsing config files. This
allows storing a config file path/list in the daxctl_ctx, and adds APIs
for setting and retrieving it.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .../daxctl/daxctl-reconfigure-device.txt      |  8 ++++++++
 configure.ac                                  |  3 +++
 daxctl/lib/libdaxctl.c                        | 20 +++++++++++++++++++
 daxctl/libdaxctl.h                            |  2 ++
 Documentation/daxctl/Makefile.am              | 11 +++++++++-
 daxctl/Makefile.am                            |  3 ++-
 daxctl/lib/Makefile.am                        |  6 ++++++
 daxctl/lib/libdaxctl.sym                      |  2 ++
 8 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
index aa87d45..09556cc 100644
--- a/Documentation/daxctl/daxctl-reconfigure-device.txt
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
+include::attrs.adoc[]
+
 daxctl-reconfigure-device(1)
 ============================
 
@@ -250,6 +252,12 @@ ndctl create-namespace --mode=devdax | \
 	jq -r "\"[reconfigure-device $(uuidgen)]\", \"nvdimm.uuid = \(.uuid)\", \"mode = system-ram\"" >> $config_path
 ----
 
+The default location for daxctl config files is under {daxctl_confdir}/,
+and any file with a '.conf' suffix at this location is considered. It is
+acceptable to have multiple files containing ini-style config sections,
+but the {section, subsection} tuple must be unique across all config files
+under {daxctl_confdir}/.
+
 include::../copyright.txt[]
 
 SEE ALSO
diff --git a/configure.ac b/configure.ac
index 3f15a7b..39ad0d4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -178,6 +178,9 @@ AC_SUBST([ndctl_confdir])
 AC_SUBST([ndctl_conf])
 AC_SUBST([ndctl_monitorconf])
 
+daxctl_confdir=${sysconfdir}/daxctl.conf.d
+AC_SUBST([daxctl_confdir])
+
 daxctl_modprobe_datadir=${datadir}/daxctl
 daxctl_modprobe_data=daxctl.conf
 AC_SUBST([daxctl_modprobe_datadir])
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 860bd9c..f173bbb 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -37,6 +37,7 @@ struct daxctl_ctx {
 	struct log_ctx ctx;
 	int refcount;
 	void *userdata;
+	const char *config_path;
 	int regions_init;
 	struct list_head regions;
 	struct kmod_ctx *kmod_ctx;
@@ -68,6 +69,22 @@ DAXCTL_EXPORT void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata)
 	ctx->userdata = userdata;
 }
 
+DAXCTL_EXPORT int daxctl_set_config_path(struct daxctl_ctx *ctx,
+					 char *config_path)
+{
+	if ((!ctx) || (!config_path))
+		return -EINVAL;
+	ctx->config_path = config_path;
+	return 0;
+}
+
+DAXCTL_EXPORT const char *daxctl_get_config_path(struct daxctl_ctx *ctx)
+{
+	if (ctx == NULL)
+		return NULL;
+	return ctx->config_path;
+}
+
 /**
  * daxctl_new - instantiate a new library context
  * @ctx: context to establish
@@ -99,6 +116,9 @@ DAXCTL_EXPORT int daxctl_new(struct daxctl_ctx **ctx)
 	*ctx = c;
 	list_head_init(&c->regions);
 	c->kmod_ctx = kmod_ctx;
+	rc = daxctl_set_config_path(c, DAXCTL_CONF_DIR);
+	if (rc)
+		dbg(c, "Unable to set config path: %s\n", strerror(-rc));
 
 	return 0;
 out:
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 683ae9c..6b6c71f 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -28,6 +28,8 @@ int daxctl_get_log_priority(struct daxctl_ctx *ctx);
 void daxctl_set_log_priority(struct daxctl_ctx *ctx, int priority);
 void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata);
 void *daxctl_get_userdata(struct daxctl_ctx *ctx);
+int daxctl_set_config_path(struct daxctl_ctx *ctx, char *config_path);
+const char *daxctl_get_config_path(struct daxctl_ctx *ctx);
 
 struct daxctl_region;
 struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx, int id,
diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
index 5991731..9c43e61 100644
--- a/Documentation/daxctl/Makefile.am
+++ b/Documentation/daxctl/Makefile.am
@@ -33,11 +33,20 @@ EXTRA_DIST = $(man1_MANS)
 
 CLEANFILES = $(man1_MANS)
 
+.ONESHELL:
+attrs.adoc: $(srcdir)/Makefile.am
+	$(AM_V_GEN) cat <<- EOF >$@
+		:daxctl_confdir: $(daxctl_confdir)
+		:daxctl_conf: $(daxctl_conf)
+		:ndctl_keysdir: $(ndctl_keysdir)
+		EOF
+
 XML_DEPS = \
 	../../version.m4 \
 	../copyright.txt \
 	Makefile \
-	$(CONFFILE)
+	$(CONFFILE) \
+	attrs.adoc
 
 RM ?= rm -f
 
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index 9b1313a..7ee65c4 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -25,4 +25,5 @@ daxctl_LDADD =\
 	../libutil.a \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
-	$(JSON_LIBS)
+	$(JSON_LIBS) \
+	-liniparser
diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am
index 25efd83..3c47a4b 100644
--- a/daxctl/lib/Makefile.am
+++ b/daxctl/lib/Makefile.am
@@ -3,6 +3,12 @@ include $(top_srcdir)/Makefile.am.in
 %.pc: %.pc.in Makefile
 	$(SED_PROCESS)
 
+DISTCLEANFILES = config.h
+BUILT_SOURCES = config.h
+config.h: $(srcdir)/Makefile.am
+	$(AM_V_GEN) echo "/* Autogenerated by daxctl/Makefile.am */" >$@ && \
+		echo '#define DAXCTL_CONF_DIR  "$(daxctl_confdir)"' >>$@
+
 pkginclude_HEADERS = ../libdaxctl.h
 lib_LTLIBRARIES = libdaxctl.la
 
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index a13e93d..fe68fd0 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -96,4 +96,6 @@ LIBDAXCTL_9 {
 global:
 	daxctl_dev_will_auto_online_memory;
 	daxctl_dev_has_online_memory;
+	daxctl_set_config_path;
+	daxctl_get_config_path;
 } LIBDAXCTL_8;
-- 
2.33.1

