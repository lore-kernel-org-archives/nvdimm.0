Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD832C88
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 02:54:53 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so879705pjb.5
        for <nvdimm@lists.linux.dev>; Mon, 22 Nov 2021 18:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzu6WTfZUrCey1J7m6mzu3SyuG3mlb0cV5bc4AfptPs=;
        b=beaUT1FtsNFsra95ne0owHh0REAyyuUzujf6WfZCqbHVqWDCseUjZNBp1imtZrvl25
         Tle8IyUp3iiK6T7rSedrQcl9c/h0UQVa4ff4523mpAef4KYGb1TbGvy3lfGAL4G4Ooqr
         TH0f0Xw5heidYTCEKZrSbgx6eXucck48D1PdG9bQqnHF3xFKgaR12HFK4qLWfYdcBAaW
         hyr06oXivq4GX87hiZVUip/cxW8DPPmY1DWSzEzAGLteKQgqOmlnE0Fzbh+eO2i8dmuO
         d0czzqQ7InLmIRWHjnUfTxiVsP9Xg6prNyjUDIVMDnnmk947ZrGB8bNv0YUysQL48hVn
         bE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzu6WTfZUrCey1J7m6mzu3SyuG3mlb0cV5bc4AfptPs=;
        b=CCu7p/mVEns9aKV2PNIqb4LvP5WlFNeEhx2dESxf518f1i2mrB0rl4jPY1RR3VAazV
         n3O1AsSLOnzyYSyvnURvwWr3arMfBEeJWr7Cy3D1dEaTY1+xWxKNJ0cnjcCaqHQMcxhD
         A8Fg7SqfjJhh80yiIVs8pku+R6ea2qBRF2WQ63k2P2FoSajABMH5zUG/itdRCZF1KvRE
         k4eVMCZZwC0J8HqJqHR8yxR1Fomz6Iq3Va50OhxUVL2TMlPr4JrnEWZy5jrZWtqO5GRd
         yp5vFC39gHCcSaWQvCwE+wg6NF+5qvMjXjjHzHhdmMqNUu6MVEYlm0jiRzWj0fhCKhfo
         MuKA==
X-Gm-Message-State: AOAM530o+gm8LIouuC8/g7/73/VzPItfgo8mYl3uAgxSZJ7IoHviPli3
	LHaLVma4O1Am1LEwSY6dxa5Aprnn7g+2LA3CIKB5/w==
X-Google-Smtp-Source: ABdhPJxeiX5ifpjvIOpWVxQMDUuHcOe3OIdJeR8Imw/gLHmEQwl4x/JiO/uU+o3bH9o5PQYkURGBJLUFMItHEKRZD78=
X-Received: by 2002:a17:902:a50f:b0:143:7dec:567 with SMTP id
 s15-20020a170902a50f00b001437dec0567mr2776615plq.18.1637636093077; Mon, 22
 Nov 2021 18:54:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-4-hch@lst.de>
 <CAPcyv4hzWBZfex=C2_+nNLFKODw8+E9NSgK50COqE748cfEKTg@mail.gmail.com>
In-Reply-To: <CAPcyv4hzWBZfex=C2_+nNLFKODw8+E9NSgK50COqE748cfEKTg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 18:54:42 -0800
Message-ID: <CAPcyv4g=KgKZR6JF8_=mTs7Ndgq7DSU+5_sTJ7gQuwUgC5dRYg@mail.gmail.com>
Subject: Re: [PATCH 03/29] dax: remove CONFIG_DAX_DRIVER
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 17, 2021 at 9:43 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > CONFIG_DAX_DRIVER only selects CONFIG_DAX now, so remove it.
>
> Applied.

Unapplied,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
