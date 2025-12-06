Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DC82D77FA;
	Sat,  6 Dec 2025 19:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765048040; cv=none; b=nZQagKeDjBzMiAa6KHavQEk8cstjUXQu//qDkg+WbUxaaRa5WtGI/Oy0bCyKJI3w9ppOuMc4KTSXI7VapXYMK994xCxzjRKjyCarZPCfhWZvVLO50Uuzf8l1QKA8K5qiFGTiz+FGIe4nZy5ckVBKYFeop9336ah7nsOknIuyoAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765048040; c=relaxed/simple;
	bh=wxyOBs2eqiacqR2Q5S6BiA1qzfuvzbxMGT0oi0e6R0g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=b8eErJ0E+5VccacAFvE3MVRSyk9igGEOXmEsGsXnQi4hM1hbK4DC2m38zM2EA3N6GiJVAXOBu4ynzQEZMAFtxsuBHieJ4QhgR6qw58KMQGkIaKSufc4fP1UKD9DJ56K2GoEo9K8OLe2R2g39WtfxZG7rGuSihmUOQLzxCojzI3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gA7tmvtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gA7tmvtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B44C4CEF5;
	Sat,  6 Dec 2025 19:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765048039;
	bh=wxyOBs2eqiacqR2Q5S6BiA1qzfuvzbxMGT0oi0e6R0g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gA7tmvtx0Bqp/Bpjb2wQ58JKZakxhDYwxM4FRzsiFaAwYQ6Vx80ycQry2Tfy5XI8o
	 JtBM2qgzKOoA73zvTNVOi0OhP6iPcUYUZNlQFP6Sh0sPQ4i5/HFD3OH1yxB2nRs2In
	 KdrsWQpJAn+WukMpYmDWNeKsYCCJHDURVK6w3PYGzJ3iZE/QEk7WTD8VYB99NffUFy
	 BmcSJBJ9uDNRbyozp7Jc+ur1aAh8gRpvtJnSvE54HTfhRIT34UxqT/q8LpEyrOCloT
	 IITnuN7mTdEPSU2w/J/VShy7ijrDdojH0FoA6s1Gfy0ogEqPljR2hUeXk+GvfrWPa9
	 KO8Sf/ZCOiRTw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F29DF3808200;
	Sat,  6 Dec 2025 19:04:17 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <69331dd6ebdba_50fc7100e3@iweiny-mobl.notmuch>
References: <69331dd6ebdba_50fc7100e3@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <69331dd6ebdba_50fc7100e3@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.19
X-PR-Tracked-Commit-Id: 30065e73d7c018cf2e1bec68e2d6ffafc17b3c25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 56a1a04dc9bf252641c622aad525894dadc61a07
Message-Id: <176504785664.2170003.16121789784406165863.pr-tracker-bot@kernel.org>
Date: Sat, 06 Dec 2025 19:04:16 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Alison Schofield <alison.schofield@intel.com>, Tejun Heo <tj@kernel.org>, Marco Crivellari <marco.crivellari@suse.com>, Dave Jiang <dave.jiang@intel.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 5 Dec 2025 12:00:54 -0600:

> git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/56a1a04dc9bf252641c622aad525894dadc61a07

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
