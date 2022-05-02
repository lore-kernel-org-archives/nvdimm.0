Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5412908
	for <nvdimm@lists.linux.dev>; Mon,  2 May 2022 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1651502714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/cnkrZgkRR3Idlc27qYe5F5+jb5pAptiZAI1JOnT4DU=;
	b=OZh4vaZ55BKxmDReCrtOAC6SDedPvGRC9KJcdobchA4Jd93i6gzDq3wvQHCJbTiVQFC0u7
	QxG30rE4zZNa13Bl/0p5IPww7FEw8XBzwQOgfVFVwVl/UwFGTJjV6VsbF+a+SnqpXmpi7l
	4iRDUAl/fdLtsg63ZFXUYFPcvWoPBrE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-cArQLBckMt2iBYcKRCgcRg-1; Mon, 02 May 2022 10:45:13 -0400
X-MC-Unique: cArQLBckMt2iBYcKRCgcRg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A90329AB408;
	Mon,  2 May 2022 14:45:12 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FDB2416175;
	Mon,  2 May 2022 14:45:12 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com,  Dave Jiang <dave.jiang@intel.com>,  linux-cxl@vger.kernel.org,  nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH] ndctl/dimm: Flush invalidated labels after overwrite
References: <165119008839.1783158.3766085644383173318.stgit@dwillia2-desk3.amr.corp.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Mon, 02 May 2022 10:48:17 -0400
In-Reply-To: <165119008839.1783158.3766085644383173318.stgit@dwillia2-desk3.amr.corp.intel.com>
	(Dan Williams's message of "Thu, 28 Apr 2022 16:54:48 -0700")
Message-ID: <x49o80guh1q.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jmoyer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> Similar to "ndctl write-labels", after "ndctl sanitize-dimm --overwrite"
> the kernel may contain a cached copy of the label area that has been
> invalidated by the overwrite. Toggle the enabled state of the dimm-device
> to trigger the kernel to release the cached copy.
>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Link: https://lore.kernel.org/all/165118817010.1772793.5101398830527716084.stgit@dwillia2-desk3.amr.corp.intel.com/
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/dimm.c |   34 ++++++++++++++++++++++------------
>  1 file changed, 22 insertions(+), 12 deletions(-)
>
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index d9718a33b22f..ac7c5270e971 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -354,6 +354,23 @@ static int rw_bin(FILE *f, struct ndctl_cmd *cmd, ssize_t size,
>  	return 0;
>  }
>  
> +static int revalidate_labels(struct ndctl_dimm *dimm)
> +{
> +	int rc;
> +
> +	/*
> +	 * If the dimm is already disabled the kernel is not holding a cached
> +	 * copy of the label space.
> +	 */
> +	if (!ndctl_dimm_is_enabled(dimm))
> +		return 0;
> +
> +	rc = ndctl_dimm_disable(dimm);
> +	if (rc)
> +		return rc;
> +	return ndctl_dimm_enable(dimm);
> +}
> +
>  static int action_write(struct ndctl_dimm *dimm, struct action_context *actx)
>  {
>  	struct ndctl_cmd *cmd_read, *cmd_write;
> @@ -377,18 +394,10 @@ static int action_write(struct ndctl_dimm *dimm, struct action_context *actx)
>  
>  	size = ndctl_cmd_cfg_read_get_size(cmd_read);
>  	rc = rw_bin(actx->f_in, cmd_write, size, param.offset, WRITE);
> -
> -	/*
> -	 * If the dimm is already disabled the kernel is not holding a cached
> -	 * copy of the label space.
> -	 */
> -	if (!ndctl_dimm_is_enabled(dimm))
> -		goto out;
> -
> -	rc = ndctl_dimm_disable(dimm);
>  	if (rc)
>  		goto out;
> -	rc = ndctl_dimm_enable(dimm);
> +
> +	rc = revalidate_labels(dimm);
>  
>   out:
>  	ndctl_cmd_unref(cmd_read);
> @@ -1043,7 +1052,7 @@ static int action_security_freeze(struct ndctl_dimm *dimm,
>  static int action_sanitize_dimm(struct ndctl_dimm *dimm,
>  		struct action_context *actx)
>  {
> -	int rc;
> +	int rc = 0;
>  	enum ndctl_key_type key_type;
>  
>  	if (ndctl_dimm_get_security(dimm) < 0) {
> @@ -1085,9 +1094,10 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
>  		rc = ndctl_dimm_overwrite_key(dimm);
>  		if (rc < 0)
>  			return rc;
> +		rc = revalidate_labels(dimm);
>  	}
>  
> -	return 0;
> +	return rc;
>  }
>  
>  static int action_wait_overwrite(struct ndctl_dimm *dimm,

Acked-by: Jeff Moyer <jmoyer@redhat.com>

