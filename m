Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A06629A2
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 18:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B5ABC340F3;
	Wed, 30 Mar 2022 18:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1648664413;
	bh=x0UHvUuC38g+S2tNI2ndVR4Ci9dODceoAMqXgTAxMik=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kRFL4adU99autJJ9gjOQA7AUFVARfmCZwHyOnQtvy9nxr7+Ma29cRtDeYfsljLg1e
	 /UxNtlQLGuhI9a0QVF6yhTJ7w0ex/D0oWztIsGfzdaWflcEJOpAFlE8g3UPXalXElr
	 3HodPs4f+BgvdIRw8Oe77FyDIxCWPN+FLjYqkaGf3aHzw1hqoI9xhPk9ytsrrvBXT+
	 65vVvqjv318b9X2KizxpaRkhHwAHmpOelyu5Y+xJYUdGOFNTrCTOGdY4OyqNEaX7K0
	 g6IVfZTc16gRlZuNz31Kc7LRoqKs9/CNrX/QwOaeHUOw7ggPxagZnLnN9MuLxBNcNo
	 LaF1qlyYPe+ZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 361BFE6BBCA;
	Wed, 30 Mar 2022 18:20:13 +0000 (UTC)
Subject: Re: [GIT PULL] LIBNVDIMM update for v5.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4hydiSDFXVVBtYyuUgutTca6eL67s7txkSgzGzW1VGT0A@mail.gmail.com>
References: <CAPcyv4hydiSDFXVVBtYyuUgutTca6eL67s7txkSgzGzW1VGT0A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4hydiSDFXVVBtYyuUgutTca6eL67s7txkSgzGzW1VGT0A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.18
X-PR-Tracked-Commit-Id: ada8d8d337ee970860c9844126e634df8076aa11
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ee96dd9614f1c139e719dd2f296acbed7f1ab4b8
Message-Id: <164866441321.5472.9111993236292688161.pr-tracker-bot@kernel.org>
Date: Wed, 30 Mar 2022 18:20:13 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 29 Mar 2022 13:54:41 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ee96dd9614f1c139e719dd2f296acbed7f1ab4b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
