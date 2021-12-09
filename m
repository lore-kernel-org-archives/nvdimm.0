Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67E2C80
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 18:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D11DC004DD;
	Thu,  9 Dec 2021 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1639073970;
	bh=UdeYhbV9l0tKRDbL8vuhki8dKl96fnKdID+Dmx0iHX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JqrIC9zfMsQL56VD9xW56jg4+Kc1bWrcHWS3B8l8UytVcC25ZXMnRTLe2WrVP0/jC
	 QTBFwNN2L3HwVz+xvMKuIj4TQcAc+0mE0hY0fMZ+oMl7CZvHUxGnqpPtBYinDbuAtE
	 t2pXC3ND1Z+THDP/f5E1H3aTIKZzPj+O3kH8rW4ALMDEFK6rvsia1ejM/OrNVVNuB/
	 YVbkfu+c/BDJJZp92JArW42vf+vBbcNeszepPrIQiYEV3pytQipLE7F9GeLjG2vYYd
	 nmH+rpD1yTJttJPqMGE5jxLGVEqoxc7iv/QFRjQglvvI9FBCCQo9PhKYxIFOsTADt1
	 HlvGUWERLEiAQ==
Date: Thu, 9 Dec 2021 10:19:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dan.j.williams@intel.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] iomap: turn the byte variable in iomap_zero_iter into a
 ssize_t
Message-ID: <20211209181929.GC69235@magnolia>
References: <20211208091203.2927754-1-hch@lst.de>
 <20211209004846.GA69193@magnolia>
 <20211209005559.GB69193@magnolia>
 <20211209061118.GA31368@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209061118.GA31368@lst.de>

On Thu, Dec 09, 2021 at 07:11:19AM +0100, Christoph Hellwig wrote:
> On Wed, Dec 08, 2021 at 04:55:59PM -0800, Darrick J. Wong wrote:
> > Ok, so ... I don't know what I'm supposed to apply this to?  Is this
> > something that should go in Christoph's development branch?
> 
> This is against the decouple DAX from block devices series, which also
> decouples DAX zeroing from iomap buffered I/O zeroing.  It is in nvdimm.git
> and has been reviewed by you as well:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending

Ah, ok.  IOWs, this is a 5.17 thing, not a critical fix for 5.16-rcX.

--D
