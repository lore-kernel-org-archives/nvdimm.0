Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6658E13AD1C
	for <nvdimm@lists.linux.dev>; Sat, 22 Nov 2025 12:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763813776; cv=none; b=JkcFKWGNDgtYFe/d/xGllEMEjF3j312fBnDWaD/U3Rj+kVuX1EoL8mUd2TBQ7nn/KcfOU50gmfcDNL6fDGWW54GDMIAiu0qQniFSRm1He6uvqxcx+CXzuaWUL8w/yBFlklstynq0NrRcgRXeirmQCyE2IXVNm8emR5tExk7XJzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763813776; c=relaxed/simple;
	bh=Q2BOTvNpSkvzy8DIVfla4K5HfV1MiS4cDAlG9UKEygw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oygYww5TIBnnDuC37smC1MRJUk2NI6UxXCsonYJvi4AjzCqhNxvg0UntVvDogkaTuG0c721pl9tHFyS9+MFIk1cUO6tQVeVjQrPhFrYMvjI54Ss296QxXoM491DzRVHfi+DIqwlcSF9ancfN5MWniw1UxI0pYDwRNGdlsxgxWBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZbOL3PV8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbOL3PV8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763813774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vmlRhYF93waksWBjUZONe38VIF8D8AG9X1Um5Uz6pF4=;
	b=ZbOL3PV8UVunRi+p9IEnYJ5AKjDqZlC3mkZQz6PAepzBFv/nX9FlywTbFj8yyFer1TnTTT
	J5rannz+dPCM1pEwDCicyr63rXBt5on8o6pzJ4vn15oHEhJe5SXpvsNCHZtQmjTeW31tKQ
	0/pQ09tbIRbDBzVStdMojRkS8ucyDwc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-IA69egs5O4SMsSW-UikYOA-1; Sat,
 22 Nov 2025 07:16:09 -0500
X-MC-Unique: IA69egs5O4SMsSW-UikYOA-1
X-Mimecast-MFC-AGG-ID: IA69egs5O4SMsSW-UikYOA_1763813768
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71F481956089;
	Sat, 22 Nov 2025 12:16:07 +0000 (UTC)
Received: from fedora (unknown [10.72.116.33])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61ACC30044DC;
	Sat, 22 Nov 2025 12:15:59 +0000 (UTC)
Date: Sat, 22 Nov 2025 20:15:41 +0800
From: Ming Lei <ming.lei@redhat.com>
To: zhangshida <starzhangzsd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure
 problems during append write
Message-ID: <aSGpbb3VUdQEGfmu@fedora>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121081748.1443507-2-zhangshida@kylinos.cn>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Nov 21, 2025 at 04:17:40PM +0800, zhangshida wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index b3a79285c27..55c2c1a0020 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
>  
>  static void bio_chain_endio(struct bio *bio)
>  {
> -	bio_endio(__bio_chain_endio(bio));
> +	bio_endio(bio);
>  }
 
bio_chain_endio() should never get called, so how can this change make any
difference?

Thanks,
Ming

