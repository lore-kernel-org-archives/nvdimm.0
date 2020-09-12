Return-Path: <SRS0=qCrT=CV=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA888C43461
	for <linux-nvdimm@archiver.kernel.org>; Sat, 12 Sep 2020 20:00:17 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B7E621531
	for <linux-nvdimm@archiver.kernel.org>; Sat, 12 Sep 2020 20:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bi81i9xp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B7E621531
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E4C9013E86C6D;
	Sat, 12 Sep 2020 13:00:16 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DACCC13E6BF87
	for <linux-nvdimm@lists.01.org>; Sat, 12 Sep 2020 13:00:13 -0700 (PDT)
Subject: Re: [GIT PULL] libnvdimm fix for v5.9-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940813;
	bh=1ua1ZLcXCb6tiC1TrMgSMt7ael1GjTGFk4a21WBy/XE=;
	h=From:In-Reply-To:References:Date:To:Cc:From;
	b=bi81i9xpRDQCGKP8qfnwZNY1pQDXBfUU1b/p7NLurRFWhZddrmc3v/BUI+Y7KsaTL
	 byyrQV6qBQWCCm8Q7+tCMclywCZ66/ZlMjoXwxTqWc/JjfSMWrn0ZPRPTyhmn2yIne
	 DjkFSGgHFn0e9S9MmcwSpS3qSvC5QwRj2iiTb8VM=
From: pr-tracker-bot@kernel.org
In-Reply-To: <a0ded0398e87c8c7bcfc2d9f5c9e3af11dda8db0.camel@intel.com>
References: <a0ded0398e87c8c7bcfc2d9f5c9e3af11dda8db0.camel@intel.com>
X-PR-Tracked-List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
X-PR-Tracked-Message-Id: <a0ded0398e87c8c7bcfc2d9f5c9e3af11dda8db0.camel@intel.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fix-v5.9-rc5
X-PR-Tracked-Commit-Id: 6180bb446ab624b9ab8bf201ed251ca87f07b413
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4f8b0a5b3f7e5f03b188de9025b60c15559790f9
Message-Id: <159994081331.29146.2263821994238588407.pr-tracker-bot@kernel.org>
Date: Sat, 12 Sep 2020 20:00:13 +0000
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Message-ID-Hash: 5RCTXZYRPGMOSESZIDA3JZ3SXTCL3EB2
X-Message-ID-Hash: 5RCTXZYRPGMOSESZIDA3JZ3SXTCL3EB2
X-MailFrom: pr-tracker-bot@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5RCTXZYRPGMOSESZIDA3JZ3SXTCL3EB2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Fri, 11 Sep 2020 22:19:57 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fix-v5.9-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4f8b0a5b3f7e5f03b188de9025b60c15559790f9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
