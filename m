Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A874C2F26
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 19:07:03 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d187so14612102pfa.10
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 11:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+WVqg4iM1IK5woHe616yKoTPDV85yaqed+lmC/0zx4Q=;
        b=E8Yv+tJ27QtdnqCiahy1ynDTxSrIHFQS9v3T6SGxOtbvrS4oJdOaAbBOu5WkKuOBfd
         YZVQDjXpyCcHf5TePEiE9WLubJVn7pkXJNntqfcUu0FB+cpVUKi2U/fVQ/r2P4FuKOGP
         rrsKex566q7w8weRBoU0ZAbtyAsexA2NArqSSGJ8aSE3asKbO/kySJdCGSVU84OEGUiB
         QCLOFQgtfcBKBXnXRpXprEE7iAtFckobPiWULixyKadweXpHSIl4fOM/cfTnhyD31lEn
         X5EcS76XqYpJKN3mK9thEa6gK63RHYW8pEdrhtUg2qPw6l/cPnln0K7VaxQOTiViReVV
         h7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+WVqg4iM1IK5woHe616yKoTPDV85yaqed+lmC/0zx4Q=;
        b=UVsCAPJRRogWFFW8fCVtwiKcgaBrOJnVNFKK4g+X2t2/ERUjoDoZqRw+VgMF0SNB5C
         KviefnSGQZuJgyulYsk77Xx54O5SwCfnzmqlZ1ethLvNQL0qXHCZeUcl8X1Ftc/5D4QI
         pvFWUJOsHlXGoZhdcvxc1fiEz/0A4NMhEffY5x/4oOOfm9OrHcCbFGGI/1aaZ1h2XNzm
         D5MtK7nEoef9JeCcGEuCXixOG6I9oNnRq8mj9Xv9s9or9fJWt6OGOp6jaG9P1SyJh4wy
         65H/EENYzaNhjDnioiU7KkYitA5B3f8tUd4FP713UTV9pETrlDce/AS3NzHM5DLMMSZ5
         BLhQ==
X-Gm-Message-State: AOAM530Y0Eriz85lO6wvjPKM8nCJak6roFYWyhZI2i6WgT8bOUo9bfZj
	oHmTm6bOx1l1tIP47+OoN59rKANkgFUJXzM64AfdUA==
X-Google-Smtp-Source: ABdhPJx4gFwHpx6eXlK2M23aHGpthiH4fAIYOpnEcI58LRfZznkCnIjyKeDQJsC3Q3CmCC8lC+fdRuCFIdo+hfnPs1A=
X-Received: by 2002:a62:784b:: with SMTP id t72mr939106pfc.86.1644260822995;
 Mon, 07 Feb 2022 11:07:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-5-hch@lst.de>
In-Reply-To: <20220207063249.1833066-5-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Feb 2022 11:06:52 -0800
Message-ID: <CAPcyv4ipZUeCjf5teFQuJX5DEs7ViGHW_PKKfoJEK8chjJTZig@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm: move free_devmap_managed_page to memremap.c
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
> free_devmap_managed_page has nothing to do with the code in swap.c,
> move it to live with the rest of the code for devmap handling.
>

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
