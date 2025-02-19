Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133431FBEB0
	for <nvdimm@lists.linux.dev>; Wed, 19 Feb 2025 16:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739983257; cv=none; b=J8HGTfRZIpaT0Jr0NNR8xR2pvMWLCYNpVz3xX9osc+Oi3WG+NCtJoaaXALnAm72/a+fd67JnZgUuRlpbS4jOSIl/kRraf1xSwm3onGrKNbWpVeS1AUib+TkdJV+nPLm+snLLUn3JCDeRWCf3D/l89uArP9iejMdFY6gS49XCQfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739983257; c=relaxed/simple;
	bh=JEiXYyZewYdZ/29ICidTlcyS7ChrkiDlmDmScjZNzKU=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=kda8GBRhsowq2u9PSpCjGSk17eJiIXXK+H/kXajBlAdfMRfHFFbNGJlnYkHXPd6TTVxq7/mBm7GF0T9HcYhDi7dpEa3rY2YajTgXynWP0agIgPwLVmnRMZ//kPDIBFxPYbxcMYDGcqlm+5qsjyOwo+S+UeiRKS3BgJKigDPCF7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QWzo0qDP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QWzo0qDP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739983254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DQDREIFxnc5HDXCuGfoZp5kxakhT8GCTFWXZKOmaSXw=;
	b=QWzo0qDP2imzFCIUx+1PuiMh/sjpZCv3Z+a4DZ+iGv0deZMi/KcUj/ofhKK6Snz+f8sbvW
	RLr1tp2nUeexnOC9MSgfXJLBALmYVF20nrep0QWaMx69XJfLMMLSO1GEBdaftvKIsJ8y+M
	NxT+CMAZKS3ODctXoB207uWFG/UGMlg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-ThzB33ccPcCmZcgY1IOmQg-1; Wed,
 19 Feb 2025 11:40:50 -0500
X-MC-Unique: ThzB33ccPcCmZcgY1IOmQg-1
X-Mimecast-MFC-AGG-ID: ThzB33ccPcCmZcgY1IOmQg_1739983249
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCFC2190FF83;
	Wed, 19 Feb 2025 16:40:48 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.82.8])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0910190C54C;
	Wed, 19 Feb 2025 16:40:46 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Alison Schofield <alison.schofield@intel.com>,  nvdimm@lists.linux.dev,
  linux-cxl@vger.kernel.org,  Ritesh Harjani <ritesh.list@gmail.com>,  Li
 Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH] ndctl: json: Region capabilities are not displayed if
 any of the BTT, PFN, or DAX are not present
References: <20250219094049.5156-1-donettom@linux.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 19 Feb 2025 11:40:44 -0500
In-Reply-To: <20250219094049.5156-1-donettom@linux.ibm.com> (Donet Tom's
	message of "Wed, 19 Feb 2025 03:40:49 -0600")
Message-ID: <x494j0pj3ar.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C-nxOv3bi3o2BIf0ixIx0k0SwrBicDaooonQLQ5gvjo_1739983249
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Donet Tom <donettom@linux.ibm.com> writes:

> If any one of BTT, PFN, or DAX is not present, but the other two
> are, then the region capabilities are not displayed in the
> ndctl list -R -C command.
>
> This is because util_region_capabilities_to_json() returns NULL
> if any one of BTT, PFN, or DAX is not present.
>
> In this patch, we have changed the logic to display all the region
> capabilities that are present.
>
> Test Results with CONFIG_BTT disabled
> =====================================
> Without this patch
> ------------------
>  # ./build/ndctl/ndctl  list -R -C
>  [
>   {
>     "dev":"region1",
>     "size":549755813888,
>     "align":16777216,
>     "available_size":549755813888,
>     "max_available_extent":549755813888,
>     "type":"pmem",
>     "iset_id":11510624209454722969,
>     "persistence_domain":"memory_controller"
>   },
>
> With this patch
> ---------------
>  # ./build/ndctl/ndctl  list -R -C
>  [
>   {
>     "dev":"region1",
>     "size":549755813888,
>     "align":16777216,
>     "available_size":549755813888,
>     "max_available_extent":549755813888,
>     "type":"pmem",
>     "iset_id":11510624209454722969,
>     "capabilities":[
>       {
>         "mode":"fsdax",
>         "alignments":[
>           65536,
>           16777216
>         ]
>       },
>       {
>         "mode":"devdax",
>         "alignments":[
>           65536,
>           16777216
>         ]
>       }
>     ],
>     "persistence_domain":"memory_controller"
>   },
>
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>  ndctl/json.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/ndctl/json.c b/ndctl/json.c
> index 23bad7f..3df3bc4 100644
> --- a/ndctl/json.c
> +++ b/ndctl/json.c
> @@ -381,9 +381,6 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
>  	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
>  	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
>  
> -	if (!btt || !pfn || !dax)
> -		return NULL;
> -

I think this was meant to be:

	if (!btt && !pfn && !dax)
		return NULL;

I think that would be the more appropriate fix.

Cheers,
Jeff

>  	jcaps = json_object_new_array();
>  	if (!jcaps)
>  		return NULL;
> @@ -436,7 +433,8 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
>  		json_object_object_add(jcap, "alignments", jobj);
>  	}
>  
> -	return jcaps;
> +	if (btt || pfn || dax)
> +		return jcaps;
>  err:
>  	json_object_put(jcaps);
>  	return NULL;

