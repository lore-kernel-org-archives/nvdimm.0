Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1131C47F53;
	Tue, 26 Nov 2024 02:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732589972; cv=none; b=AFkfcNWSyXHp2nTXQWOiE6H+SsYnI/TB4lV33PbbIHjKsiO9YN5GRSJCnv49Y21wUlfh8Enfh80LRPAtBAjYI7p+m8Z5q0LXbDbiArQOhfqqb2TVArvTEpvfINPad+2rTATrTZMdAXJZ75pKcMfy8FIJAgD/zCyC5HUwUmHl8C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732589972; c=relaxed/simple;
	bh=Y/llceuyFvWYdu6tV+2xPCVzLsqCdjHOGubb/TAgkp0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=E2hGSJ79b58/ymA/kcGsTOKcuKXcUf5+NDXLZHZxc0EuhRiXwVGM88Ja72GtsyRUXY+RNMsiOPd7/bUHwnePdGMncQBtw7RMOIsECm7Ba7h8/uzy2dfPBArqZrbIq9kviHLdpTxXtFROlj2XfFGwPIkL7GK8z7LCgNKAtP0xVzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ot9ymTE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ot9ymTE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7859C4CECE;
	Tue, 26 Nov 2024 02:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732589971;
	bh=Y/llceuyFvWYdu6tV+2xPCVzLsqCdjHOGubb/TAgkp0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ot9ymTE9KXMscsSH0PAFqgejogNMO+UB+kYQAzRDGB/nHrIFgvRomEm8SdCRmX7gN
	 +eR3YBVsrVR3e/1LLr/86Ns+gjsTNxdKrnintrAMVySX2d8HPuwk6AXKIsFZsJ0hON
	 V2cticdnNeAjJXc5zZBYY5FxnS3BjZ1IVyeEiYdq//P0fRpRZpl8bmayOJjl9StjCY
	 s/e3QJVXfapfZWhKNuIKgDcRDghojJRErDbV8/XlY7vxxtaRQdrQ455+eMgAmx/Oug
	 8AUa81bRD/Hxe8StL0DTFhpyJCp0vXb/aSPKh/OkcEcNmJ1AVEnWpfTxexoX2jpPCB
	 W4rWxkPMue+HA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0853809A00;
	Tue, 26 Nov 2024 02:59:45 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <6740e31574b0e_2de57f294c9@iweiny-mobl.notmuch>
References: <6740e31574b0e_2de57f294c9@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <6740e31574b0e_2de57f294c9@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.13
X-PR-Tracked-Commit-Id: f3dd9ae7f03aefa5bb12a4606f3d6cca87863622
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 78a2cbd809ef834b680f2825d3e4c16ec66f8ffa
Message-Id: <173258998455.4123769.1264709561580076077.pr-tracker-bot@kernel.org>
Date: Tue, 26 Nov 2024 02:59:44 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Shen Lichuan <shenlichuan@vivo.com>, Yi Yang <yiyang13@huawei.com>, Vegard Nossum <vegard.nossum@oracle.com>, Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 22 Nov 2024 14:01:25 -0600:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/78a2cbd809ef834b680f2825d3e4c16ec66f8ffa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
