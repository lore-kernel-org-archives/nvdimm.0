Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF6F2D249D
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055609; cv=none; b=UiMi0/+YrWTHhUAAiD/QLhMdiHtgN23fDCz/v1c3cR2QnXF+MBZZ9T3tFm4ZZr9xD0MEjkBY6x3pHqXxn0uqrqP9JMo4xEvN8REKtmaVhdt06/3aw59XfFzofkxrQVQHcY27WTORr8wVVUUveMCGjBbLTVTbi/LxDNxKMAZb+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055609; c=relaxed/simple;
	bh=T94U4u4ndfwQNdB24yKMar3pl1BSpRMYtTtU0E6yqRw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=NCJ6eQJYOR9sHkjH9BCjktjtlBHz+g/J0QhLYpZNy5qxDVZe5wAv7dw2oJjTu3koNkNrlsOvrSTAUpKKOoGotxOsfUrnilpNbbcl464kZT8KA6WhsrGB7PgbFTMMJJGSpmq9Lyo4rnmwIXE1LQmMe6sUJexbiKXN8p3bFGMtOwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=T7A+SgM1; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="T7A+SgM1"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250905070004epoutp045fdc7298d437849bdf686080304dd81f~iUMNUQ1dO1717317173epoutp04p
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250905070004epoutp045fdc7298d437849bdf686080304dd81f~iUMNUQ1dO1717317173epoutp04p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055604;
	bh=FPej9pylEfUnXQeixCSbjCCQx5bISB6zYCJNf1naRCg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=T7A+SgM14zHeWwEO/WY+/7d5XTi5audJAhxo/jbLw+U/zVsd/bZAm29YCMmos2o+3
	 KxNVOzyPkQtkTzC0m4978pQQavSuMVmKjcGu5rOAQVPvcxv2cbb7feSEq87abYANdl
	 8fk1dssmrV6n/7oKTT5EHKrOX6kGNSDRz/1LYiuI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250905070004epcas5p3717e4756fcb0a2d4c693c5022a760ffd~iUMNAc1Ly1350313503epcas5p3C;
	Fri,  5 Sep 2025 07:00:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cJ6fr0v3vz6B9mJ; Fri,  5 Sep
	2025 07:00:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250904134230epcas5p15b5b25aefd08067fee89d01e380bc382~iGCS5eeF52799727997epcas5p1E;
	Thu,  4 Sep 2025 13:42:30 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250904134229epsmtip22685a37b72a541c03d91c67e709d4f2e~iGCRw3Qgd1747417474epsmtip2K;
	Thu,  4 Sep 2025 13:42:29 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:12:18 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 02/20] nvdimm/label: Prep patch to accommodate cxl
 lsa 2.1 support
Message-ID: <158453976.61757055604113.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <68a49a905dd78_27db95294b@iweiny-mobl.notmuch>
X-CMS-MailID: 20250904134230epcas5p15b5b25aefd08067fee89d01e380bc382
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----wuQ5K4.jSQvA6_-.KzAZ9UFwpnGjqQNXiA11E0kuSR3-Q0Zz=_e3067_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e@epcas5p3.samsung.com>
	<20250730121209.303202-3-s.neeraj@samsung.com>
	<68a49a905dd78_27db95294b@iweiny-mobl.notmuch>

------wuQ5K4.jSQvA6_-.KzAZ9UFwpnGjqQNXiA11E0kuSR3-Q0Zz=_e3067_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/08/25 10:38AM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> LSA 2.1 format introduces region label, which can also reside
>> into LSA along with only namespace label as per v1.1 and v1.2
>>
>> As both namespace and region labels are of same size of 256 bytes.
>
>Soft-NAK
>
>Having 2 data structures of the same size is not a reason to combine their
>types.
>
>Please explain how nd_namespace_label is related to the new region label
>and why combining them is a net benefit.  This change may need to be made
>later in the series if that makes it more understandable.
>

Hi Ira,

Currently we have support of LSA v1.1 and v1.2 in Linux, Where LSA can
only accommodate one type of labels, which is namespace label.

But as per LSA 2.1, LSA can accommodate both namespace and region
labels.

As v1.1 and v1.2 only namespace label therefore we have "struct
nd_namespace_label"

As this patch-set supports LSA 2.1, where an LSA can have any of
namespace or region label. It is therefore, introduced
"struct nd_lsa_label" in-place of "struct nd_namespace_label"

>> Thus renamed "struct nd_namespace_label" to "struct nd_lsa_label",
>> where both namespace label and region label can stay as union.
>
>For now I'm naking this patch unless there is some justification for
>changing all the names vs just introducing "nd_region_label" or whatever
>it might need to be named.
>
>Ira
>

I understand that this renaming has created some extra noise in existing
code. May be I will revisit this change and try using region label
handling
separately instead of using union.

Regards,
Neeraj

------wuQ5K4.jSQvA6_-.KzAZ9UFwpnGjqQNXiA11E0kuSR3-Q0Zz=_e3067_
Content-Type: text/plain; charset="utf-8"


------wuQ5K4.jSQvA6_-.KzAZ9UFwpnGjqQNXiA11E0kuSR3-Q0Zz=_e3067_--

