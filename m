Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB14F33CA
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670518701; x=1702054701;
  h=subject:from:to:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kae5VifZrT9gzyfsGgTvij8HwuuZp8cFzVDOFu7TL0k=;
  b=AW1t/Nwnb91RVY/lZRccjTaXu9QXvE6p79IDXvPb+EDMMxcl+BQKi0AZ
   P4zk7gLWSo4WiaOBQqPZxt7eo1SCMSpH4XRedl/G1am1xA4paoOxt2m5e
   eAyCaOxfVMIIUJy1C3FxKzOxzL0qqNwQzehWskvFCClEcXjGf8kbZDnYd
   wqgDOEx81puETcFCobFeBEs8SU+mSXZoz/ZkFZvjLrydYWP0tFtOcVYPm
   F1IVfUMppEle9HNBGOLIQ5F5TJ9vBeYOHFa3XN+Rm7bNyS3Y7Eo6fJufL
   fn1O8KouUdOwzd/+c4LxSllWXMBh+g6Y1Z/f3gtfoM4IoYDpZTDW32fhy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="315942711"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="315942711"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 08:58:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="715679309"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="715679309"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 08:58:21 -0800
Subject: [ndctl PATCH v2] ndctl: create disable master passphrase support
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 09:58:20 -0700
Message-ID: 
 <167051867684.1382144.2464381152738802540.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The cxl spec supports disabling of master passphrase. This is a new command
that previously was not supported through nvdimm. Add support command to
support "master passhprase disable".

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2:
- Add man page (Vishal)

 Documentation/ndctl/meson.build |    1 +
 ndctl/builtin.h                 |    1 +
 ndctl/dimm.c                    |   25 ++++++++++++++++++++++++-
 ndctl/keys.c                    |   15 +++++++++++----
 ndctl/keys.h                    |    5 +++--
 ndctl/lib/dimm.c                |    9 +++++++++
 ndctl/lib/libndctl.sym          |    4 ++++
 ndctl/libndctl.h                |    1 +
 ndctl/ndctl.c                   |    1 +
 9 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/Documentation/ndctl/meson.build b/Documentation/ndctl/meson.build
index b82635a4cc4b..a22060538632 100644
--- a/Documentation/ndctl/meson.build
+++ b/Documentation/ndctl/meson.build
@@ -57,6 +57,7 @@ ndctl_manpages = [
   'ndctl-setup-passphrase.txt',
   'ndctl-update-passphrase.txt',
   'ndctl-remove-passphrase.txt',
+  'ndctl-remove-master-passphrase.txt',
   'ndctl-freeze-security.txt',
   'ndctl-sanitize-dimm.txt',
   'ndctl-load-keys.txt',
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index d3dbbb1afbdd..af759ef0cbfa 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -39,6 +39,7 @@ int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_setup_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_update_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_remove_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_remove_master_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_sanitize_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_load_keys(int argc, const char **argv, struct ndctl_ctx *ctx);
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index ac7c5270e971..df95ac895458 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1028,7 +1028,19 @@ static int action_remove_passphrase(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_remove_key(dimm);
+	return ndctl_dimm_remove_key(dimm, ND_USER_KEY);
+}
+
+static int action_remove_master_passphrase(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	if (ndctl_dimm_get_security(dimm) < 0) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	return ndctl_dimm_remove_key(dimm, ND_MASTER_KEY);
 }
 
 static int action_security_freeze(struct ndctl_dimm *dimm,
@@ -1595,6 +1607,17 @@ int cmd_remove_passphrase(int argc, const char **argv, void *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
+int cmd_remove_master_passphrase(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_remove_master_passphrase,
+			base_options,
+			"ndctl remove-master-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "master passphrase removed for %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
 int cmd_freeze_security(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_security_freeze, base_options,
diff --git a/ndctl/keys.c b/ndctl/keys.c
index 2f33b8fb488c..9bc558802bc4 100644
--- a/ndctl/keys.c
+++ b/ndctl/keys.c
@@ -602,17 +602,24 @@ static int discard_key(struct ndctl_dimm *dimm)
 	return 0;
 }
 
-int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
+int ndctl_dimm_remove_key(struct ndctl_dimm *dimm, enum ndctl_key_type key_type)
 {
 	key_serial_t key;
 	int rc;
 
-	key = check_dimm_key(dimm, true, ND_USER_KEY);
+	key = check_dimm_key(dimm, true, key_type);
 	if (key < 0)
 		return key;
 
-	rc = run_key_op(dimm, key, ndctl_dimm_disable_passphrase,
-			"remove passphrase");
+	if (key_type == ND_USER_KEY)
+		rc = run_key_op(dimm, key, ndctl_dimm_disable_passphrase,
+				"remove passphrase");
+	else if (key_type == ND_MASTER_KEY)
+		rc = run_key_op(dimm, key, ndctl_dimm_disable_master_passphrase,
+				"remove master passphrase");
+	else
+		return -EINVAL;
+
 	if (rc < 0)
 		return rc;
 
diff --git a/ndctl/keys.h b/ndctl/keys.h
index 03cb509e6404..9e77319c2ae6 100644
--- a/ndctl/keys.h
+++ b/ndctl/keys.h
@@ -25,7 +25,7 @@ int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek,
 				enum ndctl_key_type key_type);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek,
 				enum ndctl_key_type key_type);
-int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_remove_key(struct ndctl_dimm *dimm, enum ndctl_key_type key_type);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 		enum ndctl_key_type key_type);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
@@ -47,7 +47,8 @@ static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 	return -EOPNOTSUPP;
 }
 
-static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
+static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 9e36e289dcc2..9936183af292 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -757,6 +757,15 @@ NDCTL_EXPORT int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm,
 	return write_security(dimm, buf);
 }
 
+NDCTL_EXPORT int ndctl_dimm_disable_master_passphrase(struct ndctl_dimm *dimm,
+		long key)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "disable_master %ld\n", key);
+	return write_security(dimm, buf);
+}
+
 NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
 {
 	return write_security(dimm, "freeze");
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index f1f9edd4b6ff..c933163c0380 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -462,3 +462,7 @@ LIBNDCTL_26 {
 LIBNDCTL_27 {
 	ndctl_dimm_refresh_flags;
 } LIBNDCTL_26;
+
+LIBNDCTL_28 {
+	ndctl_dimm_disable_master_passphrase;
+} LIBNDCTL_27;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 57cf93d8d151..c52e82a6f826 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -765,6 +765,7 @@ bool ndctl_dimm_security_is_frozen(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_disable_master_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 31d2c5e35939..eebcaf7aa915 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -84,6 +84,7 @@ static struct cmd_struct commands[] = {
 	{ "setup-passphrase", { cmd_setup_passphrase } },
 	{ "update-passphrase", { cmd_update_passphrase } },
 	{ "remove-passphrase", { cmd_remove_passphrase } },
+	{ "remove-master-passphrase", { cmd_remove_master_passphrase } },
 	{ "freeze-security", { cmd_freeze_security } },
 	{ "sanitize-dimm", { cmd_sanitize_dimm } },
 #ifdef ENABLE_KEYUTILS


