Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C00D2AF16;
	Wed,  5 Jun 2024 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603260; cv=none; b=mA9DS5IlGaY0pbUgMR18laJqo1lTre7Xm4ZuFdzpipfSL5lDPg/qsG55c4kSd7iKyRZ8qtHaFHUtx0jrtC6LyboD7cDErhy2sF98OWjfdoVVtxRVrCR5ZPDJT4OISWrD2r5P66CHAUY33o6OoP+d1GqCyeIcGwQDflqxzgEkmis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603260; c=relaxed/simple;
	bh=SrI+71rKl1K55T4g8XU6Gvy25ryGeT0fvpfwcj0HJCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6wr2O3UGZdLRHFevVRbWnIoDJLzN1felZ46rBKXbuy4Au+1JhqMcgcttO60kDcR8Q9o6J7vSGdh5yeR8Tz/wtfZOF1JvgzNOtQNFn8lN+fYDu2e+lbiQbrCJjHtHrFyyxTXYlNeE53MoP3bSM7vdrCjY45uYyaToDQEINnnDmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHUeSONo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHUeSONo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BE6C2BD11;
	Wed,  5 Jun 2024 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717603260;
	bh=SrI+71rKl1K55T4g8XU6Gvy25ryGeT0fvpfwcj0HJCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jHUeSONoFrp3K20BeziXOsfGHdN9+CvCafPknjBXdJW+EfKtGiK5+3WI/vwdj1EyD
	 MO80yupTQMqjZGPjwp+VHixRfN1Pg6SFZtqced7+XJIyys+mkew9jCEIFl5hIUertr
	 RICZQAJCDC7XrX95B7TPOSlnPQQEylrVMvJB8F8eS89M/ROim6kRRVi/qVdMjLUXnP
	 brQguPtw3afEfUMvmO5w9YJFgz82e4A+n63cXuHixDXKyVLiKDmunhmgXR0U5OD1RZ
	 vxfMXVa850T6ypr1vB4zSzkoE+yc4G+UL5KWOpKHW7TizUNts2XQVS3v4pN96lCiIg
	 P8//SmpLJ2DCQ==
Date: Wed, 5 Jun 2024 10:00:56 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/12] block: use kstrtoul in flag_store
Message-ID: <ZmCLuFEjvb-BejMT@kbusch-mbp.dhcp.thefacebook.com>
References: <20240605063031.3286655-1-hch@lst.de>
 <20240605063031.3286655-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605063031.3286655-8-hch@lst.de>

On Wed, Jun 05, 2024 at 08:28:36AM +0200, Christoph Hellwig wrote:
> Use the text to integer helper that has error handling and doesn't modify
> the input pointer.

Looks good. 

Reviewed-by: Keith Busch <kbusch@kernel.org>
