Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0835171C4;
	Wed, 12 Jun 2024 03:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718164665; cv=none; b=lfiSsCdzFXQ5xj4u1XaAVJlWP3H1zcFoeu+Z0nVxsDsTqyBgPeptp5+81TAr9AXTwSOQ4DYGjhKJvQIfNqc6myVuSFO+qmwI8OUD3ZsgY31fNa/iT2rSl6Rc498YofH2jTjEjzSA9RTHpvdzbNFXshydeeHPaVFsRhKmRV6kKzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718164665; c=relaxed/simple;
	bh=IhxjPUwAUgy3BvcTsasVd3mBN/Vli4cyhD2IzJFw7Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGsfjckrcZ8GN+ZExgzo88ZpAGIve/dacToQLGYW2VSL3nYtwPXyjP6LlABaSO9JosLQ8CriT0nj8s+8ig6k0trl7GJhJQBoJq+04Os8QM69eS2HUEotxOiT22rnsx1ZlG/YxtEO63YttnZyW8uLPO0H7pVxoHpQHWQ8saxQ4fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4E89F68BEB; Wed, 12 Jun 2024 05:57:39 +0200 (CEST)
Date: Wed, 12 Jun 2024 05:57:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 02/11] block: remove the unused BIP_{CTRL,DISK}_NOCHECK
 flags
Message-ID: <20240612035738.GA25785@lst.de>
References: <20240607055912.3586772-1-hch@lst.de> <20240607055912.3586772-3-hch@lst.de> <yq1le3d3ua9.fsf@ca-mkp.ca.oracle.com> <20240610115118.GA19227@lst.de> <yq1tthzz29i.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1tthzz29i.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

I can just leave them in for now.  Or I can remove them and we add them
back with the right polarity and support in nvme when we add an
actual user.  Either way is pretty simple unlike the weird ip checksum
thing.

