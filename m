Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95939226CFE
	for <nvdimm@lists.linux.dev>; Fri, 12 Jun 2026 07:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247786; cv=none; b=h3DX4/ap71B/ZTPDL6CEZtVxgsJGjWrJfYrWlZ9aushSmRE7wcPgGfTDmF/zUrxPGbW7n5Nqpaez6NQbAYj81dCDNGK9gmKsMkXTfvlQISduziPaAX84Dzv5aCp8+tOUl0y71EqQ7hUEzJxgUo7TpIWa5ueitzs5zL2QbFnNNdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247786; c=relaxed/simple;
	bh=NF+8vu7gvwjYxK/ME8jvSTRKV+sCm7boRacSBuCU/8Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgkEqIv2kJ/bxa/VSywe4qPweHgc2wR/3PB89iFUtaIyh37uEPWWkOBwDxOq97rN2JbGcOdd7X16uju/MATGLxGSsqfJhPrjh6azNHo1c2PjoKs/3RCyQ51KwNz9aJR1bxXgdojNGvxQ8eKcibZA09KR0b+xLZ4wJ+Je86ZPJmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc9Sh1Mmtz1dd8V;
	Fri, 12 Jun 2026 15:02:44 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc9Sd6rbMz1dd8V;
	Fri, 12 Jun 2026 15:02:41 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id F286434C3EC5;
	Fri, 12 Jun 2026 15:01:14 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 12 Jun
 2026 15:02:35 +0800
Date: Fri, 12 Jun 2026 15:02:32 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <surenb@google.com>,
	<mjguzik@gmail.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<shakeel.butt@linux.dev>, <rppt@kernel.org>, <mhocko@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <linux@armlinux.org.uk>,
	<dinguyen@kernel.org>, <schuster.simon@siemens-energy.com>,
	<James.Bottomley@hansenpartnership.com>, <deller@gmx.de>, <djbw@kernel.org>,
	<willy@infradead.org>, <peterz@infradead.org>, <mingo@redhat.com>,
	<acme@kernel.org>, <namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH v2 0/4] mm: split the file's i_mmap tree for NUMA
Message-ID: <aiuvCHI32bfz6j20@hsj-2U-Workstation>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <airY5q_SspdbQDbi@lucifer>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <airY5q_SspdbQDbi@lucifer>
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)

On Thu, Jun 11, 2026 at 05:00:49PM +0100, Lorenzo Stoakes wrote:
> Hi Huang,
> 
> You seem to be replacing the file rmap altogether here, so you really ought
> to have sent this as an RFC so we could discuss it as a community first.
No problem.

> 
> Especially so as Pedro had publicly mentioned his plans to implement
> something similar here, so coordination would have been appreciated.
Yes. I am very happy to work with Pedro.

> 
> Anyway, as Pedro has pointed out, the code is overly complicated, it's far
> too configurable (not always a good thing), and the locking implementation
> is questionable.
I can make the code more simple. :)

> 
> You seem to be adding a whole bunch of open-coded complexity too, which is
> not something we want. Abstraction is key for the rmap.
> 
> You're also not adding any kdoc comments or really many comments at all,
> and you've not added any tests (though perhaps it's difficult given how
> core this is).
Got it.

> 
> So I would suggest that perhaps any respin should be sent as an RFC so we
> can engage in that conversation and ensure we're all on the same page?
> 
> Especially since Pedro plans to send an alternative, simpler, solution I
> believe.
> 
> It's also not helpful that you haven't examined the non-NUMA case :)
> perhaps your particular server behaves a certain way that this approach
> aids, but regresses other NUMA configurations?

emm. I ever hoped someone can help me to test this patch set on the non-NUMA
server.

It seems I should find some non-NUMA server before I send out the patch set. :)

> 
> We'd really need to be sure of this before accepting invasive changes like
> this.
Okay.

Thanks
Huang Shijie

