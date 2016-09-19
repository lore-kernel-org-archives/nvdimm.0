Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9364F1A1DED
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 15:09:56 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: bash completion for {enable,
 disable}-dimm commands
Date: Mon, 19 Sep 2016 16:09:00 -0600
Message-Id: <1474322940-31495-1-git-send-email-vishal.l.verma@intel.com>
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

Add bash completion for the two new commands. Don't add a "-i" by
default in __ndctl_get_dimms, instead specift "-i" manually where needed
(everywhere except the completion for disable-dimm)

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index 160a9dc..2c04504 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -127,8 +127,7 @@ __ndctl_get_ns()
 
 __ndctl_get_dimms()
 {
-	# when listing dimms, always list idle ones too
-	opts="--dimms -i $*"
+	opts="--dimms $*"
 	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
 	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
 }
@@ -148,7 +147,7 @@ __ndctl_comp_options()
 			opts=$(__ndctl_get_regions)
 			;;
 		--dimm)
-			opts=$(__ndctl_get_dimms)
+			opts=$(__ndctl_get_dimms -i)
 			;;
 		--namespace)
 			opts=$(__ndctl_get_ns)
@@ -201,10 +200,16 @@ __ndctl_comp_non_option_args()
 	disable-region)
 		opts="$(__ndctl_get_regions) all"
 		;;
+	enable-dimm)
+		opts="$(__ndctl_get_dimms -i) all"
+		;;
+	disable-dimm)
+		opts="$(__ndctl_get_dimms) all"
+		;;
 	read-labels)
 		;&
 	zero-labels)
-		opts="$(__ndctl_get_dimms) all"
+		opts="$(__ndctl_get_dimms -i) all"
 		;;
 	*)
 		return
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
