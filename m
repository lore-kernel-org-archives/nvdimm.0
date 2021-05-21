Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49E770
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 17:22:40 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id g18so13724016pfr.2
        for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 10:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4xwt7H3ydSynAZjOEHISSkaEhx58URrfefqnsYajrYo=;
        b=g1BKbncr9KMnPs6iD1lkt0ziZPK2V1clQEayLUk1t+/an8N1uPvhgun3NHMQpJPQA3
         yZ1GmqDh9BejQcRiPJa1ace6rF4HVI3MOFfSCz6CUEXdOEFDEz2nVLZMVJTD0Z9j/n9n
         D9p6LGfa+TmMnj9fBp8AC+ECH93huj2ZktaPYaZOYEAGGaVjF0RMXbt594TssvFaNaAi
         OUXh1p7LbdPS+pScyGeFPe7hVFikYzOH2f/Q2S+wUUrqyOOEpt2uvWYvfzqg3S/Ogmqu
         ibX+AI7eAFR0Qn3gbKFUs03NuBii7ns9EJztJjuOwETI+xsWOuO/OFFwlEmC9VEPkJGo
         ln3w==
X-Gm-Message-State: AOAM53246CFg0JauNuKjyVKNP4gewdo4XFa6uB8JvxQOyy3r9CaPGXTa
	Cg0BYPiJ4a+SDQYfD98T0is=
X-Google-Smtp-Source: ABdhPJwN/SKOVHqzTq8eMNvLlpfI5p0TUMMcGqBBBfFtPi25TxwCtdfeNJoGCkAE3FkaxK6OlRwjhQ==
X-Received: by 2002:a63:bc19:: with SMTP id q25mr11009138pge.211.1621617760179;
        Fri, 21 May 2021 10:22:40 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o10sm4951196pgv.28.2021.05.21.10.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:22:38 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
	id F13FE423A3; Fri, 21 May 2021 17:22:37 +0000 (UTC)
Date: Fri, 21 May 2021 17:22:37 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 03/26] block: automatically enable
 GENHD_FL_EXT_DEVT
Message-ID: <20210521172237.GA25156@42.do-not-panic.com>
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-4-hch@lst.de>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521055116.1053587-4-hch@lst.de>

On Fri, May 21, 2021 at 07:50:53AM +0200, Christoph Hellwig wrote:
> Automatically set the GENHD_FL_EXT_DEVT flag for all disks allocated
> without an explicit number of minors.  This is what all new block
> drivers should do, so make sure it is the default without boilerplate
> code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
