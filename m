Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A2A34BA46
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768145287; cv=none; b=BCehNFt4UKoWdr41Ovnimfr1ft7rAkyGXJWIrc+6cIxnRHRJ1urHizzMeNRUOFzniQqIwUAI6QpmaOZ3wAmWYxDHeUJ/mfF+u2ZoWbe6h4mcf0haJaIJzIHVCy9yg6pckl5JikUZ9XF3vlcwwwyQuWJuhukdTUuf8Dpt6tnkijg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768145287; c=relaxed/simple;
	bh=er/XHv/UxzTnDZeFO/hTKeu0UtTrtvITjK87Z7hOtz0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=fkQqIywl9jhAiAvV/YWLznnarZdvcld65fE5Nu1qWEu/0w+h7dVYymxroJf/lyCA0hb6vp+dqdp85HxNwwfb+0A81U9WIYGTAE6iwh25LceKaEZbckhe/8++8IZnIJ2NzqYQ23acpKJ9H9thEY/ncS4qyp+SY/GzYnGNmIGeR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TUt9++Nb; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TUt9++Nb"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260111152803epoutp01155ea55ad8e430e2b75a9952c8c90a7e~JtsRSHosK0553105531epoutp01N
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:28:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260111152803epoutp01155ea55ad8e430e2b75a9952c8c90a7e~JtsRSHosK0553105531epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768145283;
	bh=er/XHv/UxzTnDZeFO/hTKeu0UtTrtvITjK87Z7hOtz0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TUt9++NbDvxYHlAP+7bE70O0szyc3DpGc9iv8kcCU69qi8IZD1505SgziD3MLUNuf
	 DIsrMBygN43X8710C0itcas2L5dmpI7zPVr/mJkFIpQGsaw7ZYhSSu2k1rMAZDy0b5
	 0vFiWck5ZpnlYzoP9a4/oIXmFrDD3Qe2R02cCiko=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260111152802epcas5p271cb58809713b04a304c151ad6f3617d~JtsRB_FFF0973309733epcas5p2x;
	Sun, 11 Jan 2026 15:28:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dpzst57vpz2SSKX; Sun, 11 Jan
	2026 15:28:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260109120309epcas5p1c7ff1efa664229af7fa28dcc52bef559~JDmz6yjfa0990909909epcas5p19;
	Fri,  9 Jan 2026 12:03:09 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109120307epsmtip16b84737e05ddabbebb501138e3e332d8~JDmxdziOF1701617016epsmtip1d;
	Fri,  9 Jan 2026 12:03:07 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:33:02 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 08/17] nvdimm/label: Preserve cxl region information
 from region label
Message-ID: <1983025922.01768145282705.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f161f011-e4f3-47f4-aa09-6266da1cd423@intel.com>
X-CMS-MailID: 20260109120309epcas5p1c7ff1efa664229af7fa28dcc52bef559
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_e5510_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7@epcas5p1.samsung.com>
	<20251119075255.2637388-9-s.neeraj@samsung.com>
	<f161f011-e4f3-47f4-aa09-6266da1cd423@intel.com>

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_e5510_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/11/25 01:13PM, Dave Jiang wrote:
>
>
>On 11/19/25 12:52 AM, Neeraj Kumar wrote:
>> Preserve region information from region label during nvdimm_probe. This
>> preserved region information is used for creating cxl region to achieve
>> region persistency across reboot.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>
>Assume there's a plan to add >1 region labels preservation in the next step?

Thanks Dave for RB tag. Yes, I will prepare in next patch series.


Regards,
Neeraj

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_e5510_
Content-Type: text/plain; charset="utf-8"


------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_e5510_--

