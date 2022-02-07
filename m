Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B52F27
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 18:08:12 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id k17so11797179plk.0
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 10:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxHF7bigQnfZfNGCQpq6EtXcG8/j6GHHAEIHGHy2fyU=;
        b=W2DDXQJis+1qeQfXY6E/rxnSkSH+QKQccGw4pZqh3cKQQ7Ll28D21ZTANWBpjdTXkB
         +oBg0dRp7zXiF2K9fvNxjOnqLQ0NU4tSCX/uoDUgYXiPcW3lrnrEZ8WrBiPWSBgY4/tx
         9wQBgc3U+/16XX6zr1IGWZp+OTMhC+7AmHWl4HQOtmJdf1TDvqV9PwZseP44xIAvTKTJ
         lY9+rCsDVlGtJn+K+JfRbJQJUoxEyKL8bHmbimQ1ptdoTfcpwUfxMxs8lIMS2tr1n+Up
         0WNvMspuYRbKnLIowW6FPQwT66Mrqlup7UTEmGoUmJqEmINAArubT4xrd5hjAe0QVo24
         gEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxHF7bigQnfZfNGCQpq6EtXcG8/j6GHHAEIHGHy2fyU=;
        b=5ejBffvDd7IwcEXXMYeFt+PMHoP3vbcbU6n/imwtMMLzWXO6B/7j3h4z4ZK7+3ev1m
         jhbNYXFBi3O2p98wu2e1ecfJRTT6fdDHqrdzugkFVpXTGHdc+7a0jcgETf9y+AjsghIV
         6tTThvR7wQClc8jl3eDtK4b5ND9tR2E6baMLzJsnGMhj9YPbmn/VHiGI4Ow1qAunpEbu
         rbMjYts1DPNd19s4/ognOGu72ZIk/HFKG4muNyscRQDq8dTC/htWdpdo1AKq5dR68GtM
         nm8JL+UDVhfFDwamoBCo0GImcm1zMLJQEyNg61zq4jgDPf73bpy243aIbbhUrO0cSuIz
         OGlw==
X-Gm-Message-State: AOAM5337PVrxaJjRnFDvIzMd+Eg+WOY839i3u/gLUnN3B478GMgtVMM0
	AbaTVXAcKMuP4jJKeCJ/wa//JCWtrmWkdI+TjqZ5tw==
X-Google-Smtp-Source: ABdhPJxbjfLp1vymzfVN/rUSu7NFfwM27TjFOxcEJErT+R82ivD+XXC3ZWylDTpvE/Ebzm6hUwz4bOsdTAqXcC6BA2A=
X-Received: by 2002:a17:902:ccce:: with SMTP id z14mr815477ple.34.1644257292200;
 Mon, 07 Feb 2022 10:08:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-2-hch@lst.de>
In-Reply-To: <20220207063249.1833066-2-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Feb 2022 10:08:01 -0800
Message-ID: <CAPcyv4iKLXJftFL+jdAXFXt6-fjwSdK9D2un9PywfXDT0W7HzQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: remove a pointless CONFIG_ZONE_DEVICE check in memremap_pages
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Felix Kuehling <Felix.Kuehling@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>, 
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Alistair Popple <apopple@nvidia.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, 
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Feb 6, 2022 at 10:33 PM Christoph Hellwig <hch@lst.de> wrote:
>
> memremap.c is only built when CONFIG_ZONE_DEVICE is set, so remove
> the superflous extra check.

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
