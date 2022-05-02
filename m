Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1809B2908
	for <nvdimm@lists.linux.dev>; Mon,  2 May 2022 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1651502044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d/TMinGo71/7OoIfLc7Z3mcE2lwoj8dKrhGz0Y/fYX4=;
	b=BM61EBwBYIgs3oT7ozUaLQiuhF/61D1WlljDwwxKRdJ4Gfdrw6er+H58oRs+gBSKtbGzAT
	MkKg+Kg83sQt+G/kmtPjECW9+hGY8TZR1d4GbhWonXF0KI1m4tC/BRIXtpI87WZ11dJ87I
	dw1S7wLFfBLk2yQ6RsLWTB8d5urElwE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-e0dwKuYiORaD67qzegQyYA-1; Mon, 02 May 2022 10:34:00 -0400
X-MC-Unique: e0dwKuYiORaD67qzegQyYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91003804184;
	Mon,  2 May 2022 14:33:59 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C94C111CD36;
	Mon,  2 May 2022 14:33:59 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev,  Vishal Verma <vishal.l.verma@intel.com>,  Dave Jiang <dave.jiang@intel.com>,  Ira Weiny <ira.weiny@intel.com>,  Krzysztof Kensicki <krzysztof.kensicki@intel.com>,  patches@lists.linux.dev
Subject: Re: [PATCH] nvdimm: Allow overwrite in the presence of disabled dimms
References: <165118817010.1772793.5101398830527716084.stgit@dwillia2-desk3.amr.corp.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Mon, 02 May 2022 10:37:04 -0400
In-Reply-To: <165118817010.1772793.5101398830527716084.stgit@dwillia2-desk3.amr.corp.intel.com>
	(Dan Williams's message of "Thu, 28 Apr 2022 16:22:50 -0700")
Message-ID: <x49sfpsuhkf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jmoyer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> It is not clear why the original implementation of overwrite support
> required the dimm driver to be active before overwrite could proceed. In

Based on the log message, I'd say the intention was the opposite.

> fact that can lead to cases where the kernel retains an invalid cached
> copy of the labels from before the overwrite. Unfortunately the kernel
> has not only allowed that case, but enforced it.
>
> Going forward, allow for overwrite to happen while the label area is
> offline, and follow-on with updates to 'ndctl sanitize-dimm --overwrite'
> to trigger the label area invalidation by default.

That sounds reasonable to me.

> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Reported-by: Krzysztof Kensicki <krzysztof.kensicki@intel.com>
> Fixes: 7d988097c546 ("acpi/nfit, libnvdimm/security: Add security DSM overwrite support")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/security.c |    5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index 4b80150e4afa..b5aa55c61461 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -379,11 +379,6 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
>  			|| !nvdimm->sec.flags)
>  		return -EOPNOTSUPP;
>  
> -	if (dev->driver == NULL) {
> -		dev_dbg(dev, "Unable to overwrite while DIMM active.\n");
> -		return -EINVAL;
> -	}
> -
>  	rc = check_security_state(nvdimm);
>  	if (rc)
>  		return rc;

Assuming you've tested this (please confirm):

Acked-by: Jeff Moyer <jmoyer@redhat.com>

