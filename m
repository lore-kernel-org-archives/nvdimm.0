Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A3720E023
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769698325; cv=none; b=TFqsCl46C8Wb708RXi0i2WCNfa8R7I2YB1v+E6YXWbBWVLyis0GxD4mTHQl6ZrfbrsE59+SorgOaQzawi7yVtxa0Jd9G22p46pMVOr4VKDUbTPjMs3S3lZkAAKXAPlAEQmOShIXmqxPTlQCwNApghkOuPwZXWlfqiq7Keo4//BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769698325; c=relaxed/simple;
	bh=whQFO0imdqg5QUuh6ridbMtxCHkQa/EwXHMd6X70r/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZzfgQQVb38rBjR41keecdhnDjjMD/J+GvhTPOImM8/XbD3l6ht9egUb5OIx1PLIaIYZ+ulZ/H/CZCPFSKR035Bk9AST0q9EdPfL58nZywzyTauWLH7DS9xyMS3v5xiGMs1Hlymyoxq2Au9U6bmhfUAjhK2huNU7Ev6h1dqpT8Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LE/vJbin; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LE/vJbin"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769698323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m31pY/sxRUdVfac4+BuGSMMKkDrCtKZLQDSOVfYYwBg=;
	b=LE/vJbin+vML3GMH8ozEbd+Ymh4W+biVwpOENBcAlkwfaXUZ5No4RrpGMt0sDJzqNKJzu6
	/p2nXMiGdRHLsqsEINhB343v2bYgCiWR38eFf6ROFA3Qe3pIyAtEASRfbfz1o/Ph1MES4p
	Sl2y19jl0MBrZEoDlQ+bT4MVzXFz5yU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-MeTwMWQvM5-ZcqKuao3mkw-1; Thu, 29 Jan 2026 09:52:02 -0500
X-MC-Unique: MeTwMWQvM5-ZcqKuao3mkw-1
X-Mimecast-MFC-AGG-ID: MeTwMWQvM5-ZcqKuao3mkw_1769698321
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48057c39931so12653415e9.0
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 06:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769698321; x=1770303121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m31pY/sxRUdVfac4+BuGSMMKkDrCtKZLQDSOVfYYwBg=;
        b=OL09dXS7dQicnVrmfz8MxqDcDEjLCsc2G03ocIBqNQUMsh+fju5UN3QuotI9FT67Xu
         WnnpKV4eI61VOuFL7mffbiIH5357/NG4u/z5bW5WoZ0JLAssyrD0LgkV2+Kd+4bIloqE
         x6XDkiPrZVhWc73k/JDZ/PyQ3jWsYMz8joC5DfZsHiEVIvlOYDPy/4Wbs9yJl4tR14wH
         pYQ28ANiRTdoUp4BIJqbVQ4xFerKC8rxN+yERbUTPzalfO1vglNRKg0IdFHaQZQiy3wp
         1niftDsB1ZCXIlCat7dydB2szxxt94XbWJwPs+hfeboiJqyAYTfZp0b5gFI7ZA2e91P0
         DZKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc0ABRZ+cA+QVQf4Cb29pIlTGpQbhHyUJEaglYLvE+8VnnNbzhvMI6zdxfBkEqXlaXZ3uMb6Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxEeexialklSbjAg8f2WPgIXeK8ElpWQ6GJ5QIgwNfFxFbHv1B
	pScoZDI2NfvCld/SW0Tjb7cllrKkC9244LErA+Gu9hHg0Yoo88Q6wb0hUilHoNIUhdqLJlhTCpL
	SspbwLXrTEIaLbgbwW+cfqgf0gQQiHcsKd1Rl5hoNAPbs4TJBLzSzBNOh
X-Gm-Gg: AZuq6aIertzg9w7QPFblcHmfoJcX1Wc0KRTo3Io3QdVV2nDiXdmLHHV6TyUe3Nb0TCU
	aLtTVwpo1SGEvoIG/DVPeTqawWWB2sTXoO/+iej76bmJPdPmeEutC4kxlOhZNKMJKg+wGiZNQPE
	XKU/zE2Z3FagQZhss2DykmZA6IykFgiV005SxvEye3v34wEEpv/HIGMkAov8Hy62TANrR88uxw5
	vQPov7W5P4oLe1z8ZtjbUfwHMguUzc+0QpiPHYv/b+5wjncGBobfcG9LVbQOHsub2E+u1NGoUhU
	9sZpnRCRyU5OVwElWDwjAWDObWT1RqU9+jROfb6lWO9b7+WHwR3Opbt9IQAndNIXdZMFscuVE68
	=
X-Received: by 2002:a05:600c:4f4f:b0:47e:e48b:506d with SMTP id 5b1f17b1804b1-4806c7cc86dmr120529935e9.16.1769698320797;
        Thu, 29 Jan 2026 06:52:00 -0800 (PST)
X-Received: by 2002:a05:600c:4f4f:b0:47e:e48b:506d with SMTP id 5b1f17b1804b1-4806c7cc86dmr120529435e9.16.1769698320273;
        Thu, 29 Jan 2026 06:52:00 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-481a5d31651sm5851205e9.4.2026.01.29.06.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 06:51:59 -0800 (PST)
Date: Thu, 29 Jan 2026 15:51:58 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: support T10 protection information
Message-ID: <5xaomhu2q2jf3w2hbtkh22dytfiqc6wqyslcfoiqdcwgsud5wk@4ykdof27ntxb>
References: <20260128161517.666412-1-hch@lst.de>
 <20260128161517.666412-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260128161517.666412-16-hch@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lrS-B8n1fbFPbMZLW82JvX7tulyz7WPfX7NHBuFbjPk_1769698321
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2026-01-28 17:15:10, Christoph Hellwig wrote:
> +static inline const struct iomap_read_ops *
> +xfs_bio_read_ops(
> +	const struct xfs_inode		*ip)
> +{
> +	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> +		return &xfs_bio_read_integrity_ops;
> +	return &iomap_bio_read_ops;
> +}
> +
>  STATIC int
>  xfs_vm_read_folio(
> -	struct file		*unused,
> -	struct folio		*folio)
> +	struct file			*file,
> +	struct folio			*folio)
>  {
> -	iomap_bio_read_folio(folio, &xfs_read_iomap_ops);
> +	struct iomap_read_folio_ctx	ctx = {
> +		.cur_folio	= folio,
> +		.ops		= xfs_bio_read_ops(XFS_I(file->f_mapping->host)),

Hmm, can we use folio->mapping->host here instead? Adding fsverity,
read_mapping_folio() will be called without file reference in
generic_read_merkle_tree_page() (from your patchset). This in turn
is called from fsverity_verify_bio() in the ioend callback, which
only has bio reference. 

> +	};
> +
> +	iomap_read_folio(&xfs_read_iomap_ops, &ctx);
>  	return 0;
>  }

-- 
- Andrey

