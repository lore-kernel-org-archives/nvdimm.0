Return-Path: <SRS0=xeJQ=I5=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F67C433DB
	for <linux-nvdimm@archiver.kernel.org>; Wed, 31 Mar 2021 03:12:50 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A583619B1
	for <linux-nvdimm@archiver.kernel.org>; Wed, 31 Mar 2021 03:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A583619B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 43BDD100EB325;
	Tue, 30 Mar 2021 20:12:50 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.20; helo=mga02.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B0727100EB85F
	for <linux-nvdimm@lists.01.org>; Tue, 30 Mar 2021 20:12:47 -0700 (PDT)
IronPort-SDR: siwA428yyqv7BpPrqhJ6x8doST6rQNLlkzpuF29ZY7GZMR3zwIPSf6QJmYlKj/Vqmxui9wU8pd
 9fUxj8JPxgWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="179035503"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400";
   d="scan'208";a="179035503"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 20:12:47 -0700
IronPort-SDR: 65ptMeMqD/9Sw+rq6/RTFJ6j2Ywo6y3gr1Z9la91SPy4kFVX7Hc3WidlYGmZocf0yd4qEWAleC
 xnZGBVoRjs9A==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400";
   d="scan'208";a="438581723"
Received: from choffma1-mobl.amr.corp.intel.com (HELO omniknight.intel.com) ([10.212.71.210])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 20:12:46 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-nvdimm@lists.01.org>
Subject: [ndctl PATCH 0/3] daxctl-device fixes
Date: Tue, 30 Mar 2021 21:12:26 -0600
Message-Id: <20210331031229.384068-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Message-ID-Hash: KJHLT34DIWQWERSNUC7TZCJGADUUEADX
X-Message-ID-Hash: KJHLT34DIWQWERSNUC7TZCJGADUUEADX
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Dave Hansen <dave.hansen@linux.intel.com>, Chunye Xu <chunye.xu@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KJHLT34DIWQWERSNUC7TZCJGADUUEADX/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This series contains a couple of fixes:

1/ Check the kernel policy for onlining blocks. If that is set to
'online', and if daxctl is passed --no-online or is onlining to
ZONE_MOVABLE (default), then fail the reconfigure command as we know
we can't satisfy that ask. (Prior to these patches, the reconfigure
would succeed, and we'd print a warning after the fact, which may
result in a surprising experience).

2/ For ndctl disable-namespace (and destroy-namespace), fail the
operation if the dax device is active as system-ram.

Additionally, augment the daxctl-devices.sh unit test to test for both
of these conditions and the expected (fixed) behavior in both cases.

Vishal Verma (3):
  daxctl: fail reconfigure-device based on kernel onlining policy
  libdaxctl: add an API to check if a device is active
  libndctl: check for active system-ram before disabling daxctl devices

 .../daxctl/daxctl-reconfigure-device.txt      | 12 ++++-
 daxctl/lib/libdaxctl-private.h                |  1 +
 daxctl/lib/libdaxctl.c                        | 31 +++++++++++
 ndctl/lib/libndctl.c                          | 25 ++++++++-
 daxctl/libdaxctl.h                            |  2 +
 daxctl/device.c                               | 10 ++++
 daxctl/lib/libdaxctl.sym                      |  6 +++
 test/daxctl-devices.sh                        | 52 +++++++++++++++++++
 8 files changed, 137 insertions(+), 2 deletions(-)

-- 
2.30.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
