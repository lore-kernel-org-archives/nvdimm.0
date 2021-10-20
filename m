Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A92C81
	for <nvdimm@lists.linux.dev>; Wed, 20 Oct 2021 06:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1634711925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PrOFEvqhNQrQ0/ExACfaN4BBMFTlowBIDO0/wNK/PGI=;
	b=PoMinisIlENjtV23IhOMvbpBLah8wxjwdjn5rP8xZ+wo9VG8J45LBHAk9Fs7hbc0lzpm+s
	PWWnH5ab608WFXYURopCjgNBetS4FDQtoAqgK15/QoQfULTkwz36mH2zM3yVOkN8oikeRW
	/XM9YBOWpdDfHzGoHltb2Ejwcfi1i64=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-L6lOAFN5NBOKDq6A3x-SIw-1; Wed, 20 Oct 2021 02:38:44 -0400
X-MC-Unique: L6lOAFN5NBOKDq6A3x-SIw-1
Received: by mail-yb1-f200.google.com with SMTP id y18-20020a25a092000000b005bddb39f160so27464192ybh.10
        for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 23:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PrOFEvqhNQrQ0/ExACfaN4BBMFTlowBIDO0/wNK/PGI=;
        b=zctzWrDPBxdrA1+brK70ntS3bgrYcIjp6Z3lKD/Jz1WXCklKlsi02DCpUw0rGHeU5R
         1onG7LAnDf2+3TKiKqIhFynao6xtYWGbQgF7v/aQsS6lOo56HiH/95c24ptE8PxAc2+U
         sdiy3j3eN11AdcETMfkANgQp30j5/Rsl4y6YrqrUYJYgsJgPVtGizyXuXLgbRk5eWgp5
         RjNXgGEY3AzyAAnp8iJOoDuEuKQQxNUh9ObbcQWg+2SDexVFm2rLkQ3qYll7VlkxrfV4
         iQQYEAAqXda6kyYWH2SXQ0bfixZ2OPqYxn1gTsR6ghDaGf6ama2Vs+wE4VRT7/b1zQ6R
         1Ocw==
X-Gm-Message-State: AOAM532rXd/X69DcC5Jzh8vdnbPa9gCpQm7cZxemKvLkgcA342W4l8Bl
	13vWHfQdWMEwnm6dikR+TKS5JJMs43Wnzd5zuaDZqWM3qyEbgwPIxstMnw0j/8mvaTeo4rFfjSE
	iYJmAGAWRuCQ78aFiQPHSJX4rbCcFn7nY
X-Received: by 2002:a25:3104:: with SMTP id x4mr40913560ybx.512.1634711923714;
        Tue, 19 Oct 2021 23:38:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIZmVt4b8AgEMPxIzXR7HjibNCLFoFON5qfINqUWjmWY1rYZGs5qe6fNCsg2PkDEFW2ZrVeNuo6RpgxFciEWQ=
X-Received: by 2002:a25:3104:: with SMTP id x4mr40913541ybx.512.1634711923514;
 Tue, 19 Oct 2021 23:38:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211019073641.2323410-1-hch@lst.de>
In-Reply-To: <20211019073641.2323410-1-hch@lst.de>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Wed, 20 Oct 2021 14:38:23 +0800
Message-ID: <CAHj4cs-osb2QuuCV2PW8xhefc3ATReur=b0tVf6ogTkMFmVi=A@mail.gmail.com>
Subject: Re: fix a pmem regression due to drain the block queue in del_gendisk
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	linux-block <linux-block@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, linux-mm@kvack.org
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=yizhan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Verified the issue was fixed by this patchset.
https://lore.kernel.org/linux-block/CAHj4cs87BapQJcV0a=M6=dc9PrsGH6qzqJEt9fbjLK1aShnMPg@mail.gmail.com/

Tested-by: Yi Zhang <yi.zhang@redhat.com>


On Tue, Oct 19, 2021 at 3:37 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Dan,
>
> this series fixes my recently introduced regression in the pmem driver by
> removing the usage of q_usage_count as the external pgmap refcount in the
> pmem driver and then removes the now unused external refcount
> infrastructure.
>
> Diffstat:
>  drivers/nvdimm/pmem.c             |   33 +--------------------
>  include/linux/memremap.h          |   18 +----------
>  mm/memremap.c                     |   59 +++++++-------------------------------
>  tools/testing/nvdimm/test/iomap.c |   43 +++++++--------------------
>  4 files changed, 29 insertions(+), 124 deletions(-)
>


--
Best Regards,
  Yi Zhang

