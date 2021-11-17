Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C1F2C82
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 17:23:57 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id v19so2761013plo.7
        for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 09:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B1Ni0fagjZGByTTcZKwa1vZXhbm3ZKX3g7qTKHJy/9Y=;
        b=ugoMYNkhm/G9Ix/5oCvQZm0YAcysEe7w+8Ut7tdQ1MFfrFb++jT//Ye1Xif9z6ocKL
         upYEOlPYxRg426dSTkVWYqWTkYaINK0U1vjW0pz5KiVAdk24VzI9knnC+oq6VqBtR51R
         JsxZQwr6hfjAqg3NR5DXPnxzqFiDdVPzmokHwBWYbFcA7C4C1b/5vK2dlQpMEeU3BunN
         ptnIlMbRnCC/lX9LzDScYnrYijxgLzkCxo7ONiPawkK0khOy+cYFezVV1WUfTrdZx19A
         ia0nC0GD3aEx0ZtVWJVu5+3TyvxHmXgSem7quozm86z+iCZ04tmZvCRneUg4q76UfdBV
         iVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B1Ni0fagjZGByTTcZKwa1vZXhbm3ZKX3g7qTKHJy/9Y=;
        b=dC+oPJwCbJpJcf1UfzbO7jm6xDg4azBW2d7Am8OYg52TOFECU4Ht+qoe2eEtXP8sfq
         UGIIYln5fmBkrT3iZbAZnUbHL+qy9kpzh0yguu9fyZjigApcxb0QdEw2lt/Defk5fpAR
         RUMrYPlKyNrAW3CGNmx622r58tfdkSXs3+Ly8bEI+EuRN3W4TzWPZQfyJWg05jUdN6F6
         ephYeM/KKN71iC4PbHtTyRqVvqb3e8f2cw+W0768zOHetpsTWqSn5IUYfwsIUpe2H44B
         uFcQz8MQOsidAAlynYVLUBOz6YNAf5TPbCvgGnqBR+Fg4ZhB41BUhx7zgHZNtjFHMnCb
         Ss1A==
X-Gm-Message-State: AOAM533swvd0nZMuflgcRoG9ZyKf2ZoFUxgU+wjPo0mkYRjEuQMRg48z
	MiUj+RsSsRqvrtlz5Hvj/vB4gH2RAAudqVAS2/beJg==
X-Google-Smtp-Source: ABdhPJxkIf4IjyDIAL/AOyg+wZo8KXg00Li3POnr9FoL4MtTk7+2uk0M9RLmtvaFQhBaLJ5ZjvKGrbUA1Og0jd55rz0=
X-Received: by 2002:a17:902:7fcd:b0:142:8ab3:ec0e with SMTP id
 t13-20020a1709027fcd00b001428ab3ec0emr56745818plb.4.1637169837229; Wed, 17
 Nov 2021 09:23:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-3-hch@lst.de>
In-Reply-To: <20211109083309.584081-3-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Nov 2021 09:23:44 -0800
Message-ID: <CAPcyv4iPOcD8OsimpSZMnbTEsGZKj-GqSY=cWC0tPvoVs6DE1Q@mail.gmail.com>
Subject: Re: [PATCH 02/29] dm: make the DAX support dependend on CONFIG_FS_DAX
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The device mapper DAX support is all hanging off a block device and thus
> can't be used with device dax.  Make it depend on CONFIG_FS_DAX instead
> of CONFIG_DAX_DRIVER.  This also means that bdev_dax_pgoff only needs to
> be built under CONFIG_FS_DAX now.
>

Applied, fixed the spelling of 'dependent' in the subject and picked
up Mike's Ack from the previous send:

https://lore.kernel.org/r/YYASBVuorCedsnRL@redhat.com

Christoph, any particular reason you did not pick up the tags from the
last posting?
