Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E3F288D1;
	Thu,  6 Jun 2024 04:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717649133; cv=none; b=GTkEDq9kcTiy10/VO3ZtoIhq6mUwdbJmcLzFsDEnghDx5Es4xcctEW/DFaUqbifCJgDUZbMa8sqPh6FrMFxCv7SiHqrFMqmRuLXLucaPh1gQVQ+ZD4ywS/eKlJtmoh2PE1LMqtKhwh64lEt8w6RB6f8CzGGHlrZMTirfReAL6O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717649133; c=relaxed/simple;
	bh=Zk1CzwA5ZfeEIP6vsC5vjX/lsrAFQyhVKO0sotfDfRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=stGa7EEUOTUTOi8dQQD/mx9buxZsN3Kpbe3210e+c9WGSAwukJ7j4lxzO6j+aP/kc1FLGeG/UGoqePyvkR8n4KnFXL2MmvFxth3VI/b7whyQGKfMHvYRL14Wi013f6r+QVvYUMDCp0KGLjJQxrcM1zWRbdIbRhe210YXiibEQWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CF6268CFE; Thu,  6 Jun 2024 06:45:26 +0200 (CEST)
Date: Thu, 6 Jun 2024 06:45:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Milan Broz <gmazyland@gmail.com>
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
Subject: Re: [PATCH 01/12] dm-integrity: use the nop integrity profile
Message-ID: <20240606044525.GA8395@lst.de>
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-2-hch@lst.de> <a5570194-920c-45d8-98d5-da99db0d2f8d@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5570194-920c-45d8-98d5-da99db0d2f8d@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 05, 2024 at 04:52:27PM +0200, Milan Broz wrote:
> On 6/5/24 8:28 AM, Christoph Hellwig wrote:
>> Use the block layer built-in nop profile instead of reinventing it.
>
> As this is my "invention", I am pretty sure that "nop" profile was
> not available at the time I was prototyping AEAD dmcrypt extension.
> (It was months before we submitted it upstream - and then nobody
> apparently fixed it.)

Looking at the history the nop profile was moved from nvme to common
code to also support btt in 2015, dm-integrity was added in 2017.
So maybe you just missed it.  Anyway, I'm also happy to tone this
down a bit, it sounds a bit too aggressive..

