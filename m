Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527873FCB
	for <nvdimm@lists.linux.dev>; Wed, 22 Sep 2021 17:55:12 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id k23-20020a17090a591700b001976d2db364so2942849pji.2
        for <nvdimm@lists.linux.dev>; Wed, 22 Sep 2021 10:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N8+jps3A14GynJSmzw6LICUadjrSD3zVUsUJsLV0rZk=;
        b=WEcDd3eyNLlpTBr5G2w6/U3ACRbzvqkURm/T54pVZ+ceKtWFyz/x6J/QBF0iuPstI0
         1j3TF0GlIoCp7/8Gtpg5SUC2Z8lXRey+3ZSd0qP+bgpH4hvRdZ1eOTYTnDA2kLhJV2cm
         GRk3lliL6TVYocTBnXxg+aM88nDKCNWeLAk17R3QoD1Ex6ff43CPVBz9J/umHz4iRr4t
         ujejwc7J+kLTEOfVRs4pdFl7ZL08fpR1kKMcT8dcabFhV/KeLTqixR4pnnJYCkPilrWu
         wqd+UZ0QdBW29D/8b95V/HVgg8egLQHf//AegMC/8d1bHR0TitPJsMVNEegYPonB3lP1
         +6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8+jps3A14GynJSmzw6LICUadjrSD3zVUsUJsLV0rZk=;
        b=I3A7hpNIHD8Rbl/huFqC2QpOzWh/3Mqc/oJd2jpxZ2+RDaYCULhXAI7sfBe91ZewcX
         1JfiXyiqRptRGTjd5QxaVuhhXNPNRJ3knioyrJqQykf9gYiHEbgFE3zfMOO9HhV0g9zG
         tyvyuhi7H03nc7biTCo2glxPDBgItA+XlOwArg4TPleN4kAK5xKzZOmqf6l4wLGZ2GUL
         fIo/nzd4GcK+R3CQ6DO3SHy7FExmR9OCi5hGjPW4KoUmvFaynzpUQ+J43O2EjbfZ/mGl
         vmAxwCCzdrDP56OTLDMJUF984xw1pqPNmAUORpN2ug+kqi0qJZORWai1hwdUV2jUh376
         xxWA==
X-Gm-Message-State: AOAM532YDdZQwPt0ITHL/atpzR2Z63bce402PGE8O1qEMsqXc8UdOpzR
	saiOUDbFPhFkeG2FAUBlZA+x8ePLd5aupRJq76a2sA==
X-Google-Smtp-Source: ABdhPJxDpETDisB1tJJJ3uVbr3cMcT+3v7yQjIsumtaYD7TRgjGOZKPn8Hi8Ai2wCoWFgFR5Pq9dPHOWjA1n+IRsAWM=
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr307453pjb.93.1632333311632;
 Wed, 22 Sep 2021 10:55:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210922173431.2454024-1-hch@lst.de>
In-Reply-To: <20210922173431.2454024-1-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 22 Sep 2021 10:55:01 -0700
Message-ID: <CAPcyv4jpTyzofDyUPi7ADbGcV+cJHSohctwxu5yDNTF34KWeOg@mail.gmail.com>
Subject: Re: dax_supported() related cleanups v2
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 22, 2021 at 10:37 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> this series first clarifies how to use fsdax in the Kconfig help a bit,
> and then untangles the code path that checks if fsdax is supported.
>
> Changes since v1:
>  - improve the FS_DAX Kconfig help text further
>  - write a proper commit log for a patch missing it
>

This looks like your send script picked up the wrong cover letter?

> Diffstat
>  drivers/dax/super.c   |  191 +++++++++++++++++++-------------------------------
>  drivers/md/dm-table.c |    9 --
>  drivers/md/dm.c       |    2
>  fs/Kconfig            |   21 ++++-
>  fs/ext2/super.c       |    3
>  fs/ext4/super.c       |    3
>  fs/xfs/xfs_super.c    |   16 +++-
>  include/linux/dax.h   |   41 +---------
>  8 files changed, 117 insertions(+), 169 deletions(-)
