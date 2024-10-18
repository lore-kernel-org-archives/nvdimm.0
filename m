Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E552D7BF
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 01:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729215011; cv=none; b=LokYIJgaMJ2x+/ghb0SKTnwKbc8T6gY77goOG/BqMcL7v6D+o9+sFGGoitt96A+zwCQ4R4i7Rg7u7NDgIzO7vF4br03nOWPhdeqKSg7VpfUR986YMtI4x2kB7PqXllxBffCxi7aMNdVn/2PXggWsxF4RxOuUeYDNxwvDnEiJJA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729215011; c=relaxed/simple;
	bh=ARm9CdF/CqkuZrcM7QwN+wl9hZM+rn5ag6V2mqobYvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjqcXcYjZcuEsulH11zjcjPm/g4VJEeewRMXWMmLQQxmnv6jZCZgFm12r4LDfbgRZhx7VE/ZpVRiRQhdscIM9yVIncN64/oZU94R0D3nPWls2JA41eit1Lmg5SD80nCbbDfIeJcbKIiJop6oeZD+FVSm0KcL9gfYru354pWz0ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=be+RhvSV; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="be+RhvSV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1729215008; x=1760751008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ARm9CdF/CqkuZrcM7QwN+wl9hZM+rn5ag6V2mqobYvg=;
  b=be+RhvSVUtUpLKvs3FxlcUKkRtpie9AI+3wfc+CDTQMo/LzwI9tcJbjQ
   XFM5CKIcetn/KRe6UawoX/8RwZ3r1vbErOD7U34t1Elg9KDxOmMZ9bTyo
   Q6Lr3eZGD38rF+7RVLKvYcilOhfwAco3BBkkVid0gJ/e1wSrnPpTUd/qO
   aP8AibPgo0M1T6o8asBdfMvixrrsUSOqbohGgPyGYs3UUbZtmDoCLVbfq
   txrbNqmOua8C8PKBfiJFaHykyno0SsgaYAtf8p/eAag7rlMV3hhNxSQxe
   zVBfTvE+GaOx7/tUl5hd5SqhGIJKcdWrIL9+p5AEWOe9tneuvuVKyUhkZ
   g==;
X-CSE-ConnectionGUID: 3/iQO9IlTEyVHWfcRyYiNg==
X-CSE-MsgGUID: +u1V3QOnSMa6Rz/YMaq8GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="179323637"
X-IronPort-AV: E=Sophos;i="6.11,212,1725289200"; 
   d="scan'208";a="179323637"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 10:29:43 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 91DE7C9440
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 10:29:40 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id BF0CACFBA4
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 10:29:39 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 55BA340A7D
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 10:29:39 +0900 (JST)
Received: from iaas-rdma.. (unknown [10.167.135.44])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id E486F1A01ED;
	Fri, 18 Oct 2024 09:29:38 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v3 2/2] test/monitor.sh: Fix shellcheck SC2086 issues as more as possible
Date: Fri, 18 Oct 2024 09:30:20 +0800
Message-ID: <20241018013020.2523845-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20241018013020.2523845-1-lizhijian@fujitsu.com>
References: <20241018013020.2523845-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28738.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28738.003
X-TMASE-Result: 10--10.532800-10.000000
X-TMASE-MatchedRID: GJWipKZ49enCS1NeCvs3qIdlc1JaOB1TqMXw4YFVmwhf/JRqlbLSV7Sn
	Jfu7KIKtEi5XEH00QubCsyZB1bKGqCqQO0zIUpyn8IK7yRWPRNEk2ugFoZn4tZE8TgOkbzEohEz
	I3+mkzifvPrWB/m7DX0y+rse8BOXw0hQoRxePIEGfrLSY2RbRpE3yuY9BGW8r9Iz2KSWO8hx7j+
	VBlZHsEjjiJ+c203Ms8vc3EUpCmrVzE1fI6N2sO0hwlOfYeSqxIm2Js0m7E8KhuT/MQ6uAV/qAD
	eqinEVf2cknzgMeAbs51K+dagOOz/XhWE12qWg+GYJhRh6sses4Ddbs3t0GCZ6fSoF3Lt+M5aE0
	pi4zt43jfe52KJUqfc/7jrKpSJx3HxPMjOKY7A8LbigRnpKlKSPzRlrdFGDwZbSJQ9f2HSlhgIr
	YE2VKa7ZEfCsCXb1sr/ygZ6K2Kn21GQ3EnYnJTA==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

SC2086 [1], aka. Double quote to prevent globbing and word splitting.

Previously, SC2086 will cause error in [[]] or [], for example
$ grep -w line build/meson-logs/testlog.txt
test/monitor.sh: line 99: [: too many arguments
test/monitor.sh: line 99: [: nmem0: binary operator expected

Firstly,  generated diff by shellcheck tool:
$ shellcheck -i SC2086 -f diff test/monitor.sh

In addition, we have remove the double quote around $1 like below
changes. That's because when an empty "$1" passed to a command will open to ''
it would cause an error, for example
$ ndctl/build/test/list-smart-dimm -b nfit_test.0 ''
  Error: unknown parameter ""

-       $NDCTL monitor -c "$monitor_conf" -l "$logfile" "$1" &
+       $NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &

-       jlist=$("$TEST_PATH"/list-smart-dimm -b "$smart_supported_bus" "$1")
+       jlist=$("$TEST_PATH"/list-smart-dimm -b "$smart_supported_bus" $1)

-       $NDCTL inject-smart "$monitor_dimms" "$1"
+       $NDCTL inject-smart "$monitor_dimms" $1

-       [[ $1 == $notify_dimms ]]
+       [[ "$1" == "$notify_dimms" ]]

-               [ ! -z "$monitor_dimms" ] && break
+               [[ "$monitor_dimms" ]] && break

[1] https://www.shellcheck.net/wiki/SC2086
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
`shellcheck -i SC2086 -f diff test/*.sh | patch -p1` can auto correct some
remaining SC2086 issues, however we can find it still miss some
patterns and some changes will break the origial test.

V3:
  - Fix SC2086 issues as more as possible # Alison
  - covert [ ! -z $foo ] to [[  "foo" ]] as Vishal's suggestion.
V1:
 V1 has a mistake which overts to integer too late.
 Move the conversion forward before the operation
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 test/monitor.sh | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index 7049b36..be8e24d 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -11,7 +11,7 @@ monitor_regions=""
 monitor_namespace=""
 smart_supported_bus=""
 
-. $(dirname $0)/common
+. $(dirname "$0")/common
 
 monitor_conf="$TEST_PATH/../ndctl"
 
@@ -24,51 +24,51 @@ check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
 start_monitor()
 {
 	logfile=$(mktemp)
-	$NDCTL monitor -c "$monitor_conf" -l $logfile $1 &
+	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
 	monitor_pid=$!
 	sync; sleep 3
-	truncate --size 0 $logfile #remove startup log
+	truncate --size 0 "$logfile" #remove startup log
 }
 
 set_smart_supported_bus()
 {
 	smart_supported_bus=$NFIT_TEST_BUS0
-	monitor_dimms=$($TEST_PATH/list-smart-dimm -b $smart_supported_bus | jq -r .[0].dev)
-	if [ -z $monitor_dimms ]; then
+	monitor_dimms=$("$TEST_PATH"/list-smart-dimm -b "$smart_supported_bus" | jq -r .[0].dev)
+	if [ -z "$monitor_dimms" ]; then
 		smart_supported_bus=$NFIT_TEST_BUS1
 	fi
 }
 
 get_monitor_dimm()
 {
-	jlist=$($TEST_PATH/list-smart-dimm -b $smart_supported_bus $1)
-	monitor_dimms=$(jq '.[]."dev"?, ."dev"?' <<<$jlist | sort | uniq | xargs)
-	echo $monitor_dimms
+	jlist=$("$TEST_PATH"/list-smart-dimm -b "$smart_supported_bus" $1)
+	monitor_dimms=$(jq '.[]."dev"?, ."dev"?' <<<"$jlist" | sort | uniq | xargs)
+	echo "$monitor_dimms"
 }
 
 call_notify()
 {
-	$TEST_PATH/smart-notify $smart_supported_bus
+	"$TEST_PATH"/smart-notify "$smart_supported_bus"
 	sync; sleep 3
 }
 
 inject_smart()
 {
-	$NDCTL inject-smart $monitor_dimms $1
+	$NDCTL inject-smart "$monitor_dimms" $1
 	sync; sleep 3
 }
 
 check_result()
 {
-	jlog=$(cat $logfile)
-	notify_dimms=$(jq ."dimm"."dev" <<<$jlog | sort | uniq | xargs)
-	[[ $1 == $notify_dimms ]]
+	jlog=$(cat "$logfile")
+	notify_dimms=$(jq ."dimm"."dev" <<<"$jlog" | sort | uniq | xargs)
+	[[ "$1" == "$notify_dimms" ]]
 }
 
 stop_monitor()
 {
 	kill $monitor_pid
-	rm $logfile
+	rm "$logfile"
 }
 
 test_filter_dimm()
@@ -91,12 +91,12 @@ test_filter_bus()
 
 test_filter_region()
 {
-	count=$($NDCTL list -R -b $smart_supported_bus | jq -r .[].dev | wc -l)
+	count=$($NDCTL list -R -b "$smart_supported_bus" | jq -r .[].dev | wc -l)
 	i=0
-	while [ $i -lt $count ]; do
-		monitor_region=$($NDCTL list -R -b $smart_supported_bus | jq -r .[$i].dev)
+	while [ $i -lt "$count" ]; do
+		monitor_region=$($NDCTL list -R -b "$smart_supported_bus" | jq -r .[$i].dev)
 		monitor_dimms=$(get_monitor_dimm "-r $monitor_region")
-		[ ! -z $monitor_dimms ] && break
+		[[ "$monitor_dimms" ]] && break
 		i=$((i + 1))
 	done
 	start_monitor "-r $monitor_region"
@@ -108,25 +108,25 @@ test_filter_region()
 test_filter_namespace()
 {
 	reset
-	monitor_namespace=$($NDCTL create-namespace -b $smart_supported_bus | jq -r .dev)
+	monitor_namespace=$($NDCTL create-namespace -b "$smart_supported_bus" | jq -r .dev)
 	monitor_dimms=$(get_monitor_dimm "-n $monitor_namespace")
 	start_monitor "-n $monitor_namespace"
 	call_notify
 	check_result "$monitor_dimms"
 	stop_monitor
-	$NDCTL destroy-namespace $monitor_namespace -f
+	$NDCTL destroy-namespace "$monitor_namespace" -f
 }
 
 test_conf_file()
 {
 	monitor_dimms=$(get_monitor_dimm)
 	conf_file=$(mktemp)
-	echo -e "[monitor]\ndimm = $monitor_dimms" > $conf_file
+	echo -e "[monitor]\ndimm = $monitor_dimms" > "$conf_file"
 	start_monitor "-c $conf_file"
 	call_notify
 	check_result "$monitor_dimms"
 	stop_monitor
-	rm $conf_file
+	rm "$conf_file"
 }
 
 test_filter_dimmevent()
@@ -138,14 +138,14 @@ test_filter_dimmevent()
 	check_result "$monitor_dimms"
 	stop_monitor
 
-	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."spares_threshold")
+	inject_value=$($NDCTL list -H -d "$monitor_dimms" | jq -r .[]."health"."spares_threshold")
 	inject_value=$((inject_value - 1))
 	start_monitor "-d $monitor_dimms -D dimm-spares-remaining"
 	inject_smart "-s $inject_value"
 	check_result "$monitor_dimms"
 	stop_monitor
 
-	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."temperature_threshold")
+	inject_value=$($NDCTL list -H -d "$monitor_dimms" | jq -r .[]."health"."temperature_threshold")
 	inject_value=${inject_value%.*}
 	inject_value=$((inject_value + 1))
 	start_monitor "-d $monitor_dimms -D dimm-media-temperature"
-- 
2.44.0

