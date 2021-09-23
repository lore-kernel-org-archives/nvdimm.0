Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFAB72
	for <nvdimm@lists.linux.dev>; Thu, 23 Sep 2021 06:47:58 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B98D2610D1;
	Thu, 23 Sep 2021 06:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1632379677;
	bh=AF60ZPwUP8z9XvN4FVZ6x/vIwqknICKlpihnYWy1TEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qvh3psuo++MhYg868DDM5/QIZsRvkN1DZFAmj6R7h4FhZS8cXaZN48sQjErG2rb7S
	 boUddQRvLDXjhLRGYM11Oi0rDiEGvdN2L1a30ajG2r4+05xpJYfENvSUBJIqtpjGGz
	 5aYk0UDGTz3PYRcQwT84cMtPjoDUl0XoBVDx+FGo=
Date: Thu, 23 Sep 2021 08:47:28 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Coly Li <colyli@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	antlists@youngman.org.uk, Dan Williams <dan.j.williams@intel.com>,
	Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>, rafael@kernel.org
Subject: Re: Too large badblocks sysfs file (was: [PATCH v3 0/7] badblocks
 improvement for multiple bad block ranges)
Message-ID: <YUwjAJXjFR9tbJiQ@kroah.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <a0f7b021-4816-6785-a9a4-507464b55895@suse.de>
 <YUwZ95Z+L5M3aZ9V@kroah.com>
 <e227eb59-fcda-8f3e-d305-b4c21f0f2ef2@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e227eb59-fcda-8f3e-d305-b4c21f0f2ef2@suse.de>

On Thu, Sep 23, 2021 at 02:14:12PM +0800, Coly Li wrote:
> On 9/23/21 2:08 PM, Greg Kroah-Hartman wrote:
> > On Thu, Sep 23, 2021 at 01:59:28PM +0800, Coly Li wrote:
> > > Hi all the kernel gurus, and folks in mailing lists,
> > > 
> > > This is a question about exporting 4KB+ text information via sysfs
> > > interface. I need advice on how to handle the problem.
> 
> Hi Greg,
> 
> This is the code in mainline kernel for quite long time.

{sigh}

What tools rely on this?  If none, just don't add new stuff to the file
and work to create a new api instead.

> > Please do not do that.  Seriously, that is not what sysfs is for, and is
> > an abuse of it.
> > 
> > sysfs is for "one value per file" and should never even get close to a
> > 4kb limit.  If it does, you are doing something really really wrong and
> > should just remove that sysfs file from the system and redesign your
> > api.
> 
> I understand this. And what I addressed is the problem I need to fix.
> 
> The code is there for almost 10 years, I just find it during my work on bad
> blocks API fixing.
> 
> 
> > > Recently I work on the bad blocks API (block/badblocks.c) improvement, there
> > > is a sysfs file to export the bad block ranges for me raid. E.g for a md
> > > raid1 device, file
> > >      /sys/block/md0/md/rd0/bad_blocks
> > > may contain the following text content,
> > >      64 32
> > >     128 8
> > Ick, again, that's not ok at all.  sysfs files should never have to be
> > parsed like this.
> 
> I cannot agree more with you. What I am asking for was ---- how to fix it ?

Best solution, come up with a new api.

Worst solution, you are stuck with the existing file and I can show you
the "way out" of dealing with files larger than 4kb in sysfs that a
number of other apis are being forced to do as they grow over time.

But ideally, just drop ths api and make a new one please.

thanks,

greg k-h
