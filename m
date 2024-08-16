Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE6B1C37AE;
	Fri, 16 Aug 2024 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723834397; cv=none; b=EkZK63Pd55DEKuF23wVkCMRhjxHMD8g11mRYCG/xBefd/eeRvl6iOzqyjaIgIjSxrJhDSst0ixqriDt2V+Vg+9z48RRmmWYigTup9ld85em80DTnkSp4v8n83PrAMpFzO+xNAUfZOIhHHJauy1MQbGvY1hIkeIGQU/SBmDXcxsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723834397; c=relaxed/simple;
	bh=z0ONeofNU8rqXJvlEzskZZ7ldw7sJ6PtHeETuOJhIf8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Y2hvguH+nnrr3pxY0Edf3ZRSIwmzTw/V1pbNX47SBu4NGFKPVinlLZRU/TYDmJbGr01MdWe6gI//8+Xzu4mgzxDzF9NygC0QGKImJMpxCfCbRK2XXmJ7k3vL+YSs3tOTJn9Rqgh7VEUBiWYYNU4Zk8IC37TeKqxWzKf4VSzgZbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+M9sepS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+M9sepS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B396C32782;
	Fri, 16 Aug 2024 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723834397;
	bh=z0ONeofNU8rqXJvlEzskZZ7ldw7sJ6PtHeETuOJhIf8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=m+M9sepSVsXbhsap7sT33pJ8qgt1VQoEkIK3LHgDzS6d1iwGQCs8iumOgru208MXQ
	 Tl46gaYVGjrmAYpU/7LPM09YP6pZKS9n6AcflA3Aej9oBlVGBbp32eKiLM7p087j67
	 h8XzTjO12SKEsSm3Bv8DHpVdPC2xRWJrVrkMcE5j9XPNqJZz3PLL+eQboqoR9SVDXB
	 fzFt6dS64PpU+O4czv3jdmv+3b8e2WPpy7MZxPi+YmIbmjjpx4seuQBRVJNuDELlm0
	 mV68dmARfRadvOIxlw0urrSTUfhThpYLBqFPlBRfZuibCz0HkWv3eYpCm1/YzDZ4X+
	 uIql768pDXg6A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB6C438232A9;
	Fri, 16 Aug 2024 18:53:17 +0000 (UTC)
Subject: Re: [GIT PULL] DAX for 6.11
From: pr-tracker-bot@kernel.org
In-Reply-To: <66bf57c7b023f_22218329410@iweiny-mobl.notmuch>
References: <66bf57c7b023f_22218329410@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <66bf57c7b023f_22218329410@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.11-rc4
X-PR-Tracked-Commit-Id: d5240fa65db071909e9d1d5adcc5fd1abc8e96fe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e4a55b555db6d2a006551605ef4404529e878cd2
Message-Id: <172383439657.3603929.10117357333455532068.pr-tracker-bot@kernel.org>
Date: Fri, 16 Aug 2024 18:53:16 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zhihao Cheng <chengzhihao1@huawei.com>, Christoph Hellwig <hch@lst.de>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 16 Aug 2024 08:44:39 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.11-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e4a55b555db6d2a006551605ef4404529e878cd2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
