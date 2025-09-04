Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55512D3EDB
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055789; cv=none; b=jJTonu+huPKREXYwks2XwwRe2xRFMMummxNnGYVFEFtOAK6+WzDyLku/TDvofFNugN7gRlm9ve6bd1tNtDjxvower1TfBen4CbcI9W5p85D00m/smwZYHlBnme+rCdJOrdvNNnMJhYhbHq5UMrnIveIW90lsEw/jS4609zQdyvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055789; c=relaxed/simple;
	bh=tYTw0TUQluJ2boRtmgrcWl+mn/DykMFsYobVXc+pP2s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=tljVrREWvF7zaaI3HuvG856oJ4QNx0+b24VPSKS28FYBrmXsV/80WQp3R/944Ld4RKjkIeC1mFm0EVUwo1immWxecEHlSFqBWhEoDDu7Yc5UmceZjq4fR3VfFOs/O4vqSb1slGPi/BhVgbkqF/C7Ojn9ekMxrXV6AwmaQKLgmUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BhDpYcNw; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BhDpYcNw"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250905070304epoutp01dd5c0cf68c134453d300483136966fff~iUO1BYpKG0734707347epoutp01C
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250905070304epoutp01dd5c0cf68c134453d300483136966fff~iUO1BYpKG0734707347epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055784;
	bh=jpC6OoIJ4nWt/t21DdJG4HLH6jax/kMLcep0R/SZAYw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BhDpYcNwRXMs3SiU19nxOhj9tEchwfpQ8dvnI7d+jHVh8lQMP15T8Fdaz0Hmz5Ys0
	 v+UsU6t2UfnXDAA+qt6QYkZbp9HgSeQFftvylkT2a4UXffdgA200CFC8XOnhedCp5M
	 6CJaZtTwi3oT9VCmpp5XZnw1K7PKOxE6JHUTx9xI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250905070304epcas5p1d83816b98fb06d71d1bb7709bbfa31d9~iUO0olguf2873728737epcas5p1a;
	Fri,  5 Sep 2025 07:03:04 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cJ6kJ0pb1z2SSKw; Fri,  5 Sep
	2025 07:03:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250904142835epcas5p49586d70c778865b4b66dae580d9a6c27~iGqiEYsgK0079200792epcas5p4I;
	Thu,  4 Sep 2025 14:28:35 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250904142834epsmtip25eaf468cef29d5215dbe53e42730201e~iGqg01E1r0994409944epsmtip2e;
	Thu,  4 Sep 2025 14:28:34 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:58:29 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 07/20] nvdimm/namespace_label: Update namespace
 init_labels and its region_uuid
Message-ID: <1690859824.141757055784098.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <68a4c8d971529_27db9529479@iweiny-mobl.notmuch>
X-CMS-MailID: 20250904142835epcas5p49586d70c778865b4b66dae580d9a6c27
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead19_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908@epcas5p2.samsung.com>
	<20250730121209.303202-8-s.neeraj@samsung.com>
	<68a4c8d971529_27db9529479@iweiny-mobl.notmuch>

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead19_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/08/25 01:56PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> nd_mapping->labels maintains the list of labels present into LSA.
>> init_labels() prepares this list while adding new label into LSA
>> and updates nd_mapping->labels accordingly. During cxl region
>> creation nd_mapping->labels list and LSA was updated with one
>> region label. Therefore during new namespace label creation
>> pre-include the previously created region label, so increase
>> num_labels count by 1.
>
>Why does the count of the labels in the list not work?
>
>static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>{
>        int i, old_num_labels = 0;
>...
>        mutex_lock(&nd_mapping->lock);
>        list_for_each_entry(label_ent, &nd_mapping->labels, list)
>                old_num_labels++;
>        mutex_unlock(&nd_mapping->lock);
>...
>

Hi Ira,

init_labels() allocates new label based on comparison with existing
count of the labels in the list and passed num_labels. If num_labels
is greater than count of the labels in the list then new label is
allocated and stored in list for later usage

...
         mutex_lock(&nd_mapping->lock);
	list_for_each_entry(label_ent, &nd_mapping->labels, list)
		old_num_labels++;
	mutex_unlock(&nd_mapping->lock);

	for (i = old_num_labels; i < num_labels; i++) {
		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
		if (!label_ent)
			return -ENOMEM;

		mutex_lock(&nd_mapping->lock);
		list_add_tail(&label_ent->list, nd_mapping->labels);
		mutex_unlock(&nd_mapping->lock);
	}
...


>>
>> Also updated nsl_set_region_uuid with region uuid with which
>> namespace is associated with.
>
>Whenever using a word like 'Also' in the commit message ask if this should be a
>separate patch.  I'm thinking this hunk should be somewhere else in the series.
>
>Ira

Sure Ira, Yes both hunks are not associated, I just added both to avoid
extra commit. I will create separate commit to update region_uuid and
will remove 'Also' part from commit message.


Regards,
Neeraj

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead19_
Content-Type: text/plain; charset="utf-8"


------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead19_--

