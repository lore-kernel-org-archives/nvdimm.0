Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D395714B95E
	for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 12:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718369216; cv=none; b=mwnNRGk8rwC19kPXyjnSLy6AINN8uA3s94A4jpVdDxlz3mHCwcAcW/YlhzLofUCf/lfhCNFStFOM2AZxYJahQw6BNTFncCs8/eKmFYd2OUMlYol4Xsa9Z8x2UZgfCoOK2Hy6PYO9sZeUFx49VGEUAqcwZDhzlAh1alLpGKf2njs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718369216; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=IwIJZyCJn88tNRcN46aKL8+mwIgzxSZ9beJDNodOosgDkNjj9nJPpLhvuWYHFthnYotd0h0uhF+d2noGvn/dsqDjeMz2ygF5DTovEWxmwTbLDuAvOMPKa/pefrEAFeJAe/7G6RwYfqgyACuPV2ULjOJQ46+50uXNsFgIE+7u/1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=F1XzyBcu; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="F1XzyBcu"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240614124651epoutp038456d7561b4472ffb05573d85316ded9~Y37F-xlYU2759227592epoutp032
	for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 12:46:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240614124651epoutp038456d7561b4472ffb05573d85316ded9~Y37F-xlYU2759227592epoutp032
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718369211;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=F1XzyBcu6Uq2gV4WLnJ6bOAtm4OU6+ML67ABjy3yF7niqAtGq5yznIA+zDHFBhjgq
	 PypmrhxUQcAPI6tQUu4J4DEkcFYLnjbaPEReVeRCU1lrOlT4wtKKr8s0ceCKUD+8zB
	 Sp103kGuqffjpwDWZbzw2E7d5F6NIBNzS54uozQ4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240614124650epcas5p1829a89baff858f7e4b97c614d22f7990~Y37E9PJ9c2157921579epcas5p15;
	Fri, 14 Jun 2024 12:46:50 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4W0zYj00kxz4x9Pr; Fri, 14 Jun
	2024 12:46:48 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E0.AF.19174.8BB3C666; Fri, 14 Jun 2024 21:46:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240614124648epcas5p4a2a09d0afa38f48df010836255055259~Y37Dd8bjT0231702317epcas5p4S;
	Fri, 14 Jun 2024 12:46:48 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240614124648epsmtrp2711d90cd2d9a3ca4a853807fc67e0ac0~Y37Dc0EAz3233032330epsmtrp2O;
	Fri, 14 Jun 2024 12:46:48 +0000 (GMT)
X-AuditID: b6c32a50-b33ff70000004ae6-11-666c3bb8fa8d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.83.18846.8BB3C666; Fri, 14 Jun 2024 21:46:48 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240614124646epsmtip12aa138e5a5daa502a7a3b1f8f8cc43a1~Y37BIhnaI0421104211epsmtip1F;
	Fri, 14 Jun 2024 12:46:45 +0000 (GMT)
Message-ID: <675ba756-5361-f98a-52ca-2433c6669451@samsung.com>
Date: Fri, 14 Jun 2024 18:16:45 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 08/12] block: use kstrtoul in flag_store
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
	<mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai
	<yukuai3@huawei.com>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, Hannes Reinecke
	<hare@suse.de>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240613084839.1044015-9-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH97u3vdwamZdK019YovUumMEGttqWWwXdg5hrRjY2/tgkcdCU
	W0BKW/uYCnErgzoGQwTdhCopdKgTMmSFMBA0Sl1gEwS28OpiB4E6HkNwLAEndGu56Pjvc875
	npzX74ej/GksDM/UmhiDVqkhsU2cFldEZFTrPo1a7PLFUPUPSjGq2lHFoToc5Qh1rf5HhCrv
	HAKUd9CGUDfdr1L2K94g6nP7DUAVD7di1NUuH0KVFQ76tcsrXKphdp5DdbtforqurmLUpRrs
	9RC6z/M9hy64O8elf+010866LzC6qfZTeqqpEtDtoxaMLsl/hNGPvW4OPX9r0B+8l0svOrcl
	bk7Ois1glGmMQcRoVbq0TG16HPl2UspbKTK5WBIlUVAxpEirzGbiyPiExKiDmRr/VKToY6XG
	7HclKo1Gctf+WIPObGJEGTqjKY5k9GkavVQfbVRmG83a9GgtY9orEYt3y/zC1KyMld57XL30
	xFDVGcQCoooAD4eEFDaPXUaLwCacT3QA+JnNg7DGXwD29Q6jz43Vy7NBz1K+Lb7AZQNtAE6X
	+NBAgE/MAdj9Z3iAg4n90OO4gAWYQ4TDQk91EOsPgT9VTnICLCBU8EnR7TXNViIWtuR5QYBR
	Qgjdk3YkwKGEGT6t9a61hBIuFDZZCv0iHMeICNh/zhzQ8IjdcLjlfhCbux3+MHdprWtILOOw
	q+0BwnYdDy/ebkRZ3gpnuprXpwmDi49uYiyr4C+V99f1JjjRcWedD0Drz6VooC7qr3v9xi62
	1ouw5OkkEnBDIhgWnuaz6h3QU+7lsiyE4xW160xD3+g8YPf2HYD1j68HnQUi24a12DaMb9sw
	ju3/ytWAUwfCGL0xO51RyfSSKC1z/Pm9VbpsJ1h785GJraC+cTW6EyA46AQQR8nQYFvNUTU/
	OE15Mocx6FIMZg1j7AQy/4HK0DCBSuf/NFpTikSqEEvlcrlUsUcuIYXBs9aqND6RrjQxWQyj
	ZwzP8hCcF2ZBjvXkR3dy+yN3/Fbj5dkzS+ZfG/hAMpncYPUt7uwb63U6/ijfecrVFH90S1X7
	vg5R1bx6QF1w+OWFD9/0Ji3yBEN527YLj3d89PBv0jYhlP1bxHgq7BON/7iv9GyZGoEY2p/z
	yYHxpIKG4gHTyNTMocb6iW9KhZtVIQtxPTnFg4roogFBeGbMMcF750+OWS+ucGOW1AmOLMVo
	bo1rQd6sC/nyGjd5xtpe8vWZhwqX5e4LWOy7mr2nlie+aj6C171f1l3Qe6tN4cpNVY/zpi2p
	d5acsOncK76Rijd8S1P5tamH3HGnnYKDESdKZfY9qb+v5CmWeKEZjsp3EqoPPzkiPttNcowZ
	SkkkajAq/wM8vNUffAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWy7bCSnO4O65w0g9WzJS1W3+1ns1iwaC6L
	xZ5Fk5gsVq4+ymQx6dA1RounV2cxWey9pW0xf9lTdov2+bsYLbqv72CzWH78H5PFxI6rQLU/
	/rBarHv9nsXixC1pi+PL/7JZzFnI5iDocf7eRhaPliNvWT0uny312LSqk81j85J6jxebZzJ6
	7L7ZwObR2/yOzePj01ssHu/3XQVKnq72+LxJLoAnissmJTUnsyy1SN8ugSvjz9nTrAUmFdfm
	9jE1MOp2MXJySAiYSKzons7axcjFISSwnVFiSvNGdoiEuETztR9QtrDEyn/P2SGKXjNKTHu0
	ggkkwStgJ3Fv0XQ2EJtFQFWi494Cdoi4oMTJmU9YQGxRgWSJl38mgsWFBWwktjU+ZQSxmYEW
	3HoyH2yOiECpRP+/GUwgC5gFDjJLbHiwFOqktYwSn5auBurm4GAT0JS4MLkUpIFTwEji+rZz
	7BCDzCS6tnZBDZWX2P52DvMERqFZSO6YhWTfLCQts5C0LGBkWcUomlpQnJuem1xgqFecmFtc
	mpeul5yfu4kRHMtaQTsYl63/q3eIkYmD8RCjBAezkgjvrIVZaUK8KYmVValF+fFFpTmpxYcY
	pTlYlMR5lXM6U4QE0hNLUrNTUwtSi2CyTBycUg1M3msK3+70l2NbLWLv3j+ble+Wu6HH74vL
	Zsy+3SqX8DJ41V71209mWSxmebqvQfjhp8TIGx86BTzjL64O63uydt/fN6LMKiLTzs4ukjFl
	vRQb6sCYEqqcu8THOP7/2knHSoua1d7L7tg/PSbP4uaMK1bLJ4osEL7Reuk204GE+FdBG7U2
	HvrsNeV+5Y5rrwN9D4XP9bDMZd6je+vmw33bpr2wfrv57/Ml2eJta/wCBac+ehDf23xx2cJi
	5lmnzsRuFnCeecRvG3uQ4YfD56zPTz1Zz3XKOnuW1z4H5ay3dp5m07PiXzSt0bihL8QTxqF2
	b+Vpn6hXsjUSWu8TGS6f/LDK7oT9oh1C5tO0KtLvBSmxFGckGmoxFxUnAgCsmPLGVAMAAA==
X-CMS-MailID: 20240614124648epcas5p4a2a09d0afa38f48df010836255055259
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240613085156epcas5p255d8a6182fa283caf1c7cd6938e19c49
References: <20240613084839.1044015-1-hch@lst.de>
	<CGME20240613085156epcas5p255d8a6182fa283caf1c7cd6938e19c49@epcas5p2.samsung.com>
	<20240613084839.1044015-9-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

