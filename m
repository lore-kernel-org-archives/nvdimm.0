Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F219203BBB80
 for <linux-nvdimm@lists.01.org>; Fri, 25 Jan 2019 14:26:28 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] daxctl: Add bash-completion
Date: Fri, 25 Jan 2019 15:26:25 -0700
Message-Id: <20190125222625.15164-1-vishal.l.verma@intel.com>
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

Add bash completion helpers to contrib/ndctl to also allow for daxctl
completion. This makes it so we have a single bash-completion script
that is installed, and it provides completions for both ndctl and
daxctl. As a bonus, some of the common functions can also get reused by
both.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 155 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 128 insertions(+), 27 deletions(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index 515494d..629d6a8 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -2,6 +2,8 @@
 
 # Taken from perf's completion script.
 
+### common helpers between ndctl and daxctl
+
 __my_reassemble_comp_words_by_ref()
 {
 	local exclude i j first
@@ -49,7 +51,7 @@ __my_reassemble_comp_words_by_ref()
 }
 
 # Define preload_get_comp_words_by_ref="false", if the function
-# __ndctl_get_comp_words_by_ref() is required instead.
+# __nd_common_get_comp_words_by_ref() is required instead.
 preload_get_comp_words_by_ref="true"
 
 if [ $preload_get_comp_words_by_ref = "true" ]; then
@@ -57,7 +59,7 @@ if [ $preload_get_comp_words_by_ref = "true" ]; then
 	preload_get_comp_words_by_ref="false"
 fi
 [ $preload_get_comp_words_by_ref = "true" ] ||
-__ndctl_get_comp_words_by_ref()
+__nd_common_get_comp_words_by_ref()
 {
 	local exclude cur_ words_ cword_
 	if [ "$1" = "-n" ]; then
@@ -85,6 +87,29 @@ __ndctl_get_comp_words_by_ref()
 	done
 }
 
+__nd_common_prev_skip_opts ()
+{
+	local i cmd_ cmds_
+
+	let i=cword-1
+	cmds_=$($cmd $1 --list-cmds)
+	prev_skip_opts=()
+	while [ $i -ge 0 ]; do
+		if [[ ${words[i]} == $1 ]]; then
+			return
+		fi
+		for cmd_ in $cmds_; do
+			if [[ ${words[i]} == $cmd_ ]]; then
+				prev_skip_opts=${words[i]}
+				return
+			fi
+		done
+		((i--))
+	done
+}
+
+### ndctl
+
 __ndctlcomp()
 {
 	local i=0
@@ -351,27 +376,6 @@ __ndctl_add_special_opts()
 	esac
 }
 
-__ndctl_prev_skip_opts ()
-{
-	local i cmd_ cmds_
-
-	let i=cword-1
-	cmds_=$($cmd $1 --list-cmds)
-	prev_skip_opts=()
-	while [ $i -ge 0 ]; do
-		if [[ ${words[i]} == $1 ]]; then
-			return
-		fi
-		for cmd_ in $cmds_; do
-			if [[ ${words[i]} == $cmd_ ]]; then
-				prev_skip_opts=${words[i]}
-				return
-			fi
-		done
-		((i--))
-	done
-}
-
 __ndctl_init_filters()
 {
 	bus_filter=''
@@ -430,7 +434,7 @@ __ndctl_main()
 	__ndctl_init_filters
 
 	# Skip options backward and find the last ndctl command
-	__ndctl_prev_skip_opts
+	__nd_common_prev_skip_opts
 	subcmd=$prev_skip_opts
 	# List ndctl subcommands or long options
 	if [ -z $subcmd ]; then
@@ -498,9 +502,106 @@ _ndctl()
 	if [ $preload_get_comp_words_by_ref = "true" ]; then
 		_get_comp_words_by_ref -n =: cur words cword prev
 	else
-		__ndctl_get_comp_words_by_ref -n =: cur words cword prev
+		__nd_common_get_comp_words_by_ref -n =: cur words cword prev
 	fi
 	__ndctl_main
-} &&
+}
+
+### daxctl ###
+
+__daxctl_get_devs()
+{
+	local opts="--devices $*"
+	echo "$(daxctl list $opts | grep -E "^\s*\"chardev\":" | cut -d\" -f4)"
+}
+
+__daxctlcomp()
+{
+	local i=0
+
+	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
+	for cword in "${COMPREPLY[@]}"; do
+		if [[ "$cword" == @(--region|--dev) ]]; then
+			COMPREPLY[$i]="${cword}="
+		else
+			COMPREPLY[$i]="${cword} "
+		fi
+		((i++))
+	done
+}
+
+__daxctl_comp_options()
+{
+
+	local cur=$1
+	local opts
+
+	if [[ "$cur" == *=* ]]; then
+		local cur_subopt=${cur%%=*}
+		local cur_arg=${cur##*=}
+		case $cur_subopt in
+		--region)
+			opts=$(__ndctl_get_regions -i)
+			;;
+		--dev)
+			opts=$(__daxctl_get_devs -i)
+			;;
+		*)
+			return
+			;;
+		esac
+		__daxctlcomp "$opts" "$cur_arg"
+	fi
+}
+
+__daxctl_comp_non_option_args()
+{
+	# there aren't any commands that accept non option arguments yet
+	return
+}
+
+__daxctl_main()
+{
+	local cmd subcmd
+
+	cmd=${words[0]}
+	COMPREPLY=()
+
+	# Skip options backward and find the last daxctl command
+	__nd_common_prev_skip_opts
+	subcmd=$prev_skip_opts
+	# List daxctl subcommands or long options
+	if [ -z $subcmd ]; then
+		if [[ $cur == --* ]]; then
+			cmds="--version --help --list-cmds"
+		else
+			cmds=$($cmd --list-cmds)
+		fi
+		__daxctlcomp "$cmds" "$cur"
+	else
+		# List long option names
+		if [[ $cur == --* ]];  then
+			opts=$($cmd $subcmd --list-opts)
+			__daxctlcomp "$opts" "$cur"
+			__daxctl_comp_options "$cur"
+		else
+			[ -z "$subcmd" ] && return
+			__daxctl_comp_non_option_args "$subcmd" "$cur"
+		fi
+	fi
+}
+
+type daxctl &>/dev/null &&
+_daxctl()
+{
+	local cur words cword prev
+	if [ $preload_get_comp_words_by_ref = "true" ]; then
+		_get_comp_words_by_ref -n =: cur words cword prev
+	else
+		__nd_common_get_comp_words_by_ref -n =: cur words cword prev
+	fi
+	__daxctl_main
+}
 
-complete -o nospace -F _ndctl ndctl 2>/dev/null
+complete -o nospace -F _ndctl ndctl
+complete -o nospace -F _daxctl daxctl
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
