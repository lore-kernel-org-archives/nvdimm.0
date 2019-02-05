Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com
 [IPv6:2607:f8b0:4864:20::42b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DEEA92194D387
 for <linux-nvdimm@lists.01.org>; Tue,  5 Feb 2019 00:17:03 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g62so1145055pfd.12
 for <linux-nvdimm@lists.01.org>; Tue, 05 Feb 2019 00:17:03 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] ndctl: Fixes for building without keyutils
Date: Tue,  5 Feb 2019 19:16:52 +1100
Message-Id: <20190205081652.29600-1-oohall@gmail.com>
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

Fixes for some build errors when ndctl is configured without
keyutils support.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
Ran into this when making a test buildroot image. This is
probably not going to be an issue if you're compiling on
a real OS.
---
 ndctl/ndctl.c     | 2 ++
 ndctl/util/keys.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index b5c3bf884d65..bd333b292743 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -93,7 +93,9 @@ static struct cmd_struct commands[] = {
 	{ "remove-passphrase", { cmd_remove_passphrase } },
 	{ "freeze-security", { cmd_freeze_security } },
 	{ "sanitize-dimm", { cmd_sanitize_dimm } },
+#ifdef ENABLE_KEYUTILS
 	{ "load-keys", { cmd_load_keys } },
+#endif
 	{ "wait-overwrite", { cmd_wait_overwrite } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
diff --git a/ndctl/util/keys.h b/ndctl/util/keys.h
index c4d57eae1afc..30687a136512 100644
--- a/ndctl/util/keys.h
+++ b/ndctl/util/keys.h
@@ -46,7 +46,7 @@ static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 }
 
 static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
-		enum ndctl_key_type key_type);
+		enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
