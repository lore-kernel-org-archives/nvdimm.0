Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492AE746A
	for <nvdimm@lists.linux.dev>; Mon, 30 Jan 2023 19:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2415C433D2
	for <nvdimm@lists.linux.dev>; Mon, 30 Jan 2023 19:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675107918;
	bh=52J5/EqGhJ3KiKyV/iLX4Xpcfv1lkJzb5jsBfV0Gup0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ib7QLhO+fxZOwPJNUB43bjppstdngCG6rh1dMFX67vm2xHc902j+AYYpWI5OeiscI
	 XBWDhLNM89oTYcJdVrzRg9BQaJPftYV155LeF6KKMGgQ1DTzjemBG1aWlN/ozVo81+
	 AkEn38XP8uxtQltmDvV+DbSx54i2XNNd4V/OKl6e041o1o7miISG1rkHgZ9mK1XCbu
	 iNHhpP0dwKjn2VXk4SnMrKIkKkfkf7gE6i/Mvkagwq062VCP9lHbkgIu4FjD9MwRh+
	 Uaen15pskfu7saWpQi7QEbp4NCQdMeXMah2NZ/IksjtPc8YzAlBYPpxpJl398Q6w/N
	 ol1HdFQMqd+ZQ==
Received: by mail-lf1-f45.google.com with SMTP id y25so20668298lfa.9
        for <nvdimm@lists.linux.dev>; Mon, 30 Jan 2023 11:45:17 -0800 (PST)
X-Gm-Message-State: AFqh2kpQKrRVtB+HgIsXy5546BtQ6f98NjC3AygJJvhzeifitDPx9JK0
	LqHHNRW4i4XcNwY7HqmQAENK5nXnbR/YMZ2L5Is=
X-Google-Smtp-Source: AMrXdXuJOo7Pbv6iG6Moq7Ekn6wEAfrVjI/RQUFeuIXgnRtOAymLGgvgkwj6Zk11Ct0HYyEHh/eJJ8bCCHgUjjNms4Q=
X-Received: by 2002:ac2:4c4a:0:b0:4cc:a1e3:c04b with SMTP id
 o10-20020ac24c4a000000b004cca1e3c04bmr3476130lfk.15.1675107915984; Mon, 30
 Jan 2023 11:45:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230129231053.20863-1-rdunlap@infradead.org> <20230129231053.20863-3-rdunlap@infradead.org>
In-Reply-To: <20230129231053.20863-3-rdunlap@infradead.org>
From: Song Liu <song@kernel.org>
Date: Mon, 30 Jan 2023 11:45:03 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6GgFyF8AwJeZDTdtKfvDw2gRwPyQKii7Sgx-XqvtAcrw@mail.gmail.com>
Message-ID: <CAPhsuW6GgFyF8AwJeZDTdtKfvDw2gRwPyQKii7Sgx-XqvtAcrw@mail.gmail.com>
Subject: Re: [PATCH 2/9] Documentation: driver-api: correct spelling
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, 
	Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org, linux-raid@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, Jan 29, 2023 at 3:11 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Correct spelling problems for Documentation/driver-api/ as reported
> by codespell.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: nvdimm@lists.linux.dev
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: dmaengine@vger.kernel.org
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
[...]
>  Documentation/driver-api/md/md-cluster.rst            |    2 +-
>  Documentation/driver-api/md/raid5-cache.rst           |    2 +-

For md bits:
Acked-by: Song Liu <song@kernel.org>

[...]
