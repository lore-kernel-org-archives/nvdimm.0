Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434242DEA77;
	Mon,  6 Oct 2025 18:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759775353; cv=none; b=qWoJldcJUUV0SpNwruRO57kBAgKfCSert1RrPbOXr3YSBBEJ3ZBSM3UuvxsSalZ9ptq/5b6K66KFE2+Dr1kOFRzQZQB0goP16XDTexM9GYpFBsgc4fIEYkzg4E86yb72hRT9ZcShztYF26To1rASSreP7kiD2cl1djJ+jjSsPsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759775353; c=relaxed/simple;
	bh=4OPjsd3hGqeEHe+IBM8r7ydWtHscntUugIR6NMawL2g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Cf+5B29LV73jA3/CE+N//W1yLBxH0/5LNsCTTgQpppRATw4c3ypI8QyQMW0/WAzqSsyRK7xTOueWpJszkRC23k9c8lf2/lUzfiPuhBelLjXZD+uWQe4dZsxb5GlNbLVkxJzNK56sK3CB+dzpjAHVXeS0VK0B6Y/QAsZbLERzFQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rjGqnnC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjGqnnC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63F5C4CEF5;
	Mon,  6 Oct 2025 18:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759775352;
	bh=4OPjsd3hGqeEHe+IBM8r7ydWtHscntUugIR6NMawL2g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rjGqnnC5+RGuvN6Pz+7cAAAjy1bCSaVT5mlox8Jw+BlHklMbEZXWy1mjTuS7dUp4Q
	 dlriMNEKyKjvLwmjiV1VxTPC26EWTw8rERRoaSNpVaCHfFxNZUaee2VFHv5KB9tkWV
	 mx5AGe9KlkJz+CepNIs7hqz/Zn2EL4IvV1kkUQEt9pM8Prhb9zD2YkS8+JKpySigJC
	 kaKqhCYWSsl6y6SWSyqZyj6LJ+HTfv3l7Op8bUY5/mHWdx4DE8FnTE5FBDS4rGeleT
	 aW32oriehCs9LemsAPNJgHb3HBpUDXp4+L+kIoSEKxHGz1/Aq3szWDTAkzs4o4W7Su
	 5W89feEs+nm3Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE1A539D0C1A;
	Mon,  6 Oct 2025 18:29:03 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <68e3f338166e_2bc301294bb@iweiny-mobl.notmuch>
References: <68e3f338166e_2bc301294bb@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <68e3f338166e_2bc301294bb@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.18
X-PR-Tracked-Commit-Id: 5c34f2b6f89ad4f31db15f9c658b597e23bacdf8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ba9dac987319d4f3969691dcf366ef19c9ed8281
Message-Id: <175977534233.1510490.17244866347602340338.pr-tracker-bot@kernel.org>
Date: Mon, 06 Oct 2025 18:29:02 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, "Jiang, Dave" <dave.jiang@intel.com>, Xichao Zhao <zhao.xichao@vivo.com>, Colin Ian King <colin.i.king@gmail.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>, Guangshuo Li <lgs201920130244@gmail.com>, Alison Schofield <alison.schofield@intel.com>, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, Abaci Robot <abaci@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 6 Oct 2025 11:50:00 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ba9dac987319d4f3969691dcf366ef19c9ed8281

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
