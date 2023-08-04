Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D46BE7C
	for <nvdimm@lists.linux.dev>; Fri,  4 Aug 2023 17:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691170981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6sTBG1iJQbq6glME5UEqFb+bjYOVVGv3UBdEW6qJbyg=;
	b=VNHiTpSKFGiJa6vprYSEtGSZ2H5uiZsLB7UY0RfaeQogn1Z1+UiG1shmgsQGIrDgbWhogz
	oY4wEn5xhWJi4uV0Ek2brAqKyIglQ5WT0EV0tHCJc6f6ZTrw/33sny7Y3VAhLQhemYGukU
	8+xsEwQxzeYzthnEwCoRBCESGd4/aNM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-RFzVWL1KM36Hlb2n0K74kQ-1; Fri, 04 Aug 2023 13:43:00 -0400
X-MC-Unique: RFzVWL1KM36Hlb2n0K74kQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B570B88D542;
	Fri,  4 Aug 2023 17:42:59 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 933DE4021CE;
	Fri,  4 Aug 2023 17:42:59 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: nvdimm@lists.linux.dev,  dan.j.williams@intel.com,  vishal.l.verma@intel.com
Subject: Re: [PATCH 2/2] nvdimm/pfn_dev: Avoid unnecessary endian conversion
References: <20230804084934.171056-1-aneesh.kumar@linux.ibm.com>
	<20230804084934.171056-2-aneesh.kumar@linux.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 04 Aug 2023 13:48:48 -0400
In-Reply-To: <20230804084934.171056-2-aneesh.kumar@linux.ibm.com> (Aneesh
	Kumar K. V.'s message of "Fri, 4 Aug 2023 14:19:34 +0530")
Message-ID: <x497cqau29r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> use the local variable that already have the converted values.
>
> No functional change in this patch.
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  drivers/nvdimm/pfn_devs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 36b904a129b9..8b7342517895 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -599,14 +599,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	if (!IS_ALIGNED(res->start + le32_to_cpu(pfn_sb->start_pad),
> -				memremap_compat_align())) {
> +	if (!IS_ALIGNED(res->start + start_pad, memremap_compat_align())) {
>  		dev_err(&nd_pfn->dev, "resource start misaligned\n");
>  		return -EOPNOTSUPP;
>  	}
>  
> -	if (!IS_ALIGNED(res->end + 1 - le32_to_cpu(pfn_sb->end_trunc),
> -				memremap_compat_align())) {
> +	if (!IS_ALIGNED(res->end + 1 - end_trunc, memremap_compat_align())) {
>  		dev_err(&nd_pfn->dev, "resource end misaligned\n");
>  		return -EOPNOTSUPP;
>  	}

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

