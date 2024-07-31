Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CF91B3724
	for <nvdimm@lists.linux.dev>; Wed, 31 Jul 2024 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722441197; cv=none; b=emY6q4kJtBzjh5KHMP0ZR32xf52axegmPyrexR2dZPl5SjDsRTdgNKbsBCBdotNytGqw/OHQIqMdlGcDlRME2pJwmhpURh85C+tNb3T/bD9VRVa9GqxW1Ylz8yoj9h7EekR5VJrP7Q22rxaKNAs/C/6Oxi5vU4efdqziJAWUJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722441197; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYjxJS0tpWb+Jkvrmh/5O132DhMAfWAyodTtpIKXcVc/KzKsfvo/7FHDAOMl7CrDywoELG9BS4K6byH9rseA8baExTKyokGS1lmSo03/x2tw3YfAEeBWW/mKqsPHRXvIeVU7ihh2l4wMLjAwTOHbgjiwvlev5jHhglOvO7vA4I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6E5568B05; Wed, 31 Jul 2024 17:53:03 +0200 (CEST)
Date: Wed, 31 Jul 2024 17:53:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, hch@lst.de, ira.weiny@intel.com,
	dlemoal@kernel.org, hare@suse.de, axboe@kernel.dk,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvdimm/pmem: Set dax flag for all 'PFN_MAP' cases
Message-ID: <20240731155303.GA23096@lst.de>
References: <20240731122530.3334451-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731122530.3334451-1-chengzhihao1@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
