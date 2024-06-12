Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0B4171AF;
	Wed, 12 Jun 2024 03:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718164290; cv=none; b=RgW8Zv7gmJbRroZ9+DqbrtE9kOKsXKV2DQmrD7kTfy8YEmtj6haCNvYGbS3GnK6Z3i/QVPWH6YvhwzOlR9uKHwzhN1Ql7TKk6Xt72S+y1nSm8cTzX/jhqCjvG9N9rv6yJCskzczUxDHRRiV8ymO4mk4Ac9/4h+z22xFDHjxnBMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718164290; c=relaxed/simple;
	bh=6Twxmo74kVovFj8rxnK9Uuywnv2S78doxsxTX+lmq3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGOeXkWdagmjbAp6DsMFree9Xv9N3+PKGQ96BuvuLLibdOxDvvzG7DHeot1TqFDQwkvapdd4DzWRShSXVgPIBzGd8dkjDrRvEm9O7v9+NYRrrlgFVdDiEIvFAAQ+FtHzYNPWyEHLa9c8FLy+YZJVMQL36gbHwQceIGRm+erTwWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 939CE68BEB; Wed, 12 Jun 2024 05:51:22 +0200 (CEST)
Date: Wed, 12 Jun 2024 05:51:22 +0200
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
Message-ID: <20240612035122.GA25733@lst.de>
References: <20240607055912.3586772-1-hch@lst.de> <20240607055912.3586772-4-hch@lst.de> <yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com> <20240610115732.GA19790@lst.de> <yq1bk492dv3.fsf@ca-mkp.ca.oracle.com> <20240610122423.GB21513@lst.de> <yq1zfrrz2hj.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1zfrrz2hj.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 03:51:27PM -0400, Martin K. Petersen wrote:
> > But how do you even toggle the flag?  There is no no code to do that.
> > And if you already have a special kernel module for that it really
> > should just use a passthrough request to take care of that.
> 
> A passthrough command to the controller?

A passthrough command to the LU that has a mismatching checksum.

> > Note that unlike the NOCHECK flag which I just cleaned up because they
> > were unused, this one actually does get in the way of the architecture
> > of the whole series :( We could add a per-bip csum_type but it would
> > feel really weird.
> 
> Why would it feel weird? That's how it currently works.

Because there's no way to have it set to anything but the per-queue
one.  

> The qualification tool issues a flurry of commands injecting errors at
> various places in the stack to identify that the right entity (block
> layer, controller, storage device) catch a bad checksum, reference tag,
> etc.

How does it do that?  There's no actualy way to make it mismatch.

