Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C06372
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 08:55:09 +0000 (UTC)
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
	(envelope-from <kilobyte@angband.pl>)
	id 1mdqIC-005NTO-V3; Fri, 22 Oct 2021 10:52:48 +0200
Date: Fri, 22 Oct 2021 10:52:48 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] memremap: remove support for external pgmap refcounts
Message-ID: <YXJ74Atvd7i40O4x@angband.pl>
References: <20211019073641.2323410-1-hch@lst.de>
 <20211019073641.2323410-3-hch@lst.de>
 <YXFtwcAC0WyxIWIC@angband.pl>
 <20211022055515.GA21767@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211022055515.GA21767@lst.de>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false

On Fri, Oct 22, 2021 at 07:55:15AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 21, 2021 at 03:40:17PM +0200, Adam Borowski wrote:
> > This breaks at least drivers/pci/p2pdma.c:222
> 
> Indeed.  I've updated this patch, but the fix we need to urgently
> get into 5.15-rc is the first one only anyway.
> 
> nvdimm maintainers, can you please act on it ASAP?

As for build tests, after the p2pdma thingy I've tried all{yes,no,mod}config
and a handful of randconfigs, looks like it was the only place you missed.

As for runtime, a bunch of ndctl uses work fine with no explosions.

Thus: Tested-By.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ Don't be racist.  White, amber or black, all beers should
⣾⠁⢠⠒⠀⣿⡁ be judged based solely on their merits.  Heck, even if a
⢿⡄⠘⠷⠚⠋⠀ cider applies for a beer's job, why not?
⠈⠳⣄⠀⠀⠀⠀ On the other hand, mass-produced lager is not a race.
