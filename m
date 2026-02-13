Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4624621B9F5;
	Fri, 13 Feb 2026 01:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770945522; cv=none; b=idLebbcbeqQt2YCgw+PcYi6KrA5eRcQQkaqu3CFh9tPVUrnYBx5ozh7k5j8AsbdK3b1vTlt86K8UCOP9qlp0Vi3LIV4RS737MqmQ68TDOFRxi1gEBwiGCti0Kf0gIyQYO/Zo58sHf5rwv3mWvf5N1zJ7PXXOMdaoiLZAiD0yocg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770945522; c=relaxed/simple;
	bh=o/AFj0wbaA3ZO5SoMkiUxlTCygQN9/BnxE2QjNaq0do=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WzZ+bRXQXpee/oRnMwvxPCr780MQ/PKC73d/NoOCIC5HoIhV0Alj6G12FoX1B7MhEMlfy/PvVxsFoEBB9FpgQlprcMpGSYvVwgJkxJMDGlxDG6GPR+35Tn32+0+cMvzNsxaY5LAbBx4CgiB6z+2FMIL/waELwIttJm+1UFTmsew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGc3lPPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGc3lPPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA7AC4CEF7;
	Fri, 13 Feb 2026 01:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770945522;
	bh=o/AFj0wbaA3ZO5SoMkiUxlTCygQN9/BnxE2QjNaq0do=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bGc3lPPgGrFA6cmnLkPG6SJdlAUgug5crCwbogEXdLBguih1ga1W6oeRqgTK73/l9
	 JYAdLDbhBrg1z9ZwLcrI0z0iS+iM0Xcjm8NbvFD9rin3xvXZseJ5q42FcCDNIKgvsg
	 qStbRDJ+MDa3m95WxUOL3z2zrrz3w+GF3LPuR6kjwBIJ3tLvb1e21p8pbVngX0if02
	 BcCqe7sNaxbugzupAJwBQxWQvucLYcYIffRVJeU9uf0qpyPO+1ZVvQR2ThC/9WgK3A
	 cxLvBx5wpPwXhniTygtGc9nY5612xjga58KwoMiicbI20S/7OeTRSDWuNTY+pz/o1a
	 QPjorSVqhN30Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 85397393108D;
	Fri, 13 Feb 2026 01:18:37 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <698ceffc62269_10ad1610081@iweiny-mobl.notmuch>
References: <698ceffc62269_10ad1610081@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <698ceffc62269_10ad1610081@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.0
X-PR-Tracked-Commit-Id: a9ba6733c7f1096c4506bf4e34a546e07242df74
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e99785a923d585174a71ea9c081bee708184862e
Message-Id: <177094551623.1792804.17341554728681602271.pr-tracker-bot@kernel.org>
Date: Fri, 13 Feb 2026 01:18:36 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, Davidlohr Bueso <dave@stgolabs.net>, "Jiang, Dave" <dave.jiang@intel.com>, Li Chen <me@linux.beauty>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, "Michael S.
 Tsirkin" <mst@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 11 Feb 2026 15:09:16 -0600:

> git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.0

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e99785a923d585174a71ea9c081bee708184862e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
