Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54F018B08;
	Wed, 25 Oct 2023 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rg/t6UCm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B155C433C8;
	Wed, 25 Oct 2023 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698256843;
	bh=2nERPDJJo/iFzCwUHAQJssuuyAKf3mzyWrOcRv5x2lw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Rg/t6UCm0wsCBaSVfeYB+JFeSNlShBCKDDmAOi/8bg9IxLf5MJ7LfQxcWhCS2ZX/H
	 KqpCd22j8ZuddxXzDV++tjr0Nr7/sU+O+KkGAZeLLl7fgshtq0hy7mK6uOuPXrkCYn
	 cNUhlCwQZmWUGCifoxU0p4WMskjE72RPHR+PiGiCEo85zpp7kvMWA0y/INBck1UgdF
	 jbx1TGVcV32GIC6rgUTyKWQZWjTTNuZrCigAK9G/TP3fJBWECm3fG4bXS01SqaGO0P
	 F3YKotVG9qwGl4MsZp3oyEloc+w5gWls2DEfPODmRyrbHqGOn5A8PeNQMp/pfKEHyy
	 94/nmjtNSMaew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37389E4CC0F;
	Wed, 25 Oct 2023 18:00:43 +0000 (UTC)
Subject: Re: [GIT PULL] ACPI fix for v6.6-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAJZ5v0hQGLq6JdJqVnhF_-DqXTjHubrt7khJi_ZoDU0diNTPMQ@mail.gmail.com>
References: <CAJZ5v0hQGLq6JdJqVnhF_-DqXTjHubrt7khJi_ZoDU0diNTPMQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAJZ5v0hQGLq6JdJqVnhF_-DqXTjHubrt7khJi_ZoDU0diNTPMQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-6.6-rc8
X-PR-Tracked-Commit-Id: 9b311b7313d6c104dd4a2d43ab54536dce07f960
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 611da07b89fdd53f140d7b33013f255bf0ed8f34
Message-Id: <169825684321.26933.16361374132237868253.pr-tracker-bot@kernel.org>
Date: Wed, 25 Oct 2023 18:00:43 +0000
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, nvdimm@lists.linux.dev
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 25 Oct 2023 19:51:04 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-6.6-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/611da07b89fdd53f140d7b33013f255bf0ed8f34

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
