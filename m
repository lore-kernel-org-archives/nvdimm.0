Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8902E16F0EA;
	Fri, 14 Jun 2024 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381011; cv=none; b=CelEx1510t9OG0o+zJCIuBcqSm+EqTlOj1ncFnMG2hPXx0UDe+LcCRbERQoyXRKgl2ULQxOuAGR9UfajX1PHrBWxYYHUZ+PQYmpTySup0sbCkqZNc1NfS9fTWKsDy4K2FD4SyDEJd/yA3QVbuxbE5/Ub+kmhAFVswTjB+o8bJBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381011; c=relaxed/simple;
	bh=y9KHOvoliQVhwac/rD6nLgSGHo9c8nOF6OxAfdCQZyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lapBJzg28NFXOxZoLhrWpQsw6hWTVgOAqDADkBqH2QEwXh1Bq2oO8ogZpHv8fpfFpM2VPHsd14Je+l/snAtxG0FfDJwVGxNvDYUt6Ua7bN+Essc0TXcJQXuzgITYk/mKud9c7k96vbxsvgtmfuujZowYZWzCSA6V+QQhlBIMvjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7D45068CFE; Fri, 14 Jun 2024 18:03:22 +0200 (CEST)
Date: Fri, 14 Jun 2024 18:03:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
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
Subject: Re: move integrity settings to queue_limits v3
Message-ID: <20240614160322.GA16649@lst.de>
References: <20240613084839.1044015-1-hch@lst.de> <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 14, 2024 at 06:33:41AM -0600, Jens Axboe wrote:
> > The series is based on top of my previously sent "convert the SCSI ULDs
> > to the atomic queue limits API v2" API.
> 
> I was going to queue this up, but:
> 
> drivers/scsi/sd.c: In function ‘sd_revalidate_disk’:
> drivers/scsi/sd.c:3658:45: error: ‘lim’ undeclared (first use in this function)
>  3658 |                 sd_config_protection(sdkp, &lim);
>       |                                             ^~~
> drivers/scsi/sd.c:3658:45: note: each undeclared identifier is reported only once for each function it appears in

That sounds like you didn't apply the above mentioned
"convert the SCSI ULDs to the atomic queue limits API v2" series before?

