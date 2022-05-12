Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6D733E5;
	Thu, 12 May 2022 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=POsmG8gxTJ+8opBsMUMlh4wZguh3L79HwkpJz2EQhGE=; b=UAhw9uCow//dvgzeqpZuVgDO0q
	yVBGGglzPHB03fj1bF68oA5ctLYocF7GOkfSzv/LgwvGYFRh+GAP8WM39hrDi+S5I2NHaMt9Wxrg0
	xKDyyhbaLtmLasiTlx6LjYeOWYvTtS/1OHuh1oQK9rQPWpXDRT+R4wy7gc6Y4IM7ExYUCvM3pNp8J
	Qfjyq7zo+eV7NfkJkNsmCGfsOzYZM8xXfYBFJVxLOnsVPgXFUgSZ6FfaBysjAQy34qatn7F0dBjn4
	ZCCCoTnfCdYDL86T6eKTVpLb0IolzmsCPOFS6u2K/3rFG9M2sqbVl5wy09WPHmdS0voRDS6XbaVDl
	Xwnqaejg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1npCbC-00D00T-K8; Thu, 12 May 2022 17:27:38 +0000
Date: Thu, 12 May 2022 10:27:38 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Ben Widawsky <ben.widawsky@intel.com>, Klaus Jensen <its@irrelevant.dk>,
	Josef Bacik <jbacik@fb.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
Message-ID: <Yn1DiuqjYpklcEIT@bombadil.infradead.org>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-3-ben.widawsky@intel.com>
 <CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
 <CGME20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469@uscas1p1.samsung.com>
 <20220418163702.GA85141@bgt-140510-bm01>
 <20220512155014.bbyqvxqbqnm3pk2p@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512155014.bbyqvxqbqnm3pk2p@intel.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, May 12, 2022 at 08:50:14AM -0700, Ben Widawsky wrote:
> On 22-04-18 16:37:12, Adam Manzanares wrote:
> > On Wed, Apr 13, 2022 at 02:31:42PM -0700, Dan Williams wrote:
> > > On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > > >
> > > > Endpoint decoder enumeration is the only way in which we can determine
> > > > Device Physical Address (DPA) -> Host Physical Address (HPA) mappings.
> > > > Information is obtained only when the register state can be read
> > > > sequentially. If when enumerating the decoders a failure occurs, all
> > > > other decoders must also fail since the decoders can no longer be
> > > > accurately managed (unless it's the last decoder in which case it can
> > > > still work).
> > > 
> > > I think this should be expanded to fail if any decoder fails to
> > > allocate anywhere in the topology otherwise it leaves a mess for
> > > future address translation code to work through cases where decoder
> > > information is missing.
> > > 
> > > The current approach is based around the current expectation that
> > > nothing is enumerating pre-existing regions, and nothing is performing
> > > address translation.
> > 
> > Does the qemu support currently allow testing of this patch? If so, it would 
> > be good to reference qemu configurations. Any other alternatives would be 
> > welcome as well. 
> > 
> > +Luis on cc.
> > 
> 
> No. This type of error injection would be cool to have, but I'm not sure of a
> good way to support that in a scalable way. Maybe Jonathan has some ideas?

In case it helps on the Linux front the least intrusive way is to use
ALLOW_ERROR_INJECTION(). It's what I hope we'll slowly strive for on
the block layer and filesystems slowly. That incurs one macro call per error
routine you want to allow error injection on.

Then you use debugfs to dynamically enable / disable the error
injection / rate etc.

So I think this begs the question, what error injection mechanisms
exist for qemu and would new functionality be welcomed?

Linux builds off a brilliantly simple simple interface borrowed from
failmalloc [0]. The initial implementation on Linux then was also really
simple [1] [2] [3] however it required adding stubs on each call with a
respective build option to enable failure injection. Configuration was done
through debugfs.

Later Josef enabled us to use BPF to allow overriding kprobed functions
to return arbitrary values[4], and further generalized away from kprobes
by Masami [5].

If no failure injection is present in qemu something as simple as the initial
approach could be considered [1] [2] [3], but a dynamic interface
would certainly be wonderful long term.

[0] http://www.nongnu.org/failmalloc/
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=de1ba09b214056365d9082982905b255caafb7a2
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6ff1cb355e628f8fc55fa2d01e269e5e1bbc2fe9
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8a8b6502fb669c3a0638a08955442814cedc86b1
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=92ace9991da08827e809c2d120108a96a281e7fc
[5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=540adea3809f61115d2a1ea4ed6e627613452ba1

  Luis

> > > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > > > ---
> > > >  drivers/cxl/core/hdm.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > > > index bfc8ee876278..c3c021b54079 100644
> > > > --- a/drivers/cxl/core/hdm.c
> > > > +++ b/drivers/cxl/core/hdm.c
> > > > @@ -255,6 +255,8 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
> > > >                                       cxlhdm->regs.hdm_decoder, i);
> > > >                 if (rc) {
> > > >                         put_device(&cxld->dev);
> > > > +                       if (is_endpoint_decoder(&cxld->dev))
> > > > +                               return rc;
> > > >                         failed++;
> > > >                         continue;
> > > >                 }
> > > > --
> > > > 2.35.1
> > > >
> > > 
