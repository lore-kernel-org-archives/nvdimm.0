Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9398A3A8CB;
	Thu,  6 Jun 2024 04:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717649500; cv=none; b=enjIG9GL2QyNBL5ZlD5S9QTt/S7IOggEFIBx7P4w41YZsr0PZrwEUbdMqxnn4uyJJmZq1aN1kaiB3nYLgHHuuYTqKLxHJNtbboTG3fxDgKrkZGXgowz8pC3ZOE7nHSiqMA1kpYoo4faRlDbCoQ3/78k9+FQ+OIUyLDIi0sYUFQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717649500; c=relaxed/simple;
	bh=B+WJSpctEPZ8zi7YTS22V3d96uUBzPNLeiUi2npSWG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DHECHcFSZ6734fjIe6vy6qxo23rubIoPrGP4tdKLEDvXhyY9hP1zEw8J3fuKgbz/zrnuVc5wCLNdVqFTUjcNzUP+bl0Rj1JC4k/CmAow3h9z9cmMkfN2iC7NVRDc9ApbWdeFLp+ZBFv9LZcytUek3HafvTXz/mxiPbUh53bkhfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 78EBA68CFE; Thu,  6 Jun 2024 06:51:36 +0200 (CEST)
Date: Thu, 6 Jun 2024 06:51:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/12] block: move integrity information into
 queue_limits
Message-ID: <20240606045136.GD8395@lst.de>
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-13-hch@lst.de> <3e49207a-1efc-4fe6-99c2-8cdd9c24664c@acm.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e49207a-1efc-4fe6-99c2-8cdd9c24664c@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 05, 2024 at 10:56:20AM -0600, Bart Van Assche wrote:
> On 6/5/24 00:28, Christoph Hellwig wrote:
>>   	if (!dix && scsi_host_dix_capable(sdp->host, 0)) {
>> -		dif = 0; dix = 1;
>> +		dif = 0;
>> +		dix = 1;
>>   	}
>
> Although the above change looks fine to me, it is unrelated to the
> other changes in this patch?

Yes.  And earlier version touched this more extensible and this is what
is left of that.

