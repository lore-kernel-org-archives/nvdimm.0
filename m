Return-Path: <SRS0=gclU=XY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E8FC4360C
	for <linux-nvdimm@archiver.kernel.org>; Sun, 29 Sep 2019 17:50:27 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA36E2082F
	for <linux-nvdimm@archiver.kernel.org>; Sun, 29 Sep 2019 17:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2FmXA27"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA36E2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 079A71011360C;
	Sun, 29 Sep 2019 10:52:09 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C02AC10113609
	for <linux-nvdimm@lists.01.org>; Sun, 29 Sep 2019 10:52:06 -0700 (PDT)
Subject: Re: [GIT PULL] libnvdimm fixes for v5.4-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569779423;
	bh=sLpBK98JGjYLJeeMKeMxZXtgz3IbLinnFUJWoo1RwjE=;
	h=From:In-Reply-To:References:Date:To:Cc:From;
	b=S2FmXA27bktlnMH3emqurNob0egawmtiVT06arsVQPs65bcvb6jDvRzV6tR2k1x4d
	 TZxuckVZTADTqO73grBvrAdyjVEreHwvqdvQsViA5PEgxFS3eCY1zYAQ4Dcws6cIry
	 jeAD7YNIQvWgz4CDWZnneUAoM3x5w7tvn5pfPVwY=
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4jJjjkXXSYpYNC3y2r2YJrcSYw=tZ9p=KyA8BS46kfFuA@mail.gmail.com>
References: <CAPcyv4jJjjkXXSYpYNC3y2r2YJrcSYw=tZ9p=KyA8BS46kfFuA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4jJjjkXXSYpYNC3y2r2YJrcSYw=tZ9p=KyA8BS46kfFuA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
 tags/libnvdimm-fixes-5.4-rc1
X-PR-Tracked-Commit-Id: 4c806b897d6075bfa5067e524fb058c57ab64e7b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3c0e7b1fe1fc62bba5f591c4bc404eea96823b8
Message-Id: <156977942385.28081.14590936149544081114.pr-tracker-bot@kernel.org>
Date: Sun, 29 Sep 2019 17:50:23 +0000
To: Dan Williams <dan.j.williams@intel.com>
Message-ID-Hash: VSW2CTL743W3TJDVZG3JGTFULF2T3EVT
X-Message-ID-Hash: VSW2CTL743W3TJDVZG3JGTFULF2T3EVT
X-MailFrom: pr-tracker-bot@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Linus Torvalds <torvalds@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <>
List-Archive: <>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Sat, 28 Sep 2019 18:44:17 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3c0e7b1fe1fc62bba5f591c4bc404eea96823b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
