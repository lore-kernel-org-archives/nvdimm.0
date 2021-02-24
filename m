Return-Path: <SRS0=xJ+U=H2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6305C433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 24 Feb 2021 18:46:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 729E764F10
	for <linux-nvdimm@archiver.kernel.org>; Wed, 24 Feb 2021 18:46:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 729E764F10
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 362C5100EC1D9;
	Wed, 24 Feb 2021 10:46:37 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=pr-tracker-bot@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E3A07100EC1D4
	for <linux-nvdimm@lists.01.org>; Wed, 24 Feb 2021 10:46:34 -0800 (PST)
Received: by mail.kernel.org (Postfix) with ESMTPS id 8701064F0F;
	Wed, 24 Feb 2021 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1614192394;
	bh=tFeyr5rkGKHjhfGoWYcCEuWrrPaOmpfGpUdPujLiX0g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cIY94Hjv1SBv0MPrfpJOqdnnoFKrAWVYQ/T448oJtRgdjffCOBTuZsad2y/+SBSXL
	 cr4AUZlrJ0AxmRnYQbYtT/QlcUAH55C8hM2zB28tQq7uxpCyKoXMEVqccqSA/guyx2
	 TFuOm4UJrjBiPYn0BpN9+HbElTI+0syE0bX3Ye0gur0VQPRIbbc3JIk1OZiejy832S
	 Ca25xWygjK+mAaVS2uHGQDfAtLv533fx9NXTu5U3b9ZAerUo2Z09HNqf7I9xaOMnND
	 z6obTvSSB2Xmkhar1HMK0GhJPqnKEgCY+m6XtNwWEDV7/FSYzaI8uGsz63iKiH5sZB
	 QMvPgzkpB6gfQ==
Subject: Re: [GIT PULL] libnvdimm + device-dax for v5.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4i1-mwp8B0Y_hR44rGh9qUPuDiZeiUFJ_TJzvPoENa-pQ@mail.gmail.com>
References: <CAPcyv4i1-mwp8B0Y_hR44rGh9qUPuDiZeiUFJ_TJzvPoENa-pQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4i1-mwp8B0Y_hR44rGh9qUPuDiZeiUFJ_TJzvPoENa-pQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.12
X-PR-Tracked-Commit-Id: 64ffe84320745ea836555ad207ebfb0e896b6167
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fb9f08548873b4ffa9f1b3f96c37fd85b9a2f8db
Message-Id: <161419239453.20610.6936263777642654365.pr-tracker-bot@kernel.org>
Date: Wed, 24 Feb 2021 18:46:34 +0000
To: Dan Williams <dan.j.williams@intel.com>
Message-ID-Hash: HFFS7TGAIS4I5RGO3CBMPAR7MPZIA5NA
X-Message-ID-Hash: HFFS7TGAIS4I5RGO3CBMPAR7MPZIA5NA
X-MailFrom: pr-tracker-bot@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HFFS7TGAIS4I5RGO3CBMPAR7MPZIA5NA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The pull request you sent on Tue, 23 Feb 2021 18:47:38 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fb9f08548873b4ffa9f1b3f96c37fd85b9a2f8db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
