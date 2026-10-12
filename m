Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E0D3EC686;
	Mon, 12 Oct 2026 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815085; cv=none; b=olyOoI82HeGGbOB9zcXl3c7Fsp8zTJDSmvc9cv3wpD7Uymlw5fdgCLzcGUwmkeFUJns8JBn6YowL1mMw11Y1phEuaRMC76fVad4ypjrDOllmayK/6pSDb1RQqHQOlvObdk7cZ49u2A1ZU3RnauvHhUDTsQ+CxQ+7JC8A0O9uPrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815085; c=relaxed/simple;
	bh=UMYMVXCrg+F8bY125eegoHGmmRT2g9mVeznosBzD0VM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gv6ML8kbrRvQzSK5Y6+BIV/yaleTpvqQR6YvpIVu9b5FqXz9CZ6STqXvvXsk9bo/TAcfak0bpSPiJkDLGUPtKHIpYZ+3d01baMOFNAoYIhtPs1m4oA/D3+NSdW9koFhB56/611fjZSZtSkhlYkLXLKJ7ffr7oHmqnkHyR7NYYc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HAzgukHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAzgukHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3CD1F0089B;
	Mon, 12 Oct 2026 14:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791815084;
	bh=oLGTah0Myv6xnD2mOC2v3bmy8eKCjRM8dmAORto3RXg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HAzgukHTtKWN2TiJ3BdphPpLYxAxFpm0SxD/TqbyEsimPoxP7oUWJ5ne5b7anE08w
	 4jCNcZNvHmAJUqNe7+ZXopAT9QLh+a3DWa5OKNScmw/bA9ehTFOiTTPY+wDzNi++p6
	 phztf/Dd9DbEbKugqoO1ffjlU/Ktheg79a8VLxVuaHo+kfHfyzs/Ds+eUdUHPitsfk
	 8E2godHwCcnz9+WAuZa9+sb437XtEDlsMoBD6SoMXBS7QUyZHoeRBwsfHL+kfMAUHH
	 xBQlyZ6QnRRxOEZJlOgezx4G/n2jbTlKRXx03nslsDy27p86zbWGNMbcm8cz7TSZt8
	 8YS3T6FvtyiWQ==
Date: Mon, 12 Oct 2026 15:24:27 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
 <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
 <ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, Anisa
 Su <anisa.su@samsung.com>
Subject: Re: [PATCH v16 0/8] DCD Prep Series
Message-ID: <20261012152427.43d304a5@jic23-hlaptop>
In-Reply-To: <20261010225852.10727-1-anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Oct 2026 07:54:51 +0900
Anisa Su <anisa.su887@gmail.com> wrote:

> These are the first eight patches of the Dynamic Capacity Device (DCD)
> series. They set up: DCD enumeration, CDAT handling for DC partitions,
> the event interrupt plumbing, a preparatory refactor, and
> documentation of the DPA partition layout. They stand alone and keep DCD
> disabled. They are not dependent on the rest of the series.
> Patch 1 detects the 48h command set and then leaves mds->dcd_supported
> false. The flag is only turned on by the series that adds DCD event
> handling, so every DCD specific path added here is shut off at runtime:
> cxl_configure_dcd() never runs, no DC partition is created, no DCD
> interrupt is armed, and the CXL_PARTMODE_DYNAMIC_RAM paths are
> unreachable. The intent is to land the enumeration and plumbing while
> the extent to DAX pipeline is still under review.
> 
> Based on v7.3-rc6
> v15: https://lore.kernel.org/linux-cxl/20261007201828.952-1-anisa.su@samsung.com/
Hi Anisa,

For me, only that tiny reordering of the __free(kfree) and related pointer declaration
needs fixing before this merges.  As I mentioned in that patch, maybe Dave
would be willing to tweak that - obviously that also depends on what responses
you get from others!

Thanks,

Jonathan
