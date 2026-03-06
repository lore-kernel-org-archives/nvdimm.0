Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AA426F291
	for <nvdimm@lists.linux.dev>; Sun,  8 Mar 2026 04:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772944213; cv=none; b=EYKuizwAG002GMrZw8HFMGe98ZqBfDRknGfQ7w5n01QR9G/xBP3BZKxhKNMauJK6oDizzGYFQZX4Dl+NG03ncE3o0Qu/9JP0ycQjl8+uKfNAqwllysOYsgwsJ33QTrOZayIt1LgDIFCQ1FvAfkSPvlJ62oHec3LOiVAiGO949zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772944213; c=relaxed/simple;
	bh=/s3d8a7+gjncW1qLGaaofIMKDVUL0/tVG6Pn12FLLgA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Oz2Rvhz/aAjwcxZlbPTcm5MilpW74X8bAnvJf4SHKvK/WRlaUS3l3Nh4Mfz2C9W9pse4XflDQWTxQM851m3BAlTt39HOwoPCD92ZrHQU3VZuKZte2EC0BD3KlTSYqRT3PYjCo/caCQDRtdjAM1cWXhnKgkoMueM52r8iekK7QQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oVWOlX8g; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oVWOlX8g"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260308043002epoutp0312ff08b0edbf89622065b2fb25df03e8~aw1vL0lvK1784317843epoutp03E
	for <nvdimm@lists.linux.dev>; Sun,  8 Mar 2026 04:30:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260308043002epoutp0312ff08b0edbf89622065b2fb25df03e8~aw1vL0lvK1784317843epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1772944202;
	bh=/s3d8a7+gjncW1qLGaaofIMKDVUL0/tVG6Pn12FLLgA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oVWOlX8grc4p+2R/ur66rBxqLV9YyMOesIRehfJvkDYUsBw34h/JbRtzwQS+HLTtb
	 BnK1c6kwngxreUiL2de2jCVorvnlNYLdrCeYcoSjzT0K7z3jaGoUmUjsxN7KeAZ8ZR
	 dNyjfCcP+k/p80cncrjGCoI6i3aNSIXvs2zfCqAc=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260308043001epcas5p3632372647d98ca38a3150abac37a04c4~aw1uy6lCu1848318483epcas5p3O;
	Sun,  8 Mar 2026 04:30:01 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4fT6cn6JRHz2SSKZ; Sun,  8 Mar
	2026 04:30:01 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260306102730epcas5p308774b7b9f51e5a6c963a8b8599ab357~aObRtAise1284812848epcas5p3d;
	Fri,  6 Mar 2026 10:27:30 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260306102726epsmtip24a49a52c28cb736735db95b08c67bcf7~aObN6RQTD2983129831epsmtip2A;
	Fri,  6 Mar 2026 10:27:26 +0000 (GMT)
Date: Fri, 6 Mar 2026 15:57:19 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V6 00/18] Add CXL LSA 2.1 format support in nvdimm and
 cxl pmem
Message-ID: <1296674576.21772944201878.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aXPlGrs12BdwgGkG@aschofie-mobl2.lan>
X-CMS-MailID: 20260306102730epcas5p308774b7b9f51e5a6c963a8b8599ab357
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----3W3K1-v49fY0BJe7N6_WbqFXaoVLme8r7b8baEfkTbmtWBCI=_73c11_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91
References: <CGME20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91@epcas5p1.samsung.com>
	<20260123113112.3488381-1-s.neeraj@samsung.com>
	<aXPlGrs12BdwgGkG@aschofie-mobl2.lan>

------3W3K1-v49fY0BJe7N6_WbqFXaoVLme8r7b8baEfkTbmtWBCI=_73c11_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 23/01/26 01:16PM, Alison Schofield wrote:
>On Fri, Jan 23, 2026 at 05:00:54PM +0530, Neeraj Kumar wrote:
>
>snip
>
>>
>> Testing:
>> ========
>> In order to test this patchset, I also added the support of LSA v2.1 format
>> in ndctl. ndctl changes are available at [2]. After review, I’ll push in
>> ndctl repo for community review.
>
>Please post the ndctl changes for review. Thanks!

Sure Alison,

I am working on multi interleave support, So it may require some change in ndctl also.
I will post ndctl changes along with next series.


Regards,
Neeraj

------3W3K1-v49fY0BJe7N6_WbqFXaoVLme8r7b8baEfkTbmtWBCI=_73c11_
Content-Type: text/plain; charset="utf-8"


------3W3K1-v49fY0BJe7N6_WbqFXaoVLme8r7b8baEfkTbmtWBCI=_73c11_--

