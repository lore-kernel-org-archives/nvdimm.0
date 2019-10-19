Return-Path: <SRS0=lzik=YM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A4DCA9EAC
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Oct 2019 16:54:04 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5F8620869
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Oct 2019 16:54:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5F8620869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C6B6E1007B75D;
	Sat, 19 Oct 2019 09:56:02 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.65; helo=mga03.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D5CFD1007B75B
	for <linux-nvdimm@lists.01.org>; Sat, 19 Oct 2019 09:56:00 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Oct 2019 09:54:01 -0700
X-IronPort-AV: E=Sophos;i="5.67,316,1566889200";
   d="scan'208";a="187125377"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Oct 2019 09:54:01 -0700
Subject: [ndctl PATCH 1/4] test/dax.sh: Fix failure reporting / handling
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Date: Sat, 19 Oct 2019 09:39:43 -0700
Message-ID: <157150318391.3940762.7285126205451065448.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <157150317870.3940762.5638079137146963300.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <157150317870.3940762.5638079137146963300.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Message-ID-Hash: V4N76XP3KAT6CYI55NER6PHFG4YHRZ5B
X-Message-ID-Hash: V4N76XP3KAT6CYI55NER6PHFG4YHRZ5B
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/V4N76XP3KAT6CYI55NER6PHFG4YHRZ5B/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instrument the cleanup() function rather than the err() function to
handle run_test() failures. This ensures umount runs and reports the
line number of the test rather than the line number internal to
run_test().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dax.sh |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/test/dax.sh b/test/dax.sh
index 3bb44ac0a26c..b8eb4ce54e10 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -33,7 +33,7 @@ run_test() {
 	if ! ./dax-pmd $MNT/$FILE; then
 		rc=$?
 		if [ $rc -ne 77 -a $rc -ne 0 ]; then
-			err
+			cleanup $1
 		fi
 	fi
 }
@@ -50,7 +50,7 @@ rc=1
 mkfs.ext4 -b 4096 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-run_test
+run_test $LINENO
 umount $MNT
 
 # convert pmem to put the memmap on the device
@@ -62,7 +62,7 @@ eval $(json2var <<< "$json")
 mkfs.ext4 -b 4096 /dev/$blockdev
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-run_test
+run_test $LINENO
 umount $MNT
 
 json=$($NDCTL create-namespace -m raw -f -e $dev)
@@ -72,7 +72,7 @@ eval $(json2var <<< "$json")
 mkfs.xfs -f /dev/$blockdev -m reflink=0
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-run_test
+run_test $LINENO
 umount $MNT
 
 # convert pmem to put the memmap on the device
@@ -83,7 +83,7 @@ eval $(json2var <<< "$json")
 mkfs.xfs -f /dev/$blockdev -m reflink=0
 mount /dev/$blockdev $MNT -o dax
 fallocate -l 1GiB $MNT/$FILE
-run_test
+run_test $LINENO
 umount $MNT
 
 # revert namespace to raw mode
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
