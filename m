Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 968051A1F79
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 15:24:32 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: limit clear poison test to 4.6+ kernels
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Mar 2016 15:23:25 -0700
Message-ID: <20160329222325.31212.8411.stgit@dwillia2-desk3.jf.intel.com>
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

Prior kernels do not export a clear poison facility.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/clear.sh |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/test/clear.sh b/test/clear.sh
index e74522201231..16b0cbf3a71c 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -13,6 +13,15 @@ err() {
 	exit $rc
 }
 
+eval $(uname -r | awk -F. '{print "maj="$1 ";" "min="$2}')
+if [ $maj -lt 4 ]; then
+	echo "kernel $maj.$min lacks clear poison support"
+	exit $rc
+elif [ $maj -eq 4 -a $min -lt 6 ]; then
+	echo "kernel $maj.$min lacks clear poison support"
+	exit $rc
+fi
+
 set -e
 trap 'err $LINENO' ERR
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
