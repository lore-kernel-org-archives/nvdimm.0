Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 161B882096
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:39:06 -0800 (PST)
Subject: [ndctl PATCH 4/6] ndctl: add per-context private data
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:34:57 -0800
Message-ID: <148143809712.11895.1329521496424418324.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Allow an application to attach private data to the context. The initial
motivate is passing the ndctl_test instance into deeper leaf functions
of the unit test.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl-private.h |    1 +
 ndctl/lib/libndctl.c         |   10 ++++++++++
 ndctl/lib/libndctl.sym       |    2 ++
 ndctl/libndctl.h.in          |    2 ++
 4 files changed, 15 insertions(+)

diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 778dbb508ead..3e67db058f04 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -144,6 +144,7 @@ struct ndctl_ctx {
 	struct kmod_ctx *kmod_ctx;
 	struct daxctl_ctx *daxctl_ctx;
 	unsigned long timeout;
+	void *private_data;
 };
 
 /**
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ff74c483076e..ea3111eb6c93 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -434,6 +434,16 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 	return rc;
 }
 
+NDCTL_EXPORT void ndctl_set_private_data(struct ndctl_ctx *ctx, void *data)
+{
+	ctx->private_data = data;
+}
+
+NDCTL_EXPORT void *ndctl_get_private_data(struct ndctl_ctx *ctx)
+{
+	return ctx->private_data;
+}
+
 NDCTL_EXPORT struct daxctl_ctx *ndctl_get_daxctl_ctx(struct ndctl_ctx *ctx)
 {
 	return ctx->daxctl_ctx;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 603c386cc2a1..506bf0d67aab 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -12,6 +12,8 @@ global:
 	ndctl_set_log_priority;
 	ndctl_new;
 	ndctl_get_daxctl_ctx;
+	ndctl_set_private_data;
+	ndctl_get_private_data;
 	ndctl_invalidate;
 local:
         *;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 9d7219894ed7..d45111775525 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -77,6 +77,8 @@ struct ndctl_ctx;
 struct ndctl_ctx *ndctl_ref(struct ndctl_ctx *ctx);
 struct ndctl_ctx *ndctl_unref(struct ndctl_ctx *ctx);
 int ndctl_new(struct ndctl_ctx **ctx);
+void ndctl_set_private_data(struct ndctl_ctx *ctx, void *data);
+void *ndctl_get_private_data(struct ndctl_ctx *ctx);
 struct daxctl_ctx;
 struct daxctl_ctx *ndctl_get_daxctl_ctx(struct ndctl_ctx *ctx);
 void ndctl_invalidate(struct ndctl_ctx *ctx);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
