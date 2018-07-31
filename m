Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9132D21CB74A4
 for <linux-nvdimm@lists.01.org>; Tue, 31 Jul 2018 05:18:56 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 89A99AC00F3
 for <linux-nvdimm@lists.01.org>; Tue, 31 Jul 2018 21:18:50 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH] ndctl,
 inject-smart: add an interface to inject ctrl-temperature
Date: Tue, 31 Jul 2018 21:18:42 +0900
Message-Id: <20180731121842.27213-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch is used to add an interface to inject controller temperature.
The ndctl should be supportive of injecting all possible fields.
Although currently controller temperature injection is not supported
by NVDIMMs, this interface can return a failure report to users.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/inject-smart.c   | 1 +
 ndctl/lib/libndctl.sym | 1 +
 ndctl/lib/private.h    | 1 +
 ndctl/lib/smart.c      | 1 +
 ndctl/libndctl.h       | 2 ++
 5 files changed, 6 insertions(+)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index f5a3a6f..56c39ab 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -392,6 +392,7 @@ static int smart_inject(struct ndctl_dimm *dimm)
 	int rc = -EOPNOTSUPP;
 
 	send_inject_val(media_temperature)
+	send_inject_val(ctrl_temperature)
 	send_inject_val(spares)
 	send_inject_bool(fatal)
 	send_inject_bool(unsafe_shutdown)
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 9b36960..fae24f0 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -375,4 +375,5 @@ global:
 	ndctl_dimm_get_flags;
 	ndctl_dimm_get_event_flags;
 	ndctl_dimm_is_flag_supported;
+	ndctl_cmd_smart_inject_ctrl_temperature;
 } LIBNDCTL_16;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index a94f894..5ddc682 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -308,6 +308,7 @@ struct ndctl_dimm_ops {
 	int (*smart_threshold_set_spares)(struct ndctl_cmd *, unsigned int);
 	struct ndctl_cmd *(*new_smart_inject)(struct ndctl_dimm *);
 	int (*smart_inject_media_temperature)(struct ndctl_cmd *, bool, unsigned int);
+	int (*smart_inject_ctrl_temperature)(struct ndctl_cmd *, bool, unsigned int);
 	int (*smart_inject_spares)(struct ndctl_cmd *, bool, unsigned int);
 	int (*smart_inject_fatal)(struct ndctl_cmd *, bool);
 	int (*smart_inject_unsafe_shutdown)(struct ndctl_cmd *, bool);
diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index 7ba46d1..0e180cf 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -146,6 +146,7 @@ NDCTL_EXPORT int ndctl_cmd_##op(struct ndctl_cmd *cmd, bool enable, unsigned int
 }
 
 smart_cmd_inject_val(smart_inject_media_temperature)
+smart_cmd_inject_val(smart_inject_ctrl_temperature)
 smart_cmd_inject_val(smart_inject_spares)
 
 #define smart_cmd_inject(op) \
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 6a6bb0d..e60d80b 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -285,6 +285,8 @@ int ndctl_cmd_smart_threshold_set_spares(struct ndctl_cmd *cmd,
 struct ndctl_cmd *ndctl_dimm_cmd_new_smart_inject(struct ndctl_dimm *dimm);
 int ndctl_cmd_smart_inject_media_temperature(struct ndctl_cmd *cmd, bool enable,
 		unsigned int mtemp);
+int ndctl_cmd_smart_inject_ctrl_temperature(struct ndctl_cmd *cmd, bool enable,
+		unsigned int ctemp);
 int ndctl_cmd_smart_inject_spares(struct ndctl_cmd *cmd, bool enable,
 		unsigned int spares);
 int ndctl_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable);
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
