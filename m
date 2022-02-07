Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4CF2C9C
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 23:42:51 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d187so15748840pfa.10
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 15:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xL7zYBxlDA9OyfIUt1+hVo3jnzbaDpzhjP+X9npLjjg=;
        b=wphYccQt9nxerxeU/p5xPEp3OdfAMZRtra+QtigCBGV2rEpNVW9+U6vtvsejhTgn8e
         AjHdHHleGcguuyudfB/EYL8nXm+kpV8ZcSykDngC+byWUyRxqjSZ/RPjTH8AXc+RnLns
         uIgVupROuzl/7/rcKGowF45+b0zBguco1bdtkEO3QuTU6AEph9xDvvOseyxx2hOke+gU
         uNJF3+A19rkf9glt328qDrxjnlD9a+5MH5956bLQ7wt6C83PtpfdJpKPQIdDraMVj14L
         rYSrK3ggYTWNdNsRn2y7f5gnAE9dOOC2PJVNruXRQWVHXWccOP1/uFHHzbWsGMDwZaME
         cPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xL7zYBxlDA9OyfIUt1+hVo3jnzbaDpzhjP+X9npLjjg=;
        b=KThX7Iiujfv/RqQT113TQZZIRDskq1ZsfZwybbO5NPr4yXbjzCYUUB5rLPh5htZuIv
         FFxeiTfo0eVVsKt0dV0d13vV3cJv1cXXfBfj2xzjiJYZ1v5LipL19nA72H2wyi3WpAxp
         dkGLdjUV9mwRTN0UqPWzc25Dy4vLLRsavJ87lCsFFNC3j7b+asyDMHEPdbFkn0YiApoU
         Qg0Cev4ZksGEL8AeCsgknynaHZRrMPVBL+iyBfefuJmChevmIMeoSYyhpMzARYg2yxhK
         JzgtcSIeUMCVXfv9YYS8ye9NYK8J45U/a4jY/NNUd3w/ZEmUGws9FHKVVYTsnJ7T82un
         j27A==
X-Gm-Message-State: AOAM533AlGnqX4OvfbVhhDj+buaQg89oygiZMeptML2X+ISHR94WPNDp
	rSOqrJTSgfhhTlAX3boiKEXsvBD3fwWDvsXGHXbNrA==
X-Google-Smtp-Source: ABdhPJwrqWzltx/fzSQ9DuX2BTfk2qmQ+rOek9DuscJqYjd5cc23devekMbaCYKV7qKyZJb3bcu/cjHgnw2J/KhyG60=
X-Received: by 2002:a65:484b:: with SMTP id i11mr1385516pgs.40.1644277370737;
 Mon, 07 Feb 2022 15:42:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-6-hch@lst.de>
In-Reply-To: <20220207063249.1833066-6-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Feb 2022 15:42:39 -0800
Message-ID: <CAPcyv4iP=+jtVgdnuZjR3b-jM27zH5uk167HM=wz+=PBfvA49Q@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm: simplify freeing of devmap managed pages
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
> Make put_devmap_managed_page return if it took charge of the page
> or not and remove the separate page_is_devmap_managed helper.

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
