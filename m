Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEA0C220D4C03
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:24:24 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v4 1/4] common/rc: add _scratch_has_mount_option()
Date: Fri, 17 Nov 2017 13:28:25 -0700
Message-Id: <20171117202828.25472-2-ross.zwisler@linux.intel.com>
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

Allow tests to inquire about whether a mount option is set, rather than
just disallowing it via _exclude_scratch_mount_option().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/common/rc b/common/rc
index 0cda9da..701b1ff 100644
--- a/common/rc
+++ b/common/rc
@@ -3105,6 +3105,16 @@ _exclude_scratch_mount_option()
 	done
 }
 
+_scratch_has_mount_option()
+{
+	local mnt_opts=$(_normalize_mount_options)
+
+	if echo $mnt_opts | grep -qw "$1"; then
+		return 0
+	fi
+	return 1
+}
+
 _require_atime()
 {
 	_exclude_scratch_mount_option "noatime"
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
