Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542C513774B
	for <nvdimm@lists.linux.dev>; Mon, 23 Sep 2024 22:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727130901; cv=none; b=MzCkUJec0wSlYV7Eof2JdIVKjHLHKL5Tu4MvrnNh//jUQ7VoNPOR5H9Ox5EOGzMgb5d6pcvKWNcQ8wAkSX5xLpYubNZVLZ37PNe/rTEk4o+5obIkUTVRCmLQ570VVyeO1LRSLoViE+JCTXXHeIjCNg4t99tC85cS+PyZOtXRPuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727130901; c=relaxed/simple;
	bh=4dNMdYywQLKEHHKQg4CPY0wuHl+k2uQ88nP4ZcBnoSo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TxUDhhKVBUdPU6RJavoLKTcFexhBB0S6cr3qKyDkSQuH8afKdWlr7QYpZPaoXFYCk3vwBlKxa1k09VMoVU9SalUNGh7IO8DSya5IhP8Z7qJKNf5SNwolImMXfC4ptPOiR/CH9s3+jcBK5s3ctjfmCXhUtXg54kDUZblnNppdQaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tocCr+Vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tocCr+Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D72C4CEC4;
	Mon, 23 Sep 2024 22:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727130900;
	bh=4dNMdYywQLKEHHKQg4CPY0wuHl+k2uQ88nP4ZcBnoSo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tocCr+Vw6N901hx093ZqHwo/tHnrvIYtTqKzUXxOwRivgFM6gwMkqmJ3gJCTpDvIQ
	 hit8OfP9htVGrLpUrFyJkrOOA+OlLQxy3cagx6rSwyTFl4QMbudQTPOg3YOKDnFgKy
	 ksvFQhlsVpid+0z5sIivWp82hjgCla+yvKCvrgWPooBNa37wnc3hGZpsUC97X1d4V+
	 0wNHuHFyd4NGQxRHX3pgzsDLWBnUYLr5BU67uP+E82COdGB9dWQtRr4+5oORSH5EFY
	 +XfkWTpijDGr/N1wCwF4BsJrCZ9koEopMzvhmID2CCw37tn/jtpojQ1GfKdwGZ1aLj
	 Re8/Q0qayptHg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E473809A8F;
	Mon, 23 Sep 2024 22:35:04 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <66f0a13e3c35f_26135129411@iweiny-mobl.notmuch>
References: <66f0a13e3c35f_26135129411@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <66f0a13e3c35f_26135129411@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.12
X-PR-Tracked-Commit-Id: 447b167bb60d0bb95967c4d93dac9af1cca437db
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 00b43f85f287f4b661f1a2485bed1a476d308427
Message-Id: <172713090309.3509221.13979038144081883760.pr-tracker-bot@kernel.org>
Date: Mon, 23 Sep 2024 22:35:03 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, nvdimm@lists.linux.dev, "Rob Herring (Arm)" <robh@kernel.org>, Li
 Zhijian <lizhijian@fujitsu.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Sun, 22 Sep 2024 17:59:10 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/00b43f85f287f4b661f1a2485bed1a476d308427

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
