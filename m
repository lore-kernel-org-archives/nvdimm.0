Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6801E8345
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 03:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751601496; cv=none; b=X66wuET/dpZZaGKn/O1SutxNduDl9/gP4iC7ROpo6mj5FDdRrRBC4GgRvxeHThHWLJb3kJd7jOL+xKEikPkjyxkc5UAwpyRB2769kqdD51rp77gIFjIZ+ObKGTYhwwooUtw8iP0nqFCtbLfhVeIjuSBNXCSh/Unn9gWl0k7Z/fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751601496; c=relaxed/simple;
	bh=6vtiqsGkXH2FbouCDpR/umgLYmDvg9LQPLVhwSO7BKA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=OiuVDz9SFm/dB6Fu58tdskeiy4J22JuyPv5XwdAZQypBlPIj63AAMyTXTYJjRL+aPPzkfti/rx+nn7bdCg0hajEET251nd8goUSC1ut3EqU2iBPnvBVhITa0rlsyvAiVjftVUq5FFtqI84t6yWbC/Y8a6X7fqQFyTmsz+4/zrgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=t6Mf+O/D; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="t6Mf+O/D"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250704035805epoutp0280e778e2d512908969837e5a58470a56~O8EVcOwSc3081130811epoutp02x
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 03:58:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250704035805epoutp0280e778e2d512908969837e5a58470a56~O8EVcOwSc3081130811epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1751601485;
	bh=y1yk4opDCPjmKM628eHmiZlHMD03Vy1w+UvD8XpWdAU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t6Mf+O/D4h6/RsSh0wLjN9k6yrkwr6Xm05sR2qz2fNtiXCHizpXr8tB36QHYa/v4V
	 fzXloFjpk0Fn9x7XQZcRKnwugbe/hTHCJ+2rE1YjSzkmrkF9qIJlM7AgHlKkVXWOhd
	 vFViyhSjA+3Eh53m3n1pNYpdQbQF4vEn8W5LKWKU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250704035805epcas5p4eb1db05d50806200a375ccd34b384339~O8EVA3aRK0395403954epcas5p4y;
	Fri,  4 Jul 2025 03:58:05 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bYKbx1zCRz3hhTL; Fri,  4 Jul
	2025 03:58:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250703095816epcas5p454227536450d705540b7112b997e14d9~OtVhXZavN0423504235epcas5p4I;
	Thu,  3 Jul 2025 09:58:16 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250703095813epsmtip287d61729b6612c78d9bc9341d37d40ca~OtVe8l26b2041620416epsmtip2t;
	Thu,  3 Jul 2025 09:58:13 +0000 (GMT)
Date: Thu, 3 Jul 2025 15:28:05 +0530
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
Subject: Re: [RFC PATCH 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to
 set cxl label format
Message-ID: <1931444790.41751601485259.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <686574227268c_30f2b7294f@iweiny-mobl.notmuch>
X-CMS-MailID: 20250703095816epcas5p454227536450d705540b7112b997e14d9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_eb8b1_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124008epcas5p2e702f786645d44ceb1cdd980a914ce8e
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124008epcas5p2e702f786645d44ceb1cdd980a914ce8e@epcas5p2.samsung.com>
	<158453976.61750165203630.JavaMail.epsvc@epcpadp1new>
	<686574227268c_30f2b7294f@iweiny-mobl.notmuch>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_eb8b1_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 02/07/25 01:02PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> NDD_CXL_LABEL is introduced to set cxl LSA 2.1 label format
>> Accordingly updated label index version
>
>I'm not following why CXL specific code needs to be in nvdimm?

Hi Ira,

Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1 was
introduced in CXL 2.0 Spec, which introduced region label along with
namespace label.

NDD_LABELING is the flag used to inform nvdimm driver about namespace
labels. As region label was introduced in cxl spec. so, I have used
NDD_CXL_LABEL flag to inform nvdimmm driver about it.

I have taken this naming reference from "drivers/nvdimm/label.h"
where region label is defined as "struct cxl_region_label"

Please let me know if i should use some other name in place of this


>
>I did not get a cover letter in this thread and looking at lore I don't
>see one either:
>
>https://lore.kernel.org/all/158453976.61750165203630.JavaMail.epsvc@epcpadp1new/
>
>So perhaps I am completely out of the loop here?  Could you point me at a
>cover letter?

Yes, there seems some issue due to which my patch thread got broken into two.
1. Cover letter:
https://lore.kernel.org/linux-cxl/1931444790.41750165203442.JavaMail.epsvc@epcpadp1new/

2. Rest of the thread:
https://lore.kernel.org/linux-cxl/158453976.61750165203630.JavaMail.epsvc@epcpadp1new/


Regards,
Neeraj

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_eb8b1_
Content-Type: text/plain; charset="utf-8"


------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_eb8b1_--

