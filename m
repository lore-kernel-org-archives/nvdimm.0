Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0117A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 05:03:18 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id g19so4132855pfc.9
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 21:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XdUthPD7bGCIRJZKP+8Puk835WZG8F4AIVu+APsltrY=;
        b=SKHyNhwcEjX2tukqsuJN2TnimK7XEQvX7Q51oYiRU0Ty9pbBuLOnL0B0N8QwI2pZCN
         nrZnhlisnP9Co6ZwELmv+HO2ibT7W3czzuL+U/dW66VH+7KKZn9+xDWH0wOtv3h3ZFIZ
         MVBNIWZRRwohrq2PKOXh3uNB/cpcdziS4Jhq0QkLt0dROf0jBYfPZRFiuK/CX5d1gxDA
         eFcbubed8IV7fGfx7xLnfYiK63kpx1KivTgA0quzYP/HpPZC4NggsPFHUSYKWc6bbSeu
         /waJW2ppM/k+0+jx1Tf2PYxV6Z7z/clJ00kE6bQSssJiCua3YXpy0TXQgYHxiOGA+Lby
         gdiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XdUthPD7bGCIRJZKP+8Puk835WZG8F4AIVu+APsltrY=;
        b=K9Y7uvEj/pIRnnCWjBKpW9N99by1Pgufj/X7GnyUp6HLVrvSehmgB5RRWBQDbk/oIE
         HiCLk7rwX6zGNZF+YlQ0iy31ISYhSc+WrqsJ0/7lyuPVG6eKFxvkIjP+yrdfUB3b7aY9
         sqwjDzBcUu5qZY2Qcng0RU5rYUbfaCRbPpBYI4w+iz3CTQGJzXonezAlNJhAEqq37sMP
         FYiCGNUxENAKv/fwex7CtQyALy2kAxFPkWfRvPhrn3rdYBKVLuMIKm+mns9LorG+vVot
         ov54khOfHcWUdQ+6HhksZGIw/KjWayjmEBC7gIwGCiUQAhM+YsqXg/eiNAUAmRE5LbCL
         m4Ew==
X-Gm-Message-State: AOAM532VNhVbaGiaJmYlqYKSi0U9uU+BDPDgSUOiP8MvVEuF8xLU5m71
	5rX4s5RUkZzek6mwSdH1XVyCAHXJylYI1fC0pwSF7w==
X-Google-Smtp-Source: ABdhPJwdWnuTbalQWFuR+/JS2REBkQZ3MSK8Jn9rpx7iwKs3V0GYNIimf4MzwFgvlkY6qs+pVGtGNwW16T8gqIkEcrY=
X-Received: by 2002:a63:2c4c:0:b0:37c:4690:d4f1 with SMTP id
 s73-20020a632c4c000000b0037c4690d4f1mr2675350pgs.40.1646888598320; Wed, 09
 Mar 2022 21:03:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220304204655.3489216-1-ira.weiny@intel.com>
In-Reply-To: <20220304204655.3489216-1-ira.weiny@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 21:03:07 -0800
Message-ID: <CAPcyv4g9rz5qm=JVTsbu=nzsehka7nAVLCK7j3p4NzYRVEBiOg@mail.gmail.com>
Subject: Re: [PATCH] fs/dax: Fix missing kdoc for dax_device
To: "Weiny, Ira" <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 4, 2022 at 12:47 PM <ira.weiny@intel.com> wrote:
>
> From: Ira Weiny <ira.weiny@intel.com>
>
> struct dax_device has a member named ops which was undocumented.
>
> Add the kdoc.
>

Applied, but I fixed up the subject prefix to just "dax:" since this
is shared between the fs-dax and device-dax.
