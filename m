Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D3502193930C
 for <linux-nvdimm@lists.01.org>; Sat,  1 Apr 2017 12:33:07 -0700 (PDT)
Subject: [ndctl PATCH] test: fix kernel version detection in dax-errors.sh
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 01 Apr 2017 12:27:57 -0700
Message-ID: <149107487750.16325.8238092319248519520.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Honor the KVER environment variable for overriding kernel version
detection.

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dax-errors.sh |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/test/dax-errors.sh b/test/dax-errors.sh
index a383b14fcd5e..25615df44180 100755
--- a/test/dax-errors.sh
+++ b/test/dax-errors.sh
@@ -23,14 +23,16 @@ err() {
 	exit $rc
 }
 
-eval $(uname -r | awk -F. '{print "maj="$1 ";" "min="$2}')
-if [ $maj -lt 4 ]; then
-	echo "kernel $maj.$min lacks dax error handling"
-	exit $rc
-elif [ $maj -eq 4 -a $min -lt 7 ]; then
-	echo "kernel $maj.$min lacks dax error handling"
-	exit $rc
-fi
+check_min_kver()
+{
+	local ver="$1"
+	: "${KVER:=$(uname -r)}"
+
+	[ -n "$ver" ] || return 1
+	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
+}
+
+check_min_kver "4.7" || { echo "kernel $KVER may lack dax error handling"; exit $rc; }
 
 set -e
 mkdir -p $MNT

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
