Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F8728ECC9
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944189; cv=none; b=gVp03YH4b3nuOHTiJMsO7WE960vr/sGBM+vVgFoypJQJZ1JbQrSTrHPhtiJZYy3HqfgFrX0KSJ6r003XeK6/nby4mNX9IMJx0Io2F51pcX+SVFetktva6MljD29Da4yZjm8YW9vgSXpcUHB+NUOm+/6GFdBkBB1myGNDplK8HKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944189; c=relaxed/simple;
	bh=1TxYS5QvhfTlTRHri2ULUhlLp+H/1QHHdCx7jQ7oOq8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=lbjz2nVscM9Icb5NFP2rON2msFD9wfBqDYXTtlJ+pe4j/IbPNUcAitS3TY5px9/cT4j3aFP2ihkd4mm6iQgaUU698zKz/6dyYZ937TSfoBl7jgRhH49WWU5Ja3lTwvsb7OeT6UomCEMzSgN/M/VQwB8iLSyxkTEceeIIRLHXJxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=d9fipP0F; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="d9fipP0F"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250626132303epoutp042d828a0916b4a5930a8e0b4f7c5f9d04~MmnVQYIp12561925619epoutp042
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:23:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250626132303epoutp042d828a0916b4a5930a8e0b4f7c5f9d04~MmnVQYIp12561925619epoutp042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944183;
	bh=WwidYyhlb8xj8Tl8dra4sxOBjrQ5iJQDebbSbTXc+YQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=d9fipP0FtH9exc/uWmhX10abAq4jRHPBLQJzD41LOcfCNSmDX9C2UPBN8TNgmfKqr
	 h/cu+O6FCiSu6o12sWW2eLTiYgA4P/dLYUPAv8L5LhqFJSQmey1dXwk6RBTgYhqTvV
	 aBYhNH/LoJCn7U7v9heu4HbwF1fwbby2Ef1XBI4E=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250626132303epcas5p408d690ffa63ec0c7445430a45aa06b20~MmnUscPqi0583705837epcas5p45;
	Thu, 26 Jun 2025 13:23:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bSfWW135fz3hhT3; Thu, 26 Jun
	2025 13:23:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250626100219epcas5p2cb203ebffe437013766d5ef57ce6fa14~Mj4Ehz9Qa1788417884epcas5p2B;
	Thu, 26 Jun 2025 10:02:19 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250626100217epsmtip20bbef4af127abc08d30ef8d0772eda8b~Mj4B6vHHD3036430364epsmtip2H;
	Thu, 26 Jun 2025 10:02:16 +0000 (GMT)
Date: Thu, 26 Jun 2025 15:32:10 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 12/20] nvdimm/namespace_label: Skip region label
 during namespace creation
Message-ID: <1931444790.41750944183140.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623101740.00004840@huawei.com>
X-CMS-MailID: 20250626100219epcas5p2cb203ebffe437013766d5ef57ce6fa14
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----ccPbqUR1b2FiTe9wDLZ4x.aheQWUm9HBntMNkAPxEtPuJZ0j=_6a20d_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124040epcas5p3be044cbdc5b33b0b8465d84870a5b280
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124040epcas5p3be044cbdc5b33b0b8465d84870a5b280@epcas5p3.samsung.com>
	<2024918163.301750165206130.JavaMail.epsvc@epcpadp1new>
	<20250623101740.00004840@huawei.com>

------ccPbqUR1b2FiTe9wDLZ4x.aheQWUm9HBntMNkAPxEtPuJZ0j=_6a20d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:17AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:36 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> During namespace creation skip presence of region label if present.
>> Also preserve region label into labels list if present.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/namespace_devs.c | 48 +++++++++++++++++++++++++++++----
>>  1 file changed, 43 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index b081661b7aaa..ca8f8546170c 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -1976,6 +1976,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
>>  		if (!nd_label)
>>  			continue;
>>
>> +		/* skip region labels if present */
>> +		if (is_region_label(ndd, nd_label))
>> +			continue;
>> +
>>  		/* skip labels that describe extents outside of the region */
>>  		if (nsl_get_dpa(ndd, &nd_label->ns_label) < nd_mapping->start ||
>>  		    nsl_get_dpa(ndd, &nd_label->ns_label) > map_end)
>> @@ -2014,9 +2018,29 @@ static struct device **scan_labels(struct nd_region *nd_region)
>>
>>  	if (count == 0) {
>>  		struct nd_namespace_pmem *nspm;
>> +		for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +			struct nd_label_ent *le, *e;
>> +			LIST_HEAD(list);
>>
>> -		/* Publish a zero-sized namespace for userspace to configure. */
>> -		nd_mapping_free_labels(nd_mapping);
>> +			nd_mapping = &nd_region->mapping[i];
>> +			if (list_empty(&nd_mapping->labels))
>> +				continue;
>> +
>> +			list_for_each_entry_safe(le, e, &nd_mapping->labels,
>> +						 list) {
>> +				struct nd_lsa_label *nd_label = le->label;
>> +
>> +				/* preserve region labels if present */
>> +				if (is_region_label(ndd, nd_label))
>> +					list_move_tail(&le->list, &list);
>> +			}
>> +
>> +			/* Publish a zero-sized namespace for userspace
>
>Comment syntax as before looks to be inconsistent with file.
>

Thanks, Will update it everywhere its inconsistent.

>> +			 * to configure.
>> +			 */
>> +			nd_mapping_free_labels(nd_mapping);
>> +			list_splice_init(&list, &nd_mapping->labels);
>> +		}
>>  		nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
>>  		if (!nspm)
>>  			goto err;
>> @@ -2028,7 +2052,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
>>  	} else if (is_memory(&nd_region->dev)) {
>>  		/* clean unselected labels */
>>  		for (i = 0; i < nd_region->ndr_mappings; i++) {
>> -			struct list_head *l, *e;
>> +			struct nd_label_ent *le, *e;
>>  			LIST_HEAD(list);
>>  			int j;
>>
>> @@ -2039,10 +2063,24 @@ static struct device **scan_labels(struct nd_region *nd_region)
>>  			}
>>
>>  			j = count;
>> -			list_for_each_safe(l, e, &nd_mapping->labels) {
>> +			list_for_each_entry_safe(le, e, &nd_mapping->labels,
>> +						 list) {
>> +				struct nd_lsa_label *nd_label = le->label;
>> +
>> +				/* preserve region labels */
>> +				if (is_region_label(ndd, nd_label)) {
>> +					list_move_tail(&le->list, &list);
>> +					continue;
>> +				}
>> +
>> +				/* Once preserving selected ns label done
>Comment syntax.

Sure, Will fix it up

>> +				 * break out of loop
>> +				 */
>>  				if (!j--)
>>  					break;
>> -				list_move_tail(l, &list);
>> +
>> +				/* preserve selected ns label */
>> +				list_move_tail(&le->list, &list);
>>  			}
>>  			nd_mapping_free_labels(nd_mapping);
>>  			list_splice_init(&list, &nd_mapping->labels);
>

------ccPbqUR1b2FiTe9wDLZ4x.aheQWUm9HBntMNkAPxEtPuJZ0j=_6a20d_
Content-Type: text/plain; charset="utf-8"


------ccPbqUR1b2FiTe9wDLZ4x.aheQWUm9HBntMNkAPxEtPuJZ0j=_6a20d_--

