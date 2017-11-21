Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 992AE21B00DC1
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 15:36:40 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, bash-completion: updates for --mode options
Date: Tue, 21 Nov 2017 16:40:53 -0700
Message-Id: <20171121234053.32570-1-vishal.l.verma@intel.com>
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

With the updates to --mode for create-namespace, deprecate the old names
from bash completion. The man page removes mention of the old names, so
remove them from the completion output as well to avoid confusion.

Add the new names into the mode filtering scheme alongside the old names
so that the same filtering behaviour is seen regardless of whether a
user supplies old or new names.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index d983868..fb0d421 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -143,9 +143,9 @@ __ndctl_get_dimms()
 
 __ndctl_get_sector_sizes()
 {
-	if [[ "$mode_filter" == @(raw|memory) ]]; then
+	if [[ "$mode_filter" == @(raw|memory|fsdax) ]]; then
 		echo "512 4096"
-	elif [[ "$mode_filter" == @(dax) ]]; then
+	elif [[ "$mode_filter" == @(dax|devdax) ]]; then
 		return
 	else
 		echo "512 520 528 4096 4104 4160 4224"
@@ -183,12 +183,12 @@ __ndctl_comp_options()
 			;;
 		--type)
 			opts="pmem blk"
-			if [[ "$mode_filter" == @(dax|memory) ]]; then
+			if [[ "$mode_filter" == @(dax|memory|fsdax|devdax) ]]; then
 				opts="pmem"
 			fi
 			;;
 		--mode)
-			opts="raw sector fsdax devdax memory dax"
+			opts="raw sector fsdax devdax"
 			if [[ "$type_filter" == "blk" ]]; then
 				opts="raw sector"
 			fi
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
