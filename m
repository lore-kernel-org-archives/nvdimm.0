Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642AF2C9C
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 08:07:45 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id v186so47698030ybg.1
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 00:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PXxGXqL0fSEKZMDAAFA60E1Rbs/msz2tQymkFw5ax8o=;
        b=qlzWW2qtvfYAAanbEMYNLuRx8ZSraE6ZerXTO+z8zhvTvhhuYlpIgqjAKGiZyn03oe
         dobQls8uADFSdqKk74wWyKhvtGm+6ci7zMlOM/25PMWhbnesE0+5XQtQJ1DQ4BSmrIVR
         KXs5u2kjzPM5yfRm+Agx/SxngcjD9ixaxLZX1vw+RU3PzkOEaYN8IUkGN+VCPNNtWbRa
         OkYOtxUahGsG7+n6hO78zD3yqAbAhOS+2yz1YaW3MqVv7bTnB7WgJxSZvd7dRu/1CoqZ
         ioyre/8Cv4eirgKtPsl7phMdGqzPgirLv2toaU5HewuA29ykBKN/lcY8q2AtU/epI3VH
         FJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PXxGXqL0fSEKZMDAAFA60E1Rbs/msz2tQymkFw5ax8o=;
        b=OlsjQYk5SeLbNUGeHl2bbXjF+6Db9/0fCflLRvinvTnvkbPZBtsJ5+MY0e6TIxRFkQ
         gRto6+nyGtrgnyANuAQyMqxDnZ3Wr9Otl0krvxsGzvtYWxjToX6SttVLV2sIopg04Ik3
         sq+2p9iEeNbx0oIc1PFDki4Jqe2Xthpi28Amwte8ZQSXSGbEH99/FBzMkNynoqOPppUe
         RhF7HRrOM4eQRpFbi2s0r8HMDeS1/ghTv0MX6HjnCOJDZdslBH8C9UAF7S/z2CH+e3AS
         UjkAceOd5943xXKVWNpjHspRfEpMZv0rBilCsg20NDaqPSGgV1VnETtQG8TxqDuIfVDH
         FiDg==
X-Gm-Message-State: AOAM530OSYklK1HsDokqraPgmnHTDDT/E7L3cy3XcyflF2OoRdXRsTG2
	9pEE42tT2XNgJtcERuaoCSVn5UzZB7Vc1rWLoCQkif9nlGG9d08k
X-Google-Smtp-Source: ABdhPJxrFiobqvBhVclJNZluCx9G58Pv+JirZ6BIfPGVufYPFT03Bj1OgbKZjqvNPQBBROocQXaDN+k+XywWU2el4os=
X-Received: by 2002:a25:4742:: with SMTP id u63mr3440116yba.523.1644307664507;
 Tue, 08 Feb 2022 00:07:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-3-hch@lst.de>
In-Reply-To: <20220207063249.1833066-3-hch@lst.de>
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 8 Feb 2022 16:07:07 +0800
Message-ID: <CAMZfGtWA3M+ck8WduwxyoDiXpjC1kXs=irVZ1m-SMSREJG17Mg@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm: remove the __KERNEL__ guard from <linux/mm.h>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>, 
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Alistair Popple <apopple@nvidia.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, LKML <linux-kernel@vger.kernel.org>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, nvdimm@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 7, 2022 at 2:42 PM Christoph Hellwig <hch@lst.de> wrote:
>
> __KERNEL__ ifdefs don't make sense outside of include/uapi/.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
