Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F2C482C3;
	Mon, 24 Jun 2024 08:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719218150; cv=none; b=lR7rjpSzd5kYBo9lnTJgxrbiGAbGMqp6Qkjgi1qCfIctfwi773YaM39ITItE4qands6uaZFCgMy+ZxeV5k46B4Rf46vJiQ+7pKxiQ3/6FGRRSJFHKHFX5SE0drdgD21v0u6CYoif3ge3ZneZmf4x7AYlu0OxnLnWJUKCMV5rbnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719218150; c=relaxed/simple;
	bh=iQaPBQWjPOQlK9q4eiAviREeWvCKzzUxahs3Qk1DZfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr4SKa/xXVMwIQmKS8LrVhqppz2AaIQFOMgkIV217iOar1wWvK0VMeK5HRDPgcDY9x1RgY410jwXaqF4ipiFw8fsauOvWCgGf5Cz6Ld4YwYQEMNlrHVgjoNIsAVsk9eKyy3ryZKMfdPX0+kJJZhSj1vzrHVcasRXyf1MSDGC5fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7971768B05; Mon, 24 Jun 2024 10:35:38 +0200 (CEST)
Date: Mon, 24 Jun 2024 10:35:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: kernel test robot <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com,
	Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>, linux-m68k@lists.linux-m68k.org,
	linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
	nbd@other.debian.org, linuxppc-dev@lists.ozlabs.org,
	ceph-devel@vger.kernel.org, virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	ying.huang@intel.com, feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [axboe-block:for-next] [block]  bd4a633b6f:
 fsmark.files_per_sec -64.5% regression
Message-ID: <20240624083537.GA19941@lst.de>
References: <202406241546.6bbd44a7-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202406241546.6bbd44a7-oliver.sang@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

This is odd to say at least.  Any chance you can check the value
of /sys/block/$DEVICE/queue/rotational for the relevant device before
and after this commit?  And is this an ATA or NVMe SSD?

