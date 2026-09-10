Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D584A3F3F;
	Thu, 10 Sep 2026 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049216; cv=none; b=GeNi60+PvnLbyUO0kD+E8MzyA3DwyuBfFbv+mjzolpTCQSh31CwvvcPibnlP4K35OFr9NCzGtcyuplDUN64MPLtjpBZMFSGXhwl5RX7uMJb0Q4adRROmqOAp3DiOaRchKLzNBgmIF8rx0Gy5k/r54myswBXo6dhzVlqfx0AkN64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049216; c=relaxed/simple;
	bh=usjgwNwq8e5FVuDuIy//fKbw8DVuTnjixnyIZu/Ku78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lY8ZpZDY6Afi7C7XMldN7G1hHFMN2dwWquzdALp2oW/LHbpV1l+ZZg1IHGX4rmXTquRgAOhgrC/sx62gnXfDfIF0iYLQVgkerTcvXLaWIzy7aDx4J6MXg5ABwc/t5rHS3dhcztL9QTpIi0mmM6AnphvEX7HDYGOxmxsBnfjW5dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khYqYYox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khYqYYox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970881F0089A;
	Thu, 10 Sep 2026 14:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049215;
	bh=70DL84P6JTZYmHCwquU+RidyFpbSEn3EbhgRLehum0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khYqYYoxLCC3IHUZhWSZ/5k6MaUU7a5qG9Uq/H2as3L0W6BL+uxN7k2+pKlEBL0yR
	 dghTPtHKwmo6niWKCE/e7CEN8xnGbaRJ7ryTnxA4eepLVos7utuH62ktBK1Q3ynEdA
	 mdUmxTQ9yw+NMXWXyeBG0zO325JsctZUk79B/RHN+V+0ZYQ+50sPC8n8eD8y3pPFBB
	 05j6cHp94XsGsHj1GusZhoju5knkCNRv/37JUqphBcqKTnaYIRFBjwzHiKXiGecGar
	 zIt2dcm1Q/eBn9ED6HySRxntqymbCFq4JhBd0JZYXKsLDP+6QtIP8duViFjxKlMAKT
	 IJS3xyspz9d7Q==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON migration and pageout
Date: Thu, 10 Sep 2026 07:06:45 -0700
Message-ID: <20260910140645.168914-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <e2d2b01e-e6eb-4009-a07e-e615d576c0c3@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 10 Sep 2026 10:58:05 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 7/23/26 05:25, Gregory Price wrote:
> > On Wed, Jul 22, 2026 at 05:19:42PM -0700, SJ Park wrote:
> >> On Wed, 22 Jul 2026 08:16:56 -0400 Gregory Price <gourry@gourry.net> wrote:
> >>
> >>>
> >>> See the damon changes in:
> >>>
> >>> https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#mfb99303c85dd9d4c3f58832dc28fc55583a7217a
> >>
> >> Summarizing what you want to say, quoting something from the patch, or at least
> >> calling it "26th patch of this series" would have made reviewing much easier.
> >> Cc-ing damon@ for only patches that toucing DAMON source files and the cover
> >> letter of the series could also be helpful.  Please consider doing some of
> >> these for future replies.
> >>
> > 
> > I have been very much discouraged from this kind of trimming because it
> > removes the context of the series from the individual patches - making it
> > even more confusing.
> 
> Yes, 99% of upstream maintainers will scream at you if you CC them only on
> individual patches :)

I agree that not everyone would like selective Cc-ing, like I also replied.
But the number might be changed after we got modern mailing archives and tools
like lore (public-inbox)?

At least for me, selective Cc-ing works better as long as the cover letter is
Cc-ing all recipients of all patches.  I can understand the high level picture
from the cover letter and directly jump to the specific patch that require my
attention.  Of course the sender might failed at figuring out to which mails I
really need to pay attention.  If the cover letter doesn't tell me some details
or I feel the sender might not Cc-ed me on all the patches that require my
attention, I can fetch the entire thread from lore (public-inbox).

Meanwhile, my private inbox have limited space and suboptimal UI.  Hence I use
my private inbox as just an alarm and usually work on only public-inbox with a
CLI tool.  Hence keeping noise in private inbox lower is more important to my
specific workflow.  Again, my workflow may be very different from others.


Thanks,
SJ

[...]
