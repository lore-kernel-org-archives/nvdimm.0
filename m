Return-Path: <stellarhopper@gmail.com>
From: Vishal Verma <stellarhopper@gmail.com>
Subject: [ndctl PATCH] ndctl, bash_completion: add completion for --sector-size=
Date: Fri, 25 Aug 2017 14:49:22 -0600
Message-Id: <20170825204922.29374-1-stellarhopper@gmail.com>
To: linux-nvdimm@lists.01.org
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <stellarhopper@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Sector size options were missing completion. Add completion based on the
mode of the namespace if specified. 'raw' and 'memory' can only do 512
or 4096, where as with 'sector', more sector sizes are possible. 'dax'
doesn't accept a sector size option, so refrain from completing that.

$ ndctl create-namespace --mode=sector --sector-size=
4096   4104   4160   4224   512    520    528

$ ndctl create-namespace --mode=dax --sector-size=
<blank>

$ ndctl create-namespace --mode=raw --sector-size=
4096   512

When no mode has been specified yet, it is open game, and everything is
shown.

$ ndctl create-namespace --sector-size=
4096   4104   4160   4224   512    520    528

Signed-off-by: Vishal Verma <stellarhopper@gmail.com>
---
 contrib/ndctl | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/contrib/ndctl b/contrib/ndctl
index e77d680..9410572 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -141,6 +141,17 @@ __ndctl_get_dimms()
 	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
 }
 
+__ndctl_get_sector_sizes()
+{
+	if [[ "$mode_filter" == @(raw|memory) ]]; then
+		echo "512 4096"
+	elif [[ "$mode_filter" == @(dax) ]]; then
+		return
+	else
+		echo "512 520 528 4096 4104 4160 4224"
+	fi
+}
+
 __ndctl_file_comp()
 {
 	local cur="$1"
@@ -182,6 +193,9 @@ __ndctl_comp_options()
 				opts="raw sector"
 			fi
 			;;
+		--sector-size)
+			opts=$(__ndctl_get_sector_sizes)
+			;;
 		--map)
 			opts="mem dev"
 			;;
-- 
2.9.3
