Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137182C87
	for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 00:01:42 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id A2E9D610C7;
	Fri, 29 Oct 2021 00:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1635465702;
	bh=pQevrMguR9JpzX6BbBrXe5q6fAJubYCRmrGr0/MR/T4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=j7N8mihmeyGnj/wc2lJLHpZRdj1flgTT0heKngi0rmpuYmxAqpi8gGfyWv5ir9gPN
	 FnHchOwK/GhMhN0zEmCi0YQOXuEstu1EA8SoJ+VvVptxOeRyzg/cCOQxWaQEmxxfdG
	 8+zrnm8VhT74UjtBEPRYwphxXkzL6uEZN+I+xUstqRJNfZ0D1certfKLTTPhKMQjCa
	 9kOwi/33dfVrA+FlpSMV1O9TTgVDuPM6KCVXPMpfef5GiHqXQQuc/yAv2tctYo1ukD
	 xAbe/mIlrFOgZVw2tYSn66polu1rB4UJNsc6SeTz9D/0hgDxV2D1e1mbq2Vp0i5mUU
	 ic5CKBJDLu6lQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9099760A38;
	Fri, 29 Oct 2021 00:01:42 +0000 (UTC)
Subject: Re: [GIT PULL] nvdimm fixes v5.15-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4igx1BJpp+Z3jvjTxahPYp8TBLSZY=jU7vsBWF34XHDOA@mail.gmail.com>
References: <CAPcyv4igx1BJpp+Z3jvjTxahPYp8TBLSZY=jU7vsBWF34XHDOA@mail.gmail.com>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <CAPcyv4igx1BJpp+Z3jvjTxahPYp8TBLSZY=jU7vsBWF34XHDOA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.15-rc8
X-PR-Tracked-Commit-Id: 3dd60fb9d95db9c78fec86ba4df20852a7b974ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f25a5481af12c2360710583b84537eb9e652d57d
Message-Id: <163546570253.2403.4662600911602992959.pr-tracker-bot@kernel.org>
Date: Fri, 29 Oct 2021 00:01:42 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 28 Oct 2021 15:32:00 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.15-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f25a5481af12c2360710583b84537eb9e652d57d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
