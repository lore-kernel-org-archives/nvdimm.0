Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0473FD2
	for <nvdimm@lists.linux.dev>; Tue, 31 Aug 2021 09:06:22 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="304009056"
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="304009056"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:08 -0700
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="577063002"
Received: from msgunjal-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.30.4])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:07 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 4/7] daxctl: add basic config parsing support
Date: Tue, 31 Aug 2021 03:04:56 -0600
Message-Id: <20210831090459.2306727-5-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210831090459.2306727-1-vishal.l.verma@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4000; h=from:subject; bh=qq0ng03ad60O2cTuGXQlgZbLvY6AJQkIM8v0Ue0tuxk=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm6H9YH7ud8pWQs28jKUH7aYbGixxTuS9q9MnXCKYc/br2T 8Dm/o5SFQYyDQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABO59YXhf8VdFhNxri0/tH8EXuwOq7 COqdq7LtzoXtA690Cn3z9/2TMybJmYELPPka1NeKJJ8/vva6zinkTfnbyuOuCKYcJ8A+dXTAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add support similar to ndctl and libndctl for parsing config files. This
allows storing a config file path/list in the daxctl_ctx, and adds APIs
for setting and retrieving it.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 daxctl/lib/libdaxctl.c   | 37 +++++++++++++++++++++++++++++++++++++
 daxctl/libdaxctl.h       |  2 ++
 daxctl/Makefile.am       |  1 +
 daxctl/lib/Makefile.am   |  4 ++++
 daxctl/lib/libdaxctl.sym |  2 ++
 5 files changed, 46 insertions(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 860bd9c..659d2fe 100644
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
@@ -68,6 +71,40 @@ DAXCTL_EXPORT void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata)
 	ctx->userdata = userdata;
 }
 
+DAXCTL_EXPORT void daxctl_set_configs(struct daxctl_ctx **ctx, char *conf_dir)
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
+		perror("scandir");
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
+DAXCTL_EXPORT const char *daxctl_get_configs(struct daxctl_ctx *ctx)
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
index 683ae9c..9388f85 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -28,6 +28,8 @@ int daxctl_get_log_priority(struct daxctl_ctx *ctx);
 void daxctl_set_log_priority(struct daxctl_ctx *ctx, int priority);
 void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata);
 void *daxctl_get_userdata(struct daxctl_ctx *ctx);
+void daxctl_set_configs(struct daxctl_ctx **ctx, char *conf_dir);
+const char *daxctl_get_configs(struct daxctl_ctx *ctx);
 
 struct daxctl_region;
 struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx, int id,
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index 9b1313a..a9845a0 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -10,6 +10,7 @@ config.h: $(srcdir)/Makefile.am
 		"$(daxctl_modprobe_datadir)/$(daxctl_modprobe_data)"' >>$@ && \
 	echo '#define DAXCTL_MODPROBE_INSTALL \
 		"$(sysconfdir)/modprobe.d/$(daxctl_modprobe_data)"' >>$@
+	$(AM_V_GEN) echo '#define DAXCTL_CONF_DIR  "$(ndctl_confdir)"' >>$@
 
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
index a13e93d..190b605 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -96,4 +96,6 @@ LIBDAXCTL_9 {
 global:
 	daxctl_dev_will_auto_online_memory;
 	daxctl_dev_has_online_memory;
+	daxctl_set_configs;
+	daxctl_get_configs;
 } LIBDAXCTL_8;
-- 
2.31.1

