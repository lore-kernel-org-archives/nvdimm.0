Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 996BD21A18AAA
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 13:59:48 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] daxctl: add bash completion
Date: Wed, 14 Jun 2017 14:59:09 -0600
Message-Id: <20170614205909.26619-1-vishal.l.verma@intel.com>
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

Add bash completion for the daxctl utility.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Makefile.am    |   2 +-
 contrib/daxctl | 233 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl.spec.in  |   1 +
 3 files changed, 235 insertions(+), 1 deletion(-)
 create mode 100644 contrib/daxctl

diff --git a/Makefile.am b/Makefile.am
index 2b46736..1ae5a7a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -39,7 +39,7 @@ sles/ndctl.spec: ndctl.spec.in Makefile.am version.m4
 
 if ENABLE_BASH_COMPLETION
 bashcompletiondir = $(BASH_COMPLETION_DIR)
-dist_bashcompletion_DATA = contrib/ndctl
+dist_bashcompletion_DATA = contrib/ndctl contrib/daxctl
 endif
 
 noinst_LIBRARIES = libccan.a
diff --git a/contrib/daxctl b/contrib/daxctl
new file mode 100644
index 0000000..3d1f203
--- /dev/null
+++ b/contrib/daxctl
@@ -0,0 +1,233 @@
+# daxctl bash and zsh completion
+
+# Taken from perf's completion script.
+
+__my_reassemble_comp_words_by_ref()
+{
+	local exclude i j first
+	# Which word separators to exclude?
+	exclude="${1//[^$COMP_WORDBREAKS]}"
+	cword_=$COMP_CWORD
+	if [ -z "$exclude" ]; then
+		words_=("${COMP_WORDS[@]}")
+		return
+	fi
+	# List of word completion separators has shrunk;
+	# re-assemble words to complete.
+	for ((i=0, j=0; i < ${#COMP_WORDS[@]}; i++, j++)); do
+		# Append each nonempty word consisting of just
+		# word separator characters to the current word.
+		first=t
+		while
+			[ $i -gt 0 ] &&
+			[ -n "${COMP_WORDS[$i]}" ] &&
+			# word consists of excluded word separators
+			[ "${COMP_WORDS[$i]//[^$exclude]}" = "${COMP_WORDS[$i]}" ]
+		do
+			# Attach to the previous token,
+			# unless the previous token is the command name.
+			if [ $j -ge 2 ] && [ -n "$first" ]; then
+				((j--))
+			fi
+			first=
+			words_[$j]=${words_[j]}${COMP_WORDS[i]}
+			if [ $i = $COMP_CWORD ]; then
+				cword_=$j
+			fi
+			if (($i < ${#COMP_WORDS[@]} - 1)); then
+				((i++))
+			else
+				# Done.
+				return
+			fi
+		done
+		words_[$j]=${words_[j]}${COMP_WORDS[i]}
+		if [ $i = $COMP_CWORD ]; then
+			cword_=$j
+		fi
+	done
+}
+
+# Define preload_get_comp_words_by_ref="false", if the function
+# __daxctl_get_comp_words_by_ref() is required instead.
+preload_get_comp_words_by_ref="true"
+
+if [ $preload_get_comp_words_by_ref = "true" ]; then
+	type _get_comp_words_by_ref &>/dev/null ||
+	preload_get_comp_words_by_ref="false"
+fi
+[ $preload_get_comp_words_by_ref = "true" ] ||
+__daxctl_get_comp_words_by_ref()
+{
+	local exclude cur_ words_ cword_
+	if [ "$1" = "-n" ]; then
+		exclude=$2
+		shift 2
+	fi
+	__my_reassemble_comp_words_by_ref "$exclude"
+	cur_=${words_[cword_]}
+	while [ $# -gt 0 ]; do
+		case "$1" in
+		cur)
+			cur=$cur_
+			;;
+		prev)
+			prev=${words_[$cword_-1]}
+			;;
+		words)
+			words=("${words_[@]}")
+			;;
+		cword)
+			cword=$cword_
+			;;
+		esac
+		shift
+	done
+}
+
+__daxctlcomp()
+{
+	local i=0
+
+	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
+	for cword in "${COMPREPLY[@]}"; do
+		if [[ "$cword" == @(--dev|--region) ]]; then
+			COMPREPLY[$i]="${cword}="
+		else
+			COMPREPLY[$i]="${cword} "
+		fi
+		((i++))
+	done
+}
+
+__daxctl_get_devs()
+{
+	ls /sys/bus/nd/devices/ | grep dax | grep -oE "[0-9]+.*"
+}
+
+__daxctl_get_regions()
+{
+	ls /sys/bus/nd/devices/ | grep region | grep -oE "[0-9]+.*"
+}
+
+__daxctl_comp_options()
+{
+	local cur=$1
+	local opts
+
+	if [[ "$cur" == *=* ]]; then
+		local cur_subopt=${cur%%=*}
+		case $cur_subopt in
+		--dev)
+			opts=$(__daxctl_get_devs)
+			;;
+		--region)
+			opts=$(__daxctl_get_regions)
+			;;
+		*)
+			return
+			;;
+		esac
+		__daxctlcomp "$opts" "${cur##*=}"
+	fi
+}
+
+__daxctl_prev_skip_opts ()
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
+__daxctl_main()
+{
+	local cmd subcmd
+
+	cmd=${words[0]}
+	COMPREPLY=()
+
+	# Skip options backward and find the last daxctl command
+	__daxctl_prev_skip_opts
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
+		fi
+	fi
+}
+
+if [[ -n ${ZSH_VERSION-} ]]; then
+	autoload -U +X compinit && compinit
+
+	__daxctlcomp()
+	{
+		emulate -L zsh
+
+		local c IFS=$' \t\n'
+		local -a array
+
+		for c in ${=1}; do
+			case $c in
+			--*=*|*.) ;;
+			*) c="$c " ;;
+			esac
+			array[${#array[@]}+1]="$c"
+		done
+
+		compset -P '*[=:]'
+		compadd -Q -S '' -a -- array && _ret=0
+	}
+
+	_daxctl()
+	{
+		local _ret=1 cur cword prev
+		cur=${words[CURRENT]}
+		prev=${words[CURRENT-1]}
+		let cword=CURRENT-1
+		emulate ksh -c __daxctl_main
+		let _ret && _default && _ret=0
+		return _ret
+	}
+
+	compdef _daxctl daxctl
+	return
+fi
+
+type daxctl &>/dev/null &&
+_daxctl()
+{
+	local cur words cword prev
+	if [ $preload_get_comp_words_by_ref = "true" ]; then
+		_get_comp_words_by_ref -n =: cur words cword prev
+	else
+		__daxctl_get_comp_words_by_ref -n =: cur words cword prev
+	fi
+	__daxctl_main
+} &&
+
+complete -o nospace -F _daxctl daxctl 2>/dev/null
diff --git a/ndctl.spec.in b/ndctl.spec.in
index b481762..af106d9 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -122,6 +122,7 @@ make check
 %license util/COPYING licenses/BSD-MIT licenses/CC0
 %{_bindir}/daxctl
 %{_mandir}/man1/daxctl*
+%{bashcompdir}/
 
 %files -n LNAME
 %defattr(-,root,root)
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
