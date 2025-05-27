Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B755D1ACED9;
	Tue, 27 May 2025 13:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748352360; cv=none; b=GFiibJ5mRt7TznuVHMhPRjHha+GCio423Xs0XKVcDn7dzg2X26SKEPi13tcgqTvzz4tDA3Lcjif1Z+0q6IOr6cKtZuxWkDqLmfjow5gcfCFtv2JMUOCBNQHVi4jvTi1NYXiNm8qiOwbi7+VLnxKmYtWaf9CPUfQTPXa3Z1ERzQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748352360; c=relaxed/simple;
	bh=RJZrjlZXyF2IEyk45tZVLBAEfHaJeaF88xrgOYA4D9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwLsthoAyiX+WL15WbpElulBR/Qt8O7iS8kcuiYsqnDCQdx8DeD3rSEPBjeSQYkGJIogPwltrLXQIbrXTuFKxNxnlRpvKiOGhshpvDDNbxsoHSi8hc29cOTCiH3b7l497xaGvZYjpfIw3/pIwWqaQn5lSEOE/x+ID2dgXuzM9+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXuaWA2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXuaWA2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF88C4CEE9;
	Tue, 27 May 2025 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748352360;
	bh=RJZrjlZXyF2IEyk45tZVLBAEfHaJeaF88xrgOYA4D9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fXuaWA2TjqMjpqvK8uJbUl1dUHB8Dq7WIOcO4O8pSnnhGpYuXPQaQcs8SzLFZoh5Z
	 97P9pFajTEqwuagTGvgdRuKBDpbU7axVuFJA2CI36xHsGwRY877Ywstr6AwtLUT3Za
	 PTF1mE2BUyUJHV+ihfNBVv5lPsPdsuLJfhNUcUNPsbK3FR8/V5ZzxYfEYfNlO8ZwPY
	 +P7Obe+q5od1kiRvY8lBN6Jf4zVF9UwUe9hj7dj8mrXFa9bBmThgOPpb8rw+Jg1/ir
	 MIDjN2mf0c9WyYVZENEbUU+Xr+dloN1i6diuYiQkopPpKAFCnxdPF+6DV1Khjili9Q
	 2+kgyLidpun3g==
Date: Tue, 27 May 2025 16:25:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Michal Clapinski <mclapinski@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jonathan Corbet <corbet@lwn.net>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
Message-ID: <aDW9YRpTmI66gK_G@kernel.org>
References: <20250417142525.78088-1-mclapinski@google.com>
 <6805a8382627f_18b6012946a@iweiny-mobl.notmuch>
 <CA+CK2bD8t+s7gFGDCdqA8ZaoS3exM-_9N01mYY3OB4ryBGSCEQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bD8t+s7gFGDCdqA8ZaoS3exM-_9N01mYY3OB4ryBGSCEQ@mail.gmail.com>

On Mon, Apr 21, 2025 at 10:55:25AM -0400, Pasha Tatashin wrote:
> On Sun, Apr 20, 2025 at 10:06 PM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > Michal Clapinski wrote:
> > > Currently, the user has to specify each memory region to be used with
> > > nvdimm via the memmap parameter. Due to the character limit of the
> > > command line, this makes it impossible to have a lot of pmem devices.
> > > This new parameter solves this issue by allowing users to divide
> > > one e820 entry into many nvdimm regions.
> > >
> > > This change is needed for the hypervisor live update. VMs' memory will
> > > be backed by those emulated pmem devices. To support various VM shapes
> > > I want to create devdax devices at 1GB granularity similar to hugetlb.
> >
> > Why is it not sufficient to create a region out of a single memmap range
> > and create multiple 1G dax devices within that single range?
> 
> This method implies using the ndctl tool to create regions and convert
> them to dax devices from userspace. This does not work for our use
> case. We must have these 1 GB regions available during boot because we
> do not want to lose memory for a devdax label. I.e., if fsdax is
> created during boot (i.e. default pmem format), it does not have a
> label. However, if it is created from userspace, we create a label
> with partition properties, UUID, etc. Here, we need to use kernel

Doesn't ndctl refuse to alter namespaces on "legacy" (i.e. memmap=)
regions?

> parameters to specify the properties of the pmem devices during boot
> so they can persist across reboots without losing any memory to
> labels.
> 
> Pasha

-- 
Sincerely yours,
Mike.
