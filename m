Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AE322FE08
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752909314; cv=none; b=qc7LmKryyNkyQ/bCRobUdFMNt9s2eSUt57LRwy3CpGVUaIpfZ6PPIDibxe1v2q5fPOWs1CkmKNwHKDOmBBPGyw4QiHJOgjSIJr0KrB5QVKloApufqp/YLyvnXN93kVq10u3xGNueGldGkS5sXjnsHkg9AAEXcU6OsA58eX33qds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752909314; c=relaxed/simple;
	bh=IFXMENYuehKyDmEcdz9cDe2goFgmjIQEyXn0yMj6JFM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=mBtdRR6arGnmuqyUVhKci0gw8dZTBQOe1FqCc+vdxJjBZo8XEg1CWwRYNevi2ze+bhLqfk/u5k2nGz5rK6UTVvX0zD8Ab+3IQMgiBZ4WR/qnYdJiGDAS8PJSbDDBAcL5RkIjhIuD1ZmrlzT8eiKz/AnfwCxOrCskGs99ftAa6DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WIZJS0jS; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WIZJS0jS"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250719071504epoutp0413b06bd8f12b85ae03ffbb3ec6922e99~TlbmF7Cw-1000410004epoutp04U
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:15:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250719071504epoutp0413b06bd8f12b85ae03ffbb3ec6922e99~TlbmF7Cw-1000410004epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752909304;
	bh=JKjySgLQi1aF8xJczQx8d6lCD4F+tC3I1Ce1ucQ0Wkk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WIZJS0jSD65bQOJfDNYGdAs3WYKbc90j1eNSZxSGOVLNHfpzM99BcZ39PtPZY8glv
	 +X1hQ9/o3cZsJZ0a6NQ2TyOhn6iume7EqfpsrXIEAKHrpqaawbOJAF3GQbYxFFLxTe
	 KyB33ebqqpQ2h2Q3FcO0BJhlEWCwuWWAZC0RJl5A=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250719071502epcas5p158955edca94e829594ddd5f3ab0ae5a2~Tlbk9EFhR0199401994epcas5p1N;
	Sat, 19 Jul 2025 07:15:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bkdGG5RW0z3hhT3; Sat, 19 Jul
	2025 07:15:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250718121345epcas5p2e2d67f581d066bef4c9c494fa4252aac~TV3Gp23P_1765017650epcas5p2c;
	Fri, 18 Jul 2025 12:13:45 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250718121343epsmtip21cfd132db7d121ed9ef9926cc502b102~TV3EQ0T2f3097930979epsmtip2T;
	Fri, 18 Jul 2025 12:13:42 +0000 (GMT)
Date: Fri, 18 Jul 2025 17:43:36 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com, a.manzanares@samsung.com,
	nifan.cxl@gmail.com, anisa.su@samsung.com, vishak.g@samsung.com,
	krish.reddy@samsung.com, arun.george@samsung.com, alok.rathore@samsung.com,
	neeraj.kernel@gmail.com, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, gost.dev@samsung.com,
	cpgs@samsung.com
Subject: Re: [RFC PATCH 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to
 set cxl label format
Message-ID: <1983025922.01752909302744.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <624c255d-d7e2-4ea3-9186-b435499838a7@intel.com>
X-CMS-MailID: 20250718121345epcas5p2e2d67f581d066bef4c9c494fa4252aac
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_1b6fb_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124008epcas5p2e702f786645d44ceb1cdd980a914ce8e
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124008epcas5p2e702f786645d44ceb1cdd980a914ce8e@epcas5p2.samsung.com>
	<158453976.61750165203630.JavaMail.epsvc@epcpadp1new>
	<624c255d-d7e2-4ea3-9186-b435499838a7@intel.com>

------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_1b6fb_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 09/07/25 03:57PM, Dave Jiang wrote:
>
>
>On 6/17/25 5:39 AM, Neeraj Kumar wrote:
>> NDD_CXL_LABEL is introduced to set cxl LSA 2.1 label format
>> Accordingly updated label index version
>
>Maybe add the spec reference that defines label 2.1 format

Sure Dave, I will update commit message accordingly.

>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/dimm.c      |  1 +
>>  drivers/nvdimm/dimm_devs.c | 10 ++++++++++
>>  drivers/nvdimm/label.c     | 16 ++++++++++++----
>>  drivers/nvdimm/nd.h        |  1 +
>>  include/linux/libnvdimm.h  |  3 +++
>>  5 files changed, 27 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
>> index 91d9163ee303..8753b5cd91cc 100644
>> --- a/drivers/nvdimm/dimm.c
>> +++ b/drivers/nvdimm/dimm.c
>> @@ -62,6 +62,7 @@ static int nvdimm_probe(struct device *dev)
>>  	if (rc < 0)
>>  		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
>>
>> +	ndd->cxl = nvdimm_check_cxl_label_format(ndd->dev);
>>
>>  	/*
>>  	 * EACCES failures reading the namespace label-area-properties
>> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
>> index 21498d461fde..e8f545f889fd 100644
>> --- a/drivers/nvdimm/dimm_devs.c
>> +++ b/drivers/nvdimm/dimm_devs.c
>> @@ -18,6 +18,16 @@
>>
>>  static DEFINE_IDA(dimm_ida);
>>
>> +bool nvdimm_check_cxl_label_format(struct device *dev)
>> +{
>> +	struct nvdimm *nvdimm = to_nvdimm(dev);
>> +
>> +	if (test_bit(NDD_CXL_LABEL, &nvdimm->flags))
>> +		return true;
>> +
>> +	return false;
>> +}
>
>I think we may want to move the checking of the flag to where the patch also set the flag in order to provide a more coherent review experience. Given that I haven't read the rest of the patchset and don't know how NDD_CXL_LABEL is set, I really can't comment on whether there's a better way to detect LSA 2.1 labels. Is there a generic way to determine label versions without the implication of this is CXL device?
>

Its been set in cxl driver in later patch, May be I will update the
commit message with this information.

>> +
>>  /*
>>   * Retrieve bus and dimm handle and return if this bus supports
>>   * get_config_data commands
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 082253a3a956..48b5ba90216d 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -687,11 +687,19 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>>  		- (unsigned long) to_namespace_index(ndd, 0);
>>  	nsindex->labeloff = __cpu_to_le64(offset);
>>  	nsindex->nslot = __cpu_to_le32(nslot);
>> -	nsindex->major = __cpu_to_le16(1);
>> -	if (sizeof_namespace_label(ndd) < 256)
>> +
>> +	/* Support CXL LSA 2.1 label format */
>> +	if (ndd->cxl) {
>> +		nsindex->major = __cpu_to_le16(2);
>>  		nsindex->minor = __cpu_to_le16(1);
>> -	else
>> -		nsindex->minor = __cpu_to_le16(2);
>> +	} else {
>> +		nsindex->major = __cpu_to_le16(1);
>> +		if (sizeof_namespace_label(ndd) < 256)
>> +			nsindex->minor = __cpu_to_le16(1);
>> +		else
>> +			nsindex->minor = __cpu_to_le16(2);
>> +	}
>
>Would like to see a more coherent way of detecting label versioning. What happens when there are newer versions introduced later on? This currently feels very disjointed.
>

Thanks Dave for your suggestion. This current patch-set is extension of
commit 5af96835e4daf. We may have to do some more change to address this
coherent way of detecting label versioning. May be we can take this later.

>> +
>>  	nsindex->checksum = __cpu_to_le64(0);
>>  	if (flags & ND_NSINDEX_INIT) {
>>  		unsigned long *free = (unsigned long *) nsindex->free;
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index 5ca06e9a2d29..304f0e9904f1 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>> @@ -522,6 +522,7 @@ void nvdimm_set_labeling(struct device *dev);
>>  void nvdimm_set_locked(struct device *dev);
>>  void nvdimm_clear_locked(struct device *dev);
>>  int nvdimm_security_setup_events(struct device *dev);
>> +bool nvdimm_check_cxl_label_format(struct device *dev);
>>  #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
>>  int nvdimm_security_unlock(struct device *dev);
>>  #else
>> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
>> index e772aae71843..0a55900842c8 100644
>> --- a/include/linux/libnvdimm.h
>> +++ b/include/linux/libnvdimm.h
>> @@ -44,6 +44,9 @@ enum {
>>  	/* dimm provider wants synchronous registration by __nvdimm_create() */
>>  	NDD_REGISTER_SYNC = 8,
>>
>> +	/* dimm supports region labels (LSA Format 2.1) */
>> +	NDD_CXL_LABEL = 9,
>
>While 2.1 is defined by the CXL spec, is there anything declared by the CXL spec that makes 2.1 exclusive to CXL? Maybe the focus should be to support LSA 2.1 and avoid dragging naming CXL into the conversation at this point. It can be made more generic right? I'm concerned about dragging CXL into nvdimm when it isn't necessary. Maybe introduce a label cap field where when an nvdimm device is registered, the caller can pass in that it's capable of supporting up to a certain version of labeling? Just throwing ideas out to see if it's feasible.
>

Hi Dave,

I have taken this naming reference from "drivers/nvdimm/label.h"
where namespace label is defined as "struct nvdimm_efi_label" (LSA 1.1
is defined in nvdimm namespace spec and LSA 1.2 is defined in efi spec)
where (from commit 540ccaa2e4dd6) region label is defined as "struct
cxl_region_label"

Please let me know if I should use some other name in place of this


Regards,
Neeraj

------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_1b6fb_
Content-Type: text/plain; charset="utf-8"


------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_1b6fb_--

