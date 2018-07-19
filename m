Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43AAA21BADAB2
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 17:39:14 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, bash-completion: add completion for ndctl-monitor
Date: Wed, 18 Jul 2018 18:38:46 -0600
Message-Id: <20180719003846.12068-1-vishal.l.verma@intel.com>
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

Add bash completions for the 'ndctl monitor' command. This introduces
some new semantics where the completion for --log= can be either a file
path, or one of the canonical options (currently 'standard' or 'syslog'.
We handle this by (ab)using compgen to test whether the entered
string is a substring of one of the canonical strings. If it is, then we
include the array of the canonical strngs as well as regular _filedir
output in our reply. If not, then we rely on _filedir doing its thing.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index 7a99baf..515494d 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -91,7 +91,7 @@ __ndctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count|--firmware|--media-temperature|--ctrl-temperature|--spares|--media-temperature-threshold|--ctrl-temperature-threshold|--spares-threshold|--media-temperature-alarm|--ctrl-temperature-alarm|--spares-alarm|--numa-node) ]]; then
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count|--firmware|--media-temperature|--ctrl-temperature|--spares|--media-temperature-threshold|--ctrl-temperature-threshold|--spares-threshold|--media-temperature-alarm|--ctrl-temperature-alarm|--spares-alarm|--numa-node|--log|--dimm-event|--config-file) ]]; then
 			COMPREPLY[$i]="${cword}="
 		else
 			COMPREPLY[$i]="${cword} "
@@ -167,10 +167,13 @@ __ndctl_get_nodes()
 	echo "$nlist"
 }
 
+saveopts=""
 __ndctl_file_comp()
 {
 	local cur="$1"
+
 	_filedir
+	saveopts="${COMPREPLY[*]}"
 }
 __ndctl_comp_options()
 {
@@ -179,6 +182,7 @@ __ndctl_comp_options()
 
 	if [[ "$cur" == *=* ]]; then
 		local cur_subopt=${cur%%=*}
+		local cur_arg=${cur##*=}
 		case $cur_subopt in
 		--bus)
 			opts=$(__ndctl_get_buses)
@@ -219,7 +223,7 @@ __ndctl_comp_options()
 		--input)
 			;&
 		--firmware)
-			__ndctl_file_comp "${cur##*=}"
+			__ndctl_file_comp "$cur_arg"
 			return
 			;;
 		--label-version)
@@ -235,11 +239,45 @@ __ndctl_comp_options()
 		--numa-node)
 			opts=$(__ndctl_get_nodes)
 			;;
+		--log)
+			local my_args=( "standard" "syslog" )
+
+			__ndctl_file_comp "$cur_arg"
+			if [ -n "$cur_arg" ]; then
+				# if $cur_arg is a substring of $my_args (as
+				# determined by compgen), then we continue to
+				# manually construct opts using $my_args, but
+				# if it is not a substring (compgen returns
+				# empty), then we defer to _ndctl_file_comp
+				# and return immediately. (NOTE: subscripting
+				# of the my_args array here is fragile).
+				# If this pattern repeats, where we need to
+				# complete with filenames and some custom
+				# options, find a better way to generalize this
+				if [ -z "$(compgen -W "${my_args[*]}" -- "$cur_arg")" ]; then
+					return
+				fi
+			fi
+			opts="${my_args[*]} $saveopts"
+			;;
+		--dimm-event)
+			opts="all \
+				dimm-spares-remaining \
+				dimm-media-temperature \
+				dimm-controller-temperature \
+				dimm-health-state \
+				dimm-unclean-shutdown \
+				"
+			;;
+		--config-file)
+			__ndctl_file_comp "$cur_arg"
+			return
+			;;
 		*)
 			return
 			;;
 		esac
-		__ndctlcomp "$opts" "${cur##*=}"
+		__ndctlcomp "$opts" "$cur_arg"
 	fi
 }
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
