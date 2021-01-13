Return-Path: <SRS0=F1Ul=GQ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E600C433DB
	for <linux-nvdimm@archiver.kernel.org>; Wed, 13 Jan 2021 07:14:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C0FB22312E
	for <linux-nvdimm@archiver.kernel.org>; Wed, 13 Jan 2021 07:14:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0FB22312E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6BEFA100EB323;
	Tue, 12 Jan 2021 23:14:56 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D74AE100EB85F
	for <linux-nvdimm@lists.01.org>; Tue, 12 Jan 2021 23:14:53 -0800 (PST)
IronPort-SDR: 03oFkW+IjOhuoqNm3bQbXI8DEYlmD2LqxE6HBzuQoXzFILOVCO4gEL1i4MODFYoB23c73isMBs
 H95O+vB1b0gA==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="178310018"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400";
   d="scan'208";a="178310018"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 23:14:53 -0800
IronPort-SDR: VW8ZtevZfQnWW53LyuDrIwNU9KaJ+r1QZHvCOMwe6T/KIud0d7xVGzzdd7GNfzJx9FH1BGxx7+
 Wo5Y+WZRlT7w==
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400";
   d="scan'208";a="389408652"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 23:14:53 -0800
Subject: [ndctl PATCH 0/4] ndctl/test: softoffline, mremap, and misc fixups
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Date: Tue, 12 Jan 2021 23:14:53 -0800
Message-ID: <161052209289.1804207.11599120961607513911.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: OKHZDOEKUHMEXWWUZIULHZDIZCYBMUWW
X-Message-ID-Hash: OKHZDOEKUHMEXWWUZIULHZDIZCYBMUWW
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/OKHZDOEKUHMEXWWUZIULHZDIZCYBMUWW/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Vishal,

Here's a collection of test updates. It adds support for regression
testing pfn_to_online_page() which suffered from a lack of precision in
mixed zone memory-sections. Updates the mremap() regression to accept
failure as an option (the behavior in v5.11-rc1+). Fixes a warning, and
ditches an 'out' label.

---

Dan Williams (4):
      ndctl/test: Fix btt expect table compile warning
      ndctl/test: Cleanup unnecessary out label
      ndctl/test: Fix device-dax mremap() test
      ndctl/test: Exercise soft_offline_page() corner cases


 test/dax-pmd.c    |   17 +++++++++--------
 test/dax-poison.c |   19 +++++++++++++++++++
 test/device-dax.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 test/libndctl.c   |   12 ++++++------
 4 files changed, 79 insertions(+), 14 deletions(-)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
