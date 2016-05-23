Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 4447B1A1DFB
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 14:08:46 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 2/2] ndctl: add bash completion
Date: Mon, 23 May 2016 15:07:56 -0600
Message-Id: <1464037676-5776-3-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1464037676-5776-1-git-send-email-vishal.l.verma@intel.com>
References: <1464037676-5776-1-git-send-email-vishal.l.verma@intel.com>
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

Add bash completion support to ndctl and integrate it with autotools.
The completion is based on perf/git, and the usage experience is very
similar.

We do dynamic generation of options using --list-opts for the different
subcommands. We also attempt to complete long-options that take an
additional parameter (such as --region=region0), and non-option
arguments, such as the namespace for a 'disable-namespace' command.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Makefile.am   |   5 +
 configure.ac  |  17 +++
 contrib/ndctl | 330 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 352 insertions(+)
 create mode 100755 contrib/ndctl

diff --git a/Makefile.am b/Makefile.am
index 656b244..c781e80 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -89,6 +89,11 @@ if ENABLE_SMART
 lib_libndctl_la_SOURCES += lib/libndctl-smart.c
 endif
 
+if ENABLE_BASH_COMPLETION
+bashcompletiondir = $(BASH_COMPLETION_DIR)
+dist_bashcompletion_DATA = contrib/ndctl
+endif
+
 bin_PROGRAMS = ndctl
 
 ndctl_SOURCES = ndctl.c \
diff --git a/configure.ac b/configure.ac
index aefcf09..abd3d8e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -33,6 +33,23 @@ AC_PREFIX_DEFAULT([/usr])
 AC_PROG_SED
 AC_PROG_MKDIR_P
 
+AC_ARG_WITH([bash-completion-dir],
+	AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
+		[Install the bash auto-completion script in this directory. @<:@default=yes@:>@]),
+	[],
+	[with_bash_completion_dir=yes])
+
+if test "x$with_bash_completion_dir" = "xyes"; then
+	PKG_CHECK_MODULES([BASH_COMPLETION], [bash-completion >= 2.0],
+		[BASH_COMPLETION_DIR="`pkg-config --variable=completionsdir bash-completion`"],
+		[BASH_COMPLETION_DIR="$datadir/bash-completion/completions"])
+else
+	BASH_COMPLETION_DIR="$with_bash_completion_dir"
+fi
+
+AC_SUBST([BASH_COMPLETION_DIR])
+AM_CONDITIONAL([ENABLE_BASH_COMPLETION],[test "x$with_bash_completion_dir" != "xno"])
+
 AC_ARG_ENABLE([docs],
         AS_HELP_STRING([--disable-docs],
 	[disable documentation build @<:@default=enabled@:>@]),
diff --git a/contrib/ndctl b/contrib/ndctl
new file mode 100755
index 0000000..5a7455f
--- /dev/null
+++ b/contrib/ndctl
@@ -0,0 +1,330 @@
+# ndctl bash and zsh completion
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
+# __ndctl_get_comp_words_by_ref() is required instead.
+preload_get_comp_words_by_ref="true"
+
+if [ $preload_get_comp_words_by_ref = "true" ]; then
+	type _get_comp_words_by_ref &>/dev/null ||
+	preload_get_comp_words_by_ref="false"
+fi
+[ $preload_get_comp_words_by_ref = "true" ] ||
+__ndctl_get_comp_words_by_ref()
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
+__ndctlcomp()
+{
+	local i=0
+
+	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
+	for cword in "${COMPREPLY[@]}"; do
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map) ]]; then
+			COMPREPLY[$i]="${cword}="
+		else
+			COMPREPLY[$i]="${cword} "
+		fi
+		((i++))
+	done
+}
+
+__ndctl_get_buses()
+{
+	local opts="--buses $*"
+	echo "$(ndctl list $opts | grep -E "^\s*\"provider\":" | cut -d\" -f4)"
+}
+
+__ndctl_get_regions()
+{
+	local opts="--regions $*"
+	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
+	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
+}
+
+__ndctl_get_ns()
+{
+	opts="--namespaces $*"
+	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
+	[ -n "$reg_filter" ] && opts="$opts --bus=$reg_filter"
+	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
+}
+
+__ndctl_get_dimms()
+{
+	# when listing dimms, always list idle ones too
+	opts="--dimms -i $*"
+	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
+	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
+}
+
+__ndctl_comp_options()
+{
+	local cur=$1
+	local opts
+
+	if [[ "$cur" == *=* ]]; then
+		local cur_subopt=${cur%%=*}
+		case $cur_subopt in
+		--bus)
+			opts=$(__ndctl_get_buses)
+			;;
+		--region)
+			opts=$(__ndctl_get_regions)
+			;;
+		--dimm)
+			opts=$(__ndctl_get_dimms)
+			;;
+		--reconfig)
+			# It is ok to reconfig disabled namespaces
+			opts=$(__ndctl_get_ns -i)
+			;;
+		--type)
+			opts="pmem blk"
+			;;
+		--mode)
+			opts="raw sector memory dax"
+			;;
+		--map)
+			opts="mem dev"
+			;;
+		*)
+			return
+			;;
+		esac
+		__ndctlcomp "$opts" "${cur##*=}"
+	fi
+}
+
+__ndctl_comp_non_option_args()
+{
+	local subcmd=$1
+	local cur=$2
+	local opts
+
+	case $subcmd in
+	enable-namespace)
+		opts="$(__ndctl_get_ns -i) all"
+		;;
+	disable-namespace)
+		;&
+	destroy-namespace)
+		opts="$(__ndctl_get_ns) all"
+		;;
+	enable-region)
+		opts="$(__ndctl_get_regions -i) all"
+		;;
+	disable-region)
+		opts="$(__ndctl_get_regions) all"
+		;;
+	read-labels)
+		;&
+	zero-labels)
+		opts="$(__ndctl_get_dimms) all"
+		;;
+	*)
+		return
+		;;
+	esac
+	__ndctlcomp "$opts" "$cur"
+}
+
+__ndctl_prev_skip_opts ()
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
+bus_filter=''
+reg_filter=''
+
+__ndctl_init_filters()
+{
+	bus_filter=''
+	reg_filter=''
+
+	for __word in "${words[@]}"; do
+		if [[ "$__word" =~ --bus=(.*) ]]; then
+			bus_filter="${BASH_REMATCH[1]}"
+			# lets make sure this is in the list of buses
+			local buses=$(__ndctl_get_buses)
+			[[ "$buses" == *"$bus_filter"* ]] || bus_filter=''
+		fi
+		if [[ "$__word" =~ --region=(.*) ]]; then
+			reg_filter="${BASH_REMATCH[1]}"
+			# lets make sure this is in the list of regions
+			local regions=$(__ndctl_get_regions -i)
+			[[ "$regions" == *"$reg_filter"* ]] || reg_filter=''
+		fi
+	done
+}
+
+__ndctl_main()
+{
+	local cmd subcmd
+
+	cmd=${words[0]}
+	COMPREPLY=()
+
+	__ndctl_init_filters
+
+	# Skip options backward and find the last ndctl command
+	__ndctl_prev_skip_opts
+	subcmd=$prev_skip_opts
+	# List ndctl subcommands or long options
+	if [ -z $subcmd ]; then
+		if [[ $cur == --* ]]; then
+			cmds="--version --help --list-cmds"
+		else
+			cmds=$($cmd --list-cmds)
+		fi
+		__ndctlcomp "$cmds" "$cur"
+	else
+		# List long option names
+		if [[ $cur == --* ]];  then
+			opts=$($cmd $subcmd --list-opts)
+			__ndctlcomp "$opts" "$cur"
+			__ndctl_comp_options "$cur"
+		else
+			[ -z "$subcmd" ] && return
+			__ndctl_comp_non_option_args "$subcmd" "$cur"
+		fi
+	fi
+}
+
+if [[ -n ${ZSH_VERSION-} ]]; then
+	autoload -U +X compinit && compinit
+
+	__ndctlcomp()
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
+	_ndctl()
+	{
+		local _ret=1 cur cword prev
+		cur=${words[CURRENT]}
+		prev=${words[CURRENT-1]}
+		let cword=CURRENT-1
+		emulate ksh -c __ndctl_main
+		let _ret && _default && _ret=0
+		return _ret
+	}
+
+	compdef _ndctl ndctl
+	return
+fi
+
+type ndctl &>/dev/null &&
+_ndctl()
+{
+	local cur words cword prev
+	if [ $preload_get_comp_words_by_ref = "true" ]; then
+		_get_comp_words_by_ref -n =: cur words cword prev
+	else
+		__ndctl_get_comp_words_by_ref -n =: cur words cword prev
+	fi
+	__ndctl_main
+} &&
+
+complete -o nospace -F _ndctl ndctl 2>/dev/null
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
