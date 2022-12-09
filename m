Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043CD63C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670606643; x=1702142643;
  h=subject:from:to:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xbAgHEpWGCiWh0Yi25u09xEAQq125oz5C3++uBkXuU0=;
  b=Op2pc5zklRqFTYgkkaXHxrQONclx2/HXxgMg5bzEQs3/d+mNMDQq0p6n
   FJiXzBBpdDUDI3MaaEVswEJP/wCMexF0hlo3KZh1msU4CeaA6aLbmpZeR
   gxXYnQ/ERac+GvfMQgwMve2zezhDZBoq0fGSrC95/x1p2FZqJMFEa4cUU
   EeEUqJkdm28cC3v4yEKRNYpVSzvky7Hor1n8ACqECHOaLkREAhbP+VtDw
   mlzh7H9VweQDXwT/Cvs8UcX3pKRGULVtgndXE8kBuMGcRPczZFxuBQY2T
   DmjS96TaMLQhGKyHbNe3HgmTKkMAwJkScVJLHGAtXby0Ygl00PWdEpmy+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="315144711"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="315144711"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:24:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="771921462"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="771921462"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:24:01 -0800
Subject: [ndctl PATCH v3] ndctl: Add remove master passphrase support for
 remove-passphrase
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 vishal.l.verma@intel.com
Date: Fri, 09 Dec 2022 10:24:01 -0700
Message-ID: 
 <167060655005.1391881.16958930067463644480.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The CXL spec supports disabling of master passphrase. This is a new command
that previously was not supported through nvdimm. Add the -m option to the
existing remove-passphrase to indicate that the passphrase is a master
passphrase.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v3:
- Use -m option just like update-passphrase instead of a new command (Vishal)

v2:
- Add man page (Vishal)

 Documentation/ndctl/ndctl-remove-passphrase.txt |    5 +++++
 ndctl/dimm.c                                    |   15 +++++++++++----
 ndctl/keys.c                                    |   20 ++++++++++++--------
 ndctl/keys.h                                    |    3 ++-
 ndctl/lib/dimm.c                                |    9 +++++++++
 ndctl/lib/libndctl.sym                          |    3 +++
 ndctl/libndctl.h                                |    1 +
 7 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/Documentation/ndctl/ndctl-remove-passphrase.txt b/Documentation/ndctl/ndctl-remove-passphrase.txt
index f14e64946660..d9885a574535 100644
--- a/Documentation/ndctl/ndctl-remove-passphrase.txt
+++ b/Documentation/ndctl/ndctl-remove-passphrase.txt
@@ -33,6 +33,11 @@ include::xable-bus-options.txt[]
 --verbose::
         Emit debug messages.
 
+-m::
+--master-passphrase::
+	Indicates that we are managing the master passphrase instead of the
+	user passphrase.
+
 include::intel-nvdimm-security.txt[]
 
 include::../copyright.txt[]
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index ac7c5270e971..889b620355fc 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1028,7 +1028,8 @@ static int action_remove_passphrase(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_remove_key(dimm);
+	return ndctl_dimm_remove_key(dimm, param.master_pass ? ND_MASTER_KEY :
+							       ND_USER_KEY);
 }
 
 static int action_security_freeze(struct ndctl_dimm *dimm,
@@ -1285,6 +1286,12 @@ static const struct option sanitize_options[] = {
 	OPT_END(),
 };
 
+static const struct option remove_options[] = {
+	BASE_OPTIONS(),
+	MASTER_OPTIONS(),
+	OPT_END(),
+};
+
 static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
@@ -1586,9 +1593,9 @@ int cmd_setup_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx)
 
 int cmd_remove_passphrase(int argc, const char **argv, void *ctx)
 {
-	int count = dimm_action(argc, argv, ctx, action_remove_passphrase,
-			base_options,
-			"ndctl remove-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
+	int count = dimm_action(
+		argc, argv, ctx, action_remove_passphrase, remove_options,
+		"ndctl remove-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
 	fprintf(stderr, "passphrase removed for %d nmem%s.\n", count >= 0 ? count : 0,
 			count > 1 ? "s" : "");
diff --git a/ndctl/keys.c b/ndctl/keys.c
index 2f33b8fb488c..2c1f474896c6 100644
--- a/ndctl/keys.c
+++ b/ndctl/keys.c
@@ -589,11 +589,11 @@ static int run_key_op(struct ndctl_dimm *dimm,
 	return 0;
 }
 
-static int discard_key(struct ndctl_dimm *dimm)
+static int discard_key(struct ndctl_dimm *dimm, enum ndctl_key_type key_type)
 {
 	int rc;
 
-	rc = dimm_remove_key(dimm, ND_USER_KEY);
+	rc = dimm_remove_key(dimm, key_type);
 	if (rc < 0) {
 		fprintf(stderr, "Unable to cleanup key.\n");
 		return rc;
@@ -602,21 +602,25 @@ static int discard_key(struct ndctl_dimm *dimm)
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
+	if (key_type == ND_MASTER_KEY)
+		rc = run_key_op(dimm, key, ndctl_dimm_disable_master_passphrase,
+				"remove master passphrase");
+	else
+		rc = run_key_op(dimm, key, ndctl_dimm_disable_passphrase,
+				"remove passphrase");
 	if (rc < 0)
 		return rc;
 
-	return discard_key(dimm);
+	return discard_key(dimm, key_type);
 }
 
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
@@ -643,7 +647,7 @@ int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 		return rc;
 
 	if (key_type == ND_USER_KEY)
-		return discard_key(dimm);
+		return discard_key(dimm, key_type);
 
 	return 0;
 }
diff --git a/ndctl/keys.h b/ndctl/keys.h
index 03cb509e6404..ce71ff282442 100644
--- a/ndctl/keys.h
+++ b/ndctl/keys.h
@@ -25,7 +25,8 @@ int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek,
 				enum ndctl_key_type key_type);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek,
 				enum ndctl_key_type key_type);
-int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_remove_key(struct ndctl_dimm *dimm,
+			  enum ndctl_key_type key_type);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 		enum ndctl_key_type key_type);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 9e36e289dcc2..2b6e8a59b41d 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -757,6 +757,15 @@ NDCTL_EXPORT int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm,
 	return write_security(dimm, buf);
 }
 
+NDCTL_EXPORT int ndctl_dimm_disable_master_passphrase(struct ndctl_dimm *dimm,
+						      long key)
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
index f1f9edd4b6ff..75c32b9d4967 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -462,3 +462,6 @@ LIBNDCTL_26 {
 LIBNDCTL_27 {
 	ndctl_dimm_refresh_flags;
 } LIBNDCTL_26;
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


