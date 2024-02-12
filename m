Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B4B4CB22;
	Mon, 12 Feb 2024 22:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707775427; cv=none; b=eUoZcAsqkkbA7jBtBx1G26TvXZkgGNVVJzB5teKMI2GwM3QejLkSQT7Z+pvXJ1sm9JCBp4O7nSfpSlBLnQkjayPWfanJkY/qcHuMBPSQtmUuyx2lO68F59qGQlX04HL8uE6/gsRrphW+aFsTfwwLWzvDW3y/sLyUOUOIqK1j3Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707775427; c=relaxed/simple;
	bh=W/bpF4fDyBYCxuho4baujxfsMHNkNNXJSkVJNKjpCzs=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9z51ZsJwg9T2VktXqCMntst91C/Wn2Va3y2KWtXn9IU3AiARr2PEioj3H7lxgdTKwkZmH6bGk+4fP7TdVn+/OenamEhU8QFwXNfcGuEq5KP8TZ3qHATg+JsO363wOgAvBWWQa8othZtUbHRbdq9Zdd+3svx4H4W/n3jC8QHI+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K/ZBN8dD; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/ZBN8dD"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-59a6f2eecf6so112399eaf.1;
        Mon, 12 Feb 2024 14:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707775424; x=1708380224; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=93VuehxW8IiZjqg3cy8gX+Dj6JAjR6qHpJt8+OJ38pE=;
        b=K/ZBN8dDhbjUIYvBSCTYiGVKBoUmIb65VUHb6NvuBKjpdNw0j/s5cLsVJ+Ze08L3LD
         hg+0HnO0SfRL0XbXCiBkWout+WjYvyUESIjK+gisn6gkF5ss3fyZ4gIGSa0MLdK5CHGt
         vI1fwKaOcSeWTF2dGZNsnjoeEqy9j0y2qreM8iUX0+NpxP9JtMKlzXjfnB7gRJvAKK8r
         azLp9XTSXZAgQiid+iV2iBC76ROQcaPe9+2nsUrGSxOq4+uxy9utWVZJeX7REgnGibIm
         DCH0pyoQo6jKAeiciMHRNUB3xuTkbs5u1SbvEiju+IPf5/Ja/o/CwaH4vsesDLsWIMo1
         LhjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707775424; x=1708380224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93VuehxW8IiZjqg3cy8gX+Dj6JAjR6qHpJt8+OJ38pE=;
        b=ihWqMs0v+5Uk8pItMgh+RSTiNXHrRkg3Y4uiteAPdbVZV9Uw2GlQs0Q8W6eoRF69gK
         fXpVd0ZS7O4+q3Lam/T9Rzy8jUULYWvliBX4qFMAxW64Ei47WOBmZk+yJD0UQ7dv3xIA
         5Ix7pYlpvUcWtkzLP6ddqKqHzpmaD/MdLcIBrmUiDDPFa1xoHpxpASd5eVhQJ4SrhZRh
         RXVLqXagBVre5Qp/3n4wCCkJSIKJ+D9FtswPyAqZGvirC0NyWqN4JqRnNrZ9jjGzzJ8J
         Cx9ZZR3w1ICCB/Apid5HzsItg8PPvvN0e3bsVVm34fvPvijtQF+LA0rl2/YTu6F2N8FJ
         DDJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8APZmRxdDbGj2e8VvE14RwM3czd2szhwEYGAZidfcGubVutuhG2kQC9IbKEoCainYgdbEunEgJCKAARTooMpBLdQcR0ueqZWlrPPmtPpzp8Z+yrV2XxprbHPxWbjUry4=
X-Gm-Message-State: AOJu0YzSkXVARvP5BQp7D8aqZRyVlzne9yHHhkF4/3IhdEw79RLTf29x
	KNhylnrhqa50sCyS6HT6tTgiM8NkXUyaiAIkPztdjeozrB1+UU7z
X-Google-Smtp-Source: AGHT+IE5OBKx1zbmYznUgitfUIrZdUAxmS+Eas2NAO7RGcO4j6U6ISP+C6U15Hc5IQBn0IfaRdlLPw==
X-Received: by 2002:a05:6358:d093:b0:178:67dc:aba8 with SMTP id jc19-20020a056358d09300b0017867dcaba8mr9820912rwb.17.1707775424575;
        Mon, 12 Feb 2024 14:03:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXsq3wUY11a+L7NuGj3BsmexGP6eZMiamdWyBsuJhiWpvO+ZarhxYNh9jN84eNMeJYhoOciFuWzz1ZnHmXsGB1m36yXHC0X6Bvd9KjpNp2fx7VJj0MQPEsh3nsPhRZtad4FDyh1OEF5Sl6qvAdFW4vKJm4/bHT+gbZ3oTrxYFPUKWoaXCU5A2ztB/oOmEw9ipe0214tr1qPrrqu1jsbviotxTqCJoI+OwAKtjNxF//RL0E6DEsDwDfSwF9RXH5EZkhrN3NnBKB8JaxLEB15EJZ4s9CN4fU7ebDUQxUsrv6wIn9BfRO+1c8jZ6oAvubgeK4EOyp07xU2RteUIcVjpr9wRJuXYhpDE83B7le4oDDm3DgtWGzYJcRDGoGD0kcBYSLEQL/C5dNkiJq8bdSCq4mRA3hixJM8UqLw8YsrXx6+qTzJ5QU+i6xDEbeZdz19lsh1rjhdIC0ch55qG4OdAFBwJ3zbYmTinLp2J+1HCDD0D7jt4v3+XiYQwrtu5r7UxNtDUNdE/xZbr6vFtQozelocRvVVtl3CUicsCQ6IAHDrEAdS49M9HFhDKZm+OLaHLGH6GA5d6ktp7067c5t1JpQ8JNUR
Received: from debian ([2601:641:300:14de:7353:5102:82c6:956f])
        by smtp.gmail.com with ESMTPSA id x23-20020aa79197000000b006e05c801748sm5994884pfa.199.2024.02.12.14.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 14:03:44 -0800 (PST)
From: fan <nifan.cxl@gmail.com>
X-Google-Original-From: fan <fan@debian>
Date: Mon, 12 Feb 2024 14:03:24 -0800
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
	Russell King <linux@armlinux.org.uk>, linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	dm-devel@lists.linux.dev, nvdimm@lists.linux.dev
Subject: Re: [PATCH] nvdimm/pmem: Fix leak on dax_add_host() failure
Message-ID: <ZcqVrFKxisIwHR3p@debian>
References: <20240212162722.19080-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240212162722.19080-1-mathieu.desnoyers@efficios.com>

On Mon, Feb 12, 2024 at 11:27:22AM -0500, Mathieu Desnoyers wrote:
> Fix a leak on dax_add_host() error, where "goto out_cleanup_dax" is done
> before setting pmem->dax_dev, which therefore issues the two following
> calls on NULL pointers:
> 
> out_cleanup_dax:
>         kill_dax(pmem->dax_dev);
>         put_dax(pmem->dax_dev);
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: linux-arch@vger.kernel.org
> Cc: linux-cxl@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-xfs@vger.kernel.org
> Cc: dm-devel@lists.linux.dev
> Cc: nvdimm@lists.linux.dev

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
>  drivers/nvdimm/pmem.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 4e8fdcb3f1c8..9fe358090720 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -566,12 +566,11 @@ static int pmem_attach_disk(struct device *dev,
>  	set_dax_nomc(dax_dev);
>  	if (is_nvdimm_sync(nd_region))
>  		set_dax_synchronous(dax_dev);
> +	pmem->dax_dev = dax_dev;
>  	rc = dax_add_host(dax_dev, disk);
>  	if (rc)
>  		goto out_cleanup_dax;
>  	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
> -	pmem->dax_dev = dax_dev;
> -
>  	rc = device_add_disk(dev, disk, pmem_attribute_groups);
>  	if (rc)
>  		goto out_remove_host;
> -- 
> 2.39.2
> 
