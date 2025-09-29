Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AA72441A6
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726506; cv=none; b=kNwC8BFsxe2aXzDmJW3lrzoCVO5NqqSHVzzOha67BKQGudsOJ1wy8v9SiNOZJ2uRlq8wYGileczxSWsvfk2fohHPnUMUZnNGCv5N6r83pYNMaLQ+xap8kuJzP80OyJ4kyTeaF35olwYaYdk1qp8LxH0VkNvQQW5k9WH8p9moyV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726506; c=relaxed/simple;
	bh=GKC2jDqhCQ9O8+7T7/rP9f5i7qZZ8jtAYhu+br1ex1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=jClvO3+6kQumdHwV/eUxB/E2WN47Cb/OBHK/JUrZnJ8CDlz5dFeWxBAqulZI4jQRd73umJ1wwUAwQoVjKhRaGecw58LBzPp8amCnQ7OxpAtR7Fml28GnIUSWQ4Lm5CKrYA5je/8s3+LA2M69sJAqN0z619b3Qr3rDk7Xc7lOOfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RdoRTj9r; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RdoRTj9r"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251006045503epoutp01e6495e986338e52393867d3200c0d891~rze5tcy0w1733617336epoutp01o
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251006045503epoutp01e6495e986338e52393867d3200c0d891~rze5tcy0w1733617336epoutp01o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726503;
	bh=GKC2jDqhCQ9O8+7T7/rP9f5i7qZZ8jtAYhu+br1ex1Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RdoRTj9rGdcSaUPO5g01FYSQkoflGmG+4gPURTZczSTVM6x/s8C5mJhqA37nNXacQ
	 U6GzAGUj1+OJxNicRZ4KO5Ix7SEc9ZmfY51siPqaJmOedQFONreoLOov21qHBlLt2+
	 b8AdaWHAm1/aZna99K79VGpu3/7qbsW8iQr8skUM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251006045502epcas5p3585481acefe7e77e2d8e80ee0dddb36e~rze5X_Hw90897408974epcas5p3V;
	Mon,  6 Oct 2025 04:55:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cg6QG6l4Nz3hhT7; Mon,  6 Oct
	2025 04:55:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250929133323epcas5p11c22399e6fa7cd5806f84e2106b09951~pxCd13SUR2718427184epcas5p18;
	Mon, 29 Sep 2025 13:33:23 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929133321epsmtip2dab0f6778d09657ff92da18130db8819~pxCcrNI1A2858028580epsmtip2W;
	Mon, 29 Sep 2025 13:33:21 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:03:17 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 00/20] Add CXL LSA 2.1 format support in nvdimm and
 cxl pmem
Message-ID: <1931444790.41759726502934.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aNMnmdOY4g5PRpxY@aschofie-mobl2.lan>
X-CMS-MailID: 20250929133323epcas5p11c22399e6fa7cd5806f84e2106b09951
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_7375_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134126epcas5p3e20c773759b91f70a1caa32b9f6f27ff
References: <CGME20250917134126epcas5p3e20c773759b91f70a1caa32b9f6f27ff@epcas5p3.samsung.com>
	<20250917134116.1623730-1-s.neeraj@samsung.com>
	<aNMnmdOY4g5PRpxY@aschofie-mobl2.lan>

------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_7375_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/09/25 04:04PM, Alison Schofield wrote:
>On Wed, Sep 17, 2025 at 07:10:56PM +0530, Neeraj Kumar wrote:
>> Introduction:
>> =============
>> CXL Persistent Memory (Pmem) devices region, namespace and content must be
>> persistent across system reboot. In order to achieve this persistency, it
>> uses Label Storage Area (LSA) to store respective metadata. During system
>> reboot, stored metadata in LSA is used to bring back the region, namespace
>> and content of CXL device in its previous state.
>> CXL specification provides Get_LSA (4102h) and Set_LSA (4103h) mailbox
>> commands to access the LSA area. nvdimm driver is using same commands to
>> get/set LSA data.
>
>big snip...
>
>> Limitation (TODO):
>> ==================
>> Current changes only support interleave way == 1
>
>I see your test setup with the one way interleave and read this
>limitation. What are your plans regarding this?
>
>ie. Do you see this limitation as something you could merge with
>or do you plan to extend this patchset with support for namespaces
>build upon region ways > 1.
>
>-- Alison

Hi Alison,

My current focus is to get current patch-set upstreamed as its in good
shape wrt interleave way == 1.

Multi-interleave support will require some more efforts on top of this
change. So will take it in another series.


Regards,
Neeraj


------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_7375_
Content-Type: text/plain; charset="utf-8"


------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_7375_--

