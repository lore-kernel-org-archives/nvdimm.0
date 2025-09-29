Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F92524A04A
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726510; cv=none; b=e4QAWrxkW4OCGn31llYepXwbs/fLo34jS+fMylcQyeKc31D6VxsEMFKZESqqz7laBM74WalrsOlR1hknfAEkNTp6pPNQ+HQa6fg/FtKaFltnJRtN11aCKSmSqg4bNnu+G6rE/2y7AmRS3C+t/ijO/2j8KwzhttX45EU1YGU7zAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726510; c=relaxed/simple;
	bh=ivNLbrcVf31S8sBPae+ncnEMp0uVn4p3a8QV2tab48U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=eooCZZjHUB4PPjdJFKneGICp49fYnj5QZTQdEsGKd/01MqrYqoBI8MbThslz+cVObnQGBn/xSWsd1sN0G/+mrM8YHP+EI4Zb4yVlmXfozAYQ/HQkwVjN9aeBV3//f7ccaSQraBDJ5XgfiVszFq5L8TL9lLv8mE0zutHfHs4ySuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=S1Bq9dIE; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="S1Bq9dIE"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251006045505epoutp017fb2df3ae8164c4cbccffa78ebec5c50~rze8FZLO91645616456epoutp01G
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251006045505epoutp017fb2df3ae8164c4cbccffa78ebec5c50~rze8FZLO91645616456epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726505;
	bh=ivNLbrcVf31S8sBPae+ncnEMp0uVn4p3a8QV2tab48U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S1Bq9dIEJKGcEpGQorBManeodrB/OzpdAJ/ZKW4ZtUHBJ5G/KgXUWMre1emF944XI
	 fJLHdmVg4MTxZ4jjAcXFXvUrKUrAqZ3BVA+t3vteYDKME4ADZwbG7ir2Qhkixh3Xa5
	 EEOju8ABpzY/QOXFuIZjjpe4K6wrgHj+gj9DL7zc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251006045505epcas5p31ab6da49f91e0ee8a2955e1dbfed18bb~rze7thTUR2860328603epcas5p3J;
	Mon,  6 Oct 2025 04:55:05 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cg6QK3Fhrz6B9mB; Mon,  6 Oct
	2025 04:55:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250929141921epcas5p108726cfc1dcbc0f911df2ac28e6b54b4~pxqmxKVhp2852028520epcas5p1x;
	Mon, 29 Sep 2025 14:19:21 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929141917epsmtip2886d4998032f062d081d50a0dfcd91bf~pxqjJhU8W1938819388epsmtip2v;
	Mon, 29 Sep 2025 14:19:17 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:49:13 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Message-ID: <720167805.241759726505455.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aNRlzI9b2oFk_VeC@aschofie-mobl2.lan>
X-CMS-MailID: 20250929141921epcas5p108726cfc1dcbc0f911df2ac28e6b54b4
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----SANDhlYmavlWOafSlba8Uwn5SYx3JopzY9bfx6BHCYDp5Sgs=_75b2_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc@epcas5p1.samsung.com>
	<20250917134116.1623730-5-s.neeraj@samsung.com>
	<aNRlzI9b2oFk_VeC@aschofie-mobl2.lan>

------SANDhlYmavlWOafSlba8Uwn5SYx3JopzY9bfx6BHCYDp5Sgs=_75b2_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 24/09/25 02:42PM, Alison Schofield wrote:
>On Wed, Sep 17, 2025 at 07:11:00PM +0530, Neeraj Kumar wrote:
>> Updated mutex_lock() with guard(mutex)()
>
>Along with the other reviewer comments to limit the application
>of guard() to where it is most useful, can this be spun off
>as a single patch that would be done irregardless on the
>new label support?
>
>I'm asking the question. I don't know the answer ;)
>

This patch is independent and not related with this series.
Its good to send this seperately.


Regards,
Neeraj


------SANDhlYmavlWOafSlba8Uwn5SYx3JopzY9bfx6BHCYDp5Sgs=_75b2_
Content-Type: text/plain; charset="utf-8"


------SANDhlYmavlWOafSlba8Uwn5SYx3JopzY9bfx6BHCYDp5Sgs=_75b2_--

