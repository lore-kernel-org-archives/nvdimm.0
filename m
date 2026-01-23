Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF9B2DAFA8
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769168106; cv=none; b=jn7cembdrUXksKMpHo24OxIJr0f83dU+p0xlhRr1CxTPh4D/VTi4tqUM+rRajhgBuBPtzA9Exj1cEkp5DXudYKkDsMrS2RtFQaPkvuHVRSFyuOxna2lzhPnMonncz124YPCg4Lo9jNQ9ewqv9xl0L03SxUW4ctsiYFiDh6cHxc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769168106; c=relaxed/simple;
	bh=K1fZ6Jyj7EvLDYbtI5VuydXd/XQWsjUgOA8Wy8iC+r4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Th8dNcKyOPw0BfBHsvTKtfsQG07Q9tEFJkxAiVGIgzOBIB2aqXTyzl6HmkUZY0XOqg32JjBLHtdmAo6yskRE9JwouBz+pflKJT5u4ZvX/ZsGN3ck1XHzU86EMQPka6WJsQSltFOhX8i+7VLUNGeTkynEqKeAp3mrMt8xWWtB+Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZClxXWVN; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZClxXWVN"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123113503epoutp04ba16b81045f0cf7ece551aa056c73599~NWQQ1lHKc0631306313epoutp04G
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:35:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123113503epoutp04ba16b81045f0cf7ece551aa056c73599~NWQQ1lHKc0631306313epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769168103;
	bh=K1fZ6Jyj7EvLDYbtI5VuydXd/XQWsjUgOA8Wy8iC+r4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZClxXWVNtQTrAM4tO11r7DeJnOlFRcog8ffN/W0EstjtMX6OMDeNI5arbGg0ZRNsr
	 j+7aASvfuD6jLFoDzoGC//SLtfgbejSW54Z0/yHUKK//MyhTuffHA+u+IrNoWhfWAZ
	 72BVMu4LvR0BuOGYNZDozlo7XgpB0oOGrUCD4eeg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260123113502epcas5p36a2cfa210e79ac14a57049f2131b67ec~NWQQh3lYI2799027990epcas5p3S;
	Fri, 23 Jan 2026 11:35:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG7V6Dg7z6B9m7; Fri, 23 Jan
	2026 11:35:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123112011epcas5p24b3943c3824ab0ef7737c92630b934e9~NWDSExPai2407524075epcas5p2G;
	Fri, 23 Jan 2026 11:20:11 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123112009epsmtip2e3b26d131e1b56abea93231ec9331954~NWDQwy7c61895918959epsmtip2E;
	Fri, 23 Jan 2026 11:20:09 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:50:01 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 09/17] nvdimm/label: Export routine to fetch region
 information
Message-ID: <664457955.21769168102865.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <697021e1bdbd5_1a50d4100d9@iweiny-mobl.notmuch>
X-CMS-MailID: 20260123112011epcas5p24b3943c3824ab0ef7737c92630b934e9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_11ee34_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3@epcas5p2.samsung.com>
	<20260109124437.4025893-10-s.neeraj@samsung.com>
	<697021e1bdbd5_1a50d4100d9@iweiny-mobl.notmuch>

------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_11ee34_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 20/01/26 06:46PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> CXL region information preserved from the LSA needs to be exported for
>> use by the CXL driver for CXL region re-creation.
>>
>
>Some of the CXL tree patches did not apply cleanly to cxl/next.

I have rebased V6 with for-7.0/cxl-init. Can you please check with V6.


Regards,
Neeraj

------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_11ee34_
Content-Type: text/plain; charset="utf-8"


------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_11ee34_--

