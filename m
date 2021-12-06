Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7ED6D19
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:29:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="236159420"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="236159420"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:43 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310426"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:41 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	QI Fuli <qi.fuli@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 03/12] ndctl: make ndctl support configuration files
Date: Mon,  6 Dec 2021 15:28:21 -0700
Message-Id: <20211206222830.2266018-4-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6278; i=vishal.l.verma@intel.com; h=from:subject; bh=OBjNslSnfV5IPEDTDiyymiGzda9gO91BNgvDtRnu7+4=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+no49XNXb5le7eZ8ULU4YsaXiQ7vNLc9FD9iKP1ovesJ pYUTOkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRu/MY/vCUpEqZzn52655lctPmay bzr2qsniTA4BKr/Nz7K8u+dG+G/84fv3/3z+BcPDsgt+9x8osQiyTP6c8Sn69ov3dqy5Ecax4A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Add ndctl_configs to ndctl_ctx for supporting ndctl global configuration
files. All files with .conf suffix under {sysconfdir}/ndctl can be
regarded as global configuration files that all ndctl commands can refer
to. Add ndctl_set_configs() public function for setting ndctl default
configuration files' path. Add ndctl_get_configs() public function for
getting ndctl configuration files' path form ndctl_ctx.

Link: https://lore.kernel.org/r/20210824095106.104808-4-qi.fuli@fujitsu.com
Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac           |  4 ++--
 ndctl/lib/private.h    |  1 +
 ndctl/lib/libndctl.c   | 54 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/libndctl.h       |  2 ++
 ndctl/ndctl.c          |  1 +
 ndctl/Makefile.am      |  5 ++--
 ndctl/lib/Makefile.am  |  4 ++++
 ndctl/lib/libndctl.sym |  2 ++
 8 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index dc39dbe..42a66e1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -171,9 +171,9 @@ fi
 AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
-ndctl_monitorconfdir=${sysconfdir}/ndctl
+ndctl_confdir=${sysconfdir}/ndctl
 ndctl_monitorconf=monitor.conf
-AC_SUBST([ndctl_monitorconfdir])
+AC_SUBST([ndctl_confdir])
 AC_SUBST([ndctl_monitorconf])
 
 daxctl_modprobe_datadir=${datadir}/daxctl
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 8f4510e..f4ca71f 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -129,6 +129,7 @@ struct ndctl_ctx {
 	int regions_init;
 	void *userdata;
 	struct list_head busses;
+	const char *configs;
 	int busses_init;
 	struct udev *udev;
 	struct udev_queue *udev_queue;
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 536e142..6b68e3a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -24,6 +24,7 @@
 #include <util/util.h>
 #include <util/size.h>
 #include <util/sysfs.h>
+#include <util/strbuf.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
 #include <daxctl/libdaxctl.h>
@@ -265,6 +266,58 @@ NDCTL_EXPORT void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata)
 	ctx->userdata = userdata;
 }
 
+static int filter_conf(const struct dirent *dir)
+{
+	if (!dir)
+		return 0;
+
+	if (dir->d_type == DT_REG) {
+		const char *ext = strrchr(dir->d_name, '.');
+		if ((!ext) || (ext == dir->d_name))
+			return 0;
+		if (strcmp(ext, ".conf") == 0)
+			return 1;
+	}
+
+	return 0;
+}
+
+NDCTL_EXPORT void ndctl_set_configs_dir(struct ndctl_ctx **ctx, char *conf_dir)
+{
+	struct dirent **namelist;
+	struct strbuf value = STRBUF_INIT;
+	int rc;
+
+	if ((!ctx) || (!conf_dir))
+		return;
+
+	rc = scandir(conf_dir, &namelist, filter_conf, alphasort);
+	if (rc == -1) {
+		if (errno != ENOENT)
+			err(*ctx, "scandir for configs failed: %s\n",
+				strerror(errno));
+		return;
+	}
+
+	while (rc--) {
+		if (value.len)
+			strbuf_addstr(&value, " ");
+		strbuf_addstr(&value, conf_dir);
+		strbuf_addstr(&value, "/");
+		strbuf_addstr(&value, namelist[rc]->d_name);
+		free(namelist[rc]);
+	}
+	(*ctx)->configs = strbuf_detach(&value, NULL);
+	free(namelist);
+}
+
+NDCTL_EXPORT const char *ndctl_get_configs_dir(struct ndctl_ctx *ctx)
+{
+	if (ctx == NULL)
+		return NULL;
+	return ctx->configs;
+}
+
 /**
  * ndctl_new - instantiate a new library context
  * @ctx: context to establish
@@ -331,6 +384,7 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 	c->daxctl_ctx = daxctl_ctx;
 
 	return 0;
+
  err_ctx:
 	daxctl_unref(daxctl_ctx);
  err_daxctl:
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 87d07b7..883a56f 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -92,6 +92,8 @@ int ndctl_get_log_priority(struct ndctl_ctx *ctx);
 void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority);
 void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata);
 void *ndctl_get_userdata(struct ndctl_ctx *ctx);
+void ndctl_set_configs_dir(struct ndctl_ctx **ctx, char *conf_dir);
+const char *ndctl_get_configs_dir(struct ndctl_ctx *ctx);
 
 enum ndctl_persistence_domain {
 	PERSISTENCE_NONE = 0,
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 31d2c5e..0f908db 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -125,6 +125,7 @@ int main(int argc, const char **argv)
 	rc = ndctl_new(&ctx);
 	if (rc)
 		goto out;
+	ndctl_set_configs_dir(&ctx, NDCTL_CONF_DIR);
 	main_handle_internal_command(argc, argv, ctx, commands,
 			ARRAY_SIZE(commands), PROG_NDCTL);
 	ndctl_unref(ctx);
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index a63b1e0..1caa031 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -7,8 +7,9 @@ BUILT_SOURCES = config.h
 config.h: $(srcdir)/Makefile.am
 	$(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@ && \
 	echo '#define NDCTL_CONF_FILE \
-		"$(ndctl_monitorconfdir)/$(ndctl_monitorconf)"' >>$@
+		"$(ndctl_confdir)/$(ndctl_monitorconf)"' >>$@
 	$(AM_V_GEN) echo '#define NDCTL_KEYS_DIR  "$(ndctl_keysdir)"' >>$@
+	$(AM_V_GEN) echo '#define NDCTL_CONF_DIR  "$(ndctl_confdir)"' >>$@
 
 ndctl_SOURCES = ndctl.c \
 		builtin.h \
@@ -73,7 +74,7 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 test.c
 endif
 
-monitor_configdir = $(ndctl_monitorconfdir)
+monitor_configdir = $(ndctl_confdir)
 monitor_config_DATA = $(ndctl_monitorconf)
 
 if ENABLE_SYSTEMD_UNITS
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index e15bb22..f741c44 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -14,6 +14,10 @@ libndctl_la_SOURCES =\
 	../../util/log.h \
 	../../util/sysfs.c \
 	../../util/sysfs.h \
+	../../util/strbuf.h \
+	../../util/strbuf.c \
+	../../util/wrapper.c \
+	../../util/usage.c \
 	../../util/fletcher.h \
 	dimm.c \
 	inject.c \
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 58afb74..6e1b510 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -454,4 +454,6 @@ LIBNDCTL_25 {
 
 LIBNDCTL_26 {
 	ndctl_bus_nfit_translate_spa;
+	ndctl_set_configs_dir;
+	ndctl_get_configs_dir;
 } LIBNDCTL_25;
-- 
2.33.1

