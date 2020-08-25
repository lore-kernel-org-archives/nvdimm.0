Return-Path: <SRS0=BlKz=CD=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6812DC433E1
	for <linux-nvdimm@archiver.kernel.org>; Tue, 25 Aug 2020 19:16:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E1992071E
	for <linux-nvdimm@archiver.kernel.org>; Tue, 25 Aug 2020 19:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="afwk3wvW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E1992071E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 007DF119F73C4;
	Tue, 25 Aug 2020 12:16:23 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C9911119F73C1
	for <linux-nvdimm@lists.01.org>; Tue, 25 Aug 2020 12:16:20 -0700 (PDT)
Subject: Re: [GIT PULL] libnvdimm fixes for v5.9-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598382980;
	bh=69ccBDqMOEBQbGkKJqgfjlVZ2hQNRbSK31PGrxkE70g=;
	h=From:In-Reply-To:References:Date:To:Cc:From;
	b=afwk3wvW9YCcctQCLVnXnPxFNZWxXCgAT0WXAFMsP1WnGtnZB5rKx5dpa+5d+gNn1
	 SDxzKYau2ESpKDNn3iFgRa+sE0/+pBeGWSK/GjGHsd9G+r3HCrZ6cqiUU/DLjMtPke
	 wYEqSPIkpVCxnm8A74ETKJqhX1SXSSqIvjj2VUvk=
From: pr-tracker-bot@kernel.org
In-Reply-To: <7d850f417b20bfa559e6ef3eb133d336fb2eda3f.camel@intel.com>
References: <7d850f417b20bfa559e6ef3eb133d336fb2eda3f.camel@intel.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <7d850f417b20bfa559e6ef3eb133d336fb2eda3f.camel@intel.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fix-v5.9-rc3
X-PR-Tracked-Commit-Id: c2affe920b0e0669650943ac086215cf6519be34
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d7d1f235aaffbac15a07455a774aca42d027638c
Message-Id: <159838298051.30843.9809048489467038231.pr-tracker-bot@kernel.org>
Date: Tue, 25 Aug 2020 19:16:20 +0000
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Message-ID-Hash: 5AB73O6LTWEVDR4ZKIEHILDQMFPHPZU6
X-Message-ID-Hash: 5AB73O6LTWEVDR4ZKIEHILDQMFPHPZU6
X-MailFrom: pr-tracker-bot@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qiang.zhang@windriver.com" <qiang.zhang@windriver.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ahuang12@lenovo.com" <ahuang12@lenovo.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5AB73O6LTWEVDR4ZKIEHILDQMFPHPZU6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Tue, 25 Aug 2020 00:57:12 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fix-v5.9-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d7d1f235aaffbac15a07455a774aca42d027638c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
