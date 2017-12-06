Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EFA4220352AB6
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 16:33:21 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v5 1/2] dm-log-writes: only replay log to marks that
 exist
Date: Tue,  5 Dec 2017 17:37:43 -0700
Message-Id: <20171206003744.28587-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
References: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
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
To: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

The 'replay-log' executable will replay the dm-log-writes log until the
given mark, or until the end of the log if the mark isn't found.

This means that if the mark you're looking for was never inserted in the
log or if you give garbage to _log_writes_replay_log() the entire log will
be replayed.  This can cause unexpected test results.

Fix this by making sure that the mark we're given actually exists in the
log before we allow the replay.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 common/dmlogwrites | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index 247c7442..05829dbc 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -72,6 +72,10 @@ _log_writes_replay_log()
 {
 	_mark=$1
 
+	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --find \
+		--end-mark $_mark >> $seqres.full 2>&1
+	[ $? -ne 0 ] && _fail "mark '$_mark' does not exist"
+
 	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --replay $SCRATCH_DEV \
 		--end-mark $_mark >> $seqres.full 2>&1
 	[ $? -ne 0 ] && _fail "replay failed"
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
