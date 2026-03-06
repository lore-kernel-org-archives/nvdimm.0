Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A7A3101B6
	for <nvdimm@lists.linux.dev>; Sun,  8 Mar 2026 04:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772944213; cv=none; b=Bm+35UiW17aBqSsTZIsDs4sh7OPhrh6STW+HQHjU3hhwy/Ts5d5WKpu3C3maKhZLDsqSzAAfEvXBt3cWb9jY0awxAlp9RiqkFpjUPsYctPrj6wtcB/h3nPjO29U88a037sGWpaOR5aEFJ7lbZEGwffEGApaUoETKL4VGJGfm658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772944213; c=relaxed/simple;
	bh=0qgP1SzBYD+UBYHM7QR056M5D5ActHvOI5e8wnBlFYo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=EiWzFg0WEpUGCwO7qdNpSs6Ij/jEt0BNCQkG1fOvL8j9EzTRkGXPT/AvgsLiHUjeONeHbpX57T/qmRBEL57loAcwS3t4RUF6fDtye0YOoRq/EdPHqM3YliV/aNWqlc6k6h0Dp2vSWEkKKiKkC834tjEhvsVhEvQtwObv2r6+AH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FMXcsjln; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FMXcsjln"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260308043002epoutp0168d88ab65e71ca3fd92ef9ae131c9314~aw1vA_Rf41195111951epoutp01P
	for <nvdimm@lists.linux.dev>; Sun,  8 Mar 2026 04:30:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260308043002epoutp0168d88ab65e71ca3fd92ef9ae131c9314~aw1vA_Rf41195111951epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1772944202;
	bh=N1fuOX8nls70mXuE38bUprfyJ1x0tNIUNCbRv9tyeHs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FMXcsjlncXWuQULEYskrN23Yx4ZsI/+uatDGJBFH8iyWTKpW3qh2myeVzjkTG6lkM
	 pj5wLRhA+28g/Oy02lDSMi3CxWoPFduawY8cbZl7FrxmfX1yz40rmrcCzMl5sO4HG6
	 4WFdTTeR7RfioU4snCeCV1YOwOQNj+69bOHdg22Y=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260308043001epcas5p254afd7af8b38ab4a9b894d3da24bb460~aw1ujENVN2746927469epcas5p2N;
	Sun,  8 Mar 2026 04:30:01 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4fT6cn4W4kz2SSKZ; Sun,  8 Mar
	2026 04:30:01 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260306102615epcas5p3d75eee2880f9c2e52d3a7eb29c1b1e1b~aOaL_LdTd0510005100epcas5p3e;
	Fri,  6 Mar 2026 10:26:15 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260306102614epsmtip1394ce8285158e3a6411ec2f143f759b1~aOaKuVztH1949319493epsmtip1a;
	Fri,  6 Mar 2026 10:26:14 +0000 (GMT)
Date: Fri, 6 Mar 2026 15:56:09 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V6 00/18] Add CXL LSA 2.1 format support in nvdimm and
 cxl pmem
Message-ID: <1983025922.01772944201612.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <46584975-f4c5-4f3a-80b2-2ef5a0e4dd6b@intel.com>
X-CMS-MailID: 20260306102615epcas5p3d75eee2880f9c2e52d3a7eb29c1b1e1b
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Z2c.vZYTqadSC4aRsepS5iQJaG.Uxsawwox_nsRND3Ee9O4E=_73e4c_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91
References: <CGME20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91@epcas5p1.samsung.com>
	<20260123113112.3488381-1-s.neeraj@samsung.com>
	<46584975-f4c5-4f3a-80b2-2ef5a0e4dd6b@intel.com>

------Z2c.vZYTqadSC4aRsepS5iQJaG.Uxsawwox_nsRND3Ee9O4E=_73e4c_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/01/26 10:52AM, Dave Jiang wrote:
>
>
>On 1/23/26 4:30 AM, Neeraj Kumar wrote:
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
>Hi Neeraj,
>I'm attempting to vet the series before applying to cxl/next. But it seems to be failing multiple unit regression tests in cxl_test. We need to figure out why before the series can be merged. Most likely the changes in this series also require cxl_test updates. Can you please take a look? I will also take a look and try to help you address the issues. Thanks
>
>Ok:                 10
>Expected Fail:      0
>Fail:               4
>Unexpected Pass:    0
>Skipped:            1
>Timeout:            0
>
>The script below [1] can get you up and running with a qemu environment where you can run cxl_test.
>
>.../run_qemu/run_qemu.sh --cxl --cxl-test --cxl-debug --hmat -r wipe
>
>cd ndctl
>meson test -C build --suite=cxl
>
>[1] https://github.com/pmem/run_qemu
>
>DJ

Sure Dave,

I am able to reproduce the same, I will analyze and fix them in next patch series.


Regards,
Neeraj

------Z2c.vZYTqadSC4aRsepS5iQJaG.Uxsawwox_nsRND3Ee9O4E=_73e4c_
Content-Type: text/plain; charset="utf-8"


------Z2c.vZYTqadSC4aRsepS5iQJaG.Uxsawwox_nsRND3Ee9O4E=_73e4c_--

