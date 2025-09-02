Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253F82EF669;
	Tue,  2 Sep 2025 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756827320; cv=none; b=oGYdcf6mWcVSYuqpwIxFC/LT6Low1gtejVMCeTPX9bxQsFMDvTOZDK78XjEGiQwun01AhaRpo4UpncMqIqqtDYyLln+HTOtlOTZ/mADnmu16MT4/0iVdV8eV6RYfrAZpV8tiUpDddp60ThmZv/GJgwPaIBSOcN38/XQn0+Rz/z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756827320; c=relaxed/simple;
	bh=kzYKGVadSPv9NME2aJItAScHQKnKboMO69iumtu+g7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lx3jzdZcfynRPRUsRhxXWVCp65e7sIemGZNiKarIF4ESdmZfxG6v46Pz1QTjNgLXsQrbDzQOeXyMkxU+1LcKEHtkvexZrgHKswIwB12Js/T0USguIXnLvNaX2NsuxZCrtfkG1fAhGBt4EB7iO6wucDQMhheIQJ/2kZoQz8xyq6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQHjMSHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQHjMSHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD86C4CEF5;
	Tue,  2 Sep 2025 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756827320;
	bh=kzYKGVadSPv9NME2aJItAScHQKnKboMO69iumtu+g7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HQHjMSHMoSkGigOCLVQnJxNXj5QNvpKbBfznH62inZWwfFDFVp9PrfOfO42PXjf3V
	 HBy4F/pQUciXmHqluZgcSBOvbEGsDIDPNvQaW5SRy0jl3QdR69VDmYDUQ/cYKJzJzJ
	 eryE1wC5lIxqm5A5DQxxK+3RKarkSO04n7fEV3ip8S5I/JIXKI1dsJBLWwMR2a10US
	 NbNjwzkgoiLZ6XVOOhYi7D+GHzWgS1BWAobQrqqVoTGH7dBZ+A10zQ86LuwYySQpzs
	 9pZ5XRr9y4rZu6IKNkuYrR0tBpmrwKLLIJLnku3F81uMA22UuGJgmGoTxP9hPueQ6C
	 ovSeGGMEwit3w==
Date: Tue, 2 Sep 2025 18:35:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Message-ID: <aLcOsDa2K7qMcXtU@kernel.org>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>
 <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>

Hi Michał,

On Mon, Sep 01, 2025 at 06:01:25PM +0200, Michał Cłapiński wrote:
> On Fri, Aug 29, 2025 at 9:57 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Hi Ira,
> >
> > On Thu, Aug 28, 2025 at 07:47:31PM -0500, Ira Weiny wrote:
> > > + Michal
> > >
> > > Mike Rapoport wrote:
> > > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > >
> > > > There are use cases, for example virtual machine hosts, that create
> > > > "persistent" memory regions using memmap= option on x86 or dummy
> > > > pmem-region device tree nodes on DT based systems.
> > > >
> > > > Both these options are inflexible because they create static regions and
> > > > the layout of the "persistent" memory cannot be adjusted without reboot
> > > > and sometimes they even require firmware update.
> > > >
> > > > Add a ramdax driver that allows creation of DIMM devices on top of
> > > > E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> > >
> > > While I recognize this driver and the e820 driver are mutually
> > > exclusive[1][2].  I do wonder if the use cases are the same?
> >
> > They are mutually exclusive in the sense that they cannot be loaded
> > together so I had this in Kconfig in RFC posting
> >
> > config RAMDAX
> >         tristate "Support persistent memory interfaces on RAM carveouts"
> >         depends on OF || (X86 && X86_PMEM_LEGACY=n)
> >
> > (somehow my rebase lost Makefile and Kconfig changes :( )
> >
> > As Pasha said in the other thread [1] the use-cases are different. My goal
> > is to achieve flexibility in managing carved out "PMEM" regions and
> > Michal's patches aim to optimize boot time by autoconfiguring multiple PMEM
> > regions in the kernel without upcalls to ndctl.
> >
> > > From a high level I don't like the idea of adding kernel parameters.  So
> > > if this could solve Michal's problem I'm inclined to go this direction.
> >
> > I think it could help with optimizing the reboot times. On the first boot
> > the PMEM is partitioned using ndctl and then the partitioning remains there
> > so that on subsequent reboots kernel recreates dax devices without upcalls
> > to userspace.
> 
> Using this patch, if I want to divide 500GB of memory into 1GB chunks,
> the last 128kB of every chunk would be taken by the label, right?

No, there will be a single 128kB namespace label area in the end of 500GB.
It's easy to add an option to put this area in the beginning.

Using dimm device with namespace labels instead of region device for e820
memory allows to partition a single memmap= region and it is similar to
patch 1 in your series.

> My patch disables labels, so we can divide the memory into 1GB chunks
> without any losses and they all remain aligned to the 1GB boundary. I
> think this is necessary for vmemmap dax optimization.
 
My understanding is that you mean info-block reserved in each devdax device
and AFAIU it's different from namespace labels. 

My patch does not deal with it, but I believe it also can be addressed
with a small "on device" structure outside the actual "partitions".

> > [1] https://lore.kernel.org/all/CA+CK2bAPJR00j3eFZtF7WgvgXuqmmOtqjc8xO70bGyQUSKTKGg@mail.gmail.com/

-- 
Sincerely yours,
Mike.
