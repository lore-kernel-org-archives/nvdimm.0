Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795852F43
	for <nvdimm@lists.linux.dev>; Thu,  8 Sep 2022 13:13:29 +0000 (UTC)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MNffn2sX8z67NB8;
	Thu,  8 Sep 2022 21:12:17 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Thu, 8 Sep 2022 15:13:20 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Sep
 2022 14:13:20 +0100
Date: Thu, 8 Sep 2022 14:13:19 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <x86@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <peterz@infradead.org>, <bp@alien8.de>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<a.manzanares@samsung.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] memregion: Add arch_flush_memregion() interface
Message-ID: <20220908141319.00000f01@huawei.com>
In-Reply-To: <631940536d040_2736529437@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220829212918.4039240-1-dave@stgolabs.net>
	<20220907153016.f7cd4f42a337fedae8319f28@linux-foundation.org>
	<631940536d040_2736529437@dwillia2-xfh.jf.intel.com.notmuch>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 7 Sep 2022 18:07:31 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Andrew Morton wrote:
> > I really dislike the term "flush".  Sometimes it means writeback,
> > sometimes it means invalidate.  Perhaps at other times it means
> > both.
> > 
> > Can we please be very clear in comments and changelogs about exactly
> > what this "flush" does.   With bonus points for being more specific in the 
> > function naming?
> >   
> 
> That's a good point, "flush" has been cargo-culted along in Linux's
> cache management APIs to mean write-back-and-invalidate. In this case I
> think this API is purely about invalidate. It just so happens that x86
> has not historically had a global invalidate instruction readily
> available which leads to the overuse of wbinvd.
> 
> It would be nice to make clear that this API is purely about
> invalidating any data cached for a physical address impacted by address
> space management event (secure erase / new region provision). Write-back
> is an unnecessary side-effect.
> 
> So how about:
> 
> s/arch_flush_memregion/cpu_cache_invalidate_memregion/?

Want to indicate it 'might' write back perhaps?
So could be invalidate or clean and invalidate (using arm ARM terms just to add
to the confusion ;)

Feels like there will be potential race conditions where that matters as we might
force stale data to be written back.

Perhaps a comment is enough for that. Anyone have the "famous last words" feeling?

Jonathan




