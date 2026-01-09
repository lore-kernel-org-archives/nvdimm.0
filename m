Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D368C34BA3B
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768145287; cv=none; b=ptGRVOi8nNO8gC0XTykBS9Rygql7StIThhBuYmxih/P5XLs0iV4PQbv0OIsvUT9CTveS9bfgzz6O4gEV+96OWB5uKKc8RvuWD+Xf4DEa1hSmkfubLqWkTxI9scnFQ84UKycnlK81LULuoKyhng62p3NZsTrm34daSo3LeaB+zIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768145287; c=relaxed/simple;
	bh=ItBUyj9JRcjcqb72kaMat0ZM8AVwVmueUeogq6n0OGE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Wvhfod6dioNJnmD3Sw1e3xRd3EsAVZc1iMG3McMHxe1sh5wz1f1pAzvV4wiXeULBmKxQ7NutzpFNCUTMH3XBCuTekUaVieHH95rQi1e4gtOaGSSft79gN7b/22YAJ4v+eEQePy2x3NaosHfOqDHyRpwZijXm67ZjIWBQOBSnY5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QXbGvBUA; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QXbGvBUA"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260111152804epoutp0473189ad89a4f09b96007262d42c22eda~JtsSUHD9n2564525645epoutp043
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:28:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260111152804epoutp0473189ad89a4f09b96007262d42c22eda~JtsSUHD9n2564525645epoutp043
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768145284;
	bh=LdQgQqWIKzc0yAudDbs+7yaVjSNIi/OFl+0w6Q2a2M8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QXbGvBUA4ANZMmSxeNuZIyj+2mqCldovICjpnaQ0xYUW5ePVh7zuW1niUznvRgEBb
	 8Yj/3U960Hp9ws23fA2XUPq3zx7Kof0RCqhCga1IcvBA0H+lrZvSAUdlXGLrhMWaLg
	 T0ZJZ7c8N/zZVx5G8KQdCs4SUWhRj71tG21ZjCxA=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260111152803epcas5p1c2ac77fe958f1590341edf333fb4479b~JtsRwQcsL1125111251epcas5p10;
	Sun, 11 Jan 2026 15:28:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dpzsv3Yv6z3hhT3; Sun, 11 Jan
	2026 15:28:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260109123139epcas5p129230abf5bed2e490cd275e1a4276e87~JD-rpw1fW0058100581epcas5p1Y;
	Fri,  9 Jan 2026 12:31:39 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109123137epsmtip1c0e6fd03fd96bd3ed658efd8f25c7089~JD-qeRKin3245632456epsmtip1i;
	Fri,  9 Jan 2026 12:31:37 +0000 (GMT)
Date: Fri, 9 Jan 2026 18:01:29 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 15/17] cxl/pmem_region: Add sysfs attribute cxl
 region label updation/deletion
Message-ID: <158453976.61768145283486.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ba6d7e3e-493c-43f4-9ae6-373dbe7f4f0f@intel.com>
X-CMS-MailID: 20260109123139epcas5p129230abf5bed2e490cd275e1a4276e87
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_e5d9f_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1@epcas5p2.samsung.com>
	<20251119075255.2637388-16-s.neeraj@samsung.com>
	<ba6d7e3e-493c-43f4-9ae6-373dbe7f4f0f@intel.com>

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_e5d9f_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/11/25 04:10PM, Dave Jiang wrote:
>
>
>On 11/19/25 12:52 AM, Neeraj Kumar wrote:
>> Using these attributes region label is added/deleted into LSA. These
>> attributes are called from userspace (ndctl) after region creation.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  Documentation/ABI/testing/sysfs-bus-cxl | 22 ++++++
>>  drivers/cxl/core/pmem_region.c          | 93 ++++++++++++++++++++++++-
>>  drivers/cxl/cxl.h                       |  7 ++
>>  3 files changed, 121 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
>> index c80a1b5a03db..76d79c03dde4 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-cxl
>> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
>> @@ -624,3 +624,25 @@ Description:
>>  		The count is persistent across power loss and wraps back to 0
>>  		upon overflow. If this file is not present, the device does not
>>  		have the necessary support for dirty tracking.
>> +
>> +
>> +What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_update
>> +Date:		Nov, 2025
>> +KernelVersion:	v6.19
>> +Contact:	linux-cxl@vger.kernel.org
>> +Description:
>> +		(RW) Write a boolean 'true' string value to this attribute to
>> +		update cxl region information into LSA as region label. It
>> +		uses nvdimm nd_region_label_update() to update cxl region
>> +		information saved during cxl region creation into LSA. This
>> +		attribute must be called at last during cxl region creation.
>
>Please consider:
>attribute must be written last during cxl region creation.
>
>No need to mention kernel specifics like function names. Just give general description of what the attribute does. Same for the next attribute below.
>
>Also, does this attribute needs to be readable? The documentation above does not explain the read attribute if so.
>
>DJ

Fixed it in V5


Regards,
Neeraj

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_e5d9f_
Content-Type: text/plain; charset="utf-8"


------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_e5d9f_--

