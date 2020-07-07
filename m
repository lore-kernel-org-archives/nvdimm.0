Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB288C433DF
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 02:57:40 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CBB562070C
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 02:57:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBB562070C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C61A41108E908;
	Mon,  6 Jul 2020 19:57:40 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.93; helo=mga11.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 6F9321108E905
	for <linux-nvdimm@lists.01.org>; Mon,  6 Jul 2020 19:57:38 -0700 (PDT)
IronPort-SDR: wJCOZznacXWk680TAqmiPDln0m8KJb2R7hwpgWSBegYq6HAlfrgPsBkvhsHpWXX6yiobeLoyYG
 S/Su0uODA9Bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="145631401"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800";
   d="scan'208";a="145631401"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:57:38 -0700
IronPort-SDR: /wf4FLmyYRwz9pu0PJYL6WbJhjKWiv2z8idB9+umZCJSXkcqeXsjOlAZASonrn5Hl8mtXNB1bM
 d+m0tQGfnoqg==
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800";
   d="scan'208";a="427306452"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:57:37 -0700
Subject: [ndctl PATCH 12/16] ndctl/test: Test firmware-activation interface
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Cc: vishal.l.verma@intel.com
Date: Mon, 06 Jul 2020 19:41:22 -0700
Message-ID: <159408968244.2386154.13977439163065953722.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159408961822.2386154.888266173771881937.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159408961822.2386154.888266173771881937.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: IUJ6PUTYBZCSY5VCZSPQTCER6OAL7PFC
X-Message-ID-Hash: IUJ6PUTYBZCSY5VCZSPQTCER6OAL7PFC
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/IUJ6PUTYBZCSY5VCZSPQTCER6OAL7PFC/>
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
 test/firmware-update.sh |   50 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/test/firmware-update.sh b/test/firmware-update.sh
index ed7d7e53772c..098dd92b4eb3 100755
--- a/test/firmware-update.sh
+++ b/test/firmware-update.sh
@@ -22,23 +22,63 @@ reset()
 
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
+	# check that unforced activation fails
+	[ $NDCTL activate-firmware -b $NFIT_TEST_BUS0 ] && err "$LINENO"
+
+	# force activation
+	json=$($NDCTL activate-firmware $NFIT_TEST_BUS0 --force)
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
