Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0875119E7E8;
	Fri,  7 Jun 2024 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717771957; cv=none; b=Xk2ArpTn4PVDYv3TcQCw2PnzkJ9G5KjhW13zAuqKWR3p22x3ZHcQ6pJ2f20sM4BoeM6XSlJ7UMzcSNLkoNFAXcL5JlLEeDDDc3nKccJo3l9KrIX1kyXVP/l28KTHfHwThhF1sHpiHXddHE1hKJHADCO02xyRTu8POJjgjcpaNRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717771957; c=relaxed/simple;
	bh=kip7cU4LQ/stecxCbdZCbu/gCVxB0BN8MSUuhLHblTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nrKBLyHkrGH08Z1LtWPMaQWMTrzmUEw4BhC+lDuXVWhamW/FKS+DRLgDitCJEcLGf2ei2TU9XVxaE+K19LyT/OUSc9AZtxetxJb/IPa0XT8BGuT2VfcC6BxpV7M8CiRJaUAY+WFn8t3aJPDPoHcR7Cqa8Lybq2ojraCfcVoQmOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CD7F68BFE; Fri,  7 Jun 2024 16:52:21 +0200 (CEST)
Date: Fri, 7 Jun 2024 16:52:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
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
Subject: Re: [PATCH 11/11] block: move integrity information into
 queue_limits
Message-ID: <20240607145220.GA7073@lst.de>
References: <20240607055912.3586772-1-hch@lst.de> <20240607055912.3586772-12-hch@lst.de> <8cd46b95-bfdf-42a4-809f-36ff88062322@suse.de> <1c4e6c61-fc39-4f59-a103-761984d98b18@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c4e6c61-fc39-4f59-a103-761984d98b18@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 07, 2024 at 09:35:02AM +0200, Hannes Reinecke wrote:
>>> +?????? if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY)) {
>>> +?????????????? pr_warn("integrity support disabled.\n");
>>> +?????????????? return -EINVAL;
>>> +?????? }
>>> +
>> Why is that an error?
>> Surely 'validate' should not return an error if BLK_DEV_INTEGRITY is 
>> disabled and no limits are set?

Look a few lines above, we'll never get here if no tuple_size is set,
which is now the indicator for metadata support.

