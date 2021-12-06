Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E947C2CB2
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:28:46 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300804837"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="300804837"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:45 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310457"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:44 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 09/12] daxctl: add basic config parsing support
Date: Mon,  6 Dec 2021 15:28:27 -0700
Message-Id: <20211206222830.2266018-10-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6418; h=from:subject; bh=TY59o3SbW7My8IE9KZ1oV6icSPungbvlaVrYC3TgWhY=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+no1XoX0WBfPn7Hv8NRD1qGBlzetCY41m6Olnnaw7+nJ N1afOkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjARoTeMDOvOrPk/VeD6unMsy72sTh namOr6rP1qLbDw7bWn05NVTeQZGX43KG5nOHL7E8OxqGl/+AT+cZndE3Dy7tny/RHn4dbo7VwA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add support similar to ndctl and libndctl for parsing config files. This
allows storing a config file path/list in the daxctl_ctx, and adds APIs
for setting and retrieving it.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .../daxctl/daxctl-reconfigure-device.txt      |  8 ++++
 configure.ac                                  |  3 ++
 daxctl/lib/libdaxctl.c                        | 39 +++++++++++++++++++
 daxctl/libdaxctl.h                            |  2 +
 Documentation/daxctl/Makefile.am              | 11 +++++-
 daxctl/Makefile.am                            |  1 +
 daxctl/lib/Makefile.am                        |  4 ++
 daxctl/lib/libdaxctl.sym                      |  2 +
 8 files changed, 69 insertions(+), 1 deletion(-)

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
index 9e1c6db..e779b51 100644
--- a/configure.ac
+++ b/configure.ac
@@ -178,6 +178,9 @@ AC_SUBST([ndctl_confdir])
 AC_SUBST([ndctl_conf])
 AC_SUBST([ndctl_monitorconf])
 
+daxctl_confdir=${sysconfdir}/daxctl
+AC_SUBST([daxctl_confdir])
+
 daxctl_modprobe_datadir=${datadir}/daxctl
 daxctl_modprobe_data=daxctl.conf
 AC_SUBST([daxctl_modprobe_datadir])
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 860bd9c..2de3616 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -17,6 +17,8 @@
 #include <util/log.h>
 #include <util/sysfs.h>
 #include <util/iomem.h>
+#include <util/strbuf.h>
+#include <util/parse-configs.h>
 #include <daxctl/libdaxctl.h>
 #include "libdaxctl-private.h"
 
@@ -37,6 +39,7 @@ struct daxctl_ctx {
 	struct log_ctx ctx;
 	int refcount;
 	void *userdata;
+	const char *configs;
 	int regions_init;
 	struct list_head regions;
 	struct kmod_ctx *kmod_ctx;
@@ -68,6 +71,42 @@ DAXCTL_EXPORT void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata)
 	ctx->userdata = userdata;
 }
 
+DAXCTL_EXPORT void daxctl_set_configs_dir(struct daxctl_ctx **ctx, char *conf_dir)
+{
+	struct dirent **namelist;
+	struct strbuf value = STRBUF_INIT;
+	int rc;
+
+	if ((!ctx) || (!conf_dir))
+		return;
+
+	rc = scandir(conf_dir, &namelist, filter_conf_files, alphasort);
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
+DAXCTL_EXPORT const char *daxctl_get_configs_dir(struct daxctl_ctx *ctx)
+{
+	if (ctx == NULL)
+		return NULL;
+	return ctx->configs;
+}
+
 /**
  * daxctl_new - instantiate a new library context
  * @ctx: context to establish
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 683ae9c..6be09d9 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -28,6 +28,8 @@ int daxctl_get_log_priority(struct daxctl_ctx *ctx);
 void daxctl_set_log_priority(struct daxctl_ctx *ctx, int priority);
 void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata);
 void *daxctl_get_userdata(struct daxctl_ctx *ctx);
+void daxctl_set_configs_dir(struct daxctl_ctx **ctx, char *conf_dir);
+const char *daxctl_get_configs_dir(struct daxctl_ctx *ctx);
 
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
index 9b1313a..a5c6de1 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -10,6 +10,7 @@ config.h: $(srcdir)/Makefile.am
 		"$(daxctl_modprobe_datadir)/$(daxctl_modprobe_data)"' >>$@ && \
 	echo '#define DAXCTL_MODPROBE_INSTALL \
 		"$(sysconfdir)/modprobe.d/$(daxctl_modprobe_data)"' >>$@
+	$(AM_V_GEN) echo '#define DAXCTL_CONF_DIR  "$(daxctl_confdir)"' >>$@
 
 daxctl_SOURCES =\
 		daxctl.c \
diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am
index db2351e..7a53598 100644
--- a/daxctl/lib/Makefile.am
+++ b/daxctl/lib/Makefile.am
@@ -13,6 +13,10 @@ libdaxctl_la_SOURCES =\
 	../../util/iomem.h \
 	../../util/sysfs.c \
 	../../util/sysfs.h \
+	../../util/strbuf.h \
+	../../util/strbuf.c \
+	../../util/wrapper.c \
+	../../util/usage.c \
 	../../util/log.c \
 	../../util/log.h \
 	../../util/parse-configs.h \
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index a13e93d..7098aba 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -96,4 +96,6 @@ LIBDAXCTL_9 {
 global:
 	daxctl_dev_will_auto_online_memory;
 	daxctl_dev_has_online_memory;
+	daxctl_set_configs_dir;
+	daxctl_get_configs_dir;
 } LIBDAXCTL_8;
-- 
2.33.1

