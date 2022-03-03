Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3B07E
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 14:48:47 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id y11so6401993eda.12
        for <nvdimm@lists.linux.dev>; Thu, 03 Mar 2022 06:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IQjVRiRy4c9jIh4S1Ufiz+FcO3tGme0RXIPV+Ov5R88=;
        b=EQdJDzX7NFx14kL8xqT702212BvVbZJpWWokIRXjVnhTyHeCrnBE7B7lEoL18+gEYD
         M3mKOO09/tmQqUxX1EMtZnHer479xBWbYHxTaVQZ3YR9mbWzrww9FU4hSuR075gGA6s0
         v4xlntKVirqILvLUr8XdVcN9YdebJlUHHXHvEbqhEL3USNWbjom6Z4PXfkTriUB4CIgi
         FTijWrdp7q4Ljkk1KYnRzy9RnUhzMS95JuKsTvmDZx20R+Pil74ShK02YTKeEzEoBiY7
         i0DMRV5pNvJYJszjmeh1of5k7oLEElNbxeqldYS8jjZcFR8zHpWaAfLTlSr+yKfxUF4E
         EIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IQjVRiRy4c9jIh4S1Ufiz+FcO3tGme0RXIPV+Ov5R88=;
        b=AZsExokzF/wM7tSw6ZtSWn9hFtAzgySUONXDYOmEPdjjgOJEL5W7tl2L2uMtlTFKnB
         Y6l6CLd9uF6Cl+Y60EnKDT1M+8oy3dOmAHv2806Q237YDjzeKMycsETeMIwa9LIyWK8h
         HOME0VCssDONy+Kz4UBC9esbGNmMxuJC0Ult57m8D3p9T7JvqtSvnZT62oAqWGKTNZM5
         I1N/ZqAb08KD6waWSDKQ/fvDQbrMbic36TZH0+8Eu6iqUE6ib1suDhoOxfTlaXwZdrib
         cLuMSTcMh8dnK9vUrufAXc6xkKWHXb746TTTgoOhjycQ3CErbi5cC3+CYcTvKLZJ8qvH
         XbuQ==
X-Gm-Message-State: AOAM5308UXzBwfp1lJToRXcOjIb67XjFlN49bVTsVnC+Z/OhFH52cjrm
	/SNsXszBzcqjOgjZqtcfKl9DyzbDvrMOw/DVpqk=
X-Google-Smtp-Source: ABdhPJxC3/F/nITnZ/dqhO7GQgKGUK3h0VPxhHt7adLIhtss+vOHVIU3L0u1AGN7d9ozXDr2PI4BaDWp2YreGH6K+2o=
X-Received: by 2002:a05:6402:492:b0:404:c4bf:8b7e with SMTP id
 k18-20020a056402049200b00404c4bf8b7emr34256179edv.318.1646318926214; Thu, 03
 Mar 2022 06:48:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220303111905.321089-1-hch@lst.de> <20220303111905.321089-2-hch@lst.de>
In-Reply-To: <20220303111905.321089-2-hch@lst.de>
From: Max Filippov <jcmvbkbc@gmail.com>
Date: Thu, 3 Mar 2022 06:48:34 -0800
Message-ID: <CAMo8BfKgtEVU2qpu3BQqQB7cxtPzF-Hmuifr4xEhe0TRiyJ=WQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] iss-simdisk: use bvec_kmap_local in simdisk_submit_bio
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>, 
	Justin Sanders <justin@coraid.com>, Philipp Reisner <philipp.reisner@linbit.com>, 
	Lars Ellenberg <lars.ellenberg@linbit.com>, Denis Efremov <efremov@linux.com>, 
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, 
	"open list:TENSILICA XTENSA PORT (xtensa)" <linux-xtensa@linux-xtensa.org>, linux-block@vger.kernel.org, 
	drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 3, 2022 at 3:19 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  arch/xtensa/platforms/iss/simdisk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
