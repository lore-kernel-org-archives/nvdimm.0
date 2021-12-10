Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4706D13
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175693; x=1670711693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jEfWQ/J3u0hPjKWY2OIjVkQ1WPOK8Isbg6xwo5/vLD0=;
  b=EwTdsK1NtVB1WhwBQfJwMnJplNClFDkgz7rfxvgENfNysz1TDbRA62Ka
   V/ankU2Myx1RFpslGa4UQrkwPLYXMG8E8KBcxGbQqg3FRI03Nw6z+a+n6
   3/XeaWRt79B9eAx4LYAmJC6AD6BCMwnrWvUL7o4k2l8nzoVw3EviDrn7e
   3z71mZ1GZeVVE2X02JRHDhEVSbQ4IQMEQd0NITT/pCyNNgO3r8nQ77aC6
   almhW9htmP4CQe8lESXB6MIHlXODbyL1gkiC+/I5W535ho0SO9c5mFGU1
   vujaiaUWgPrbSaJ+IniGuhFxYo8Uk6JD1xgCA3dZPuwetnmKpvEF5kbOY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843350"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843350"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113655"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:44 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	QI Fuli <qi.fuli@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 02/11] ndctl: make ndctl support configuration files
Date: Fri, 10 Dec 2021 15:34:31 -0700
Message-Id: <20211210223440.3946603-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5000; i=vishal.l.verma@intel.com; h=from:subject; bh=WpXwitG2R3C+mt4MMW+vxycw1yhO2F+09/vq7jZhkSk=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr/47YCcT2m5h+SOQYe5fY/u8FtXVt/PVl/iukfm8vYpl VWB4RykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZy8gcjw8OMqicaijPPV3Gem1aV+3 qx2KSUiaeviPi81Cl1rysyOMnwv9A+RyZt4uZnItpMF6ZGi8mr3K3xvf9+5c29B1Z2b2H34wUA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Add a 'config_path' to ndctl_ctx for supporting ndctl global configuration
files. Any file with a .conf suffix under {sysconfdir}/ndctl.conf.d/ will
be regarded as a global configuration file which can have INI-style config
sections. Add an ndctl_set_config_path() API for setting the default
configuration files' path for ndctl. Add an ndctl_get_config_path() API for
getting ndctl configuration files' path from ndctl_ctx.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac           |  5 +++--
 ndctl/lib/private.h    |  1 +
 ndctl/lib/libndctl.c   | 20 ++++++++++++++++++++
 ndctl/libndctl.h       |  2 ++
 ndctl/Makefile.am      |  4 ++--
 ndctl/lib/Makefile.am  |  6 ++++++
 ndctl/lib/libndctl.sym |  2 ++
 7 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index cbd5a6f..a264af7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -171,9 +171,10 @@ fi
 AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
-ndctl_monitorconfdir=${sysconfdir}/ndctl
+ndctl_confdir=${sysconfdir}/ndctl.conf.d
+ndctl_conf=ndctl.conf
 ndctl_monitorconf=monitor.conf
-AC_SUBST([ndctl_monitorconfdir])
+AC_SUBST([ndctl_confdir])
 AC_SUBST([ndctl_monitorconf])
 
 daxctl_modprobe_datadir=${datadir}/daxctl
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 8f4510e..d442e6c 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -129,6 +129,7 @@ struct ndctl_ctx {
 	int regions_init;
 	void *userdata;
 	struct list_head busses;
+	const char *config_path;
 	int busses_init;
 	struct udev *udev;
 	struct udev_queue *udev_queue;
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 536e142..1f742ff 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -265,6 +265,22 @@ NDCTL_EXPORT void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata)
 	ctx->userdata = userdata;
 }
 
+NDCTL_EXPORT int ndctl_set_config_path(struct ndctl_ctx *ctx, char *config_path)
+{
+	if ((!ctx) || (!config_path))
+		return -EINVAL;
+	ctx->config_path = config_path;
+
+	return 0;
+}
+
+NDCTL_EXPORT const char *ndctl_get_config_path(struct ndctl_ctx *ctx)
+{
+	if (ctx == NULL)
+		return NULL;
+	return ctx->config_path;
+}
+
 /**
  * ndctl_new - instantiate a new library context
  * @ctx: context to establish
@@ -327,6 +343,10 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 	if (!c->udev_queue)
 		err(c, "failed to retrieve udev queue\n");
 
+	rc = ndctl_set_config_path(c, NDCTL_CONF_DIR);
+	if (rc)
+		dbg(c, "Unable to set config path: %s\n", strerror(-rc));
+
 	c->kmod_ctx = kmod_ctx;
 	c->daxctl_ctx = daxctl_ctx;
 
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 87d07b7..3cc7f20 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -92,6 +92,8 @@ int ndctl_get_log_priority(struct ndctl_ctx *ctx);
 void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority);
 void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata);
 void *ndctl_get_userdata(struct ndctl_ctx *ctx);
+int ndctl_set_config_path(struct ndctl_ctx *ctx, char *config_path);
+const char *ndctl_get_config_path(struct ndctl_ctx *ctx);
 
 enum ndctl_persistence_domain {
 	PERSISTENCE_NONE = 0,
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index afdd03c..00d2612 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -7,7 +7,7 @@ BUILT_SOURCES = config.h
 config.h: $(srcdir)/Makefile.am
 	$(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@ && \
 	echo '#define NDCTL_CONF_FILE \
-		"$(ndctl_monitorconfdir)/$(ndctl_monitorconf)"' >>$@
+		"$(ndctl_confdir)/$(ndctl_monitorconf)"' >>$@
 	$(AM_V_GEN) echo '#define NDCTL_KEYS_DIR  "$(ndctl_keysdir)"' >>$@
 
 ndctl_SOURCES = ndctl.c \
@@ -74,7 +74,7 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 test.c
 endif
 
-monitor_configdir = $(ndctl_monitorconfdir)
+monitor_configdir = $(ndctl_confdir)
 monitor_config_DATA = $(ndctl_monitorconf)
 
 if ENABLE_SYSTEMD_UNITS
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index e15bb22..0a52c01 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -3,6 +3,12 @@ include $(top_srcdir)/Makefile.am.in
 %.pc: %.pc.in Makefile
 	$(SED_PROCESS)
 
+DISTCLEANFILES = config.h
+BUILT_SOURCES = config.h
+config.h: $(srcdir)/Makefile.am
+	$(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@ && \
+		echo '#define NDCTL_CONF_DIR  "$(ndctl_confdir)"' >>$@
+
 pkginclude_HEADERS = ../libndctl.h ../ndctl.h
 lib_LTLIBRARIES = libndctl.la
 
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 58afb74..66d7f21 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -454,4 +454,6 @@ LIBNDCTL_25 {
 
 LIBNDCTL_26 {
 	ndctl_bus_nfit_translate_spa;
+	ndctl_set_config_path;
+	ndctl_get_config_path;
 } LIBNDCTL_25;
-- 
2.33.1

