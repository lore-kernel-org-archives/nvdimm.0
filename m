Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BCC2F28
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 18:08:40 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso21327638pjv.1
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 10:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zYdhIytWWvNZPQpgxc7JanMz43mOjz+UXOqpB/Si8gY=;
        b=R93xjTEs3HgPo29762m4uqHy6DgEIiw341Wvf7q57zjQt/fMOf/vIggnLWq+UIkvE2
         ItYfM1ocg4jOoHter+LGmVVn+56WIrTresjlRqOzDpxhR2gE2Z7XKfivMQnYws3oBpcN
         Wnp4OjEX2kVSHOm5wWUaWUQHoBL2pZOajsCNpVYP+2s7M4Pt370NfYYH6tCLMb0ePa8z
         HUeyronXi33SaNNHMgqIF/E3v+pRpLWgtLiP7uZ593CHEdxKAHCZRXlItwp/sNFJZgmH
         Q6m9V+2GxeMGSIE/EyF8AlQqUfCTIeQOL4NCF8eo53fHgen+/6rfpdiFIvCtnwfrEBzm
         8haA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zYdhIytWWvNZPQpgxc7JanMz43mOjz+UXOqpB/Si8gY=;
        b=LP6Ge0s6mgunpbcO9GrhyxIndA7UmumF7PiwvWwyU3+wHcP2Gp/iuJSRwnUDQlAKbz
         YRX1ZVokNEc2R0f8+unGOazLsnM970vnUHiHkno2uNlhOv3Q6a+FcjPcDxLuPelnOK2K
         qn12QLlQ8o/RDNMqXwgw6K+JJ2f/0bMZht44H9cOGLsmUcXppHxfjH9xbRGLaQdExtur
         fKpB6aUG+JLyqNQKSssPAEJcN8TCEE6haeZP4ezWC8MYlLqkGCyaEcfWb9JJfMjNVmjN
         94fnbtsW+JUMKE9yDVdw8mmWROonstqqxJ3cYpSugT80rjIuZ24vtwwM6gVE/9HxyNHC
         EiUQ==
X-Gm-Message-State: AOAM532vzo6zG1mamGlVh3l8ylsMoz8lPT5VwGEUfNaFGW6vDCxcoCk9
	1bEvDHnsMcXWwXpCplDfN2s+3SgA4GEnJQLlCgtRPg==
X-Google-Smtp-Source: ABdhPJzkFzzjmqODkvgrvwQLNfbzdHBUvOVv75drXwoWtoHzOi4Qr8amdduzRjHB4i+xpu3YrgRs1ma/CEMYchNDNj0=
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr121877pjb.93.1644257320409;
 Mon, 07 Feb 2022 10:08:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-3-hch@lst.de>
In-Reply-To: <20220207063249.1833066-3-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Feb 2022 10:08:29 -0800
Message-ID: <CAPcyv4i3hJR9WBh6PFN9VgA0p3x4Vvgdy6T3b-3_bP_LaPK9fg@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm: remove the __KERNEL__ guard from <linux/mm.h>
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
> __KERNEL__ ifdefs don't make sense outside of include/uapi/.

Yes.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
