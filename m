Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515D4335543
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769450598; cv=none; b=J+SXA2NJzxn5ME64z2jQNfynNi3gvcet+s4dAyZcg9I12kt4N7M9VEPZiB/edoDwxqmELhXvnZXPilKVPIFWlx8bgNclzrUl/n+bh7nJTEoRG10+fPElDTLbRCXt+hOXhR9jvK0n8ocFcy/KSpZ6wmBJyigXi5w/pyAB+OPm+7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769450598; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=d6kJXGyqRrAiIdD7igNAg7ElXhmZPLwSUilpA7Q2Axmgzt1xDOqbx98wA21kJ7l42RP+fpdKqiNKdPo6vlTRM7OpHX8CqD+3qRHngcBkWpNr57UOMLlfY480idwd6hYzpm6mZN5nfMg6zDtvZS9GKIGjxw8BnGLTIIRih8FSgTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eavK9guM; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eavK9guM"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260126180313epoutp04bf7c588b1483804ff7c55f18b007316b~OWfCIv3va0912809128epoutp04j
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 18:03:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260126180313epoutp04bf7c588b1483804ff7c55f18b007316b~OWfCIv3va0912809128epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769450593;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=eavK9guME8J5LIadxOdM42c8eQg+ZLV2yd5A2r92RCAui6FQaWJcqvO/aFI1QYEXM
	 LE8I5rK+PWk6svAJmmv1aBeTUdCUIPeoRNaFqrja3RwRHUlo/UrSwNB/rWKkJxaWd/
	 RV4+f80nf9np5rtb2ofv6BF6eI1Lg23ArNfe91So=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260126180312epcas5p4671e4f372b35f3f122d0bf96d3e698ff~OWfB5XLct2909929099epcas5p4o;
	Mon, 26 Jan 2026 18:03:12 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4f0Gc01wy7z6B9m5; Mon, 26 Jan
	2026 18:03:12 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260126180311epcas5p4a19d73b6fc8b7abc57c3efb8feca8f4a~OWfAj4lK10116001160epcas5p4a;
	Mon, 26 Jan 2026 18:03:11 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260126180309epsmtip17ecf8e8264e0645442d441305040008d~OWe-EUJ6e0279302793epsmtip14;
	Mon, 26 Jan 2026 18:03:09 +0000 (GMT)
Message-ID: <d5b8c029-d290-409c-a888-e36bb2e639f0@samsung.com>
Date: Mon, 26 Jan 2026 23:33:08 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/15] block: add a bdev_has_integrity_csum helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260121064339.206019-4-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260126180311epcas5p4a19d73b6fc8b7abc57c3efb8feca8f4a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260121064403epcas5p3dae5541f5ae17a7ab8db6dc650a5b6e5
References: <20260121064339.206019-1-hch@lst.de>
	<CGME20260121064403epcas5p3dae5541f5ae17a7ab8db6dc650a5b6e5@epcas5p3.samsung.com>
	<20260121064339.206019-4-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
