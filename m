Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BD470
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 17:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1628097039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4FQdNHQEjWBY3vrC7jQfX7slS9YZo6hOaUV4jGNGi4=;
	b=hm+QEGX9OIVlPPE4irBkNg7ynzz1jGPG4quN4L+sT+fuTxqWgtY5LxRagp2Mbm0InygrYT
	kvULmRT7dRlrbQxm/O+PMxgKig8ziqP8GpES3sKVPO2sOPxMzkwTX6/gJQDvAJougqkboC
	07+2rDizqLsjftXuaiFCtZJmh0v+ksw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-JkXZYH0uPqOftNh5nRX7Cw-1; Wed, 04 Aug 2021 13:10:37 -0400
X-MC-Unique: JkXZYH0uPqOftNh5nRX7Cw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B7D4107ACF5;
	Wed,  4 Aug 2021 17:10:36 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F16FA1981C;
	Wed,  4 Aug 2021 17:10:35 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev,  Krzysztof Kensicki <krzysztof.kensicki@intel.com>,  vishal.l.verma@intel.com
Subject: Re: [PATCH] libnvdimm/region: Fix label activation vs errors
References: <162766356450.3223041.1183118139023841447.stgit@dwillia2-desk3.amr.corp.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 04 Aug 2021 13:12:01 -0400
In-Reply-To: <162766356450.3223041.1183118139023841447.stgit@dwillia2-desk3.amr.corp.intel.com>
	(Dan Williams's message of "Fri, 30 Jul 2021 09:46:04 -0700")
Message-ID: <x49lf5ht9r2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jmoyer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> There are a few scenarios where init_active_labels() can return without
> registering deactivate_labels() to run when the region is disabled. In
> particular label error injection creates scenarios where a DIMM is
> disabled, but labels on other DIMMs in the region become activated.
>
> Arrange for init_active_labels() to always register deactivate_labels().
>
> Reported-by: Krzysztof Kensicki <krzysztof.kensicki@intel.com>
> Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation.")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>


> ---
>  drivers/nvdimm/namespace_devs.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 2403b71b601e..745478213ff2 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -2527,7 +2527,7 @@ static void deactivate_labels(void *region)
>  
>  static int init_active_labels(struct nd_region *nd_region)
>  {
> -	int i;
> +	int i, rc = 0;
>  
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> @@ -2546,13 +2546,14 @@ static int init_active_labels(struct nd_region *nd_region)
>  			else if (test_bit(NDD_LABELING, &nvdimm->flags))
>  				/* fail, labels needed to disambiguate dpa */;
>  			else
> -				return 0;
> +				continue;
>  
>  			dev_err(&nd_region->dev, "%s: is %s, failing probe\n",
>  					dev_name(&nd_mapping->nvdimm->dev),
>  					test_bit(NDD_LOCKED, &nvdimm->flags)
>  					? "locked" : "disabled");
> -			return -ENXIO;
> +			rc = -ENXIO;
> +			goto out;
>  		}
>  		nd_mapping->ndd = ndd;
>  		atomic_inc(&nvdimm->busy);
> @@ -2586,13 +2587,17 @@ static int init_active_labels(struct nd_region *nd_region)
>  			break;
>  	}
>  
> -	if (i < nd_region->ndr_mappings) {
> +	if (i < nd_region->ndr_mappings)
> +		rc = -ENOMEM;
> +
> +out:
> +	if (rc) {
>  		deactivate_labels(nd_region);
> -		return -ENOMEM;
> +		return rc;
>  	}
>  
>  	return devm_add_action_or_reset(&nd_region->dev, deactivate_labels,
> -			nd_region);
> +					nd_region);
>  }
>  
>  int nd_region_register_namespaces(struct nd_region *nd_region, int *err)

