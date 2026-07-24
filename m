Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13164282F25
	for <nvdimm@lists.linux.dev>; Fri, 24 Jul 2026 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784898402; cv=none; b=RpLZ9YqP6uG1kdj7uK5PZkufvE7DFuITpYKUpH8WsAnLCYTKV1BsmJrdCVxmAwJpWImPyqcoUHJZNkfxpnh4fMNuMrGOtRSQzOvWEl5U2+3w2/ijxuhlpxffTPHQXzZaiHYQ3WmwZFkH0Mfwsc4oGQnS0XovjYBJzEjphGQT5FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784898402; c=relaxed/simple;
	bh=BO1Qo1nw+0PvCR2G2yHuB96lktg3Fj/o/8I/fLPhaLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A820+S7Exik4Afsq2zZn/9D6tbVV3VDXk61WbePkzi52tfa6136b+qpBB/dG0Va6n5+07QRlIxn8x7vKFWLR6njXcSvo8IuqTFYTdPr1ByEmrqtySQUL5Tjnv1jZgdjA8Bp8Br+R7cWbIqfqMA1bMj1dbLTbqsOIoMKeND1EMz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=rweNnp8s; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="rweNnp8s"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8f032b47e3cso3302206d6.0
        for <nvdimm@lists.linux.dev>; Fri, 24 Jul 2026 06:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784898400; x=1785503200; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uClgs/33iOo+YM1fFExYaaz7O5yD2KHvC68r49braVw=;
        b=rweNnp8sHDZ8hROkmW/qHuduNSP3FtfKcC/1YWcUG4pE/nS8+eM3gXgbCnD5HpIUQw
         pj5L+uKu+etPFAA2SOR6OoArEPf+LTbIP5VvGYEG39FQxA5IwlhIyGGTtAoW32XC8tky
         fz/hdfnnJ24sOm0OCkJrZsYsiP66u7GvVaRHsP4lpFsRm5lmItzFI2vCB7VudPaOmayK
         vjfo4cu4q91on4wU0syqmRj0rerrgiFncnvBFqAb0mrZVIznV69ygkB5T17TGh5wnSi0
         7/cVNaoldQefN5ILvI4QnW1K7BX7KYepE6IseLpzC9bE5qd8yeOd+gJBW6CiQkYC5Vcg
         tJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784898400; x=1785503200;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uClgs/33iOo+YM1fFExYaaz7O5yD2KHvC68r49braVw=;
        b=bLGD6jPvV8i1o6F6CLlWcQHlcDa7T2ca6yu0sndswRuayMUxT0sYi7osX1A+Nak66R
         RFJfFH2Vm+RJ5U17BQ1diqpbd3QOEfgDoKt67nGh7ACI8Of+eRmN1YCGsOg462T//Hg9
         0+yZK/dhUQCuGREX3eo8+LNY7b5+l/xZjMjEB6swgCfYr2jD9e0ElyRROpsU/6PTqITk
         Q7vcMYeNDltDESHilc6ytwRNdHe8vBR4JDgqW5xvjh/L+Dp4iHYL8kRAiDoW6Xff5wI+
         BcCDe2cjtHTc8hCDrfQo7tn4VLReUH9mkf7K+j3QSSXUFz+FrI5C+vtKd28vP8YawU1X
         /Zlw==
X-Forwarded-Encrypted: i=1; AHgh+RoFQLASUWC6TGuJU5vNBjWsbcMoEwb78bRK3RTLgC/R/enWWXFbqV2p1zFgjpsmd/EzfpmfC+c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yweh95E+byYqS9wDlca+QLiPueQXqsLm+loZsMDNtwMQTfZH/Oy
	3tApv87ys9rTvu4RCvCbK9SxwZ+jrh1V3U8vI+VM+C9tG5s8+BjkHeFXXg9bikl0C+M=
X-Gm-Gg: AR+sD10iZLVterQORS2pFHlheGQuaZD8OYd7A40p8RPzgtUaM53V4blHBuZ7ZIfI/t5
	7W05SKQxDUCPEp6h9RuxkBxsvIAcrB17EIVO5e9fnuy/Bt97JmF/zEwA2XdOXIZga7cCTZfx+21
	krOAa8XJOod/Qn88L9qP5XnduFSrtxixYeLiXQLWZsd1x1eyBxFq7zgAV8WaD7I1+HgYxkRa7TP
	bruScr6MvMF/tBOTrjlkoq49PAA3uOvJy3zXS/vFES9hbsiIMeT3o3N9ZnEC03JGBn63Hkfa9n0
	kDy9RSozKZwn4wxqGvrhl58cbgmaWKhXDZQXZT+KoH1R3dJPd4d7YGcMv02wjoV7eDopwVnwCSW
	28XMMD5ikhtR9aUafoG7UJTp/RETFI3/WazqJKOTIZMbb7dy+zYZPHcHmeQrP7BK8fhOrYysexb
	OkYXqijr/V7+KKGEo8Lz3f12Peg5g6HjHu505x//k9J50V5Jq/MAUA3OLDsdsB9b4CkjaM
X-Received: by 2002:a05:6214:ccb:b0:8dd:4979:4b19 with SMTP id 6a1803df08f44-907ca570d4dmr77408266d6.13.1784898399844;
        Fri, 24 Jul 2026 06:06:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b5f85sm68863316d6.2.2026.07.24.06.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 06:06:39 -0700 (PDT)
Date: Fri, 24 Jul 2026 09:06:34 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com
Subject: Re: [RFC PATCH 0/8] dax/kmem: support for private NUMA nodes
Message-ID: <amNegmEeK1dUP1Dz@gourry-fedora-PF4VCD3F>
References: <20260722183519.935213-1-gourry@gourry.net>
 <amMUZ-QnxV0SKevW@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amMUZ-QnxV0SKevW@MWDK4CY14F>

On Fri, Jul 24, 2026 at 03:45:23PM +0800, Richard Cheng wrote:
> On Wed, Jul 22, 2026 at 02:35:11PM +0800, Gregory Price wrote:
> 
> Hi Gregory,
> 
> I have some thoughts especially for ownership and configs.
> 
> I think it would be good to expose dax control of private node, just with
> the following guarantees.
> 
> Let's make it clear that userspace should never become the owner
> of private node, they should be driver-owned and 1-to-1 mapping relationship.
> 

The intent here is 100% 1-to-1 driver:node mappings.

Technically there's nothing unreasonable about single-owner multi-node, but
really we just don't want multiple devices on one node.

> A userspace tool can request to reconfigure some capability of the DAX device, and
> maybe how the driver expose it.
> 
> A dax range may have several deployment rules, e.g. devdax, system-ram or private, with
> the patch series' tool, it looks like a userspace tool can convert a DAX device between
> dax and system-ram mode, I think that's unsafe especially when the region is online as
> system-ram.
> 
> And it will cause coherence issue to be resolved, if no special or strong use cases, I would
> prevent having such ability to convert the rules in runtime, especially for fixed-purpose device.
> 

Right now we can't really prevent a user from doing:

echo dax0.0 > dax/drivers/devdax/unbind
echo dax0.0 > dax/drivers/kmem/bind

And in fact we depend on kmem being the default target for CXL to
auto-probe through to hotplug.  For CXL accelerators, the current
intended auto-probe behavior is to terminate at an offline kmem dax
binding, and then expect the user to either rebind the dax device, or
rebind the entire cxl device:

echo $DEVICE > ../drivers/cxl_pci/unbind
echo $DEVICE > ../pci/my_cxl_device_driver/bind

I have some old patches that augment how drivers select the dax mode,
I can see about reviving that and maybe letting the source driver
also dictate which dax modes are valid according to the source.

I'll look into that.

> For capability bitmap part, I think it's reasonable to expose it, but with 2 concepts
> - supported_caps : immutable, supplied by the provider/vendor
> - enabled-caps : selected policy, subset of supported_caps
> 
> The invariant should always hold
> """
> enabled_caps & ~supported_caps == 0
> """
> 
> This way we can prevent userspace from touching things that they shouldn't.
> 

This I like, and i think you've convinced me that this should be a
separate dax device driver so we're not overloading kmem.

That said, for a dax device that was not created by a driver, but
instead created via something like "memmap=" boot parameter, i'm we
can't really dictate supported caps - but for a driver that *does* want
to limit support, I think we can manage that.

> Maybe a demo with a driver would be nice ?
> 

Sure! I think i'm going to include my anon-memory only compressed ram
service back into v6 w/ the dax driver extensions you've suggested.

~Gregory

