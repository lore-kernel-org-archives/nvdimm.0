Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5C32C82
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 03:48:03 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso1385769pjb.0
        for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 19:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BQpMJpPq/OIJ1A+jReESOD3pvkOjXmQh8KJADyXTrz8=;
        b=jKMXPC6R380cNIQ/lk6QhOIiLqsp4XKj1eRLbWdIfXDMXjf2sFtM/A4DNKzZle92lO
         3U1GnSeEGBEEzHeeSOTcj6e6Hlhrl2Cgom3C+oy6m84LroLIm83mhibtNhOC9a7kpuLa
         ouXLOQwDClItscEUt0Jtcfsiacpxarhj3trqquFBkBV1VRiZIUVoCcdmCugOwJ+8mJs6
         RFqDPmjgXZyOm3EQaprR9sZoOXJ0YQXXHWkXXD+DsFaSM6qnnUL3vYnF49/xzscWLZfD
         M7pqOQ9uH/J1/XHGYxb48lxo0PQegLqWhqBsHyRYBVi7oUWjdYWmqFepS80LAFQdqtcA
         s5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQpMJpPq/OIJ1A+jReESOD3pvkOjXmQh8KJADyXTrz8=;
        b=0RCNkV8xvvPoOMIm7nGWKjONwuNmYwKKy8L8V0DXRo1SNIhdkeo9d8H1Lm2bm+P4z+
         T2dC257CxCogOU3lUSptCsiSBB4oGS4a5oyMVqEH2fcGcu36utAk3xT/FJqrBt/Zg617
         d/7NMZC+5X4aKUzkLHUeN1dS19ZiG+NyoLVs6v7WDRHyFWU0Pa5ZRLnQSj30l9EvU3WO
         pXHorPEfe49NoX9ltNkIwyHKxIEacLiZRfq+1kwA7YRBSeEjy/8qqbRAL3e9V6Xkde4F
         hq48HnaWk1T8vZZLACzlG4C36Uue3moBNtwLBvJdIbNlAy0UNK+T8wArkO1hB0aThc3J
         X0aA==
X-Gm-Message-State: AOAM531vm8VOpcTL1yw/AVbbW53AhqO3SEVIjaVgCSXzehEMxmxAxI/t
	6994BjRO3Re96eSS1OMHk0HnpFBgK0BHkRE73trmsQ==
X-Google-Smtp-Source: ABdhPJwXdBqxRTwwq0bi38HdemI3/UrUSQvkef2geUCQrgUs13GwLl6CkzHERiNWivJH+HCOX6YcKKMcXBwB2wDg59I=
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id
 i11-20020a1709026acb00b0014276c3d35fmr13991510plt.89.1637725682824; Tue, 23
 Nov 2021 19:48:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-28-hch@lst.de>
In-Reply-To: <20211109083309.584081-28-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 19:47:52 -0800
Message-ID: <CAPcyv4jrUAJ28J6Q75jmfQRz2nj4a3v6bZVjFpROd98efuafsQ@mail.gmail.com>
Subject: Re: [PATCH 27/29] dax: fix up some of the block device related ifdefs
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The DAX device <-> block device association is only enabled if
> CONFIG_BLOCK is enabled.  Update dax.h to account for that and use
> the right conditions for the fs_put_dax stub as well.

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
