Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AF135B137
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961590; cv=none; b=p9sykszi5nX1A3/ZHaRtg96oZ8X+lOyYSc9h+jjonYJ/TzrBHOANwI6Pfp+1JGD9vDdQEylVRxK4TJB+1UvvbTqsHkGx8brku1FhLejQJPh0yJjXRRaC9gUXe/t/FEFLSsJVTJW+mBFzv/yl10x7D3xj1vdLXtZV2XPcApSKSbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961590; c=relaxed/simple;
	bh=BcY+vqbk/I8+92CEv/b8+SMUOcs3EO5U90uyAtZmk8w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=iojycfydQHUfR+2xa6tC1LkL/iORUOGqaDeuQtJJxoy3PWHfF25LADWwCUerDe8aH8Fg0ebopJAdgrVINUDu+c+5/BoHrZ60rFVd+RzsFyYgOgOHlt0X9BSlJkYE+ynN8K917TAGpKmiFANDKQ1AyN21frhsfbcftJZ5LouMY+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YeACgAYE; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YeACgAYE"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260109122626epoutp04b69041c99db1c382e2ecb15ad158203b~JD7IiPUSx1350013500epoutp04Q
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:26:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260109122626epoutp04b69041c99db1c382e2ecb15ad158203b~JD7IiPUSx1350013500epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767961586;
	bh=kleLtImyRJiChWgLb2YQwZJI+VAiPbjbF79QLS8MXAU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YeACgAYEEAc5imQzfUi6POWzE72Kco2qRoBMir6iIw133yq7ISp4oair9i5RbZ5wa
	 wXOGbUq+ET2VgWKG7MUg1dwWnmpKlh0BOj1g270c0yNrtN9LUzsZKgslionfJZhBID
	 iz0NK4KHT/q8UxZQ+cIaYNkDY4/pa/nLO6TJhHX0=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260109122626epcas5p472c50adb88b32c7ac83726bbb2a66da6~JD7IIqcZv0428204282epcas5p4f;
	Fri,  9 Jan 2026 12:26:26 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dngxF0GF0z2SSKX; Fri,  9 Jan
	2026 12:26:25 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260109122624epcas5p4e3ece0d53cbdb6f0856310fe40c2e3aa~JD7GkSYc40428204282epcas5p4Z;
	Fri,  9 Jan 2026 12:26:24 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109122623epsmtip1c0d681da9d4ede35ceb82b3dd8bd3172~JD7FYOlEz2771427714epsmtip1o;
	Fri,  9 Jan 2026 12:26:22 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:56:16 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 13/17] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Message-ID: <20260109122616.ihwrfzbktsgv5l67@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217153529.00002c2b@huawei.com>
X-CMS-MailID: 20260109122624epcas5p4e3ece0d53cbdb6f0856310fe40c2e3aa
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_e6279_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075332epcas5p2d173f0373aa1ccdfcd4d75c68d5d09fd
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075332epcas5p2d173f0373aa1ccdfcd4d75c68d5d09fd@epcas5p2.samsung.com>
	<20251119075255.2637388-14-s.neeraj@samsung.com>
	<20251217153529.00002c2b@huawei.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_e6279_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/12/25 03:35PM, Jonathan Cameron wrote:
>On Wed, 19 Nov 2025 13:22:51 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> For region label update, need to create device attribute, which calls
>> nvdimm exported routine thus making pmem_region dependent on libnvdimm.
>> Because of this dependency of pmem region on libnvdimm, segregate pmem
>> region related code from core/region.c to core/pmem_region.c
>>
>> This patch has no functionality change. Its just code movement from
>> core/region.c to core/pmem_region.c
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>Minor stuff below.
>Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks Jonathan for RB tag.

>
>
>>  #define SET_CXL_REGION_ATTR(x)
>> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
>> new file mode 100644
>> index 000000000000..b45e60f04ff4
>> --- /dev/null
>> +++ b/drivers/cxl/core/pmem_region.c
>> @@ -0,0 +1,202 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright(c) 2020 Intel Corporation. */
>> +#include <linux/device.h>
>> +#include <linux/memregion.h>
>> +#include <cxlmem.h>
>> +#include <cxl.h>
>> +#include "core.h"
>> +
>> +/**
>> + * DOC: cxl pmem region
>> + *
>> + * The core CXL PMEM region infrastructure supports persistent memory
>> + * region creation using LIBNVDIMM subsystem. It has dependency on
>> + * LIBNVDIMM, pmem region need updation of cxl region information into
>
>Perhaps reword as:
>
>pmem region needs to update the cxl region information in the LSA.
>

Fixed it accrodingly in V5

>> + * LSA. LIBNVDIMM dependency is only for pmem region, it is therefore
>> + * need this separate file.
>
>This seems like an explanation for the patch. Not sure we need it
>in the final code.  Anyone who considers changing this will rapidly
>spot that in the build files.
>
>...

Fixed it in V5

>
>> +static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
>> +	&cxl_base_attribute_group,
>> +	NULL,
>
>Whilst here, perhaps drop that trailing , there shouldn't be one on a terminating
>entry like this.

Fixed it in V5


Regards,
Neeraj

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_e6279_
Content-Type: text/plain; charset="utf-8"


------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_e6279_--
