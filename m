Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2502E1E51E0;
	Tue, 30 Sep 2025 10:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227322; cv=none; b=P5UcOp64NkJL1XCtC8HiVwuvNrixp7xSOpwwIv+gxy/apo7SKipeEDERXZJBq5nsPOfo1UucJHVgjtrHOYVxZddEWgizhylLcFxNKw3GyLPoIVP0JkZx1i2m3rmqqqM96R6dzr9wgcraVSOCrU3rATzB/TEnHZngEp85281DNe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227322; c=relaxed/simple;
	bh=MNWyXnGoHFWpG7Rnd9CdwwT83DvQVU8dAcsX+F387zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFUnfG2x5sE7SVawI7m7ENKvWPz0EC53VORU1MF+eZM+OmuoJRgDZ8ZJ8WN0Q2g6ZQ5FUoebpGXdhGCU0+ELBPlFMmdn9C1Ngwc2SlcGK0RECP6ck64+XX9XTdQwvYhTTZIPnsFW6dAUapsNXoVzmuCSUjGitP74iykk3WWjSnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzMCcLE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzMCcLE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC5DC4CEF0;
	Tue, 30 Sep 2025 10:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759227321;
	bh=MNWyXnGoHFWpG7Rnd9CdwwT83DvQVU8dAcsX+F387zM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EzMCcLE6C8KZLJh6bAr7/dj98kB4GetUjjXSsrSkignLS9+qNMWsSgibyHzJyZ1vX
	 iJ1ZlKJ6yQKjjJelIpeo4QzKi+NGvq7mVs9Q00yS6jCiZU5C1zJLTi/RNOAwc1uS6F
	 3HI3wUdkej0Vchvk/3LEkj1VQeV7K3+RgHhd9xpDEKmxtmEehIVtrSwTIS9PF9fmfo
	 Rrdq+aqgkYUDw7W2Rpmg/nsedJOOfJXX7Wq8yechMS/ZdUuWUgypINJjH0szYVUuVF
	 zJCY6ub8OkexmvZgcsu7jM2BsYO+U7TOdnSdfv3LMIIynDaYzY1/tHbvRZ66K4jzET
	 q1UTo03EGLcsg==
Date: Tue, 30 Sep 2025 12:15:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: dan.j.williams@intel.com
Cc: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Message-ID: <aNuts7yMTJdtmDXZ@kernel.org>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>
 <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
 <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
 <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch>

On Fri, Sep 26, 2025 at 11:45:19AM -0700, dan.j.williams@intel.com wrote:
> Michał Cłapiński wrote:
> [..]
> > > As Mike says you would lose 128K at the end, but that indeed becomes
> > > losing that 1GB given alignment constraints.
> > >
> > > However, I think that could be solved by just separately vmalloc'ing the
> > > label space for this. Then instead of kernel parameters to sub-divide a
> > > region, you just have an initramfs script to do the same.
> > >
> > > Does that meet your needs?
> > 
> > Sorry, I'm having trouble imagining this.
> > If I wanted 500 1GB chunks, I would request a region of 500GB+space
> > for the label? Or is that a label and info-blocks?
> 
> You would specify an memmap= range of 500GB+128K*.
> 
> Force attach that range to Mike's RAMDAX driver.
> 
> [ modprobe -r nd_e820, don't build nd_820, or modprobe policy blocks nd_e820 ]
> echo ramdax > /sys/bus/platform/devices/e820_pmem/driver_override
> echo e820_pmem > /sys/bus/platform/drivers/ramdax
> 
> * forget what I said about vmalloc() previously, not needed
> 
> > Then on each boot the kernel would check if there is an actual
> > label/info-blocks in that space and if yes, it would recreate my
> > devices (including the fsdax/devdax type)?
> 
> Right, if that range is persistent the kernel would automatically parse
> the label space each boot and divide up the 500GB region space into
> namespaces.
> 
> 128K of label spaces gives you 509 potential namespaces.

I was also thinking that the label area can be put either in the end or in
the beginning of the memmap= range, so that if you specify memmap=<1G
aligned address - 128K> the actual space will be 1G aligned.

-- 
Sincerely yours,
Mike.
