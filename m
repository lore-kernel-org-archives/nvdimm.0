Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8CE2F5312
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 22:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750198166; cv=none; b=fz8pTwtWvCTQwVFEAWfH8Efu9KliasrTVoEbg2VKlh3bZiF0drW9WayI6DgyHaklJjvy2OHxB0dC4foV+ERCRHT24zt8Iy4FmteSDMXrOEAzXhDDNVYn99T8ek7Q7rFgrSdfDlsXfIw/cn9+qw/qhemQzsHzkoNfaFIeUxjd09k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750198166; c=relaxed/simple;
	bh=KHNQkq9xuMKZnrA+AEl/eVcQduVbc35sK5BU1qgAKi0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aRg8JkwvAIYYMHbsVXQS/yA4i+sZLx/FcdnfNYBE9THVS2Pmcop0CDZDXg0BhkdTGBeGK0iuvCNkFQ42xxjr/zMxLtnurmsLdwJ0j2xRY3VXwcPr6TTM7ECaGrkLINUT2jMRzfjJLc1lqJ7xPW4INi8PatG+giqwrKd5XUHd9Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJ48bJ+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJ48bJ+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCF1C4CEE3;
	Tue, 17 Jun 2025 22:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750198165;
	bh=KHNQkq9xuMKZnrA+AEl/eVcQduVbc35sK5BU1qgAKi0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cJ48bJ+XYi7MtGGo2YV+w8a1WgYA5eSlhNElIxNYmcX7w0Iu2lmieoPAInDqfsiFh
	 AHkqrSQDcosknt1c29NOyZKBCwlUj0tN9Sok/XwW3Nws4o3RYGOthneiC3VTHCTtEP
	 zp9NTSfIO2CLcTSgabgGRsI1ydUG00n6+i5FX2jsxGl2yyc07kisDS6WbhP1fiLiyG
	 91ALs44nQ9JZGFcUl2muHEVnaeGIZmStgnpUn5lE3Q34cl0Yl1jgNjC9BgL3UIh2jY
	 /sF/52p9aodxgJqMgOR2e6IE17S6PvpVrT9CpzTzzxae0DJ4emJT1NVc5v9MW4/ATD
	 MpDm4/m0GC0pQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70FA838111DD;
	Tue, 17 Jun 2025 22:09:55 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM fixes for 6.16-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <6851d41fbecbd_25410c29475@iweiny-mobl.notmuch>
References: <6851d41fbecbd_25410c29475@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <6851d41fbecbd_25410c29475@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.16-rc3
X-PR-Tracked-Commit-Id: 62a65b32bddb0f242b106b8c464913f2f01c108d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 52da431bf03b5506203bca27fe14a97895c80faf
Message-Id: <175019819412.3713246.2860953096104093019.pr-tracker-bot@kernel.org>
Date: Tue, 17 Jun 2025 22:09:54 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, Conor Dooley <conor.dooley@microchip.com>, Oliver O'Halloran <oohall@gmail.com>, Drew
 Fustini <drew@pdp7.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 17 Jun 2025 15:46:23 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-fixes-6.16-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/52da431bf03b5506203bca27fe14a97895c80faf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
