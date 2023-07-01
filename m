Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1C3C2F0
	for <nvdimm@lists.linux.dev>; Sat,  1 Jul 2023 16:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24C5EC433CA;
	Sat,  1 Jul 2023 16:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1688227923;
	bh=M0PDgaOnQIx4mh1sMnVuyY+C9pRZqgcDrieVFxpmVBY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Xn/vEAFJ+rtyiTqtDmBThXSGWgM/H8jKTi/pRLUTvy+fp4PdzLHiwf+Bggx6/H3VP
	 wuwqkUjZNPtQZzgjQwzIvhMkiHY/D52Kor0fYPFZvpCda86L6zqGF/SpA5/R3Abge1
	 Wk7lqfm+0xqo0gBGy4mC2ubSn4zzXrkysvWWeV2sysMbBz0Q7+tFK3nGZGs7K/9vX+
	 jlLTqpVKlbE+oZObdzJlPyu5AIPjT3RPapy3VgTEbpW/l+g4iGhGmqQ1igr8Z9yo9u
	 s3mmEPUdlgXT7Jh+cXgpguBLcWujilhVKSzaZXHQUiEiTxqOt6t1L+tpTE1P2+fdy2
	 YevB/UuBJoZDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09A27C6445B;
	Sat,  1 Jul 2023 16:12:03 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 6.5
From: pr-tracker-bot@kernel.org
In-Reply-To: <b40d43f78d320324c7a65ec0f3162524a4781c4c.camel@intel.com>
References: <b40d43f78d320324c7a65ec0f3162524a4781c4c.camel@intel.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <b40d43f78d320324c7a65ec0f3162524a4781c4c.camel@intel.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.5
X-PR-Tracked-Commit-Id: 1ea7ca1b090145519aad998679222f0a14ab8fce
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a1c979c6b7dfe5b6c105d0f0f9f068b5eb07e25
Message-Id: <168822792302.621.8262643616504738837.pr-tracker-bot@kernel.org>
Date: Sat, 01 Jul 2023 16:12:03 +0000
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Torvalds, Linus" <torvalds@linux-foundation.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 30 Jun 2023 19:17:47 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a1c979c6b7dfe5b6c105d0f0f9f068b5eb07e25

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
