Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 601ED2194D3B8
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 14:34:11 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 bash-completion: add helpers for security commands
Date: Fri,  1 Feb 2019 15:34:08 -0700
Message-Id: <20190201223408.18823-1-vishal.l.verma@intel.com>
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

Add bash completion helpers for security-related commands and their
options.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index 629d6a8..e17fb0b 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -116,7 +116,7 @@ __ndctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count|--firmware|--media-temperature|--ctrl-temperature|--spares|--media-temperature-threshold|--ctrl-temperature-threshold|--spares-threshold|--media-temperature-alarm|--ctrl-temperature-alarm|--spares-alarm|--numa-node|--log|--dimm-event|--config-file) ]]; then
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count|--firmware|--media-temperature|--ctrl-temperature|--spares|--media-temperature-threshold|--ctrl-temperature-threshold|--spares-threshold|--media-temperature-alarm|--ctrl-temperature-alarm|--spares-alarm|--numa-node|--log|--dimm-event|--config-file|--key-handle|--key-path|--tpm-handle) ]]; then
 			COMPREPLY[$i]="${cword}="
 		else
 			COMPREPLY[$i]="${cword} "
@@ -298,6 +298,10 @@ __ndctl_comp_options()
 			__ndctl_file_comp "$cur_arg"
 			return
 			;;
+		--key-path)
+			__ndctl_file_comp "$cur_arg"
+			return
+			;;
 		*)
 			return
 			;;
@@ -358,6 +362,19 @@ __ndctl_comp_non_option_args()
 	start-scrub)
 		opts="$(__ndctl_get_buses) all"
 		;;
+	setup-passphrase)
+		;&
+	update-passphrase)
+		;&
+	remove-passphrase)
+		;&
+	freeze-security)
+		;&
+	sanitize-dimm)
+		;&
+	wait-overwrite)
+		opts="$(__ndctl_get_dimms -i) all"
+		;;
 	*)
 		return
 		;;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
