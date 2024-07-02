Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BC074047;
	Tue,  2 Jul 2024 07:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905532; cv=none; b=OvO62cmax8M2GKtAhZTpx9uYAp1LE5T0i5QOMKQKt82Eu7XVrUikK8vPHYl4XLzfTAx6yZ0ZA6X9b6iNH7QdXsAC4p0NtgpGCGOxfX3+tImdOSMlk5o28pxMgDoUxd6ZEJwaVEY/B3KabdPI4RkpGgRGUQoEjFfgSNoRiMbEx0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905532; c=relaxed/simple;
	bh=+sMR8Y+fELBV98VkEZAmEYgkVwqnEdYtSXSzNoB2jX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEgNYpEfVRJpi3fpemItYdBPZC818qgDpHPv++lA20MSyP3ZtHMJxN7DJLhv41LQOGinttCvLdRvuQls6x06GeWz5hPzqtcO96aPbabEizIAQMVGY3qJdn7dGDh7E7qygiHavAq8eeyRPdOJLjcn9a4pPGFFvm1/ysaGMTzY3DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nxBkkv55; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nxBkkv55"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yRJduJ4b13YGEVnBaImf8MBMoj+rPcyZfPfJ5uybrn0=; b=nxBkkv5533e0ibSUtWu/FWqca9
	T02UNeMXerA742jTnmxcJDpprQYJhN+AB5mjSyF1tkFtaC9NWv/DI0JPbLwQgi37wPeed5cA37c0e
	+2f4q+qCCkqKwjebfWNgYqdh3KcmHS4SeimB2eXIojre3wqBiKfJ74iCTIY0nzAi/62xdvvQQ9QVV
	ggumCBVJg78P9RdScYdX17RSGD42SxwMGXnk/F0Te2sI20BEGRBsqQOtoGA/KEqDDyMxAk9wtOs1O
	z/1WMLlWsZ6latPxKW85ISPYOrT1dPDdYNH/mzAspCJntQyhFPayqTd56frrg1OjYGXYjfO03yN/a
	E+Zh4hIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sOXzk-00000005s56-0D5a;
	Tue, 02 Jul 2024 07:32:08 +0000
Date: Tue, 2 Jul 2024 00:32:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Oliver Sang <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, oe-lkp@lists.linux.dev,
	lkp@intel.com, Jens Axboe <axboe@kernel.dk>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	linux-block@vger.kernel.org, linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, ying.huang@intel.com,
	feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [axboe-block:for-next] [block]  1122c0c1cc:  aim7.jobs-per-min
 22.6% improvement
Message-ID: <ZoOs9wdR1yBPB-7J@infradead.org>
References: <202406250948.e0044f1d-oliver.sang@intel.com>
 <ZnqGf49cvy6W-xWf@infradead.org>
 <Znt4qTr/NdeIPyNp@xsang-OptiPlex-9020>
 <ZnuNhkH26nZi8fz6@infradead.org>
 <ZnzP+nUrk8+9bANK@xsang-OptiPlex-9020>
 <ZnzwbYSaIlT0SIEy@infradead.org>
 <ZoJnO09LBj6kApY7@xsang-OptiPlex-9020>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoJnO09LBj6kApY7@xsang-OptiPlex-9020>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 01, 2024 at 04:22:19PM +0800, Oliver Sang wrote:
> from below, it seems the patchset doesn't introduce any performance improvement
> but a regression now. is this expected?

Not having the improvement at least alleviate my concerns about data
integrity.  I'm still curious where it comes from as it isn't exactly
expected.

