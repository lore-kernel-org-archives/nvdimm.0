Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7ED443D;
	Thu, 16 May 2024 00:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715821000; cv=none; b=guzuzLIqlMW2oFQU75Hg2e5wmWEaBWs9vPqGolQsH9eoKLvYJpgiVlYc6KG0KwWBJFz9mAAYcvuA5eUff6c0wszn+waMM+A1ITFvA2UIi7uxG05iAzoBydsgULrsvAQn9crQ5yG243MJiG6kEFqba95hbdiKdedAxtoxkQsctiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715821000; c=relaxed/simple;
	bh=6ls7SdnkgkxvebDaVplQmMCTP0ogxef8vK2o0ajOUss=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=o9gO7WUssB/2TdE2meAjG1i34XIpjstxWdFXe1Ess69LGivhREYMWD1xKPQxrtkGMSMvyTWnp5A4gjp9a5cdUZnhDQzpEZEvvx9Up09iq9flBO4yY7LpG/xV+YLfqti3qXIChmbXeSUtY22kRzJ/W79K+seWmmtHRv30O/VXv+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFoAmIJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFoAmIJS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71D2AC4AF09;
	Thu, 16 May 2024 00:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715821000;
	bh=6ls7SdnkgkxvebDaVplQmMCTP0ogxef8vK2o0ajOUss=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MFoAmIJSZ9zObBgRSo6kISX1Ofiy37A0ncx6L04gfUca9EFjPdTbIeZaTFW7MKcBQ
	 +MotOrfxyPsLMFbTT18GZ/FL1VuEDBtzcnQpO+3+2SPXw4aDfhDpSBmjpNnvb3j9Rx
	 E6Lod0oa/mpkanufX09kvsHkc4m1NnEf9Up9xBL/GlKm0uVGK0OZQ/ncXQFb6v46P+
	 MDgKe/ADuLzJDxOWYHG9clX6cp5SNA0s8Kedg+sHQ/jEOSgR+g2D4soKNYxay9bHaJ
	 AMx4BtEPd0R3z4x7OgutdSyb5aVV5soAhtsia0i2omKcdzOzJus+TD4U0ChSFLb4nW
	 L8NTmMS3rxFMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69A95C43336;
	Thu, 16 May 2024 00:56:40 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <6644e5ca3a1a7_7467294a@iweiny-mobl.notmuch>
References: <6644e5ca3a1a7_7467294a@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <6644e5ca3a1a7_7467294a@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.10
X-PR-Tracked-Commit-Id: 41147b006be2174b825a54b0620ecf4cc7ec5c84
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c405aa3ea36c1f973a9f10bbcfabc9aeeb38040c
Message-Id: <171582100042.27993.13167929080400575403.pr-tracker-bot@kernel.org>
Date: Thu, 16 May 2024 00:56:40 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 15 May 2024 09:41:46 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c405aa3ea36c1f973a9f10bbcfabc9aeeb38040c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
