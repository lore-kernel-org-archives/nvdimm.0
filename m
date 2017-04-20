Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD4532193DFA5
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 14:05:30 -0700 (PDT)
Subject: [ndctl PATCH 5/5] test, create.sh: gate test on v4.5+
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Apr 2017 13:59:25 -0700
Message-ID: <149272196500.23427.16512180505514852858.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The "create.sh" test depends on commit commit 0731de0dd95b "libnvdimm,
pfn: move 'memory mode' indication to sysfs".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/create.sh |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/test/create.sh b/test/create.sh
index 1a5d7d77bf25..992f2ff48ad0 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -13,6 +13,17 @@ err() {
 	exit $rc
 }
 
+check_min_kver()
+{
+	local ver="$1"
+	: "${KVER:=$(uname -r)}"
+
+	[ -n "$ver" ] || return 1
+	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
+}
+
+check_min_kver "4.5" || { echo "kernel $KVER may lack namespace mode attribute"; exit $rc; }
+
 set -e
 trap 'err $LINENO' ERR
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
