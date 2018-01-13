Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6783C2205B938
 for <linux-nvdimm@lists.01.org>; Fri, 12 Jan 2018 15:58:05 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] ndctl: add an option to check-namespace to rewrite
 the log
Date: Fri, 12 Jan 2018 17:03:15 -0700
Message-Id: <20180113000315.29082-2-vishal.l.verma@intel.com>
In-Reply-To: <20180113000315.29082-1-vishal.l.verma@intel.com>
References: <20180113000315.29082-1-vishal.l.verma@intel.com>
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

Add a --rewrite-log option to ndctl check-namespace which reads the
active log entries, and rewrites them as though initializing a new BTT.
This allows us to convert an old (pre 4.15) format of log/padding layout
to a new one that is compatible with other BTT implementations.

In the btt-pad-compat unit test, add testing for the format conversion
operation.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-check-namespace.txt | 11 +++++
 ndctl/check.c                                 | 70 ++++++++++++++++++++++++++-
 ndctl/namespace.c                             |  6 ++-
 test/btt-pad-compat.sh                        |  9 ++++
 4 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/Documentation/ndctl/ndctl-check-namespace.txt b/Documentation/ndctl/ndctl-check-namespace.txt
index 49353b1..ea4183a 100644
--- a/Documentation/ndctl/ndctl-check-namespace.txt
+++ b/Documentation/ndctl/ndctl-check-namespace.txt
@@ -42,6 +42,17 @@ OPTIONS
 	Perform metadata repairs if possible. Without this option,
 	the raw namespace contents will not be touched.
 
+-L::
+--rewrite-log::
+	Regenerate the BTT log and write it to media. This can be used to
+	convert from the old (pre 4.15) padding format that was incompatible
+	with other BTT implementations to the updated format. This requires
+	the --repair option to be provided.
+
+	WARNING: Do not interrupt this operation as it can potentially cause
+	unrecoverable metadata corruption. It is highly recommended to create
+	a backup of the raw namespace before attempting this.
+
 -f::
 --force::
 	Unless this option is specified, a check-namespace operation
diff --git a/ndctl/check.c b/ndctl/check.c
index d3aa1aa..09dd125 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -46,6 +46,7 @@ struct check_opts {
 	bool verbose;
 	bool force;
 	bool repair;
+	bool logfix;
 };
 
 struct btt_chk {
@@ -246,6 +247,12 @@ static void btt_log_group_read(struct arena_info *a, u32 lane,
 	memcpy(log, &a->map.log[lane], LOG_GRP_SIZE);
 }
 
+static void btt_log_group_write(struct arena_info *a, u32 lane,
+			struct log_group *log)
+{
+	memcpy(&a->map.log[lane], log, LOG_GRP_SIZE);
+}
+
 static u32 log_seq(struct log_group *log, int log_idx)
 {
 	return le32_to_cpu(log->ent[log_idx].seq);
@@ -358,6 +365,7 @@ enum btt_errcodes {
 	BTT_LOG_MAP_ERR,
 	BTT_MAP_OOB,
 	BTT_BITMAP_ERROR,
+	BTT_LOGFIX_ERR,
 };
 
 static void btt_xlat_status(struct arena_info *a, int errcode)
@@ -405,6 +413,11 @@ static void btt_xlat_status(struct arena_info *a, int errcode)
 			"arena %d: bitmap error: internal blocks are incorrectly referenced\n",
 			a->num);
 		break;
+	case BTT_LOGFIX_ERR:
+		err(a->bttc,
+			"arena %d: rewrite-log error: log may be in an unknown/unrecoverable state\n",
+			a->num);
+		break;
 	default:
 		err(a->bttc, "arena %d: unknown error: %d\n",
 			a->num, errcode);
@@ -563,6 +576,44 @@ static int btt_check_bitmap(struct arena_info *a)
 	return rc;
 }
 
+static int btt_rewrite_log(struct arena_info *a)
+{
+	struct log_group log;
+	int rc;
+	u32 i;
+
+	info(a->bttc, "arena %d: rewriting log\n", a->num);
+	/*
+	 * To rewrite the log, we implicitly use the 'new' padding scheme of
+	 * (0, 1) but resetting the log to a completely initial state (i.e.
+	 * slot-0 contains a made-up entry containing the 'free' block from
+	 * the existing current log entry, and a sequence number of '1'. All
+	 * other slots are zeroed.
+	 *
+	 * This way of rewriting the log is the most flexible as it can be
+	 * (ab)used to convert a new padding format back to the old one.
+	 * Since it only recreates slot-0, which is common between both
+	 * existing formats, an older kernel will simply initialize the free
+	 * list using those slot-0 entries, and run with it as though slot-2
+	 * is the other valid slot.
+	 */
+	memset(&log, 0, LOG_GRP_SIZE);
+	for (i = 0; i < a->nfree; i++) {
+		struct log_entry ent;
+
+		rc = btt_log_read(a, i, &ent);
+		if (rc)
+			return BTT_LOGFIX_ERR;
+
+		log.ent[0].lba = ent.lba;
+		log.ent[0].old_map = ent.old_map;
+		log.ent[0].new_map = ent.new_map;
+		log.ent[0].seq = 1;
+		btt_log_group_write(a, i, &log);
+	}
+	return 0;
+}
+
 static int btt_check_arenas(struct btt_chk *bttc)
 {
 	struct arena_info *a = NULL;
@@ -591,6 +642,12 @@ static int btt_check_arenas(struct btt_chk *bttc)
 		rc = btt_check_bitmap(a);
 		if (rc)
 			break;
+
+		if (bttc->opts->logfix) {
+			rc = btt_rewrite_log(a);
+			if (rc)
+				break;
+		}
 	}
 
 	if (a && rc != BTT_OK) {
@@ -1094,13 +1151,14 @@ static int btt_recover_first_sb(struct btt_chk *bttc)
 }
 
 int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
-		bool repair)
+		bool repair, bool logfix)
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
 	struct check_opts __opts = {
 		.verbose = verbose,
 		.force = force,
 		.repair = repair,
+		.logfix = logfix,
 	}, *opts = &__opts;
 	int raw_mode, rc, disabled_flag = 0, open_flags;
 	struct btt_sb *btt_sb;
@@ -1127,6 +1185,16 @@ int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 		goto out_bttc;
 	}
 
+	if (opts->logfix) {
+		if (!opts->repair) {
+			err(bttc, "--rewrite-log also requires --repair\n");
+			rc = -EINVAL;
+			goto out_bttc;
+		}
+		info(bttc,
+			"WARNING: interruption may cause unrecoverable metadata corruption\n");
+	}
+
 	bttc->opts = opts;
 	bttc->sys_page_size = sysconf(_SC_PAGESIZE);
 	bttc->rawsize = ndctl_namespace_get_size(ndns);
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index d31244b..6b19f28 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -39,6 +39,7 @@
 static bool verbose;
 static bool force;
 static bool repair;
+static bool logfix;
 static struct parameters {
 	bool do_scan;
 	bool mode_default;
@@ -121,6 +122,7 @@ OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels
 
 #define CHECK_OPTIONS() \
 OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
+OPT_BOOLEAN('L', "rewrite-log", &logfix, "regenerate the log"), \
 OPT_BOOLEAN('f', "force", &force, "check namespace even if currently active")
 
 static const struct option base_options[] = {
@@ -985,7 +987,7 @@ static int namespace_reconfig(struct ndctl_region *region,
 }
 
 int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
-		bool repair);
+		bool repair, bool logfix);
 
 static int do_xaction_namespace(const char *namespace,
 		enum device_action action, struct ndctl_ctx *ctx)
@@ -1049,7 +1051,7 @@ static int do_xaction_namespace(const char *namespace,
 					break;
 				case ACTION_CHECK:
 					rc = namespace_check(ndns, verbose,
-							force, repair);
+							force, repair, logfix);
 					if (rc < 0)
 						return rc;
 					break;
diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index cbfe990..d10efe3 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -193,6 +193,15 @@ do_tests()
 	cycle_ns "$dev"
 	verify_idx 0 2
 
+	# rewrite log using ndctl, verify conversion to new format
+	ndctl check-namespace --rewrite-log --repair --force --verbose $dev
+	do_random_io "/dev/$blockdev"
+	cycle_ns "$dev"
+	verify_idx 0 1
+
+	# check-namespace again to make sure everything is ok
+	ndctl check-namespace --force --verbose $dev
+
 	# the old format btt metadata was created with a null parent uuid,
 	# making it 'stickier' than a normally created btt. Be sure to clean
 	# it up by wiping the info block
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
