Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509824;
	b=JQOTpSxMhg43qWg3u8DHInEAqlYcJCLbz1NKXci8HvFvpOnWp1IONtGlsHcU5pniLqqC
	 hD2fCToeNem8GaZ3taRlckn5LMdQvVt2aw6eZ39YCTE7jE6VmBCp4uS2Gsl2OrOkJbZp6
	 YBswCeZWaF2hV/Ilpbgn6um/6EfsxPakDObBwytfB7/CUeKEWoj4JdAcAwYpXna4Hxapy
	 Ua8C+Jj1ajiClIO9UPZ7pKPDlQrPZCl1IBV7TX/bZuPZCsJOWEKf0sQkHlzf7xdJrKV0z
	 Bp5C7UGo59oVjtNK65618jkC8TbKRlF4kuSxzMEvTqVq7wVio5uoSMBKXSs7YPl+/yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509824;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:
	 X-Msg-Generator:Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=bv+w4SPqJHgJSc/Ri/nAxGFknxpTeekag4KmQjPOdAY=;
	b=M+CuQ1o3Cn7gM5WTvzwBhI6SGB+i6g+MWDycGhzKKfMsrMrCBScT6KrMzVkQXhGOSoqW
	 iktPi2qIztrs9NXPjyBtW3KBzIHCGOz9SkWlEF0pobaHFZ5HPgdk6gWtKsfF/WRfc0fTs
	 o0IWCFabChydIwijOzf3jyBMpgD3ur2J7PxW+u5C4ztAELihp2e7MGGrenE8MWVmjZTeO
	 SlyvqaRyo6Y5vQRninPhdGf+QJzLFao/Z0MkLfbgmThlV9/B4z80nI77EuwR0W04pcUJt
	 2jZYJ4+3r61G0ONIRs2jEpq/4QrbTpwithwWNm6MWKZrmrRfwvFWfEpl/gguk5tXZVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=FmBAPLPP;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC74606A334
	for <nvdimm@lists.linux.dev>; Tue, 24 Nov 2026 08:43:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CC74606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=FmBAPLPP
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261124084335epoutp0378f116da01da84f15e0af23bfa22fa36~q7qogInvm1692416924epoutp03d;
	Tue, 24 Nov 2026 08:43:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261124084335epoutp0378f116da01da84f15e0af23bfa22fa36~q7qogInvm1692416924epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795509815;
	bh=bv+w4SPqJHgJSc/Ri/nAxGFknxpTeekag4KmQjPOdAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmBAPLPP2mhGFVwNHvYu9RLbxnRYBoVw/8ymAq7p6DsxiuqRByG2O+15P/bQz45wH
	 ONOcDc3+s/GAA8aVXLubnSYuAWzZF6xY/sedOKG3cCL32MYutURDGQnzSa2eejzxiF
	 6GioVndOT2s5GhkSElScO45slA2g1jz2ijYeqjn0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20261124084335epcas5p2c84e920886d69e131764edcb7537c200~q7qnxZ8BJ1183811838epcas5p2V;
	Tue, 24 Nov 2026 08:43:35 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.87]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jYbtt2JwWz6B9mC; Tue, 24 Nov
	2026 08:43:34 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d~q7o0df1RC0651506515epcas5p3W;
	Tue, 24 Nov 2026 08:41:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261124084126epsmtip20d1bb7fc51b7be9416c78f041855e347~q7owLbH482941029410epsmtip2v;
	Tue, 24 Nov 2026 08:41:26 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Anuj Gupta <anuj20.g@samsung.com>, Christoph Hellwig <hch@lst.de>, Anuj
	Gupta <anuj1072538@gmail.com>, Nitesh Shetty <nj.shetty@samsung.com>, Pavel
	Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, Sumit
	Semwal <sumit.semwal@linaro.org>, Christian Koenig
	<christian.koenig@amd.com>, Philipp Stanner <phasta@kernel.org>, Dan
	Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara
	<jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Ojaswin
	Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, Zhang
	Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, Li Wang
	<liwang@kylinos.cn>, Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: Re: [RFC PATCH v2 0/8] ext4: Add dma-buf read/write support
Date: Tue, 24 Nov 2026 14:10:25 +0530
Message-Id: <20261124084025.2101804-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
	<20261120154153.GC28611@lst.de>
	<361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
	<CGME20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d@epcas5p3.samsung.com>

On Mon, Nov 23, 2026 at 09:51:41AM +0800, Mengmeng Zhao wrote:
> Hi Anuj, I'd be happy to help pull our patches together into a single
> unified series and send it out for review, if you're okay with that—and
> would appreciate your review once it's posted as well. Please let me know how
> you'd like to coordinate, or if you have any updates in progress on your
> side before I put the series together.

Hi Mengmeng,

We already have updates in progress on the XFS side.

We will consolidate the combined series along with your ext4 work and
related patches, keeping your authorship.

One more thing that we are looking at combining is the ability to share
the registration across files. Pavel had mentioned this earlier in our
xfs series [1] and posted a series too [2] which needs some more work.

FWIW, we also had ext4 changes, but intentionally started with one
filesystem (XFS) so that the common interface could settle first.

[1] https://lore.kernel.org/linux-block/4649a20f-aba9-418e-987f-66f21ab24410@gmail.com/
[2] https://lore.kernel.org/linux-block/cover.1793751001.git.asml.silence@gmail.com/
