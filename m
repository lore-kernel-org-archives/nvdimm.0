Return-Path: <SRS0=UQD7=72=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6095C433DF
	for <linux-nvdimm@archiver.kernel.org>; Sat, 13 Jun 2020 20:25:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 97E1520882
	for <linux-nvdimm@archiver.kernel.org>; Sat, 13 Jun 2020 20:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p92yHx/B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97E1520882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4D00E1011760A;
	Sat, 13 Jun 2020 13:25:30 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EF35C10106A08
	for <linux-nvdimm@lists.01.org>; Sat, 13 Jun 2020 13:25:28 -0700 (PDT)
Subject: Re: [GIT PULL] libnvdimm for v5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592079929;
	bh=p67YCzZtZlltepJbmahkXUTSZ7AlDa28pMxCnf9z3do=;
	h=From:In-Reply-To:References:Date:To:Cc:From;
	b=p92yHx/BsU2vAOOKP35MWGmS9VbjIyEw7MWJyqBYupjHXA5KCnnmwzmji3hWP6+Ql
	 6T3YMg5hhw0SHLzjeyfvMHcN3MJRu1fXdEYAcjYXVjCfHmtOFA2x2dOc4+x6r+ZmZN
	 zx1/duk3dCEt+rKDaxnKNuPsOU1zsB80kCxGmo0U=
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4jDQ9VVZJTD=cz+VvPxo6FNQGbW=BYA1Qhix-yQkSWeCQ@mail.gmail.com>
References: <CAPcyv4jDQ9VVZJTD=cz+VvPxo6FNQGbW=BYA1Qhix-yQkSWeCQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4jDQ9VVZJTD=cz+VvPxo6FNQGbW=BYA1Qhix-yQkSWeCQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
 tags/libnvdimm-for-5.8
X-PR-Tracked-Commit-Id: 6ec26b8b2d70b41d7c2affd8660d94ce78b3823c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d74b15dbbbd2741f3580d7c884cd285144ae0cab
Message-Id: <159207992896.31508.586656922760504069.pr-tracker-bot@kernel.org>
Date: Sat, 13 Jun 2020 20:25:28 +0000
To: Dan Williams <dan.j.williams@intel.com>
Message-ID-Hash: SPX7SHGUTWPM7CELK5ZZOB7PYCS5FYGO
X-Message-ID-Hash: SPX7SHGUTWPM7CELK5ZZOB7PYCS5FYGO
X-MailFrom: pr-tracker-bot@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Vaibhav Jain <vaibhav@linux.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SPX7SHGUTWPM7CELK5ZZOB7PYCS5FYGO/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Fri, 12 Jun 2020 15:46:50 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d74b15dbbbd2741f3580d7c884cd285144ae0cab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
