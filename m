Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30522CB2
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:45:01 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253845"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253845"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:58 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579098"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:57 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 15/16] cxl-cli: add bash completion
Date: Thu, 11 Nov 2021 13:44:35 -0700
Message-Id: <20211111204436.1560365-16-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2674; h=from:subject; bh=ILnqSEBVCPfTBuMvhajQdkFsVUNeONqJRClLLXV7M+8=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DZsnRqSn1/ptzVntUGesy9w1Z+eBSafnf7GfsG/XvaYE 23UPO0pZGMQ4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCR/bMZGd6/un+hqEhWzTxCdOKLXx dnOxb0f/DT1HRMvJB88//BKG+GfxqrDnu8f811Yy0j+yqr1xIJtiuy1B7Hz5Hp7Qnxef87hRMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add bash completion for the cxl-cli commands implemented so far:
  cxl-list
  cxl-read-labels
  cxl-write-labels
  cxl-zero-labels

Acked-by: Dan Williams <dan.j.williams@intel.com>
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

