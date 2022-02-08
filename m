Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E6A2F24
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 08:07:07 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id m6so47493170ybc.9
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 00:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lrJ/uUGCKgoKFH52TnhTE0iJcbWnNbC2//ZX4wls2Dw=;
        b=kNP/DVt8Qf+7bUY3UT5ZfqP8u/Zt0jSOyRJstDT02WFgtxz0uQpIo4XqdFFTnYfT/M
         F2Df9FQ1s1DpZs0sKfObwDOAAXfKQ7/T2yeAjlKR3i/reWmzZVjWKP3xdxDfOd3jfA7b
         tz5+cjBNS6/V6VXodt+MN/KM9Uxi0esuP7iu1e3jkfmQt4QdsMTpVKtJq5SLYiKaO6wV
         GdLTObr64l6FVPZjPzvdKBJR2Rjj+n9hO45a68l8DCZafC6+U2M4uJdIA6MbLvDKJRJZ
         DYHtfhyDzmb+GdSk9jY5Magnd6SN2eMgQm2n0M1xh1E5HMRa0EDjVN/rUBMFIXJjqzfO
         gYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lrJ/uUGCKgoKFH52TnhTE0iJcbWnNbC2//ZX4wls2Dw=;
        b=dRpwcT/aSkq/Ypa3NGWhmjULh+09AMQPrMZ+68+9y+Ai4IeG8JNp3JEZ2CQvBvdMPL
         dOZvaogzB6X9roHKRP24+tJJFT9SpTF2Ksum6QERUxzWWas2fphetU/8dB3E8bnJVKaO
         soiMaquevKdysVpCqyiSG7+9YCQLwIGNtJ9b3chGPh8eZuIi0XokfQR0lMxAwnyMsoc4
         aXLz85aa1lGlcmaa3VY9PYMz/XOvopxwHG3HaxkpaFFSXymgCed84qP79aAUrmsCftO8
         /HH0yr9FzexuZp18BY1HTnL3kTcwSHi4yH175gJvpuz5+6sIsQt6CDsBx4dLPuESRb9Q
         EvnA==
X-Gm-Message-State: AOAM532LUz0RcugJwH7ASmgGIGoX0Syps8uwA9qq93stzhR8WVKWjNDR
	Ly8D2T1YKsCLbgKMf29/TwPHpw9muFjW1sruQePMUQ==
X-Google-Smtp-Source: ABdhPJyc0mkGJILuXoiCncxc7dUnInOYzU71tTwuAgOjc/Gz6ioJ07N3R1Qa59huN3y/0lYz2j4xsFCGHPxb7jwVlxY=
X-Received: by 2002:a25:e406:: with SMTP id b6mr3405161ybh.703.1644307626738;
 Tue, 08 Feb 2022 00:07:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-2-hch@lst.de>
In-Reply-To: <20220207063249.1833066-2-hch@lst.de>
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 8 Feb 2022 16:06:30 +0800
Message-ID: <CAMZfGtUfqoaJ7L7rLP2Vdfy_nvr30qppRX-RfTFUh8TeO3ZznA@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: remove a pointless CONFIG_ZONE_DEVICE check in memremap_pages
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

On Mon, Feb 7, 2022 at 2:36 PM Christoph Hellwig <hch@lst.de> wrote:
>
> memremap.c is only built when CONFIG_ZONE_DEVICE is set, so remove
> the superflous extra check.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
