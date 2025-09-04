Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F963093C7
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756996492; cv=none; b=Kcd/5uYy1s+6ftD/Rd+scSXI6l58xkO0x5Y3ni+xZy3r+idCGY6XPOl2GPNH2S3i0lHcCBObGQwByDP0+lSSbz4Dr+BnN5awHLjnmnLZlMt+WxQ2v272zFSlSJhHHANDJTy9FS8uQ167weHmM01XZqPXd5RMdZFveAgrf6W88EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756996492; c=relaxed/simple;
	bh=5bp/92ROC/MIhinmDI/pNyNNDoOoefSD9Kf2q8amg/A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=nBfh4FZdWIY5eucj01rySJRBQnuZmmld0ncqNkDvMd3JZoklm+BzablNMHlsitAMEDOholaE6YQAoad+drguxcMxdSkwbYFtcP/VPrjVwufisZDafTnX3MooRVMn81smz9DO19kwKNkEXlJWyK3byV+Ns+lHZgnZ1sDy2e7fhZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ft7R67z6; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ft7R67z6"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250904143448epoutp026775ecd010a210840146bbaf495a2bba~iGv9K8IaP2123721237epoutp02U
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:34:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250904143448epoutp026775ecd010a210840146bbaf495a2bba~iGv9K8IaP2123721237epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756996488;
	bh=jnfTWRF/FMaqmWy+MGqeeb2CttG3aCtI8os1JvqG2AU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ft7R67z6oETGIdpRuLeRNGdMWi/wf1IaP2G6d0SsoIBXezRXx9Rt99XnNKKP3idSc
	 MGl7Miwx6UqEiQfQTYR6zyuZYXriuVeWHU+ZsxxK93GOF4dd8U3iaHiMUg+BA0Ke/H
	 3GvQ3tpG9gZ5jN/Kwop/RSCllNYuZg7qPdrmvySw=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250904143447epcas5p3d02bc4203cd4e4a428a60dd0a71b533a~iGv8YJIZz2391723917epcas5p3O;
	Thu,  4 Sep 2025 14:34:47 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.88]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cHhny4Bcjz6B9m4; Thu,  4 Sep
	2025 14:34:46 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250904143446epcas5p3ecf61b44e98a9e6eda2d8d49e4992de0~iGv7Aaf7K2391723917epcas5p3N;
	Thu,  4 Sep 2025 14:34:46 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904143444epsmtip1336043d5c30befc8ec88a30fd6779655~iGv53pWe50814008140epsmtip1h;
	Thu,  4 Sep 2025 14:34:44 +0000 (GMT)
Date: Thu, 4 Sep 2025 20:04:40 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 12/20] nvdimm/namespace_label: Skip region label
 during namespace creation
Message-ID: <20250904143440.l5fca2dgvmi2c325@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813165554.00002dea@huawei.com>
X-CMS-MailID: 20250904143446epcas5p3ecf61b44e98a9e6eda2d8d49e4992de0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead3a_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121238epcas5p212dcce5cc5713173913ee154d5098a2c
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121238epcas5p212dcce5cc5713173913ee154d5098a2c@epcas5p2.samsung.com>
	<20250730121209.303202-13-s.neeraj@samsung.com>
	<20250813165554.00002dea@huawei.com>

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead3a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 04:55PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:42:01 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> During namespace creation skip presence of region label if present.
>
>Confusing description.  What does skipping presence mean?
>Reword.
>
>During namespace creation, skip any region labels found.

Thanks Jonathan, I will fix it in next patch-set

>
>
>> Also preserve region label into labels list if present.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/namespace_devs.c | 50 +++++++++++++++++++++++++++++----
>>  1 file changed, 45 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index e5c2f78ca7dd..8edd26407939 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -1985,6 +1985,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
>>  		if (!lsa_label)
>>  			continue;
>>
>> +		/* skip region labels if present */
>
>This is kind of obvious comment. I'd drop it.

Sure, I will drop it in next patch-set


Regards,
Neeraj

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead3a_
Content-Type: text/plain; charset="utf-8"


------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead3a_--
