Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x241.google.com (mail-qk0-x241.google.com
 [IPv6:2607:f8b0:400d:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 999D021314737
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 18:56:42 -0700 (PDT)
Received: by mail-qk0-x241.google.com with SMTP id y4-v6so634684qka.5
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 18:56:42 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH v2 1/2] ndctl, test: add some helper function for test script
Date: Tue, 12 Jun 2018 21:56:15 -0400
Message-Id: <20180613015616.26487-2-msys.mizuma@gmail.com>
In-Reply-To: <20180613015616.26487-1-msys.mizuma@gmail.com>
References: <20180613015616.26487-1-msys.mizuma@gmail.com>
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
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Some test scripts have same function. So, this patch introduces
the functions to 'test/common' new file.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 test/common | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 test/common

diff --git a/test/common b/test/common
new file mode 100644
index 0000000..8fafa91
--- /dev/null
+++ b/test/common
@@ -0,0 +1,60 @@
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
+
+# Global variables
+
+# ndctl
+#
+if [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ]; then
+	export ndctl=../ndctl/ndctl
+elif [ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ]; then
+	export ndctl=./ndctl/ndctl
+else
+	echo "Couldn't find an ndctl binary"
+	exit 1
+fi
+
+# Functions
+
+# err
+# $1: line number which error detected
+# $2: cleanup function (optional)
+#
+err()
+{
+	echo test/$(basename $0): failed at line $1
+	[ -n "$2" ] && "$2"
+	exit $rc
+}
+
+# check_min_kver
+# $1: Supported kernel version. format: X.Y
+#
+check_min_kver()
+{
+	local ver="$1"
+	: "${KVER:=$(uname -r)}"
+
+	[ -n "$ver" ] || return 1
+	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
+}
+
+# do_skip
+# $1: Skip message
+#
+do_skip()
+{
+	echo kernel $(uname -r): $1
+	exit 77
+}
+
+# check_prereq
+# $1: command to check
+#
+check_prereq()
+{
+	if ! command -v "$1" >/dev/null; then
+		do_skip "missing $1, skipping..."
+	fi
+}
-- 
2.18.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
