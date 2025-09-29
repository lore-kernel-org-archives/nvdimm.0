Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB011A9FB0
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726392; cv=none; b=ExAFOQM3T3paaC2GCNH3z2G5AWG1d8otoiFViWRdMBdRgE2K/Wfw53HNW+9kHcLP8mjGyJ0BeNQsNJ2PKxF8vofy569EoJ5oeJBrnwAwfotpl/IapS9k+ND6nzEFdDA4aTgSXN2wICfrwmz4Qrz4t+KxyENE48/Crih/eqZrrwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726392; c=relaxed/simple;
	bh=Q2kmveq+C7RooPxNI2u+eaupkIQfD19EQoUNvxI1XPc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=hdMGks0dWoLnrUS6yIIKuQf9EMVX6YkE1ny3ju3g6Z0oDkv6o0cAN5JC0cpZGsmQrDBEC+DgdFHtU+xE61dc/9bRjIULXhmZgRNmT7znD6S46LY3I0AvkVZcJ+X1J9MhUt0kXsfcP0J5hKSm+IsM31LQXWbqY3XLk14/3GeOlE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fh9cJ4iQ; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fh9cJ4iQ"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251006045302epoutp01c63293acbf26b823595ebfdc7d6b391a~rzdI1Tgub1645616456epoutp01j
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:53:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251006045302epoutp01c63293acbf26b823595ebfdc7d6b391a~rzdI1Tgub1645616456epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726382;
	bh=nfKFNKfeJiqkNVGd8THAVIqpLF2bjXYQMQChn0Sqbbg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fh9cJ4iQxFb/K2uAl8i1VNNwrNfVsnidvhyNF8fQV+VRzsYRnbbzS+Vqw16wmKEKw
	 ntOPLe0jbAMbV4kVgctXk8E8hWQ/LRFoce40YhFZbjwdm5mk9xkkDiyW3AuCJNfaHP
	 dTtpOg32vanRhOABQ6QKSTWY7mxeT0iLVJE5MsqM=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251006045301epcas5p366ae7b70217b12b8c77f26d410d2ca37~rzdIhCpiN0330803308epcas5p3S;
	Mon,  6 Oct 2025 04:53:01 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cg6Mx5Rrfz2SSKY; Mon,  6 Oct
	2025 04:53:01 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250929131341epcas5p3002671c37f155252b7012e141e196d88~pwxRFPOK_3271832718epcas5p3t;
	Mon, 29 Sep 2025 13:13:41 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250929131339epsmtip17fa8c0e777da6bc46ea4fc62eb1682a9~pwxPoySny1879918799epsmtip1T;
	Mon, 29 Sep 2025 13:13:39 +0000 (GMT)
Date: Mon, 29 Sep 2025 18:43:31 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 07/20] nvdimm/region_label: Add region label delete
 support
Message-ID: <1983025922.01759726381745.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <77672d54-8133-4324-9ae7-39d11a335cb2@intel.com>
X-CMS-MailID: 20250929131341epcas5p3002671c37f155252b7012e141e196d88
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----mxO_4HALYOJvr1vdRg0el_y50LUdjfkHM5FQPcyM.heriKG9=_7331_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134142epcas5p49d85873cf3ea5f3166c63381ab668fc7
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134142epcas5p49d85873cf3ea5f3166c63381ab668fc7@epcas5p4.samsung.com>
	<20250917134116.1623730-8-s.neeraj@samsung.com>
	<77672d54-8133-4324-9ae7-39d11a335cb2@intel.com>

------mxO_4HALYOJvr1vdRg0el_y50LUdjfkHM5FQPcyM.heriKG9=_7331_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 22/09/25 02:37PM, Dave Jiang wrote:
>
>> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
>> +{
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nd_label_ent *label_ent;
>> +	int ns_region_cnt = 0;
>> +	int i, rc;
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		/* Find non cxl format supported ndr_mappings */
>> +		if (!ndd->cxl) {
>> +			dev_info(&nd_region->dev, "Unsupported region label\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		/* Find if any NS label using this region */
>> +		guard(mutex)(&nd_mapping->lock);
>> +		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>> +			if (!label_ent->label)
>> +				continue;
>> +
>> +			/*
>> +			 * Check if any available NS labels has same
>> +			 * region_uuid in LSA
>> +			 */
>> +			if (nsl_region_uuid_equal(label_ent->label,
>> +						  &nd_set->uuid))
>> +				ns_region_cnt++;
>
>Why not just return -EBUSY here immediately? It seems the code returns -EBUSY as long as there's 1 or more below.
>
>> +		}
>> +	}
>> +
>> +	if (ns_region_cnt) {
>> +		dev_dbg(&nd_region->dev, "Region/Namespace label in use\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +
>> +		rc = del_labels(nd_mapping, &nd_set->uuid, RG_LABEL_TYPE);
>> +		if (rc)
>> +			return rc;
>> +	}
>
>Can this be folded into the for loop above or does it a full pass to check before starting the label deletion process?
>
>DJ

Yes, if we use "return -EBUSY" in first loop itself then we can call del_labels()
I will fix this in next patch-set

Regards,
Neeraj

------mxO_4HALYOJvr1vdRg0el_y50LUdjfkHM5FQPcyM.heriKG9=_7331_
Content-Type: text/plain; charset="utf-8"


------mxO_4HALYOJvr1vdRg0el_y50LUdjfkHM5FQPcyM.heriKG9=_7331_--

