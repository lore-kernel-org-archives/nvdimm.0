Return-Path: <SRS0=31fz=XC=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A06C43140
	for <linux-nvdimm@archiver.kernel.org>; Sat,  7 Sep 2019 00:00:08 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 130E52178F
	for <linux-nvdimm@archiver.kernel.org>; Sat,  7 Sep 2019 00:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="M08mv9Ay"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 130E52178F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 434E020294F2D;
	Fri,  6 Sep 2019 17:00:54 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=pr-tracker-bot@kernel.org; receiver=linux-nvdimm@lists.01.org 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 281A920294F26
 for <linux-nvdimm@lists.01.org>; Fri,  6 Sep 2019 17:00:53 -0700 (PDT)
Subject: Re: [GIT PULL] libnvdimm fix for v5.3-rc8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1567814406;
 bh=bO5D7b+G4BacDXfHXQp7mqjyzEa961ZYDoRZ01kCtNE=;
 h=From:In-Reply-To:References:Date:To:Cc:From;
 b=M08mv9AypFTjYdUaHMxmT+I0/cDZXVcrLFl+Byxf60wP6Zjf5+Ul982M4PBT28OfW
 IAMlOMdA08n0fCyYbIpxvaKplSBkcWPnMYlpgO8ohYBzenUhLiyb/RV7Di2npzo3M0
 H/W8ZkQjyB6Xzdu8Df6F048ljACf9ooTrWoAsGY0=
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4jDWgZDJTAgghrFX1MQXPJX_6jiqsmx9sQUOL7ZaWtk+w@mail.gmail.com>
References: <CAPcyv4jDWgZDJTAgghrFX1MQXPJX_6jiqsmx9sQUOL7ZaWtk+w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4jDWgZDJTAgghrFX1MQXPJX_6jiqsmx9sQUOL7ZaWtk+w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
 tags/libnvdimm-fix-5.3-rc8
X-PR-Tracked-Commit-Id: 274b924088e93593c76fb122d24bc0ef18d0ddf4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7641033e17efe472c0e2fd6da00f1b75dc6788f3
Message-Id: <156781440637.2933.2647196814273727641.pr-tracker-bot@kernel.org>
Date: Sat, 07 Sep 2019 00:00:06 +0000
To: Dan Williams <dan.j.williams@intel.com>
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-nvdimm <linux-nvdimm@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
Message-ID: <20190907000006.0RvsX38Q8sTM0EL3CaPSct0esSGZ2E4wF6ndaP9f51o@z>

The pull request you sent on Fri, 6 Sep 2019 13:00:00 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fix-5.3-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7641033e17efe472c0e2fd6da00f1b75dc6788f3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
