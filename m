Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95E533E9
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:34 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606997"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606997"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:27 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271460"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:26 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 21/21] cxl-cli: add bash completion
Date: Thu,  1 Jul 2021 14:10:05 -0600
Message-Id: <20210701201005.3065299-22-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701201005.3065299-1-vishal.l.verma@intel.com>
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bash completion for the cxl-cli commands implemented so far:
  cxl-list
  cxl-read-labels
  cxl-write-labels
  cxl-zero-labels

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/contrib/ndctl b/contrib/ndctl
index 680fe6a..cae4b1b 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -647,5 +647,114 @@ _daxctl()
 	__daxctl_main
 }
 
+### cxl-cli ###
+
+__cxl_get_devs()
+{
+	local opts=("--memdevs" "$*")
+	cxl list "${opts[@]}" | grep -E "^\s*\"memdev\":" | cut -d'"' -f4
+}
+
+__cxlcomp()
+{
+	local i=0
+
+	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
+	for cword in "${COMPREPLY[@]}"; do
+		if [[ "$cword" == @(--memdev|--offset|--size|--input|--output) ]]; then
+			COMPREPLY[$i]="${cword}="
+		else
+			COMPREPLY[$i]="${cword} "
+		fi
+		((i++))
+	done
+}
+
+__cxl_comp_options()
+{
+
+	local cur=$1
+	local opts
+
+	if [[ "$cur" == *=* ]]; then
+		local cur_subopt=${cur%%=*}
+		local cur_arg=${cur##*=}
+		case $cur_subopt in
+		--memdev)
+			opts="$(__cxl_get_devs -i)"
+			;;
+		*)
+			return
+			;;
+		esac
+		__cxlcomp "$opts" "$cur_arg"
+	fi
+}
+
+__cxl_comp_non_option_args()
+{
+	local subcmd=$1
+	local cur=$2
+	local opts
+
+	case $subcmd in
+	read-labels)
+		;&
+	write-labels)
+		;&
+	zero-labels)
+		opts="$(__cxl_get_devs -i) all"
+		;;
+	*)
+		return
+		;;
+	esac
+	__cxlcomp "$opts" "$cur"
+}
+
+__cxl_main()
+{
+	local cmd subcmd
+
+	cmd=${words[0]}
+	COMPREPLY=()
+
+	# Skip options backward and find the last cxl command
+	__nd_common_prev_skip_opts
+	subcmd=$prev_skip_opts
+	# List cxl subcommands or long options
+	if [ -z $subcmd ]; then
+		if [[ $cur == --* ]]; then
+			cmds="--version --help --list-cmds"
+		else
+			cmds=$($cmd --list-cmds)
+		fi
+		__cxlcomp "$cmds" "$cur"
+	else
+		# List long option names
+		if [[ $cur == --* ]];  then
+			opts=$($cmd $subcmd --list-opts)
+			__cxlcomp "$opts" "$cur"
+			__cxl_comp_options "$cur"
+		else
+			[ -z "$subcmd" ] && return
+			__cxl_comp_non_option_args "$subcmd" "$cur"
+		fi
+	fi
+}
+
+type cxl &>/dev/null &&
+_cxl()
+{
+	local cur words cword prev
+	if [ $preload_get_comp_words_by_ref = "true" ]; then
+		_get_comp_words_by_ref -n =: cur words cword prev
+	else
+		__nd_common_get_comp_words_by_ref -n =: cur words cword prev
+	fi
+	__cxl_main
+}
+
 complete -o nospace -F _ndctl ndctl
 complete -o nospace -F _daxctl daxctl
+complete -o nospace -F _cxl cxl
-- 
2.31.1

