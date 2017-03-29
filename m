Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D7822050AAEC
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 10:37:43 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] completion: updates for file name completion
Date: Wed, 29 Mar 2017 11:36:16 -0600
Message-Id: <20170329173616.7571-1-vishal.l.verma@intel.com>
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

Add file name completion for the --input and --output arguments of
read-labels and the new write-labels commands.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index c97adcc..076423f 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -91,7 +91,7 @@ __ndctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace) ]]; then
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output) ]]; then
 			COMPREPLY[$i]="${cword}="
 		else
 			COMPREPLY[$i]="${cword} "
@@ -132,6 +132,11 @@ __ndctl_get_dimms()
 	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
 }
 
+__ndctl_file_comp()
+{
+	local cur="$1"
+	_filedir
+}
 __ndctl_comp_options()
 {
 	local cur=$1
@@ -171,6 +176,12 @@ __ndctl_comp_options()
 		--map)
 			opts="mem dev"
 			;;
+		--output)
+			;&
+		--input)
+			__ndctl_file_comp "${cur##*=}"
+			return
+			;;
 		*)
 			return
 			;;
@@ -215,6 +226,8 @@ __ndctl_comp_non_option_args()
 		;&
 	read-labels)
 		;&
+	write-labels)
+		;&
 	zero-labels)
 		opts="$(__ndctl_get_dimms -i) all"
 		;;
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
