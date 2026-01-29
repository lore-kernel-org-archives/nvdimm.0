Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FA037F116
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 09:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769678848; cv=none; b=EYyZq6438lPLHfi5sGChnVI/j41cSjonCQyb1YHSwmUGzulZuQ/eBjFNveIC3Vp/I6xZb5rNjhetdWbAMKuV0xNvCQ1s02qmC6CQfkVwqP1h74ERYA42ZJrcCJ+UneUJYrDKLf9JXoi9LHtGaEdbHG8U9PC2Bw7SiBNcUUEokbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769678848; c=relaxed/simple;
	bh=4bRaTgrCKseoLnMwWid7iSb2X5Y0CMnCnaMIQDLYSAw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=upTt91g2+86Wg9uLXz4UbzQ6eDzX+EeLGfYPs2KQoqf28xyEV+sYUKux3Yivi+TmIINEeHs9ErbomwILyvXqpNPLePVn4RU5cNMHKxq91z9WreQjSXf3mXh46zHhNwlazXdvQYEaNxHpg2Ri9xJI/Iy2XQAxrW06eVUN+0RdQnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GzzAzzTV; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GzzAzzTV"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260129092724epoutp016e1d6700ec827e2ac9a9702885a55b11~PKYhgCaSS1968019680epoutp01Z
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 09:27:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260129092724epoutp016e1d6700ec827e2ac9a9702885a55b11~PKYhgCaSS1968019680epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769678844;
	bh=HTJkzz/t9Yvine6k3rYUCcimE1lwu9jEJYFkbVE5xQA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GzzAzzTVXzlBQLcffAa6J4diAS2/dcKB9/cCFco2XOO6/hCKRPCrjmuuLQsRxD/ZM
	 lP73gbJdsDnsgnXQcfO6VHflm4/8wNP9Chs+Vvk4C0kWqEw/158wqIDR7IhE/8ylsf
	 4tlt6ECACReaM66Pu2bEbcpp31HCX+4Er5ZCKhKQ=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260129092723epcas5p17ea68069b8cddc520c61ea4540435011~PKYhIRM8v2500625006epcas5p1j;
	Thu, 29 Jan 2026 09:27:23 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4f1v1Q6K97z6B9mC; Thu, 29 Jan
	2026 09:27:22 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260129092722epcas5p262db49c6db5e12931dc0433090b20e57~PKYfn3rZJ2444824448epcas5p2R;
	Thu, 29 Jan 2026 09:27:22 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260129092720epsmtip186b0b3daa7cec921ec0d647610f08fd1~PKYeDuLvH0871908719epsmtip1L;
	Thu, 29 Jan 2026 09:27:20 +0000 (GMT)
Date: Thu, 29 Jan 2026 14:53:06 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj gupta <anuj1072538@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
	<djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: support file system generated / verified integrity information
Message-ID: <20260129092306.7kxrizlwwk2ee756@green245.gost>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260127151609.GA1883@lst.de>
X-CMS-MailID: 20260129092722epcas5p262db49c6db5e12931dc0433090b20e57
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_136471_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260129092722epcas5p262db49c6db5e12931dc0433090b20e57
References: <20260121064339.206019-1-hch@lst.de>
	<CACzX3AuDkwEw3v0bNmYLk8updk1ghVJa-T9o=EHXor9FA7badw@mail.gmail.com>
	<20260127151609.GA1883@lst.de>
	<CGME20260129092722epcas5p262db49c6db5e12931dc0433090b20e57@epcas5p2.samsung.com>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_136471_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 27/01/26 04:16PM, Christoph Hellwig wrote:
>On Tue, Jan 27, 2026 at 08:24:28PM +0530, Anuj gupta wrote:
>> Hi Christoph,
>>
>> Here are the QD1 latency numbers (in usec)
>
>Thanks a lot!
>
>Adding in the baseline numbers, as I wanted to compare those:
>
>> Intel Optane:
>>
>> Sequential read
>>   | size | baseline | xfs-bounce |  xfs-pi  |
>>   +------+----------+-----------+-----------+
>>   |   4k |    7.18  |    13.62   |     7.20 |
>>   |  64K |   36.40  |    99.66   |    34.16 |
>>   |   1M |  206.38  |   258.88   |   306.23 |
>>   +------+----------+------------+----------+
>
>So for 4k and 64k reads we basically get back to the baseline.
>The 1M numbers are puzzling, though.  I wonder if we need to
>add WQ_CPU_INTENSIVE or do some other tweaks to the XFS I/O
>completion workqueue so that we don't overload the scheduler.

Tried adding WQ_CPU_INTENSIVE[1] but didn't see any change in the 1M
latency. Looks like this needs something beyond just workqueue tuning.

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_136471_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_136471_--
