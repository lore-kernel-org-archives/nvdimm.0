Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 183EC21B00DE6
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:24:26 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v4 3/4] dm-log-writes: allow DAX to be used when
 possible
Date: Fri, 17 Nov 2017 13:28:27 -0700
Message-Id: <20171117202828.25472-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
References: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
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
To: fstests <fstests@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Enhance _require_dm_target so that a user can request a minimum version of a
given dm target.

DAX support was added to v1.1.0 of the dm-log-writes kernel module, so
allow the DAX mount option starting with that version.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
---
 common/dmlogwrites           |  5 +++--
 common/rc                    | 23 +++++++++++++++++++++--
 doc/requirement-checking.txt |  5 +++--
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index 80ed4fc..2cb804c 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -23,8 +23,9 @@ _require_log_writes()
 	[ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
 		_notrun "This test requires a valid \$LOGWRITES_DEV"
 
-	_exclude_scratch_mount_option dax
-	_require_dm_target log-writes
+	local z=0
+	_scratch_has_mount_option dax && z=1
+	_require_dm_target log-writes 1 $z 0
 	_require_test_program "log-writes/replay-log"
 }
 
diff --git a/common/rc b/common/rc
index 701b1ff..c1f24ed 100644
--- a/common/rc
+++ b/common/rc
@@ -1782,6 +1782,18 @@ _require_sane_bdev_flush()
 	fi
 }
 
+_compare_dm_target_versions()
+{
+	for i in $(seq 0 2); do
+		if [[ ${_actual_ver[$i]} > ${_required_ver[$i]} ]]; then
+			return
+		fi
+		if [[ ${_actual_ver[$i]} < ${_required_ver[$i]} ]]; then
+			_notrun "dm $_target version ${_required_ver[@]} required"
+		fi
+	done
+}
+
 # this test requires a specific device mapper target
 _require_dm_target()
 {
@@ -1795,8 +1807,15 @@ _require_dm_target()
 
 	modprobe dm-$_target >/dev/null 2>&1
 
-	$DMSETUP_PROG targets 2>&1 | grep -q ^$_target
-	if [ $? -ne 0 ]; then
+	local _version=$($DMSETUP_PROG targets 2>&1 | grep ^$_target)
+	if [[ $_version =~ .*v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
+		# check for a required minimum version?
+		if [[ $# == 4 ]]; then
+			local _actual_ver=(${BASH_REMATCH[@]:1})
+			local _required_ver=($2 $3 $4)
+			_compare_dm_target_versions
+		fi
+	else
 		_notrun "This test requires dm $_target support"
 	fi
 }
diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
index 4e01b1f..bbfc34f 100644
--- a/doc/requirement-checking.txt
+++ b/doc/requirement-checking.txt
@@ -112,10 +112,11 @@ _require_statx
 DEVICE MAPPER REQUIREMENTS
 ==========================
 
-_require_dm_target <name>
+_require_dm_target <name> [<version 1> <version 2> <version 3>]
 
      The test requires the use of the device mapper target and will be skipped
-     if it isn't available in the kernel.
+     if it isn't available in the kernel.  Optionally specify the minimum
+     three part version number of the dm target that is required.
 
 _require_log_writes
 
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
