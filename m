Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B8233E7
	for <nvdimm@lists.linux.dev>; Tue, 31 Jan 2023 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A32A6C4339B;
	Tue, 31 Jan 2023 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675167017;
	bh=05Q0a0laoCL7B6cNeIdWae9i1mi1jqE1MmHEn48y7wY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AiLDIkfX/yC0s7oWbtxL2qgShGmaWg6DGpF2fcHDuTAYOpe4a0iGTOaS6tx1RZ7Na
	 y9uZae2xgPIq5V8e5Uwh3KWRbXPs/2kTYa4F1NdAZpGtECOprYO7b8lUGzbEWfbpRf
	 ZHvZzYUDj+Y/+NwYcyBDD/3Bj82qhjsbu3dP1BO5Rrkfj4jl7Tkbtin8JNyymkiFJa
	 IO+rix27EvPxnRVABnUcTTGGzu6v5gKk15JhkBCsgtnRe4Nk9cbI10R/FYiCalCEjJ
	 AewgByYVYe6k8wGX3tbIjdvlUsVbjKG5sps5v2mWvEaoR+hd2pQAJkeYt52xf2vZOQ
	 ciDD188aOinZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7574CC4314C;
	Tue, 31 Jan 2023 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling errors (series 2)
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
Date: Tue, 31 Jan 2023 12:10:17 +0000
References: <20230129231053.20863-1-rdunlap@infradead.org>
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
 tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org,
 cgroups@vger.kernel.org, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, mchehab@kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev, vkoul@kernel.org,
 dmaengine@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
 gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, jdelvare@suse.com,
 linux@roeck-us.net, linux-hwmon@vger.kernel.org, jiri@nvidia.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, paulmck@kernel.org, frederic@kernel.org,
 quic_neeraju@quicinc.com, josh@joshtriplett.org, rcu@vger.kernel.org,
 jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 sparclinux@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 29 Jan 2023 15:10:44 -0800 you wrote:
> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
> 
> These patches are based on linux-next-20230127.
> 
> 
>  [PATCH 1/9] Documentation: admin-guide: correct spelling
>  [PATCH 2/9] Documentation: driver-api: correct spelling
>  [PATCH 3/9] Documentation: hwmon: correct spelling
>  [PATCH 4/9] Documentation: networking: correct spelling
>  [PATCH 5/9] Documentation: RCU: correct spelling
>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling
>  [PATCH 8/9] Documentation: sparc: correct spelling
>  [PATCH 9/9] Documentation: userspace-api: correct spelling
> 
> [...]

Here is the summary with links:
  - [4/9] Documentation: networking: correct spelling
    https://git.kernel.org/netdev/net-next/c/a266ef69b890

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


