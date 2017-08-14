Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 912F321DFC888
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 13:33:52 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] bash completion: updates for the improved filtering
Date: Mon, 14 Aug 2017 14:34:22 -0600
Message-Id: <20170814203422.28284-1-vishal.l.verma@intel.com>
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

ndctl added improved filtering means, allowing one to filter listings
with any combination of bus, dimm, region, or namespace. Make bash
completion use that to only show the filtered set for any object. For
example:

$ ndctl list --region=region6 --dimm=nmem<tab>
nmem0   nmem1

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/ndctl | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/contrib/ndctl b/contrib/ndctl
index fd560cb..e77d680 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -103,6 +103,9 @@ __ndctlcomp()
 __ndctl_get_buses()
 {
 	local opts="--buses $*"
+	[ -n "$dimm_filter" ] && opts="$opts --dimm=$dimm_filter"
+	[ -n "$reg_filter" ] && opts="$opts --region=$reg_filter"
+	[ -n "$ns_filter" ] && opts="$opts --namespace=$ns_filter"
 	echo "$(ndctl list $opts | grep -E "^\s*\"provider\":" | cut -d\" -f4)"
 }
 
@@ -110,6 +113,8 @@ __ndctl_get_regions()
 {
 	local opts="--regions $*"
 	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
+	[ -n "$dimm_filter" ] && opts="$opts --dimm=$dimm_filter"
+	[ -n "$ns_filter" ] && opts="$opts --namespace=$ns_filter"
 	[ -n "$type_filter" ] && opts="$opts --type=$type_filter"
 	[ -n "$idle_filter" ] && opts="$opts --idle"
 	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
@@ -119,7 +124,9 @@ __ndctl_get_ns()
 {
 	opts="--namespaces $*"
 	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
-	[ -n "$reg_filter" ] && opts="$opts --bus=$reg_filter"
+	[ -n "$dimm_filter" ] && opts="$opts --dimm=$dimm_filter"
+	[ -n "$reg_filter" ] && opts="$opts --region=$reg_filter"
+	[ -n "$mode_filter" ] && opts="$opts --mode=$mode_filter"
 	[ -n "$type_filter" ] && opts="$opts --type=$type_filter"
 	[ -n "$idle_filter" ] && opts="$opts --idle"
 	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
@@ -129,6 +136,8 @@ __ndctl_get_dimms()
 {
 	opts="--dimms $*"
 	[ -n "$bus_filter" ] && opts="$opts --bus=$bus_filter"
+	[ -n "$reg_filter" ] && opts="$opts --region=$reg_filter"
+	[ -n "$ns_filter" ] && opts="$opts --namespace=$ns_filter"
 	echo "$(ndctl list $opts | grep -E "^\s*\"dev\":" | cut -d\" -f4)"
 }
 
@@ -263,6 +272,8 @@ __ndctl_init_filters()
 {
 	bus_filter=''
 	reg_filter=''
+	ns_filter=''
+	dimm_filter=''
 	type_filter=''
 	idle_filter=''
 	mode_filter=''
@@ -280,6 +291,19 @@ __ndctl_init_filters()
 			local regions=$(__ndctl_get_regions -i)
 			[[ "$regions" == *"$reg_filter"* ]] || reg_filter=''
 		fi
+		if [[ "$__word" =~ --namespace=(.*) ]]; then
+			ns_filter="${BASH_REMATCH[1]}"
+			# lets make sure this is in the list of namespaces
+			local nss=$(__ndctl_get_ns -i)
+			[[ "$nss" == *"$ns_filter"* ]] || ns_filter=''
+		fi
+		if [[ "$__word" =~ --dimm=(.*) ]]; then
+			dimm_filter="${BASH_REMATCH[1]}"
+			# lets make sure this is in the list of dimms
+			local dimms=$(__ndctl_get_dimms)
+			[[ "$dimms" == *"$dimm_filter"* ]] || dimm_filter=''
+		fi
+
 		if [[ "$__word" =~ --idle ]]; then
 			idle_filter="1"
 		fi
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
