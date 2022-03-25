Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF4C468E
	for <nvdimm@lists.linux.dev>; Fri, 25 Mar 2022 01:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EA61C340EC;
	Fri, 25 Mar 2022 01:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1648172145;
	bh=qnYmc4wng3z+TmJTuaCD8cdv/mTfl1AiPWkurwWbx9M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=j9nktIyOzwQW+BpmtjNQwETRSgrTERAMndYY76QB9LcRO6/2X53OoHdwOd3yQVF5A
	 aKc86OZr2vs2nPiy4oHm1jcZ1Su0GaHI/f/mTTWQikkHIbElWujvLAr0oYrtaO0arn
	 5tnBw/E8KrcDX9szu629bxXpu9tNiKEhi1wGMNUymJX+oULw4s1aNzZu4Hp8ng0jyk
	 1H6p+dArgqM5rEcS6h3lQuF/yrQEG3lpIw8VKI+b6nOfps95+OhQg+gsrTp1ejwoJp
	 MZyefvtQttWzIkfXUA4Z9HWp7+v0Ali2o2CXvFNsKVJzjlg0LiRwqfke/QVujodmpf
	 KZQSVymbU25Pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D145E7BB0B;
	Fri, 25 Mar 2022 01:35:45 +0000 (UTC)
Subject: Re: [GIT PULL] DAX update for 5.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4iOwM+qaKdw-BPkDe9Fpc19YVezVVurZ0n0o7OsRsEuJw@mail.gmail.com>
References: <CAPcyv4iOwM+qaKdw-BPkDe9Fpc19YVezVVurZ0n0o7OsRsEuJw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4iOwM+qaKdw-BPkDe9Fpc19YVezVVurZ0n0o7OsRsEuJw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-for-5.18
X-PR-Tracked-Commit-Id: db8cd5efeebc4904df1653926102413d088a5c7e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f0614eefbf829a2914ac9a82cb8bbeaf1af28f9d
Message-Id: <164817214537.9489.14898749761150938874.pr-tracker-bot@kernel.org>
Date: Fri, 25 Mar 2022 01:35:45 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 22 Mar 2022 18:39:49 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-for-5.18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f0614eefbf829a2914ac9a82cb8bbeaf1af28f9d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
