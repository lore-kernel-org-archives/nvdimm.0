Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BACA48EBDB
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 13:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785331886; cv=none; b=cAv5BvM1+D786q8QnbqurI0iD2EltTnLMc95E0xpq5dpd85tPs/n7gspPkRd/N1pRikrGbEKlCFQUuvWwuURmbSHhC9xwSEra6a9HzQiP1/adTIOR27S0EhzuMs1EzsTRSTiAjHnbcGEXaqrJMjGct+BOmKkA9+VwlyYqd7y82I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785331886; c=relaxed/simple;
	bh=Iv3uIwtWa01Luo7O4hUrj8gNPuZqtvYC/04Ig+OBMa0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Nta39CtPiEbwftZZz+WYkbLnQWpDR3fKCaYhvaAH+fGWR4AdTs4IvHHcTyFcHS1Au55104x+TdJHy0K14xAqZDWyo9nQ+3iZbBOgkG5KUvsWMG6Ss+ZpbU/GhHTcJS3lOK5Hq9fEnFx4qE55wrERV8Vwzorp2oADQ4yRNTXYokU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=a/vx3sBp; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="a/vx3sBp"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260729133113epoutp03a5f197b114a255b26c84b13306d63995~GxeFCnMSo0040700407epoutp03G
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 13:31:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260729133113epoutp03a5f197b114a255b26c84b13306d63995~GxeFCnMSo0040700407epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785331873;
	bh=ZDJk27gz63Bjx+XAUOCj+oZxhX4eQ8qfTG8bNQ0cMfY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=a/vx3sBpS/twRkYi1yYleTFghokVhPFGbyJBTuoA0tnB3E+P8eDvzp6JfzVf3SEz3
	 X42C0s/dWsZL55ZqOZKs8UOHQgWrNJJT7qY9tQd+sBH5Uh+TAM8gFdOCvbZR5Gdzow
	 w4HlYs4R0lC4adNXeJEodErFhPZUbOhGLjE6zSqQ=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260729133112epcas5p3bd1d18bb66b0f8808d9cacfabc76c032~GxeENHPUg2902429024epcas5p3H;
	Wed, 29 Jul 2026 13:31:12 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h9CsC4dk9z6B9m5; Wed, 29 Jul
	2026 13:31:11 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260729133110epcas5p4c215a866cd371ec48e2608765dc26ad9~GxeCj-bm90481504815epcas5p4d;
	Wed, 29 Jul 2026 13:31:10 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260729133105epsmtip2d312a27a0649b2d7cf4807b11b2517f0~Gxd95g22x2496024960epsmtip2k;
	Wed, 29 Jul 2026 13:31:05 +0000 (GMT)
Message-ID: <73317bf9-f7df-43f9-abc2-daa25a675485@samsung.com>
Date: Wed, 29 Jul 2026 19:01:04 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/14] io_uring/rsrc: extend buffer update
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi
	Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Sumit
	Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?=
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
In-Reply-To: <633d33d8e278999f55126794fce948343403494a.1785274111.git.asml.silence@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260729133110epcas5p4c215a866cd371ec48e2608765dc26ad9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260728213008epcas5p418dfc10b7ef786e162ade86d14430475
References: <cover.1785274111.git.asml.silence@gmail.com>
	<CGME20260728213008epcas5p418dfc10b7ef786e162ade86d14430475@epcas5p4.samsung.com>
	<633d33d8e278999f55126794fce948343403494a.1785274111.git.asml.silence@gmail.com>

On 7/29/2026 2:59 AM, Pavel Begunkov wrote:
> @@ -882,8 +894,13 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>   	struct io_imu_folio_data data;
>   	bool coalesced = false;
>   
> -	if (!uaddr) {
> -		if (size)
> +	if (desc->type >= __IO_REGBUF_TYPE_MAX)
> +		return ERR_PTR(-EINVAL);
> +	if (!mem_is_zero(&desc->__resv, sizeof(desc->__resv)))
> +		return ERR_PTR(-EINVAL);

desc->flags  isn't validated here, unlike __resv. nonzero flags should 
be rejected too?

> +
> +	if (desc->type == IO_REGBUF_TYPE_EMPTY) {
> +		if (uaddr || size)
>   			return ERR_PTR(-EFAULT);
>   		/* remove the buffer without installing a new one */
>   		return NULL;

