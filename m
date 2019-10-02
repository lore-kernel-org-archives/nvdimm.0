Return-Path: <SRS0=ArFb=X3=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9158FC4360C
	for <linux-nvdimm@archiver.kernel.org>; Wed,  2 Oct 2019 23:49:47 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B92A21A4C
	for <linux-nvdimm@archiver.kernel.org>; Wed,  2 Oct 2019 23:49:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B92A21A4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2694E10FC4062;
	Wed,  2 Oct 2019 16:50:57 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 8370B100DC433
	for <linux-nvdimm@lists.01.org>; Wed,  2 Oct 2019 16:50:55 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:49:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200";
   d="scan'208";a="195032122"
Received: from vverma7-desk1.lm.intel.com ([10.232.112.164])
  by orsmga003.jf.intel.com with ESMTP; 02 Oct 2019 16:49:37 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-nvdimm@lists.01.org>
Subject: [ndctl PATCH 08/10] Documentation: clarify memory movablity for reconfigure-device
Date: Wed,  2 Oct 2019 17:49:23 -0600
Message-Id: <20191002234925.9190-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002234925.9190-1-vishal.l.verma@intel.com>
References: <20191002234925.9190-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Message-ID-Hash: ZCSGBW5W4T4KLRG3S5FUDJA3GWUNO6VU
X-Message-ID-Hash: ZCSGBW5W4T4KLRG3S5FUDJA3GWUNO6VU
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Dave Hansen <dave.hansen@linux.intel.com>, Ben Olson <ben.olson@intel.com>, Michal Biesek <michal.biesek@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZCSGBW5W4T4KLRG3S5FUDJA3GWUNO6VU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move the note about potential races in memory onlining into the
'Description' section to make it more prominent. Reword the note to talk
about the sources of such races, and talk about the new 'race detection'
semantics in daxctl.

Link: https://github.com/pmem/ndctl/issues/110
Reported-by: Ben Olson <ben.olson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .../daxctl/daxctl-reconfigure-device.txt      | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
index 196d692..4663529 100644
--- a/Documentation/daxctl/daxctl-reconfigure-device.txt
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -97,6 +97,20 @@ error reconfiguring devices: Operation not supported
 reconfigured 0 devices
 ----
 
+'daxctl-reconfigure-device' nominally expects that it will online new memory
+blocks as 'movable', so that kernel data doesn't make it into this memory.
+However, there are other potential agents that may be configured to
+automatically online new hot-plugged memory as it appears. Most notably,
+these are the '/sys/devices/system/memory/auto_online_blocks' configuration,
+or system udev rules. If such an agent races to online memory sections, daxctl
+checks if the blocks were onlined as 'movable' memory. If this was not the
+case, and the memory blocks are found to be in a different zone, then a
+warning is displayed. If it is desired that a different agent control the
+onlining of memory blocks, and the associated memory zone, then it is
+recommended to use the --no-online option described below. This will abridge
+the device reconfiguration operation to just hotplugging the memory, and
+refrain from then onlining it.
+
 OPTIONS
 -------
 -r::
@@ -121,16 +135,6 @@ OPTIONS
 	brought online automatically and immediately with the 'online_movable'
 	policy. Use this option to disable the automatic onlining behavior.
 
-	NOTE: While this option prevents daxctl from automatically onlining
-	the memory sections, there may be other agents, notably system udev
-	rules, that online new memory sections as they appear. Coordinating
-	with such rules is out of scope of this utility, and the system
-	administrator is expected to remove them if they are undesirable.
-	If such an agent races to online memory sections, daxctl is prepared
-	to lose the race, and not fail the onlining operation as it only
-	cares that the memory section was onlined, not that it was the one
-	to do so.
-
 -f::
 --force::
 	When converting from "system-ram" mode to "devdax", it is expected
-- 
2.20.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
