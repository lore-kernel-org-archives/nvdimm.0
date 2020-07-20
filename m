Return-Path: <SRS0=HKnB=A7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187F8C433E8
	for <linux-nvdimm@archiver.kernel.org>; Mon, 20 Jul 2020 23:54:32 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E74C522B4D
	for <linux-nvdimm@archiver.kernel.org>; Mon, 20 Jul 2020 23:54:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E74C522B4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E193C1243C6A2;
	Mon, 20 Jul 2020 16:54:31 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.115; helo=mga14.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EA9D91243792E
	for <linux-nvdimm@lists.01.org>; Mon, 20 Jul 2020 16:54:29 -0700 (PDT)
IronPort-SDR: SkFlPN+C9kHXksAC9ciIH1msF47JPwVjqJjPe2r9ANRWKSmWwEvJpvepbqSyIPaTdgAEnQk62H
 7b9hBNda8U3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="149188698"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800";
   d="scan'208";a="149188698"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 16:54:29 -0700
IronPort-SDR: uccUtHt9HOYS4GMnLXuOZjbnWWhr+OIyybzW9oBDdR2RKGGhggDkRwlklb6kXNRGbeqKwTnxEO
 wIK+39DEeZig==
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800";
   d="scan'208";a="487418337"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 16:54:29 -0700
Subject: [ndctl PATCH v2 4/4] ndctl/test: Test firmware-activation interface
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Cc: vishal.l.verma@intel.com
Date: Mon, 20 Jul 2020 16:38:12 -0700
Message-ID: <159528829258.994840.14916080245194585010.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159528827109.994840.13180558014653471832.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159528827109.994840.13180558014653471832.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: SULALDLB4QT26IW742GBKEZHKQCQCV4Z
X-Message-ID-Hash: SULALDLB4QT26IW742GBKEZHKQCQCV4Z
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SULALDLB4QT26IW742GBKEZHKQCQCV4Z/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the nfit_test firmware-update+activation emulation to validate the
operation of the kernel sysfs attributes, libndctl, ndctl update-firmware,
and ndctl activate-firmware.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/firmware-update.sh |   47 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index ed7d7e53772c..284b8268dbdd 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -22,23 +22,60 @@ reset()
 
 detect()
 {
-	dev=$($NDCTL list -b $NFIT_TEST_BUS0 -D | jq .[0].dev | tr -d '"')
-	[ -n "$dev" ] || err "$LINENO"
+	$NDCTL wait-scrub $NFIT_TEST_BUS0
+	fwa=$($NDCTL list -b $NFIT_TEST_BUS0 -F | jq -r '.[0].firmware.activate_method')
+	[ $fwa = "suspend" ] || err "$LINENO"
+	count=$($NDCTL list -b $NFIT_TEST_BUS0 -D | jq length)
+	[ $((count)) -eq 4 ] || err "$LINENO"
 }
 
 do_tests()
 {
+	# create a dummy image file, try to update all 4 dimms on
+	# nfit_test.0, validate that all get staged, validate that all
+	# but one get armed relative to an overflow error.
 	truncate -s 196608 $image
-	$NDCTL update-firmware -f $image $dev
+	json=$($NDCTL update-firmware -b $NFIT_TEST_BUS0 -f $image all)
+	count=$(jq 'map(select(.firmware.activate_state == "armed")) | length' <<< $json)
+	[ $((count)) -eq 3 ] || err "$LINENO"
+	count=$(jq 'map(select(.firmware.activate_state == "idle")) | length' <<< $json)
+	[ $((count)) -eq 1 ] || err "$LINENO"
+
+	# validate that the overflow dimm can be force armed
+	dev=$(jq -r '.[] | select(.firmware.activate_state == "idle").dev' <<< $json)
+	json=$($NDCTL update-firmware -b $NFIT_TEST_BUS0 $dev -A --force)
+	state=$(jq -r '.[0].firmware.activate_state' <<< $json)
+	[ $state = "armed" ] || err "$LINENO"
+
+	# validate that the bus indicates overflow
+	fwa=$($NDCTL list -b $NFIT_TEST_BUS0 -F | jq -r '.[0].firmware.activate_state')
+	[ $fwa = "overflow" ] || err "$LINENO"
+
+	# validate that all devices can be disarmed, and the bus goes idle
+	json=$($NDCTL update-firmware -b $NFIT_TEST_BUS0 -D all)
+	count=$(jq 'map(select(.firmware.activate_state == "idle")) | length' <<< $json)
+	[ $((count)) -eq 4 ] || err "$LINENO"
+	fwa=$($NDCTL list -b $NFIT_TEST_BUS0 -F | jq -r '.[0].firmware.activate_state')
+	[ $fwa = "idle" ] || err "$LINENO"
+
+	# re-arm all DIMMs
+	json=$($NDCTL update-firmware -b $NFIT_TEST_BUS0 -A --force all)
+	count=$(jq 'map(select(.firmware.activate_state == "armed")) | length' <<< $json)
+	[ $((count)) -eq 4 ] || err "$LINENO"
+
+	# trigger activation via suspend
+	json=$($NDCTL activate-firmware -v $NFIT_TEST_BUS0)
+	idle_count=$(jq '.[].dimms | map(select(.firmware.activate_state == "idle")) | length' <<< $json)
+	busy_count=$(jq '.[].dimms | map(select(.firmware.activate_state == "busy")) | length' <<< $json)
+	[ $((idle_count)) -eq 4 -o $((busy_count)) -eq 4 ] || err "$LINENO"
 }
 
 check_min_kver "4.16" || do_skip "may lack firmware update test handling"
 
 modprobe nfit_test
-rc=1
 reset
-rc=2
 detect
+rc=1
 do_tests
 rm -f $image
 _cleanup
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
