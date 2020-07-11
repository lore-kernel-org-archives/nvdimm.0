Return-Path: <SRS0=TTaI=AW=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4EFC433E0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 11 Jul 2020 04:25:07 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E25C420725
	for <linux-nvdimm@archiver.kernel.org>; Sat, 11 Jul 2020 04:25:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhwfpIqL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E25C420725
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B9000111A4250;
	Fri, 10 Jul 2020 21:25:06 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3BD29111A424E
	for <linux-nvdimm@lists.01.org>; Fri, 10 Jul 2020 21:25:04 -0700 (PDT)
Subject: Re: [GIT PULL] libnvdimm fix for v5.8-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594441503;
	bh=NGQZ1kTuBiTUB4JUrvKttB3qSookfrNHgOO2Sc16454=;
	h=From:In-Reply-To:References:Date:To:Cc:From;
	b=PhwfpIqL7IwfvjEibmQjviwXMivdIXD8o5aQQbXLBogJIZ7leaXZWHivJI2vBb5KC
	 ULRFLKvgc0ciaMwotreHgzkW6D4zrEC+JT5fD/uCemiNPo8VKnhsoJmxJuoqZe5mkk
	 vhe3kcoAs8JdlDkW/3fLsAwQ6G47dsGtsukv8MbE=
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4jSHxx-dscb7PAadNVBWhVWgT_iczah_6TQ=JSprw9ZNg@mail.gmail.com>
References: <CAPcyv4jSHxx-dscb7PAadNVBWhVWgT_iczah_6TQ=JSprw9ZNg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4jSHxx-dscb7PAadNVBWhVWgT_iczah_6TQ=JSprw9ZNg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
 tags/libnvdimm-fix-v5.8-rc5
X-PR-Tracked-Commit-Id: 813357fead4adee73f7eca6bbe0e69dfcf514dc6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1df0d8960499e58963fd6c8ac75e544f2b417b29
Message-Id: <159444150388.19180.2542503483544403679.pr-tracker-bot@kernel.org>
Date: Sat, 11 Jul 2020 04:25:03 +0000
To: Dan Williams <dan.j.williams@intel.com>
Message-ID-Hash: 2HHJRBY4G6PYNNS6HKZJDA4YWN3ASTC7
X-Message-ID-Hash: 2HHJRBY4G6PYNNS6HKZJDA4YWN3ASTC7
X-MailFrom: pr-tracker-bot@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2HHJRBY4G6PYNNS6HKZJDA4YWN3ASTC7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Fri, 10 Jul 2020 18:26:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fix-v5.8-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1df0d8960499e58963fd6c8ac75e544f2b417b29

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
