Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E431BF38
	for <nvdimm@lists.linux.dev>; Fri,  7 Jun 2024 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717785122; cv=none; b=C/9ytwasXoehnDAKaYsQI7RueXRbisJv+yVGb8DGJ088/I2Bjajz4ussF+wnMYEn6UYsC7kgPQk+cVXHVOIEoFrWy0HpXRD93Bj+mYCO4hN2t3bQcI6kaV656CLg0aKA+Q4JphNxGV47eoAKa7HZ315uonWxKPuYQS5lWphlvlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717785122; c=relaxed/simple;
	bh=5VGyEcgYUZVsYd3JEKkHt82oXNDR1d8g9jbtXoEWEPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=oVwViv46pKwUhnNBri2wtzVTU/3oPJJOQf+WVfCZuj95syLZNmImatlAQ/aR/+vkcIpz7S4UkTnibBuvHVWNPu+UyGGOjO5eV7TdFcj2lTeRv5qMiXRn6PvlbfRsckbUiYZO+AQPhPfEGY/ADz3Ic01ERu1gP5Klo56z15eqPP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MDHcgyKZ; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MDHcgyKZ"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240607183150epoutp018d1fe2696772c2998245b3cc9381eb55~WzHT8peGM0489504895epoutp01m
	for <nvdimm@lists.linux.dev>; Fri,  7 Jun 2024 18:31:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240607183150epoutp018d1fe2696772c2998245b3cc9381eb55~WzHT8peGM0489504895epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717785110;
	bh=Q7UteAPU1jA8crxsj3DgD2vFH2FK2jVTwOwPPdbKvCw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=MDHcgyKZ4cKFzzHyh298rfvSpNjrWKLBoXmDd7oVFirJx/15iqgXXR1MuN3zDyIer
	 PeVDKTUxA5ifTA/F3zWtN3LWJLmOh/33/YK3vn+j49LByq4TOwNYUoLcTOozi9bg0s
	 Af3+ET9A2brasJoe59n4V4Jce443KSgfC59uOhDw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240607183149epcas5p4f4e675de6d486120a013e2f505a94038~WzHSqWxtY1183311833epcas5p4W;
	Fri,  7 Jun 2024 18:31:49 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VwqXz4NVDz4x9Pq; Fri,  7 Jun
	2024 18:31:47 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A0.D9.08853.31253666; Sat,  8 Jun 2024 03:31:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240607183146epcas5p2274f401a5fa7bcaeab89a814847ab2af~WzHQU3USS2960329603epcas5p2S;
	Fri,  7 Jun 2024 18:31:46 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240607183146epsmtrp22776e0f93ea286e1fcb0913b1f4efa82~WzHQT-STE2710127101epsmtrp2M;
	Fri,  7 Jun 2024 18:31:46 +0000 (GMT)
X-AuditID: b6c32a44-d67ff70000002295-fd-666352132248
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	E9.CD.18846.21253666; Sat,  8 Jun 2024 03:31:46 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240607183144epsmtip1be7eb2e9bc00f4f582c6ec22f2566f94~WzHOFwhcD3142631426epsmtip1e;
	Fri,  7 Jun 2024 18:31:44 +0000 (GMT)
Message-ID: <8d26d133-6fac-531c-d300-5b99678f1cbd@samsung.com>
Date: Sat, 8 Jun 2024 00:01:43 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 04/11] block: remove the blk_integrity_profile structure
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
	<mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai
	<yukuai3@huawei.com>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240607055912.3586772-5-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmuq5wUHKawZFeBYvVd/vZLBYsmsti
	sXL1USaLSYeuMVo8vTqLyWLvLW2L+cueslu0z9/FaNF9fQebxfLj/5gsJnZcZbJY+eMPq8W6
	1+9ZLE7ckrY4vvwvm8WchWwOAh7n721k8Wg58pbV4/LZUo9NqzrZPDYvqfd4sXkmo8fumw1s
	Hr3N79g8Pj69xeLxft9VNo/Pm+QCuKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOAnlFSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU
	6BUn5haX5qXr5aWWWBkaGBiZAhUmZGdMun2EpWAxd8XF76eYGhj7ObsYOTkkBEwktn07ztLF
	yMUhJLCbUWL74dWsEM4nRonTq7tZ4JxVc9vZYFoafy5khEjsZJQ42XMEynnLKDH7zmUmkCpe
	ATuJT58OsoPYLAIqEmfPvmaHiAtKnJz5hAXEFhVIlvjZdQBsqrCAj8T/5ltgcWYBcYlbT+aD
	zRERKJX4veQpE8gCZoGFzBL9N6YAORwcbAKaEhcml4LUcAoYSUy/t44RoldeYvvbOcwQl37g
	kFhw3xHCdpH4fHwVC4QtLPHq+BZ2CFtK4vO7vVCfJUtcmnmOCcIukXi85yCUbS/ReqqfGWQt
	M9Da9bv0IVbxSfT+fgJ2jYQAr0RHmxBEtaLEvUlPWSFscYmHM5awQpR4SNz4kQgSFhJYyygx
	rZ1pAqPCLKQwmYXk91lIfpmFsHcBI8sqRsnUguLc9NRk0wLDvNRyeHQn5+duYgSndC2XHYw3
	5v/TO8TIxMF4iFGCg1lJhNevOD5NiDclsbIqtSg/vqg0J7X4EKMpMHImMkuJJucDs0peSbyh
	iaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1MThMuKNnZX08RcGCIaHom
	xlby4bLQa/XHH6ZUOug1m83LUL36RHiPxjONvLmnF6n0nOWSXLQ8Z2WvCXN0UNGkxL4LIt9m
	bCnetClnpbPF9bMOS6bqz3pp9kfInHd28lebtEVvjeQuO31LN9j182PM88zK9KbIcha2r/tf
	XKs+MKN5Rfqb94+4e7nMdvGaSJ2QNwiYfbpNO3nqKefTa84pf4mx13n39CFf3Z2b695bvDU6
	ax+eXc96LOmFwb4ZWqG7jqTxr7eaIFdQeZqDU04qbaLa175a3s3SPX6TW5NK37IpMp6z4dmv
	JPPu+xrhPV1BSboLf25+/WeGgLJk5tadW9sELU1VVql/2hizfO1aJZbijERDLeai4kQA5sVg
	g3IEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWy7bCSnK5QUHKawaOH6har7/azWSxYNJfF
	YuXqo0wWkw5dY7R4enUWk8XeW9oW85c9Zbdon7+L0aL7+g42i+XH/zFZTOy4ymSx8scfVot1
	r9+zWJy4JW1xfPlfNos5C9kcBDzO39vI4tFy5C2rx+WzpR6bVnWyeWxeUu/xYvNMRo/dNxvY
	PHqb37F5fHx6i8Xj/b6rbB6fN8kFcEdx2aSk5mSWpRbp2yVwZUy6fYSlYDF3xcXvp5gaGPs5
	uxg5OSQETCQafy5k7GLk4hAS2M4osa75NwtEQlyi+doPdghbWGLlv+fsEEWvGSVW/dnIBJLg
	FbCT+PTpIFgRi4CKxNmzr9kh4oISJ2c+ARskKpAs8fLPRLC4sICPxP/mW2BxZqAFt57MB5sj
	IlAq0f9vBhPIAmaBhcwSi06/ZoPYtpZR4sDTtUAOBwebgKbEhcmlIA2cAkYS0++tY4QYZCbR
	tbULypaX2P52DvMERqFZSO6YhWTfLCQts5C0LGBkWcUomlpQnJuem1xgqFecmFtcmpeul5yf
	u4kRHL1aQTsYl63/q3eIkYmD8RCjBAezkgivX3F8mhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe
	5ZzOFCGB9MSS1OzU1ILUIpgsEwenVANTxdN/T21YDvzQ2nY+a+ma6/uK+X88UJbZx//7zO9n
	/tN+p9zsuyDNE6Bne/5r2BapjJrcVaUMHRN9mUPWP15xu8chRyJX9/ytbS2P9LbtzAhRWhyb
	f/e02qrpL1Yucb9XYCiw6djzSyu/fJxxedFjqQ8xL2ZquNd/dDxgyqV7XdfWJOSOv/Hdw5d/
	KvsLfVorwPHZ7fUau+/t/ZnfLwr9qnp9+1LuMxbjq38mHHn1ReTA/sdrahLnrXi8Q8y4zG6D
	zJuM1/2833ex8bz/Njd2qtbJLscbp+9FZDUUdJifFDH2t9Pf/cVnxsvYhoVn2FZ+eHz9dkGv
	8tXn7ff4k942X/FIWHggrXgL78FtO298jhBQYinOSDTUYi4qTgQAwDSZfE0DAAA=
X-CMS-MailID: 20240607183146epcas5p2274f401a5fa7bcaeab89a814847ab2af
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240607060043epcas5p1a6d4d8c3536fe3b6e43ad34155803fc2
References: <20240607055912.3586772-1-hch@lst.de>
	<CGME20240607060043epcas5p1a6d4d8c3536fe3b6e43ad34155803fc2@epcas5p1.samsung.com>
	<20240607055912.3586772-5-hch@lst.de>

On 6/7/2024 11:28 AM, Christoph Hellwig wrote:
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1177,7 +1177,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
>   	struct mapped_device *md = dm_table_get_md(ti->table);
>   
>   	/* We require an underlying device with non-PI metadata */
> -	if (!bi || strcmp(bi->profile->name, "nop")) {
> +	if (!bi || bi->csum_type != BLK_INTEGRITY_CSUM_NONE) {
>   		ti->error = "Integrity profile not supported.";
>   		return -EINVAL;

I'd rename BLK_INTEGRITY_CSUM_NONE to BLK_INTEGRITY_CSUM_NOP. Overall.

Current choice is a bit confusing as it indicates that code is trying to 
handle "none" case while it is actually trying to handle/support "nop" 
profile.

With extended format off:
# nvme format /dev/nvme0n1 -l 5 -m 0 -i 0 -f
Success formatting namespace:1
# cat /sys/block/nvme0n1/integrity/format
nop

With extended format on:
# nvme format /dev/nvme0n1 -l 5 -m 1 -i 0 -f
Success formatting namespace:1
# cat /sys/block/nvme0n1/integrity/format
none

nop is the case when bi->tuple_size is perfectly valid (i.e. not zero), 
and the code needs to have support for it.
none is the case when bi->tuple_size is zero, and the code only needs to 
ensure that it does nothing.

That said, the change can be deferred to a future patch as well.

So, looks good!

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
