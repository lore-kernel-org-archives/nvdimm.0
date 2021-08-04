Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5F970
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1628097127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oSmR+/HijKgPwgA8IKqDoIEh2RdgQnMoqoL9TJOZ15I=;
	b=ROXJHedIJvZAaDA9/xC+Y2OoNg7ky44ESya1kH9DZ462kbsDeZ+I8dgxLPLzR0pvklrPON
	ACN36gjZ+iBzzugzOH71ZcH6F+Mz0HSAaV4gAilcLMrSVG2Au7SVj+DBcfLmMno0Wh6RlT
	L08rrN5APmPoLsMkwNg+2sxUw1ySsbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-GgwxHg9uNQW68tPBnQC5eg-1; Wed, 04 Aug 2021 13:12:04 -0400
X-MC-Unique: GgwxHg9uNQW68tPBnQC5eg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A5A51084F55;
	Wed,  4 Aug 2021 17:12:03 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 180494536;
	Wed,  4 Aug 2021 17:12:03 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev,  vishal.l.verma@intel.com
Subject: Re: [PATCH] tools/testing/nvdimm: Fix missing 'fallthrough' warning
References: <162767522046.3313209.14767278726893995797.stgit@dwillia2-desk3.amr.corp.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 04 Aug 2021 13:13:28 -0400
In-Reply-To: <162767522046.3313209.14767278726893995797.stgit@dwillia2-desk3.amr.corp.intel.com>
	(Dan Williams's message of "Fri, 30 Jul 2021 13:00:20 -0700")
Message-ID: <x49h7g5t9on.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jmoyer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dan Williams <dan.j.williams@intel.com> writes:

> Use "fallthrough;" to address:
>
> tools/testing/nvdimm/test/nfit.c: In function =E2=80=98nd_intel_test_fini=
sh_query=E2=80=99:
> tools/testing/nvdimm/test/nfit.c:436:37: warning: this statement may
> =09fall through [-Wimplicit-fallthrough=3D]
>   436 |                 fw->missed_activate =3D false;
>       |                 ~~~~~~~~~~~~~~~~~~~~^~~~~~~
> tools/testing/nvdimm/test/nfit.c:438:9: note: here
>   438 |         case FW_STATE_UPDATED:
>       |         ^~~~
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  tools/testing/nvdimm/test/nfit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test=
/nfit.c
> index 54f367cbadae..b1bff5fb0f65 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -434,7 +434,7 @@ static int nd_intel_test_finish_query(struct nfit_tes=
t *t,
>  =09=09dev_dbg(dev, "%s: transition out verify\n", __func__);
>  =09=09fw->state =3D FW_STATE_UPDATED;
>  =09=09fw->missed_activate =3D false;
> -=09=09/* fall through */
> +=09=09fallthrough;
>  =09case FW_STATE_UPDATED:
>  =09=09nd_cmd->status =3D 0;
>  =09=09/* bogus test version */

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

