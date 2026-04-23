Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A335AC33
	for <nvdimm@lists.linux.dev>; Thu, 23 Apr 2026 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776965252; cv=none; b=H9vl49edgRgXIpTTKsZjDDoqaMb4qesCIogEQAeR3+8goUFiR9DU3z8UReYuEGPo4F9Kj3t3z4kbudoTXO88EV2fZgcHlfF2FDYZkthsSs0IYDVjZ9MCY6GyHr/0S1Gdwi+iNC4V4wpCrhEl0MgGEgjO/Kym8T6qGzCU1c9iurs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776965252; c=relaxed/simple;
	bh=Iw9IjvIGMsKoBUILNNyJxK0ypNF4yUyPycUJvOWnFoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3SRLBYHUcQiAY0SfqdlrlP0IJLTWa1Z5ooxq4bWVCu6B3Swedp9VLD9vDGF7ZLdzPzVo37g9k2249DmlPl+7F1wspVQUtsh1n4mufdAkwJ6KC3KCuZ860Cu4jCD8xRuQDaWn1bA/n7ybELrgq4lTFRFOxf90ohOQlyGZsD5BKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=bWSDEF6B; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="bWSDEF6B"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50d87610513so75880941cf.3
        for <nvdimm@lists.linux.dev>; Thu, 23 Apr 2026 10:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776965249; x=1777570049; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VvC66dFEnVbU2q3BQXKFJd31eHL1LmeSE9BPsJjLUdk=;
        b=bWSDEF6BSSYA0aukQhMcTINbmGRim0bHk2VWZgTrb56Jz6ydVA99Yy5dicx3LsPCar
         CtZUnuRHawZymeR39kIGz+pbv8rbX5RTUOP/2vkDZMUe6l/PKnSvzNHVr0xR9VbzQ73F
         Gevs/3y3kx9EZGcE/n4GHJLYR9uPzZxWEkYYoB5Zf5ltgfJ+QP0H408ql78cpmLfY4X0
         GstYqxQ+g71E2/1hSW/W5bhGz1cTrE3Cwu07KxHKuSI2Kb6WoWy/PbeRHGGPW6GrgO2L
         Yc5Kbss10spr+N01XAHYt1+jT3wdKvbzJERKh2yDHiQVYAB7upRoPTcBq4HoWK+Pn91s
         I0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776965249; x=1777570049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VvC66dFEnVbU2q3BQXKFJd31eHL1LmeSE9BPsJjLUdk=;
        b=q7CvF0tS5GJPrhEbF+IioXBOcBYUZqIOn1dIPWKyQ67C890dfb+TohzQqk2y9uBB5A
         40dCKozjr+TRJPrwWCEVXCNCvhFHSzbEU4oWOb9qYKTT0BguJYuifI8sQ4JfExPoid3d
         gwPvqQJS699liB8q7sl27HIXxAmtmm72E+W0lIDC8UKshJw8nyrfVVnWtTMy2WGUd6s2
         zBxvMRUthkR/vEkm2Lf/qoZaVhM/KaWad8t/kp4He7ijH0GHnKlq6yREE7/xFV1dREAL
         yadE8/zic/xj4KlsYKu6HEyJIisXPN65N0D7j5D/U9Vn3cSACeAM5R3Ueq/942YgQsr+
         rAmw==
X-Forwarded-Encrypted: i=1; AFNElJ8liT9HWcFBA42k7T7dMLfj7VOEHZ+QJRfI+8aZAAPPxpqkl/AYGz/KTI7spV5TalvCdj1koiY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEkj2Ib1NJVhDGfolj8I43AQUAYesHXJU7XCdIo/tUcDHt1oqk
	oFgPrvtCPh0yBHKYRl2l9cazQWAaDFDmt/F7x9+pvpVF+N0GpMitGQ3i/VtJKZpA9vQ=
X-Gm-Gg: AeBDietQkny5kM4rB04yvj5/zsTlLe1aoZWwsABIcfDgHAoZ1HMCnhrmopGzh9nnU3x
	Sp42LzMxeWjGolH+PGAKepLcDui5tW00XwoHhIPXVfXIWGrOva8+2kH5ItApLp5uxi6V6cbg9wv
	aRmXy3aOfVH5tdoSUV8MvJnspBftqFn3y1IL36wyO32nJWSPpF171ozClwjdxmKppQiISPdXUr+
	lHwhnQvCruovBF8m+tobBeQWXuAPcktGUyFkYG1uFVg6aF4ZACGlp40tyRzARgv8KpM+Q3OhJZ8
	21bJ/hYXFKVbA9BwKtigIS4+8jXUaWgM00c2vbEdclrgsW2mwP6XnC5gyXQ9OP344q953zPk+rp
	KLMv/0mwx8yMrAaUsAfduycqHx5j0OsOw2mkukqTVy3zu/MXWPvwDhXvJyqtMdLQS1qSsF5YHtA
	OnOpU0RzZ3dwQgzu2ZnzCKVxxIKqJ5BkX2KTO+0B6tNqnEvLjvojuypKm9r1fnfg==
X-Received: by 2002:ac8:5988:0:b0:50b:4eb9:a97c with SMTP id d75a77b69052e-50e36bd6e6cmr429301921cf.15.1776965249137;
        Thu, 23 Apr 2026 10:27:29 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50fb11f9986sm82137441cf.22.2026.04.23.10.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 10:27:28 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:27:27 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org, 
	iweiny@kernel.org, pasha.tatashin@soleen.com, mclapinski@google.com, 
	rppt@kernel.org, joao.m.martins@oracle.com, jic23@kernel.org, gourry@gourry.net, 
	john@groves.net, rick.p.edgecombe@intel.com
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
Message-ID: <aepS0w2aeIh2xx0G@plex>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>

Hi Dave,

On 04-23 10:02, Dave Jiang wrote:
> This RFC series is created as a proof of concept to connect device DAX to guest
> memory by riding on top of guest memfd in order to prove out that device DAX
> can be used as guest memory. The series seeks to jump start a discussion on
> if there are interests in creating a DAX bridge to utilize CXL memory for guest
> memory until the N_PRIVATE implementation by Gregory [1] is available upstream
> and DAX users are ready to move to the new scheme. Once there's an established
> consensus of interest, we can move the discussion to the best way to implement
> the DAX bridge and the future of device DAX as guest.

I cannot speak to the CXL/DAX use case, but I can provide perspective 
from a persistence point of view. Currently, as a temporary workaround, 
we are using emulated pmem in DevDax mode for live update purposes. 
However, going forward, our plan is to switch to regular memory and use 
LUO + memfd/guestmemfd backed by regular RAM to preserve resources.

We are working on a patch series that we plan to send out in the coming 
weeks to preserve guestmemfd via LUO.

By design, all resources that participate and need to be preserved 
across reboots for live update purposes must have FD handlers.

Does your series allow DAX memory with 1G alignment (i.e. 1G pages) to 
back guest_memfd?  That is also an interesting use case, while HugeTLB 
support for guest_memfd is in progress, it still has not yet landed.

> I did the bare minimal to get the PoC to pass a modified version of KVM gmem
> selftest (guest_memfd_test) in order to prove out that DAX can go in the gmem
> path. A DAX char dev is created and the fd is passed in user space with
> vm_set_user_memory_region2(). The DAX region is passed in as a whole when used
> unlike memfd where any size can be passed in to be allocated.
> 
> The folks on the cc line are people that Dan Williams has mentioned that may be
> of interest to this.
> 
> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F/T/#t
> 
> 
> Dave Jiang (12):
>   dax: rate limit dev_dax_huge_fault() output
>   dax: Save the kva from memremap
>   dax: Add fallocate support to device dax
>   dax: Move dax_pgoff_to_phys() to dax bus to be used by dev dax
>   dax: Add dax_operations and supporting functions to device dax
>   dax: Add helper to determine if a 'struct file' supports dax
>   KVM: guest_memfd: Add setup of daxfd when binding gmem
>   fs: allow char dev to go through fallocate
>   dax: Add dax_get_dev_dax() helper function
>   kvm: Implement dax support for KVM faulting
>   kvm: Add daxfd support for supported flags
>   selftest/kvm: Add daxfd support for gmem selftest
> 
>  arch/x86/kvm/Kconfig                          |   1 +
>  arch/x86/kvm/mmu/mmu.c                        |  48 ++-
>  drivers/dax/bus.c                             | 132 ++++++-
>  drivers/dax/dax-private.h                     |   8 +
>  drivers/dax/device.c                          |  80 +++--
>  fs/open.c                                     |   3 +-
>  include/linux/dax.h                           |  15 +
>  include/linux/kvm_host.h                      |  39 +++
>  include/uapi/linux/kvm.h                      |   4 +
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../testing/selftests/kvm/guest_daxfd_test.c  | 329 ++++++++++++++++++
>  virt/kvm/Kconfig                              |   4 +
>  virt/kvm/guest_memfd.c                        |  92 ++++-
>  virt/kvm/kvm_main.c                           |   6 +
>  14 files changed, 711 insertions(+), 51 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/guest_daxfd_test.c
> 
> 
> base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> -- 
> 2.53.0
> 
