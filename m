Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE70214B95E
	for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718369161; cv=none; b=azTC1FeWW1bgutLXjvDudDV7nb14IGj2+bVfb+QaKtz4zd5E3x/BeIAdWuhh//hHSRB0uHPBbdM7N49fdH6Fvkq2rUGBCmEbecPF7atcKeYnyljTyMhd5WMtR9/EaWVM3DdYNpTEWZ5rycLolvWmEY9F2oU+Vx8ZjMp8HrcR+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718369161; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=atyixpFqULopDJY5xbo9IdOUZz8hZ+D6QZzLGorubHFaZuS2NsaX0VIP1wp/MWDfqj8vtnItoBM9IrBGU7NNPRRlCIWzVt8ZSkNNdyHZP59lQLaCJyFt6VAz8UPiDS3DbES622jBgQo+/l0PN3zoWSBPqCg7jjB/3UIzwulW7nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NkD3QEl1; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NkD3QEl1"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240614124550epoutp019ed9444cef44306aeff8c9d9b0c419ba~Y36NCvEj01863218632epoutp01T
	for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 12:45:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240614124550epoutp019ed9444cef44306aeff8c9d9b0c419ba~Y36NCvEj01863218632epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718369150;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=NkD3QEl1TzCwuqv2akadRPE/FCdD+sZFAgjSD6UKO3FJbCM/YXWutLit995fX8LMP
	 Pi6vbX8b4Kus5YqSKPgq4Lnc+6gCaZFboQgFaEH8+K0Kw4T1a90D9QJlLoDIuC9AX7
	 DROcgjlsDcs73Km3m81X4ZyFcmCqUhwCI7kvM48Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240614124549epcas5p2642f3c5838185873463e8d821ec38f52~Y36MTKQoL2365623656epcas5p2Z;
	Fri, 14 Jun 2024 12:45:49 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4W0zXW6JmLz4x9Pt; Fri, 14 Jun
	2024 12:45:47 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	83.4C.10047.B7B3C666; Fri, 14 Jun 2024 21:45:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240614124547epcas5p2199de6f83d51ede53a4d2a220b4c92d3~Y36KY2TJY0304403044epcas5p2e;
	Fri, 14 Jun 2024 12:45:47 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240614124547epsmtrp2fc3900cd977caf58be546b84dd014a7a~Y36KXI58l3233132331epsmtrp2h;
	Fri, 14 Jun 2024 12:45:47 +0000 (GMT)
X-AuditID: b6c32a49-1d5fa7000000273f-91-666c3b7b9889
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B8.AC.07412.B7B3C666; Fri, 14 Jun 2024 21:45:47 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240614124544epsmtip16d65381439fb13d5c02e392a9c9b009f~Y36IFmV6i3174031740epsmtip1v;
	Fri, 14 Jun 2024 12:45:44 +0000 (GMT)
Message-ID: <34214fea-0e59-4293-bc14-d6078f518976@samsung.com>
Date: Fri, 14 Jun 2024 18:15:44 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 01/12] block: initialize integrity buffer to zero before
 writing it to media
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
In-Reply-To: <20240613084839.1044015-2-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmpm61dU6awY1+A4vVd/vZLBYsmsti
	sXL1USaLSYeuMVo8vTqLyWLvLW2L+cueslu0z9/FaNF9fQebxfLj/5gsJnZcZbJY+eMPq8W6
	1+9ZLE7ckrY4vvwvm8WchWwOAh7n721k8Wg58pbV4/LZUo9NqzrZPDYvqfd4sXkmo8fumw1s
	Hr3N79g8Pj69xeLxft9VNo/Pm+QCuKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOAnlFSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU
	6BUn5haX5qXr5aWWWBkaGBiZAhUmZGec2rGUqcCo4trcPqYGRt0uRk4OCQETicM3fjN3MXJx
	CAnsZpS43veQHcL5xCjxsKeTEcL5xihx4OZzJpiWe01dUC17GSX2H93EApIQEnjLKNH9LhvE
	5hWwk9j1fD5bFyMHB4uAqsSdK3IQYUGJkzOfgJWLCiRL/Ow6wAZiCwskSbz7ugJsPrOAuMSt
	J/PBbBGBUonfS54ygexiFljILNF/YwoTyEw2AU2JC5NLQWo4BYwkHl08yQrRKy+x/e0csNsk
	BD5wSCzZ+YUZ4mgXiem/H0PZwhKvjm9hh7ClJD6/28sGYSdLXJp5DurJEonHew5C2fYSraf6
	mUH2MgPtXb9LH2IXn0Tv7ydg50gI8Ep0tAlBVCtK3Jv0lBXCFpd4OGMJlO0hsX7DHzZIsK1l
	lNj84xDbBEaFWUjBMgvJ+7OQvDMLYfMCRpZVjJKpBcW56anFpgWGeanl8NhOzs/dxAhO6Fqe
	OxjvPvigd4iRiYPxEKMEB7OSCO+shVlpQrwpiZVVqUX58UWlOanFhxhNgdEzkVlKNDkfmFPy
	SuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1OTS1ILYLpY+LglGpg0jUS++cz9/iKGf+Y
	jiq4qiudbGuTFftStOcz7/c9a1wfvs/KctHxKSheUen/4ceL4OaX84Ii3t2qyfzXdSc6wq5p
	+/Zde4Smscs1PrwUtm21Mr/k6ar0D06H+FktF33WqP1lvLxp428ezv4Vn1/KzC1M7VnHWzzt
	kEWPnZKKre6Pij93WANmzOL7UT7Lb5mYfurVitmS3xUEOK5YPlAv2ZQ18dUVqdVmkr/eyS3d
	HaOd3xK7RdJwx9ZCl6dfXSYXb/8ksUU5I86o869rwNKHrLb6qudX7xLLaT3h+uaPzyXFwEnu
	mop7Nqiet35jNCV4tqHwFqWncbxqz7xuvr9ysdThM8/KBoG4dK1mLZ4TSizFGYmGWsxFxYkA
	SgkISHEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWy7bCSnG61dU6awfUDnBar7/azWSxYNJfF
	YuXqo0wWkw5dY7R4enUWk8XeW9oW85c9Zbdon7+L0aL7+g42i+XH/zFZTOy4ymSx8scfVot1
	r9+zWJy4JW1xfPlfNos5C9kcBDzO39vI4tFy5C2rx+WzpR6bVnWyeWxeUu/xYvNMRo/dNxvY
	PHqb37F5fHx6i8Xj/b6rbB6fN8kFcEdx2aSk5mSWpRbp2yVwZZzasZSpwKji2tw+pgZG3S5G
	Tg4JAROJe01dzCC2kMBuRokDfysh4uISzdd+sEPYwhIr/z0HsrmAal4zSmyZtIkFJMErYCex
	6/l8ti5GDg4WAVWJO1fkIMKCEidnPgErERVIlnj5ZyLYHGGBJIl3X1cwgdjMQPNvPZkPZosI
	lEr0/5vBBDKfWWAhs8Si06/ZIJatZZSYcXMdK8gCNgFNiQuTS0EaOAWMJB5dPMkKMchMomtr
	FyOELS+x/e0c5gmMQrOQ3DELyb5ZSFpmIWlZwMiyilEytaA4Nz032bDAMC+1XK84Mbe4NC9d
	Lzk/dxMjOHq1NHYw3pv/T+8QIxMH4yFGCQ5mJRHeWQuz0oR4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzGs6YnSIkkJ5YkpqdmlqQWgSTZeLglGpg0uR9+H7Silb/Fvavn6Z9ZwxIEkwQrlrOfs/+
	6ya5I8rLryX8Lj8VHZsS3G14a2aSrTyv0Z7vbTJXfk9unHXv1+EvIXHOL1osLjZnbDkcbXZ3
	Me+ebV1r2P3urZvM281vee7K45Ccyxyf/l+MlXu7vNhidabjj7V35Y3FTjQt9mVsuNl5hjPu
	HKOoiBlHXeiP1NAtHY4KUVp+O9jtzmsJbane8X3G7BsX/6eE12/vup7KGf7nQ9/fle9yd0u7
	zeR85LTkS4Ry7oEDvT6CNybb5USwvw12/1SrVmxRO8Hl1Lm426dEZivcsbjrvC67Ozn124Yv
	rJL9f/MDot365r9bn+vkaLNY95PcoeInZRyzlViKMxINtZiLihMBTBTXmU0DAAA=
X-CMS-MailID: 20240614124547epcas5p2199de6f83d51ede53a4d2a220b4c92d3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240613085027epcas5p3aed19d209869dcff978cebcf18a521bb
References: <20240613084839.1044015-1-hch@lst.de>
	<CGME20240613085027epcas5p3aed19d209869dcff978cebcf18a521bb@epcas5p3.samsung.com>
	<20240613084839.1044015-2-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
