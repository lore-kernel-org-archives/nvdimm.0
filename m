Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7B39223DB786
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 21:29:20 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 4/4] ndctl,
 bash-completion: Add bash completion for inject-smart
Date: Thu,  8 Feb 2018 22:35:00 -0700
Message-Id: <20180209053500.6871-4-vishal.l.verma@intel.com>
In-Reply-To: <20180209053500.6871-1-vishal.l.verma@intel.com>
References: <20180209053500.6871-1-vishal.l.verma@intel.com>
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

This adds bash completion for the enw ndctl inject-smart command.
non-option arguments are completed with dimms, and new options
requiring data are marked as such.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index eeda1c4..89e0252 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -91,7 +91,7 @@ __ndctlcomp()
 
 	COMPREPLY=( $( compgen -W "$1" -- "$2" ) )
 	for cword in "${COMPREPLY[@]}"; do
-		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count|--firmware) ]]; then
+		if [[ "$cword" == @(--bus|--region|--type|--mode|--size|--dimm|--reconfig|--uuid|--name|--sector-size|--map|--namespace|--input|--output|--label-version|--align|--block|--count|--firmware|--media-temperature|--ctrl-temperature|--spares|--media-temperature-threshold|--ctrl-temperature-threshold|--spares-threshold|--media-temperature-alarm|--ctrl-temperature-alarm|--spares-alarm) ]]; then
 			COMPREPLY[$i]="${cword}="
 		else
 			COMPREPLY[$i]="${cword} "
@@ -210,6 +210,13 @@ __ndctl_comp_options()
 		--label-version)
 			opts="1.1 1.2"
 			;;
+		--media-temperature-alarm)
+			;&
+		--ctrl-temperature-alarm)
+			;&
+		--spares-alarm)
+			opts="on off"
+			;;
 		*)
 			return
 			;;
@@ -262,6 +269,9 @@ __ndctl_comp_non_option_args()
 	inject-error)
 		opts="$(__ndctl_get_ns -i)"
 		;;
+	inject-smart)
+		opts="$(__ndctl_get_dimms -i)"
+		;;
 	*)
 		return
 		;;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
