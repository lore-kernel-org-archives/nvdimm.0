Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F7A8004A;
	Mon, 10 Jun 2024 11:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718020659; cv=none; b=jxl0/fL/78gNXpaVHZeLGruTP2+epbv8II7OvAHQLRoit5mCiMQTtRRf04ET5awNRbi5WC9aKt61dlIyuApgDr9HFYybqLxQLTtrABloX11O2go/8HW6og8SpUiFZqxSYLRNz1j51ssjSswFBsNKXGaxwtABvzAre7wSwintL0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718020659; c=relaxed/simple;
	bh=9kW/E4nZEehJip0LLdtTI5i6g2dQF7OvxqMMqsxqQZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfOfAHuF1K3MvH9NlerllU+NVuVXQDGqIOghSrRm+VYJV3+HZ7xScr1kO9J6UnxVYR/XjeR5eeSjuLqjVvISeiqxZuQM9cIYSXBkE76iaFZZSXc5PP643TkinThNgkCgP8QLtbk5hAgarC4y4TqR2x9dknEyItouT0sdrmC8xrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5778867373; Mon, 10 Jun 2024 13:57:33 +0200 (CEST)
Date: Mon, 10 Jun 2024 13:57:32 +0200
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
Subject: Re: [PATCH 03/11] block: remove the BIP_IP_CHECKSUM flag
Message-ID: <20240610115732.GA19790@lst.de>
References: <20240607055912.3586772-1-hch@lst.de> <20240607055912.3586772-4-hch@lst.de> <yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 10, 2024 at 07:56:00AM -0400, Martin K. Petersen wrote:
> > Remove the BIP_IP_CHECKSUM as sd can just look at the per-disk
> > checksum type instead.
> 
> This removes the ability to submit an individual I/O using a CRC instead
> of the IP checksum. There are cases which can't be expressed when
> the controller is operating in IP checksum mode.

Huh, how?
