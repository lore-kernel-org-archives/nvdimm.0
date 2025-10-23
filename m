Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07206254876;
	Thu, 23 Oct 2025 07:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761205186; cv=none; b=JOEOVDnRySIinPk6BWaE288+IpCuKjdFQcgkQy4o9SOFv5/SQJDqc3aujo82OMu3FEGaXWpRrPoX0MOZRiWpr28v+PzgF2SgbLnxhrHwpzM+lN91wtVmftDm05QnkXI/rvBTWZ2/0oVTYZAFaIViYsXH05/NaJRU66Dk6dhRZTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761205186; c=relaxed/simple;
	bh=/Y2hL14e1iVQLoCNujnXvEmMm2MILBfzDLZAAGFs1V0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDKB0Fx6s7XizJGhMLaoTWL3IW/QoPuYq+u+ItAlOGyc4wZTXy/URwNvBiJIHcBkkhlWWAns9c8+akK6SB/9czlPmsaTaqwNDV+VPdjKCTX963ySVPxzU0AOUnTWgvpldSa3hItWZwqpOVcfJynFxp3GfGopOpMk2vMFJKc3omU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFwALB0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFwALB0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126D6C4CEE7;
	Thu, 23 Oct 2025 07:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761205185;
	bh=/Y2hL14e1iVQLoCNujnXvEmMm2MILBfzDLZAAGFs1V0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZFwALB0cl8RKUGdmrRE5YDwPArX/Kp7yJ7OsI7IImhMPoUlK5PHtiSsb4vqWKo6Zr
	 fnrXT2K73NZaRGq8perxlcbCzVZfSOMz1BrMEC5d3umLBhR7PaGiVU/jG3fr8z7NUj
	 7pUppziVYtNITXR0VY0AHAi7szjRCKPb2od5STBHnK6X8DVxeb3OHJbDHISjyX4sLt
	 kXzL6BP9I4hnG19PYBISFcnMCZkckvThOFdRje+uThSzgTW5zXtcdpJuak6qYvIuqe
	 jP56d7ZtAOBRHzdwlACr9TNmlgbzeB1XilpvY2VsuKhnDuPX30nbB+pUN69XaQ4vkk
	 D2b8lKR2x00NQ==
Date: Thu, 23 Oct 2025 10:39:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: dan.j.williams@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com,
	=?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v2 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM
 DIMM devices
Message-ID: <aPnbuurCUlErW0Yf@kernel.org>
References: <20251015080020.3018581-1-rppt@kernel.org>
 <20251015080020.3018581-2-rppt@kernel.org>
 <68f2da6bd013e_2a201008c@dwillia2-mobl4.notmuch>
 <aPjujSjgLSWsAtsb@kernel.org>
 <68f968d34154f_10e9100e0@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68f968d34154f_10e9100e0@dwillia2-mobl4.notmuch>

On Wed, Oct 22, 2025 at 04:29:23PM -0700, dan.j.williams@intel.com wrote:
> Mike Rapoport wrote:
> [..]
> > > > +config RAMDAX
> > > > +	tristate "Support persistent memory interfaces on RAM carveouts"
> > > > +	depends on OF || X86
> > > 
> > > I see no compile time dependency for CONFIG_OF. The one call to
> > > dev_of_node() looks like it still builds in the CONFIG_OF=n case. For
> > > CONFIG_X86 the situation is different because the kernel needs
> > > infrastructure to build the device.
> > > 
> > > So maybe change the dependency to drop OF and make it:
> > > 
> > > 	depends on X86_PMEM_LEGACY if X86
> > 
> > We can't put if in a depends statement :(
> 
> Ugh, yeah, whoops.
> 
> > My intention with "depends on OF || X86" was that if it's not really
> > possible to use this driver if it's not X86 or OF because there's nothing
> > to define a platform device for ramdax to bind.
> > 
> > Maybe what we actually need is
> > 
> > 	select X86_PMEM_LEGACY_DEVICE if X86
> > 	default n
> > so that it could be only explicitly enabled in the configuration and if it
> > is, it will also enable X86_PMEM_LEGACY_DEVICE on x86.
> > With default set to no it won't be build "accidentailly", but OTOH cloud
> > providers can disable X86_PMEM_LEGACY and enable RAMDAX and distros can
> > build them as modules on x86 and architectures that support OF. 
> > 
> > What do you think?
> 
> Perhaps:
> 
>     depends on X86_PMEM_LEGACY || OF || COMPILE_TEST

Works for me :)
 
> ...because it is awkward to select symbols that has dependencies that
> may be missing, and it shows that this driver has no compile time
> dependencies on those symbols.

-- 
Sincerely yours,
Mike.
