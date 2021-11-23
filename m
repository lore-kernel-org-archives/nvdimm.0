Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5612C83
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 21:17:09 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id g28so232720pgg.3
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 13:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PQeh1LIqbqFtSovgn5WZ7VLYBwfefd3KuHYAxcJ6bdE=;
        b=z/Kv5aF3II2Q1LX6Aazu4oeYGV1DsHDm6VPftSCm/GsXUqcvpUYlHGhNQfvcAEzM+t
         KHEErzvzy9AE7efI2veDZidjjq+fK6s2UJs7fEhnYmQiPFx9rvXEwel822roodlc/FcK
         DEv5SfZdo4Mf/qMs7Jb75ZFTHTDu0awILjq9sqTvXs+VIsFn7y/1XB/C+/lY4NwLFtHP
         cHAfa2a7eS26AcezybSCXTWBbxiGPri9iUr8Wx/IV+DiOD4YHSNiMvTZGqn4/3tFE8gU
         fEqZVpI1Dt83hXy63DNbfv4vosQWDr6RKn8ZmI1PKEqbMIgBEyzoH/HXIZQqJ3XqzuZq
         V9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PQeh1LIqbqFtSovgn5WZ7VLYBwfefd3KuHYAxcJ6bdE=;
        b=1a2HqMeQyOz2qWI6WDAc1M+Z5YcphpBKfoePP4bjlW7JHIfSK4kDULBQTWKy6Rykvq
         PsiTOwqQxJojtB/rFd/5SsL8nbdpRAbCSi20uDsDGNZu3tIIZPj+SEgE9o7LOdsTcesH
         31oQzOOqk2WqWsFCLGZ8esoT5W9pJhsWJlxJpjIdFcj/l8Pp5eymjEVk6PEcx6fHKoUt
         TwHYgFBIPjPqEv35XligzDq6mql/wHjLZlfSYCxC3dGT0IToks35hGJ3bgi0RiNJ8CRb
         P3SbfYHlqzqWGj2xjCUMDmXFzQkKAAcboVb/C3k8cCbMHNaFiureSKua1YKon2hMeFf3
         x9Hg==
X-Gm-Message-State: AOAM533tyOtrImUaFR1S3VA2nevjdhTM7rqAItkXN9chbKJLPCAmrqhQ
	A4wPJp5Y7bn+Uq9QWPfscLKFjHW4ur1tKENTPrSW+Q==
X-Google-Smtp-Source: ABdhPJxo6xmNJWXyaaVPBEUy4anrM6xGk5zJ5S54bOFTPTbJYWg88+GG8ODe3guk693xmG8x/Zkzy+Ul3gB1uuDCJIA=
X-Received: by 2002:a63:5401:: with SMTP id i1mr6112849pgb.356.1637702228750;
 Tue, 23 Nov 2021 13:17:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-17-hch@lst.de>
In-Reply-To: <20211109083309.584081-17-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 13:16:58 -0800
Message-ID: <CAPcyv4jjvoT=aW+_Ks+8L60HG0ypesSi8A+a5F2JXu1dEWHVCw@mail.gmail.com>
Subject: Re: [PATCH 16/29] fsdax: simplify the offset check in dax_iomap_zero
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The file relative offset must have the same alignment as the storage
> offset, so use that and get rid of the call to iomap_sector.

Agree.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
