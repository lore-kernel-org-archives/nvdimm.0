Return-Path: <SRS0=31k+=ZY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B65C432C3
	for <linux-nvdimm@archiver.kernel.org>; Mon,  2 Dec 2019 02:50:20 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF20C22315
	for <linux-nvdimm@archiver.kernel.org>; Mon,  2 Dec 2019 02:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8j3ICw2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF20C22315
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 086ED10113326;
	Sun,  1 Dec 2019 18:53:43 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3BEAB1011330F
	for <linux-nvdimm@lists.01.org>; Sun,  1 Dec 2019 18:53:41 -0800 (PST)
Subject: Re: [GIT PULL] libnvdimm for v5.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575255018;
	bh=RO+fehXn7xEYNLzjW5d/2mdfvqStG6MwQCJzoZuVGaw=;
	h=From:In-Reply-To:References:Date:To:Cc:From;
	b=A8j3ICw2f8erBGN80bUB7I3sP0+B1g/ulo4rnRy1ZSraBXH1ZZ7xh+FqCcLv8ToZv
	 Sx+l0EOx9ZCUTgVx9RGvhnp5+iX2nPzU++Sc9PCmCAP6Fd62Tg4fpJIrrq9u/CaLcW
	 ywq/NIwU3SvKSBhFIHMMS6fgoCSRHsx/jZR9A2bo=
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4jftz7mN=4zNPo1tGZfcXxfKunTUF4Owof6pJ108GYk=g@mail.gmail.com>
References: <CAPcyv4jftz7mN=4zNPo1tGZfcXxfKunTUF4Owof6pJ108GYk=g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4jftz7mN=4zNPo1tGZfcXxfKunTUF4Owof6pJ108GYk=g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
 tags/libnvdimm-for-5.5
X-PR-Tracked-Commit-Id: 0dfbb932bb67dc76646e579ec5cd21a12125a458
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d10032dd539c93dbff016f5667e5627c6c2a4467
Message-Id: <157525501843.1709.13111514700340254733.pr-tracker-bot@kernel.org>
Date: Mon, 02 Dec 2019 02:50:18 +0000
To: Dan Williams <dan.j.williams@intel.com>
Message-ID-Hash: LD6SNVXJIDI5SPRAOVEVLBZIZLI2DRM5
X-Message-ID-Hash: LD6SNVXJIDI5SPRAOVEVLBZIZLI2DRM5
X-MailFrom: pr-tracker-bot@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LD6SNVXJIDI5SPRAOVEVLBZIZLI2DRM5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Fri, 29 Nov 2019 10:56:22 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d10032dd539c93dbff016f5667e5627c6c2a4467

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
