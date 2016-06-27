Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 917F11A1E01
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 14:28:26 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] ndctl: make completion smarter wrt mode/type/idle
 options
Date: Mon, 27 Jun 2016 15:27:25 -0600
Message-Id: <1467062845-24290-1-git-send-email-vishal.l.verma@intel.com>
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

Add three new 'filters' for mode, type, and idle.

'mode' and 'type' work with each other to prevent a blk namespace from
showing modes like 'dax' or 'memory', or if those modes are specified,
then limiting 'type' to 'pmem'.

Also show completions for --map= only if mode is 'memory'.

For idle filtering (typically relevant for 'ndctl list', only show idle
{namespaces, regions} in the completion id a --idle has been specified
on the command line so far. This makes sense because trying to list an
idle namespace without --idle (even if you know that is the one you
want) won't show any output withot --idle.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

v2: Remove filtering for --map=  (Dan)

 contrib/ndctl | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index b7a82fc..160a9dc 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -110,6 +110,8 @@ __ndctl_get_regions()
 {
 	local opts="--regions $*"
 	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
+	[ -n "$type_filter" ] && opts="$opts --type=$type_filter"
+	[ -n "$idle_filter" ] && opts="$opts --idle"
 	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
 }
 
@@ -118,6 +120,8 @@ __ndctl_get_ns()
 	opts="--namespaces $*"
 	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
 	[ -n "$reg_filter" ] && opts="$opts --bus=$reg_filter"
+	[ -n "$type_filter" ] && opts="$opts --type=$type_filter"
+	[ -n "$idle_filter" ] && opts="$opts --idle"
 	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
 }
 
@@ -147,7 +151,7 @@ __ndctl_comp_options()
 			opts=$(__ndctl_get_dimms)
 			;;
 		--namespace)
-			opts=$(__ndctl_get_ns -i)
+			opts=$(__ndctl_get_ns)
 			;;
 		--reconfig)
 			# It is ok to reconfig disabled namespaces
@@ -155,9 +159,15 @@ __ndctl_comp_options()
 			;;
 		--type)
 			opts="pmem blk"
+			if [[ "$mode_filter" == @(dax|memory) ]]; then
+				opts="pmem"
+			fi
 			;;
 		--mode)
 			opts="raw sector memory dax"
+			if [[ "$type_filter" == "blk" ]]; then
+				opts="raw sector"
+			fi
 			;;
 		--map)
 			opts="mem dev"
@@ -224,13 +234,13 @@ __ndctl_prev_skip_opts ()
 	done
 }
 
-bus_filter=''
-reg_filter=''
-
 __ndctl_init_filters()
 {
 	bus_filter=''
 	reg_filter=''
+	type_filter=''
+	idle_filter=''
+	mode_filter=''
 
 	for __word in "${words[@]}"; do
 		if [[ "$__word" =~ --bus=(.*) ]]; then
@@ -245,6 +255,15 @@ __ndctl_init_filters()
 			local regions=$(__ndctl_get_regions -i)
 			[[ "$regions" == *"$reg_filter"* ]] || reg_filter=''
 		fi
+		if [[ "$__word" =~ --idle ]]; then
+			idle_filter="1"
+		fi
+		if [[ "$__word" =~ --type=(.*) ]]; then
+			type_filter="${BASH_REMATCH[1]}"
+		fi
+		if [[ "$__word" =~ --mode=(.*) ]]; then
+			mode_filter="${BASH_REMATCH[1]}"
+		fi
 	done
 }
 
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
