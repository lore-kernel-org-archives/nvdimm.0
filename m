Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C1C639
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 05:22:29 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id ud5so31112080ejc.4
        for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 21:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JT2zjT50rht2X94XzcouBAPT5GFii3bjIj7XRp3VvSY=;
        b=XL7TA8xz8/VTQjaB016MEjIHi2wQ3+aaiLjctaPBvvWejoSoTyF+d/qcRH6ZGkK3nF
         ubhTfCMxq3RR1ltB4aRl6oWu9nuKYbwyHu0UXiz3HujG/faYcWNbKqH9/tc3kyRcZVt/
         5k0VVue2Okd9QdmVpCeHMy/5Nuj9jJezzrWzKEhCKC0xqoQ9ZD3m0gOHoITIA7szsVhO
         F0+QEGNidJfZQGnnD6rN9HSzJGd+XWrkZvN6sHhEOsm7rLIAQShBKkoFxb5zyVbDpE1I
         QVRi18f61d1162yth39NUyPKkvLzbqJkczVgRAp0XMvg6WEW9RShY7b0GsrA4nmuDPY9
         XQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JT2zjT50rht2X94XzcouBAPT5GFii3bjIj7XRp3VvSY=;
        b=fvSehY7xTai0SLhszwSaVweg+Va8+LeZzUBPHod7Gqv/eKfdEM6ZcsVH83jJPKo0XP
         szAGKQvq8XrFXkvGvh7HfVbko1n+yt/5yI8s6DuSUzgu5oTMXLNYMuzajo87zLWz5Ks2
         y2ibRPPSKo1RncvdeTNImlKhL45SYR5W4xCYQ6rKFp/KRIulzNT4Mc/r+0t+43iE3i/S
         MZB98C7+dBpYphrh4FUEh/fOxn7o3pjZh/0PcI6VHz96cH3cH2oNzmzq/iGIXsAasz3g
         j8HH7Xbj7eBv/ARW5J7T1pU+VPV1EW5TT99jCv056PHp9TAXukbJq+2Mw6AQ+PTp+F5f
         Nkkg==
X-Gm-Message-State: ANoB5pm7Fwh2KS+h+7aQDmJuZaxxxTQ/SEADjnYTsmVpnsu8M+kAe7MW
	d4Mw6g2yDj0gj1amEoORXIc=
X-Google-Smtp-Source: AA0mqf6pA++mi5EwFmvBN12/VotrvFcJjYg7m0dCSqueJ+hdKGhJuAq32vs3PuEZN7MkirwksOUWVw==
X-Received: by 2002:a17:906:f84d:b0:7b9:631b:7dfb with SMTP id ks13-20020a170906f84d00b007b9631b7dfbmr27859674ejb.32.1669699347703;
        Mon, 28 Nov 2022 21:22:27 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i13-20020a17090639cd00b0078d957e65b6sm5730134eje.23.2022.11.28.21.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 21:22:27 -0800 (PST)
Date: Tue, 29 Nov 2022 08:22:24 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: dan.j.williams@intel.com, nvdimm@lists.linux.dev
Subject: Re: [bug report] libnvdimm: fix mishandled nvdimm_clear_poison()
 return value
Message-ID: <Y4WXEAP5YSOfUcVV@kadam>
References: <Y39FbkGEvQ8TcS1d@kili>
 <x49r0xnksq0.fsf@segfault.boston.devel.redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49r0xnksq0.fsf@segfault.boston.devel.redhat.com>

On Mon, Nov 28, 2022 at 10:24:07AM -0500, Jeff Moyer wrote:
> Dan Carpenter <error27@gmail.com> writes:
> 
> > Hello Dan Williams,
> >
> > The patch 868f036fee4b: "libnvdimm: fix mishandled
> > nvdimm_clear_poison() return value" from Dec 16, 2016, leads to the
> > following Smatch static checker warnings:
> >
> >     drivers/nvdimm/claim.c:287 nsio_rw_bytes() warn:
> >     replace divide condition 'cleared / 512' with 'cleared >= 512'
> >
> >     drivers/nvdimm/bus.c:210 nvdimm_account_cleared_poison() warn:
> >     replace divide condition 'cleared / 512' with 'cleared >= 512'
> >
> > drivers/nvdimm/claim.c
> >     252 static int nsio_rw_bytes(struct nd_namespace_common *ndns,
> >     253                 resource_size_t offset, void *buf, size_t size, int rw,
> >     254                 unsigned long flags)
> >     255 {
> >     256         struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
> >     257         unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
> >     258         sector_t sector = offset >> 9;
> >     259         int rc = 0, ret = 0;
> >     260 
> >     261         if (unlikely(!size))
> >     262                 return 0;
> >     263 
> >     264         if (unlikely(offset + size > nsio->size)) {
> >     265                 dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
> >     266                 return -EFAULT;
> >     267         }
> >     268 
> >     269         if (rw == READ) {
> >     270                 if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
> >     271                         return -EIO;
> >     272                 if (copy_mc_to_kernel(buf, nsio->addr + offset, size) != 0)
> >     273                         return -EIO;
> >     274                 return 0;
> >     275         }
> >     276 
> >     277         if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
> >     278                 if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
> >     279                                 && !(flags & NVDIMM_IO_ATOMIC)) {
> >     280                         long cleared;
> >     281 
> >     282                         might_sleep();
> >     283                         cleared = nvdimm_clear_poison(&ndns->dev,
> >     284                                         nsio->res.start + offset, size);
> >     285                         if (cleared < size)
> >     286                                 rc = -EIO;
> > --> 287                         if (cleared > 0 && cleared / 512) {
> >                                                    ^^^^^^^^^^^^^
> > Smatch suggests changing this to "&& cleared >= 512" but it doesn't make
> > sense to say if (cleared > 0 && cleared >= 512) {.  Probably what was
> > instead intended was "if (cleared > 0 && (cleared % 512) == 0) {"?
> 
> No, it is correct as written.  cleared is the number of bytes cleared.
> The badblocks_clear interface takes 512 byte sectors as an input.  We
> only want to call badblocks_clear if we cleared /at least/ one sector.
> 
> It could probably use a comment, though.  :)

Okay.  Thanks for looking at this!

regards,
dan carpenter

