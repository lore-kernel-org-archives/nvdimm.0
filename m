Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072F51EEE6
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 03:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751601495; cv=none; b=iWpM1f7/cYh8GFbW++pAQ8Sa13TNKCjz3j0K6jA+ZuQHV+meTah/Q3+fhFulzeSKq3yyW19obw7+rguH51jB3Q1iSaJnAK5qMDV1T6J9/v9bR0KKClgscg3UjcKDNijbSC7+lRMCWQIYLn4g7/yG/lXZbKe7oF+hjON8uQyARxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751601495; c=relaxed/simple;
	bh=CwsW/v3kGTUgLenN3mCNVgbHpSdDlpbvzUgi56ChsA8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=txk0iuaEPdF2n8M+bxMsx/Dk8FqfucP7JPrPiMv4NnSlfNFBJxVNK9UqRz51SVC9ug12iDHylAqAnn38dDOZseHZypYaMrRN1ZnUT0HFfVTL6WkqAFnaQKZPg6iwwFllHCG9RW7azn3SPKQZRf67LWtonnWwudo4GHjTV9eg/8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Sy5ykVVv; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Sy5ykVVv"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250704035806epoutp01f8514954d9786c2ec55137b91bcea09c~O8EV6u6Qy2769427694epoutp01g
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 03:58:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250704035806epoutp01f8514954d9786c2ec55137b91bcea09c~O8EV6u6Qy2769427694epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1751601486;
	bh=x/8gj71UJV86nP6lspRD9k7s8nGbai8aJQjsGNNfkWs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Sy5ykVVv9igqpbrP5eTn+ACaqNixyqCQJqmIqarv/c9xCb+XH518N4F8tsGuN6meQ
	 wLMHXZFJBXmVuGd56oPNBUItOsjxPfYYpWTsJNPvjw6GK21ZZFZfTZ+F5jWxKGOdyt
	 zmIDWub3p70R5y6CFiKvCITYFA7C0LqlI6nfY/QY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250704035805epcas5p320c4465b7969403a662650d43de3d573~O8EVMpvZo0399503995epcas5p3J;
	Fri,  4 Jul 2025 03:58:05 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bYKbx3SWkz6B9m6; Fri,  4 Jul
	2025 03:58:05 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250703100429epcas5p1dd84b9da7f710c941e856857e212f64a~Ota9A8bTr0702407024epcas5p1G;
	Thu,  3 Jul 2025 10:04:29 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250703100426epsmtip1b6479f8c372de8f2814a0faefe0c5332~Ota6ltdXZ2058220582epsmtip1u;
	Thu,  3 Jul 2025 10:04:26 +0000 (GMT)
Date: Thu, 3 Jul 2025 15:34:21 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 02/20] nvdimm/label: Prep patch to accommodate cxl
 lsa 2.1 support
Message-ID: <158453976.61751601485478.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6865728b489a7_30f2b72947b@iweiny-mobl.notmuch>
X-CMS-MailID: 20250703100429epcas5p1dd84b9da7f710c941e856857e212f64a
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_ebefa_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124011epcas5p2264e30ec58977907f80d311083265641
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124011epcas5p2264e30ec58977907f80d311083265641@epcas5p2.samsung.com>
	<700072760.81750165203833.JavaMail.epsvc@epcpadp1new>
	<6865728b489a7_30f2b72947b@iweiny-mobl.notmuch>

------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_ebefa_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 02/07/25 12:55PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> In order to accommodate cxl lsa 2.1 format region label, renamed
>> nd_namespace_label to nd_lsa_label.
>
>This does not really make it clear why a name change is required.
>
>Could you elaborate here?

Hi Ira,

LSA 2.1 format introduces region label, which can also reside into LSA
along with only namespace label as per v1.1 and v1.2

As both namespace and region labels are of same size, i.e, 256 bytes.
Therefore I have introduced nd_lsa_label as following

   struct nd_lsa_label {
	union {
		struct nd_namespace_label ns_label;
		struct cxl_region_label rg_label;
	};
   };

Sure, I will update commit message with above information in next
patch-set.


Thanks,
Neeraj

------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_ebefa_
Content-Type: text/plain; charset="utf-8"


------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_ebefa_--

