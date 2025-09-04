Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D948F3090FA
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756995898; cv=none; b=MTBNCTGUQFXC7dz/cIRnD3hMhChBX690XuQ4vlxx/JUp070KJ/qN+9M3yHEkEAI54a90+8UMHZGRv1dRwfUcnHyzPZP5Q6W3WZZJk346BVNb+hD+FZZHVvCYKS9pMHRRLX+89bYjvvsWS+RkyFM7C4RgZdkQEVnS9c2T55McD4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756995898; c=relaxed/simple;
	bh=rXizUaMeeJHGRgDHEsOcoN4pKpjy1oo22NgyBntIbd8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=mUq7iTNIGnLUQFsQs6u8BV5Gv/kkzF27oTsZxuJHGKPAgNoOFu+OGRoUnY0AAQ6WfsDy60RbicwrNuHp8PPI9Q2AeHR1euTAUpz6h22qKgEnY5Tuz03xbyAMhkKDkosBhOT8Kw+97XaIkD6m+v29ckeBnmZo2CCrZzMRlM3BseU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jsegh/IR; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jsegh/IR"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250904142454epoutp04b14362cbd68fc8ed3c9be769ea97a37f~iGnUYKTeM0113501135epoutp04D
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:24:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250904142454epoutp04b14362cbd68fc8ed3c9be769ea97a37f~iGnUYKTeM0113501135epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756995894;
	bh=qoiDptdgyUFjz3gdoq09yJAfTI36DqUH1Pp0hibVgZo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jsegh/IRue9FkRjWI9Jsbifv/w/KCnfCghGHystwM762lRXHq4Q6odCPjYFARFpfE
	 19JMfNkEuIzr0LKYjgs1w815OYNWH9rEafbl7qaXC+7cOvKsVHmVwXIjcxm5CDJ9EP
	 RpnCq6pBS0y6W5rlfS2J3z48kNJ8Tn05ycxXo4Q0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250904142454epcas5p12ac962b94580190e5a3f6600c08ed63d~iGnUEGH7R0053600536epcas5p1V;
	Thu,  4 Sep 2025 14:24:54 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cHhZY4BGwz6B9m6; Thu,  4 Sep
	2025 14:24:53 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250904142452epcas5p40047078323fae682cca73f6dc99028aa~iGnSP93N83180031800epcas5p4p;
	Thu,  4 Sep 2025 14:24:52 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250904142451epsmtip259cd7272a4eb456ae1007c891cc2b754~iGnRAO_-r1019010190epsmtip2p;
	Thu,  4 Sep 2025 14:24:51 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:54:45 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 07/20] nvdimm/namespace_label: Update namespace
 init_labels and its region_uuid
Message-ID: <20250904142445.gohwsacmtuuqb6uu@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813155802.00003f3d@huawei.com>
X-CMS-MailID: 20250904142452epcas5p40047078323fae682cca73f6dc99028aa
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e2696_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908@epcas5p2.samsung.com>
	<20250730121209.303202-8-s.neeraj@samsung.com>
	<20250813155802.00003f3d@huawei.com>

------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e2696_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 03:58PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:41:56 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> nd_mapping->labels maintains the list of labels present into LSA.
>> init_labels() prepares this list while adding new label into LSA
>> and updates nd_mapping->labels accordingly. During cxl region
>> creation nd_mapping->labels list and LSA was updated with one
>> region label. Therefore during new namespace label creation
>> pre-include the previously created region label, so increase
>> num_labels count by 1.
>>
>> Also updated nsl_set_region_uuid with region uuid with which
>> namespace is associated with.
>
>Any reason these are in the same patch?  I'd like to have
>seen a bit more on why this 'Also' change is here and a separate
>patch might make that easier to see.

I will create separate commit to update region_uuid and will remove
'Also' part from commit message. Yes both hunks are not associated,
I just added both to avoid extra commit.


Regards,
Neeraj

------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e2696_
Content-Type: text/plain; charset="utf-8"


------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e2696_--
