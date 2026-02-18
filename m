Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C449A19E992
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 10:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771411976; cv=none; b=rUzIQQcmshg5xm4aLs5vnhw80Cv/VoOReYD3AEFGTPy3FDvnV3wOsv8oEOBaVjIDA6/Um7hQthj38iYnCOrT7sXU00mVwbtzigipdJn04g3GFn3eu0UmrXOUqRWz345nC65g520gGxNTJ/S0kgcIZdhSLWiC7Hd1/Py1O0KtiPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771411976; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=oa1SCYLkUOW7TfWXL+Ct7wEgCo3SFXb4T/Iwb6uXRfN1xOq7r0oaR6e2sygMc0vGH6SKIaA6RzioOJ7FHWqxPHWBv/1ag2sFyPS3cfX3W3byjUbrEkBKWmuPDz8Vdgy2f4ddHF8OC3wwwX22Jzyu7Mghh44BtjOKD4/1wlsN5AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MYGC1Pxj; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MYGC1Pxj"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260218105252epoutp0357695451803203d7c698f85b5e0a5b8b~VUc3FAXAg2906629066epoutp03c
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 10:52:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260218105252epoutp0357695451803203d7c698f85b5e0a5b8b~VUc3FAXAg2906629066epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771411972;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=MYGC1PxjznuhiOWZu70tL4bYSlPmvjJ5fGp7ptC6gLYqdx1l7RKpNU69WhRXkh0TH
	 6WydTKrvq7cj3KUxBMpVB59u+9t+tR0lSgd+qBYUyXcHNwMV/rHBSlyIjlImotWKPP
	 9oRd7nDLpBMKXQNg6acGUvjn0o7zDuNfhzpWnyVg=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260218105252epcas5p2a1cd5fd4a4fa3e5a71cbbe99421ef9b6~VUc2nkLM00982209822epcas5p2x;
	Wed, 18 Feb 2026 10:52:52 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4fGCyq3G6Xz6B9m6; Wed, 18 Feb
	2026 10:52:51 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260218105250epcas5p3d63a86bf5f61784ccd0f02bbaf2cd280~VUc1PEMui1692816928epcas5p3V;
	Wed, 18 Feb 2026 10:52:50 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260218105249epsmtip10a20eda6b4f4ae6e5d841b750a3e92d2~VUczwmyvL1133211332epsmtip11;
	Wed, 18 Feb 2026 10:52:48 +0000 (GMT)
Message-ID: <e40e6a2f-a03a-4133-b863-a88df0b967cf@samsung.com>
Date: Wed, 18 Feb 2026 16:22:48 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/15] block: pass a maxlen argument to
 bio_iov_iter_bounce
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260218061238.3317841-8-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260218105250epcas5p3d63a86bf5f61784ccd0f02bbaf2cd280
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260218061322epcas5p2ad69ece4b346b48d47f90a52a120801e
References: <20260218061238.3317841-1-hch@lst.de>
	<CGME20260218061322epcas5p2ad69ece4b346b48d47f90a52a120801e@epcas5p2.samsung.com>
	<20260218061238.3317841-8-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
