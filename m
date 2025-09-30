Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3F3221FC6;
	Tue, 30 Sep 2025 10:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227104; cv=none; b=SeeDCxdW7SxUxsz2SOnMszDw3EX/y6/eFeAJH2tTvVmiRdlJFDaSyy4iwLMSWqPsNqUZVty284kine3eMcouebIj2EcQInDb3D3xB60goEdTB2J7OfguXzvBxsKw6YhBNvE+di7q2DlNuc7GTMFQ3i51aVmZak3sPLVqEpjfWZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227104; c=relaxed/simple;
	bh=nQiB9x6LVTor0rUg13JxaN9DSoNnxVocFRy7A4rwhN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0eav9z7mjfF0vHKb2FnXiIkftZk3/rb2IJKm4DYeMrLzsd8C/Z2gw9lztgZCKNQXx0IWME2SoKEOmfvukh21SIq+/94oe50l3QXezVAq97mVseCQzAajcqSpXjxndYpjI2XcX1TxGdyJgM77moYZIxpll8vvDPgM7AXOWz7h8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFCo7Wxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFCo7Wxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F3AC4CEF0;
	Tue, 30 Sep 2025 10:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759227103;
	bh=nQiB9x6LVTor0rUg13JxaN9DSoNnxVocFRy7A4rwhN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PFCo7WxtPFsgR+fJZk1IYzTYSR7R4gVmihaKer2MbfEfvZil4Sc5gGoUHTJsE0AjC
	 LWdt7CuX9zl859TVUkm2BcqPXtkBTiZ0PxjavQGwR2UhvS1a7C9F1xYSd2RDhJcmk+
	 pkyxIbFWI+SEoh1ffi8vAIQg5qOrCMDV5ZfVgfueTp9DPIN1xKa2OGEKpSq2XmGT5f
	 Rqj+6K4DGhwdbWXdmuuiAfs4ZC9ZYTXimCD6EFLVt4yZPlXANp8U2Q9vGAd1TDlDA9
	 QY61zxcshu5eF0yHC7Kv/EP7txFUCCHxYdxTmxpHTlqbO+nZ2lTHR2mFI8CQghhtHl
	 N7OLorNNRxgZQ==
Date: Tue, 30 Sep 2025 12:11:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: dan.j.williams@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Message-ID: <aNus2chNlLGmEiOg@kernel.org>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
 <68d34488c5b8d_10520100b6@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68d34488c5b8d_10520100b6@dwillia2-mobl4.notmuch>

On Tue, Sep 23, 2025 at 06:08:24PM -0700, dan.j.williams@intel.com wrote:
> Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > There are use cases, for example virtual machine hosts, that create
> > "persistent" memory regions using memmap= option on x86 or dummy
> > pmem-region device tree nodes on DT based systems.
> > 
> > Both these options are inflexible because they create static regions and
> > the layout of the "persistent" memory cannot be adjusted without reboot
> > and sometimes they even require firmware update.
> > 
> > Add a ramdax driver that allows creation of DIMM devices on top of
> > E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> > 
> > The DIMMs support label space management on the "device" and provide a
> > flexible way to access RAM using fsdax and devdax.
> 
> Hi Mike, I like this. Some questions below:
> 
> > +static struct platform_driver ramdax_driver = {
> > +	.probe = ramdax_probe,
> > +	.remove = ramdax_remove,
> > +	.driver = {
> > +		.name = "e820_pmem",
> > +		.of_match_table = of_match_ptr(ramdax_of_matches),
> 
> So this driver collides with both e820_pmem and of_pmem, but I think it
> would be useful to have both options (with/without labels) available and
> not require disabling both those other drivers at compile time.
> 
> 'struct pci_device_id' has this useful "override_only" flag to require
> that the only driver that attaches is one that is explicitly requested
> (see pci_match_device()).
> 
> Now, admittedly platform_match() is a bit more complicated in that it
> matches 3 different platform device id types, but I think the ability to
> opt-in to this turns this from a "cloud-host-provider-only" config
> option to something distro kernels can enable by default.

It looks like /sys/bus/platform/devices/e820_pmem/driver_override does the
trick.

I'll make the driver to use "ramdax" as the name and rely on
driver_override for binding it to a device.

-- 
Sincerely yours,
Mike.
