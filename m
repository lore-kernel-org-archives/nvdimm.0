Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 874FB1A1E28
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 16:26:02 -0700 (PDT)
Subject: [ndctl PATCH 2/4] test: ensure create.sh always picks a suitable
 BTT-host namespace
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Aug 2016 16:23:16 -0700
Message-ID: <147026659678.11162.9148598870507509552.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The default namespace picked by create-namespace might not be suitable
to host a BTT. Specify this size to guarantee a usable selection.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/create.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/create.sh b/test/create.sh
index b0dcdb7da2bd..e9777f25e31a 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -44,7 +44,7 @@ eval $(echo $json | sed -e "$json2var")
 
 # create blk
 dev="x"
-json=$($NDCTL create-namespace $BUS -t blk -m raw)
+json=$($NDCTL create-namespace $BUS -t blk -m raw -s 17M)
 eval $(echo $json | sed -e "$json2var")
 [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
 [ $mode != "raw" ] && echo "fail: $LINENO" &&  exit 1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
