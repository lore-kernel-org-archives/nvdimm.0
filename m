Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93479137905
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745947; cv=none; b=STBOwSVYAY7uw2ZlsIxcXEohYVMYluR6fafkOAMEui3vByNY5J0VhgksYW0BzXEenFytUW3tVVCHXWHFk4uv2almqpDOOt9ISgql3KosDeXMcf3gzcQxXVp6csm5/d/KmJPKTg9uefwoVBbmpDYfVT9i2HOaZzPkiO342UXfXqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745947; c=relaxed/simple;
	bh=8p2opZvkqwz13/KE3xtrCvYEBGR5Menz1ZsHlu33loo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkJsxhbO0nRHZZ1UEZF9FGtLhT6ye+VbIN2MO9Oc6ktziKM70ibYR/CTWRV1GDuE+TAimcIKYkq72DiF6ppkpt/eIcI0G9vCCB0QMAe7SAoowxV0GoEHSQmJFEzOPR3e2X/JuDXb4WHdXGZ3P6lOi9H/adsK3asI23i16bsYVZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6e506bf7e79so75530a34.3
        for <nvdimm@lists.linux.dev>; Wed, 06 Mar 2024 09:25:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709745943; x=1710350743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lICbiutwJIIAg+5ET7ThLgtawqmnV2P0QQDIe0xrltM=;
        b=Ckd8Rmzs/kmFiL7kmxtiRA/vzXec3CwmTeF1j3R/aXBs1INH1JBSlU7qHqkapUoDDq
         vee6cPLzZaWF4/4I19xuomiqA0gf9ylUemprOvjwIvNkXL7xNYwoU/spwfybmwTGpLog
         fAsjI0qwTLBvXQAwFKeltLbTSMuZUu94grmnM0PlgAAlzoD7xCDMtD86ehxNXLMemhyN
         svTBs33zGFhPLb3xq11nc9Xy9daT/qBWURe959ELEhqvqfomuqs1oEPZObVSM125vuQC
         o8V7VTyL0mngI+62f0i2sz7ge2novxBl5gZLH1qWRzpP1v5RZUgm45C2zTqdYLzoT35G
         RiXw==
X-Forwarded-Encrypted: i=1; AJvYcCXUNFAUY85KhJR9JYbiIK4eBHsNThrD59YpgiMkMGQAcAjI3KZAx252MIGG1ZBIzF5G044fYt+ex/JEsvDTioxY6vm4wVok
X-Gm-Message-State: AOJu0YyuqSPVwOsXtlBxNg1gQCzPk04v2EaQNu/od7cjJ0OCqIYfk65b
	mx0J+r5zDgRN2ayfHPUXSBtnaCVAovv0DtsBfu+MCukYx+aluywu3ntPKspM/w==
X-Google-Smtp-Source: AGHT+IEdsnL3H44CitlVgXc79s74rTtqtEN4ML5+/b1ZAmEVQMCdoGLTdYY8JEGFQDrqRWcv7J2kZw==
X-Received: by 2002:a05:6870:ac12:b0:221:42a1:9457 with SMTP id kw18-20020a056870ac1200b0022142a19457mr5265846oab.9.1709745943643;
        Wed, 06 Mar 2024 09:25:43 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id i8-20020a05620a0a0800b007883c9be0a9sm1108184qka.80.2024.03.06.09.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 09:25:43 -0800 (PST)
Date: Wed, 6 Mar 2024 12:25:42 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] dm-integrity: set max_integrity_segments in
 dm_integrity_io_hints
Message-ID: <ZeinFsPEsajU__Iv@redhat.com>
References: <20240306142739.237234-1-hch@lst.de>
 <20240306142739.237234-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306142739.237234-4-hch@lst.de>

On Wed, Mar 06 2024 at  9:27P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Set max_integrity_segments with the other queue limits instead
> of updating it later.  This also uncovered that the driver is trying
> to set the limit to UINT_MAX while max_integrity_segments is an
> unsigned short, so fix it up to use USHRT_MAX instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-integrity.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index c5f03aab455256..a2e5cfe84565ae 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -3419,6 +3419,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
>  		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
>  		limits->dma_alignment = limits->logical_block_size - 1;
>  	}
> +	limits->max_integrity_segments = USHRT_MAX;
>  }
>  
>  static void calculate_journal_section_size(struct dm_integrity_c *ic)
> @@ -3586,7 +3587,6 @@ static void dm_integrity_set(struct dm_target *ti, struct dm_integrity_c *ic)
>  	bi.interval_exp = ic->sb->log2_sectors_per_block + SECTOR_SHIFT;
>  
>  	blk_integrity_register(disk, &bi);
> -	blk_queue_max_integrity_segments(disk->queue, UINT_MAX);
>  }
>  
>  static void dm_integrity_free_page_list(struct page_list *pl)
> -- 
> 2.39.2
> 

I've picked this up for 6.9:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.9&id=f30e5ed1306be8a900b33317bc429dd3794d81a1

Thanks.
