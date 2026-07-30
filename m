Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB863AFD16;
	Thu, 30 Jul 2026 11:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411387; cv=none; b=nKRa0LR8pIVYIlZZPI4iCMqpqb/gsL1RsqoGSTsQAM/FWvza5ukSo82IjY4RxDSAJPcb7BguuCymvUN9QLBERdlDGCNZTRiKWFcaZKATWS1dzOggVEEayCSkeYKLYEVkR7SuRLLXQLLqDwfFFyuRG+kDShFoz192pFS4yVTdK1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411387; c=relaxed/simple;
	bh=zLysCEEqoEuWyM6opQgluK5L0ojRhH4UN4NK8AHNaik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=MllZcHfvKioAX+u6vs9Lpgr61IP0sotV0y2UaC1N6kmPH/T6fu54VRnFkYyui3lp0SwlpcP3bN809a4eLzpg2wervCr3MokZril8s5mmN7/jaLNtsv/L3YgznaOMnX5BMVhSkpAN7qjKwOhbhtSYB/IxrEIuM1AADbnQYJHa/hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=G1m0nOj5; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G1m0nOj5"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260730113622epoutp01cd551f2ca3195d893edf957daba54315~HDjFDmUL01609216092epoutp01Y;
	Thu, 30 Jul 2026 11:36:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260730113622epoutp01cd551f2ca3195d893edf957daba54315~HDjFDmUL01609216092epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785411382;
	bh=mERFm4283SSrRFHo9/1ATS072a+0UIQwbggX9r32jfU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=G1m0nOj55iDA9Dd+o78RP1b6wsb5owePEsyB2HLZpWZ6TNjoaPNBKS3Bl9iVZZRQV
	 leVdqeIcsnTbKQnqgOQLWCGR3KeuMAqMAHOvOQ5XtXOayIBD6utXS6XH8KTkELKZgr
	 zEcrc4MUK5bcbMdqpy2eFgv3VLAU+aJAnTZlwZ/4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260730113620epcas5p2cd2dd6e62a21b0504d36dfba298dab5e~HDjD3F8l_1787417874epcas5p2O;
	Thu, 30 Jul 2026 11:36:20 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h9nGC3jq9z6B9m4; Thu, 30 Jul
	2026 11:36:19 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260730113618epcas5p2fa034480e41d3e4e7b6c61c98a1ee498~HDjB8riTb1788217882epcas5p2K;
	Thu, 30 Jul 2026 11:36:18 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260730113614epsmtip13123c94af622f6e0e15c09cb30ff8023~HDi9_RAYA0540705407epsmtip1s;
	Thu, 30 Jul 2026 11:36:14 +0000 (GMT)
Message-ID: <09134617-6d9e-4963-9319-1855e88a4df9@samsung.com>
Date: Thu, 30 Jul 2026 17:06:13 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
To: Pavel Begunkov <asml.silence@gmail.com>, Caleb Sander Mateos
	<csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph
	Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, Alexander
	Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Sumit Semwal
	<sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>, Jason Gunthorpe <jgg@nvidia.com>, Damien Le
	Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin
	Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>, Ilya
	Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <de4ec386-42ba-41c3-bcbe-1fe8b2f71ba9@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260730113618epcas5p2fa034480e41d3e4e7b6c61c98a1ee498
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260730104131epcas5p4b52720519486f7ac774c317923a79c81
References: <cover.1785274111.git.asml.silence@gmail.com>
	<19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
	<CADUfDZpwF0jp2e=+c3w_NjWPbnQ858bkSD731M6+x27jzgcJiw@mail.gmail.com>
	<CGME20260730104131epcas5p4b52720519486f7ac774c317923a79c81@epcas5p4.samsung.com>
	<de4ec386-42ba-41c3-bcbe-1fe8b2f71ba9@gmail.com>

On 7/30/2026 4:11 PM, Pavel Begunkov wrote:
>>
>> I wonder if it's possible to perform the PRP list page allocations and
>> initialization in nvme_dma_buf_io_map() instead of the I/O path. The
>> NVMe dma_pools are per-NUMA-node linked lists protected by spinlocks,
>> making them significant CPU hotspots. If the dmabuf registration set
>> up a contiguous DMA-coherent list of PRP entries for the pages of the
>> registered buffer, any command using the dmabuf and requiring at most
>> 1 PRP list page (i.e. length <= 2 MB) could just set its PRP list
>> pointer to an offset into the dmabuf's PRP list.
> 
> Possible to an extent, predecessor patches tried that, I left it for
> later to keep the series simpler. I guess chaining won't work in
> general case.
> I mentioned this to Kanchan, Anuj and Nitesh before, they were up to
> playing with nvme optimisations in general, and since sgl from Anuj
> is ready, maybe they already have a prototype somewhere for that.
> 

Right, I have prototyped the PRP list optimisation before. I will send 
it once the initial version of this series lands, to avoid adding new 
review churn while the rest of the series is pretty settled.
> -- 
> Pavel Begunkov

