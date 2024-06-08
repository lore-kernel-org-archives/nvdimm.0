Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E81FDA;
	Sat,  8 Jun 2024 05:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717823428; cv=none; b=A6nmFxIfmSn6BtBcObvUw74N1xZaPwMEQIetsSaf2m3V7vkhMjk43PSDFupM1koufj3JRzLPY22arFzAv6U9Jx82rg0zdP3CbQMDF4ToIQwhtc1DHKWm7XKV1dTpCIpQSzhZ8R1WpcDIlBBfV+7Q77yjCPDF8P8tWDmXKFdRWCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717823428; c=relaxed/simple;
	bh=LcO1iRhj+p2foFEfQqNRcpOV9bbj+m8SiMAVM4hl/qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knLWKZzuZJ57DL12QzipkulzBmXYZX5FEP/SOGEgzmU8HqBa25Xp+TO2GKeowaL+ZTc2N1BxrpVP8Sot/sz+jkegtV6UzvysLUSDZLwpk8cI0RnRUmlmTdIPwVt2bYAHriiQau1xLWlRINywuvUtkCAojh1RTytybUPtpvb6dWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F9AF68AFE; Sat,  8 Jun 2024 07:10:23 +0200 (CEST)
Date: Sat, 8 Jun 2024 07:10:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: move integrity settings to queue_limits v2
Message-ID: <20240608051022.GA23972@lst.de>
References: <20240607055912.3586772-1-hch@lst.de> <ZmMqfj3T9Ft680j6@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmMqfj3T9Ft680j6@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 07, 2024 at 11:42:54AM -0400, Mike Snitzer wrote:
> > For dm-integrity my testing showed that even the baseline fails to create
> > the luks-based dm-crypto with dm-integrity backing for the authentication
> > data.  As the failure is non-fatal I've not addressed it here.
> 
> Setup is complicated. Did you test in terms of cryptsetup's testsuite?

I didn't realize cryptsetup has yet another testsuite..

> Or something else?

I just followed a random guid on the internet on how to set up the
authenticated encryption, wrote a script to do it and used that for
testing.

