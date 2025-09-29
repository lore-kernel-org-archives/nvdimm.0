Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEB0247287
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726510; cv=none; b=hEzB53lj/skN0bhv3SwgInIdUxLZsqTy6S1gRqepfqEQCzHv4IsrmZbs4b/fhxyRVX9espBmvQD5EJN3f4YxqOO25aW8Cec+W/SClMnx5qjJVpuNc9Li5nz75dNLidIrjCwTKgy4FCn1d/iqeW1RTZz6KBkLaOWp1gizkzg7PZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726510; c=relaxed/simple;
	bh=tSY4x4vxebts9gODXbyGa+eGhARGSZMq2iBv9gh/YpA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Z8GoNd9OXDcYmtIuV6ujc5T75DK1bHn8WjI0uiKQqPEi7Yl3FBB6eGzd/oIaJOmnesXOyECz7OIyqcORSkHSdnDHK2G79JkWfGXzuZbrPsdhXerTUqm5A6xk1zS/vq+TjUUQW+rQgnlYErcOlkEzIz5/w/zRCWA7ud0kGZp9xSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Kc7o7ree; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Kc7o7ree"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251006045505epoutp01db004999585a738c027023649912c5ae~rze7YVb8-1805018050epoutp01W
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251006045505epoutp01db004999585a738c027023649912c5ae~rze7YVb8-1805018050epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726505;
	bh=tNN+FazP8ImXDuBGAG2Zx9hJXJuQjwtfjXILk1sFxO4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Kc7o7reet+yIbN9Vm3E0AfJKebiWkyn9LJeLnbepvyUrTiFCCo5B6rmtZc/qoyxrx
	 p++GpgiL3paUt5faWRbrvapEyETEwnqw92cZ3HFQMKmPxG/969IyRtmj1kPsaDCZKf
	 gMSIqMxJLvBTAvNaif+6Zs8fQwx8U3gzhd0ePKBs=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251006045504epcas5p2cf325e6820622dcc6c5ca96983dbeff9~rze7GMwZG0811608116epcas5p2u;
	Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cg6QJ5gZKz6B9mC; Mon,  6 Oct
	2025 04:55:04 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250929140720epcas5p196c2aa8ca4e2978fb13f5e562b94aa5c~pxgHFqRt20518905189epcas5p1S;
	Mon, 29 Sep 2025 14:07:20 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250929140718epsmtip12a19cda4f0e2588cbca6590fd017bc3c~pxgFy-rV71914219142epsmtip1V;
	Mon, 29 Sep 2025 14:07:18 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:37:15 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 03/20] nvdimm/label: Modify nd_label_base() signature
Message-ID: <148912029.181759726504783.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aNRccteuoHH0oPw4@aschofie-mobl2.lan>
X-CMS-MailID: 20250929140720epcas5p196c2aa8ca4e2978fb13f5e562b94aa5c
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_75c0_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134134epcas5p3f64af9556015ed9dfb881f852ea854c4@epcas5p3.samsung.com>
	<20250917134116.1623730-4-s.neeraj@samsung.com>
	<7622b25c-a0d8-47b6-910b-9b2e42e099e4@intel.com>
	<1296674576.21758556382506.JavaMail.epsvc@epcpadp2new>
	<aNRccteuoHH0oPw4@aschofie-mobl2.lan>

------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_75c0_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 24/09/25 02:02PM, Alison Schofield wrote:
>On Mon, Sep 22, 2025 at 06:14:40PM +0530, Neeraj Kumar wrote:
>> On 19/09/25 04:34PM, Dave Jiang wrote:
>> >
>> >
>> > On 9/17/25 6:40 AM, Neeraj Kumar wrote:
>> > > nd_label_base() was being used after typecasting with 'unsigned long'. Thus
>> > > modified nd_label_base() to return 'unsigned long' instead of 'struct
>> > > nd_namespace_label *'
>> > >
>> > > Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> >
>> > Just a nit below:
>> >
>> >
>> > > ---
>> > >  drivers/nvdimm/label.c | 10 +++++-----
>> > >  1 file changed, 5 insertions(+), 5 deletions(-)
>> > >
>> > > -static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
>> > > +static unsigned long nd_label_base(struct nvdimm_drvdata *ndd)
>> > >  {
>> > >  	void *base = to_namespace_index(ndd, 0);
>> > >
>> > > -	return base + 2 * sizeof_namespace_index(ndd);
>> > > +	return (unsigned long) (base + 2 * sizeof_namespace_index(ndd));
>> >
>> > Space is not needed between casting and the var. Also applies to other instances in this commit.
>> >
>> > DJ
>>
>> Thanks Jonathan, Ira and Dave for RB tag. Sure, I will fix this in next
>> patch-set.
>
>This is independent of the patchset, right?
>How about just sending a one off patch for this, and shortening this
>set by a tiny bit :)
>

Yes Alison, This patch is independent and not directly related with LSA
2.1 support series. Sure, Will push it seperately.


Regards,
Neeraj



------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_75c0_
Content-Type: text/plain; charset="utf-8"


------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_75c0_--

