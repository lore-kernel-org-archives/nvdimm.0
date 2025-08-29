Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D9B29BD97;
	Fri, 29 Aug 2025 07:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756454237; cv=none; b=DVw9kmgnjo3fkBIKnBz/D2ehyTU7m2tikLXV7c2vsEyNnvC5AdHTjxX70UHkIgWS4XPEfm691wBGbDZ+6DdD8PpAkHUnn6kLivvn9Tp9SikxRHQr7YuDK/pbxOurffQFw32qiD0GzumjL9CvEEgFPqd9M850pILmVi873OkT5go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756454237; c=relaxed/simple;
	bh=MkzmS5fzDy6nMNEI2R0lYWY4fh1AFCRX/InvS81aY/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+Y0N5+Rz7+SkPDyGL70hzNyHbnyLFLtDV1Agno5QC/WcGPHg29ZlWwIDiYjDYTJJQ31Md+NYZTKv2oXUPFmKy7MHssgRoXPGvVgf85NTEEHV3d09A15Cgbi9Sx5b+yco+ZTK+xPD88z2G7jh8F+W3R2fwO5beXAMMdGLgKRcpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5k+zUHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5k+zUHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E957C4CEF0;
	Fri, 29 Aug 2025 07:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756454236;
	bh=MkzmS5fzDy6nMNEI2R0lYWY4fh1AFCRX/InvS81aY/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q5k+zUHBtzIK4EotrgLiBEfZHgHeJK+jJ/kj1vHiowR1OSRr2Anvt1F12D1TLCS9x
	 zngFdVCJYPcH4thYLQskxL8v6L8zPKtF3AWmMzmZuaKJfnul4aMFbXPtJS7F6UloIf
	 BmkaoQOR4lGslEvs+jRPSDPlShJJnj8N7ksPngaAWob5jQQ49qmC512ifyOaBK/jt5
	 w4ZUj1QYl/4E7wNj1ItlU+jSCo3O7yF+AJtt9H4wp8yR0ucacg+j4jltTpj8lD2kC4
	 Equuyzsi+DmdjlaVFHc2ZcGoJRFsps33624yIfPgBrhc7qEqbJGlMr8KXPi/TCx6UR
	 GD62qhjSG40zw==
Date: Fri, 29 Aug 2025 10:57:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Michal Clapinski <mclapinski@google.com>, jane.chu@oracle.com,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Message-ID: <aLFdVX4eXrDnDD25@kernel.org>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>

Hi Ira,

On Thu, Aug 28, 2025 at 07:47:31PM -0500, Ira Weiny wrote:
> + Michal
> 
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
> 
> While I recognize this driver and the e820 driver are mutually
> exclusive[1][2].  I do wonder if the use cases are the same?

They are mutually exclusive in the sense that they cannot be loaded
together so I had this in Kconfig in RFC posting

config RAMDAX
	tristate "Support persistent memory interfaces on RAM carveouts"
	depends on OF || (X86 && X86_PMEM_LEGACY=n)

(somehow my rebase lost Makefile and Kconfig changes :( )

As Pasha said in the other thread [1] the use-cases are different. My goal
is to achieve flexibility in managing carved out "PMEM" regions and
Michal's patches aim to optimize boot time by autoconfiguring multiple PMEM
regions in the kernel without upcalls to ndctl.
 
> From a high level I don't like the idea of adding kernel parameters.  So
> if this could solve Michal's problem I'm inclined to go this direction.

I think it could help with optimizing the reboot times. On the first boot
the PMEM is partitioned using ndctl and then the partitioning remains there
so that on subsequent reboots kernel recreates dax devices without upcalls
to userspace.

[1] https://lore.kernel.org/all/CA+CK2bAPJR00j3eFZtF7WgvgXuqmmOtqjc8xO70bGyQUSKTKGg@mail.gmail.com/

-- 
Sincerely yours,
Mike.
