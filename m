Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390E02C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 14:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641480159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ziI0c5zpDrfARzHWSXczYyQXV4rhV2uF5H/yu3MCuIA=;
	b=hzjCB8vgmtRRoJgUfU+7Tqssh59RVeI0eWmS+3a235FiajsGSLfkkjpWwp66nYDVgZKDHu
	0yztWn5AnhP0IX+hXURGGUimEoM8kpTf1fXD44UzYUNcbaFzDdLHqtYvs0e9pQmkpTQptt
	sHvQUJudodyszxvXBV1+OGJoz3TnMns=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-iTa3SYG6PTWY15j9dIwOBA-1; Thu, 06 Jan 2022 09:42:38 -0500
X-MC-Unique: iTa3SYG6PTWY15j9dIwOBA-1
Received: by mail-qt1-f199.google.com with SMTP id s6-20020a05622a018600b002b2d93b9c73so2096906qtw.9
        for <nvdimm@lists.linux.dev>; Thu, 06 Jan 2022 06:42:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ziI0c5zpDrfARzHWSXczYyQXV4rhV2uF5H/yu3MCuIA=;
        b=MUNYjt3ze8CVDrhNE02E6Kmqw6XPiEg/Wczt2qZPmP/RIVFyga0047kIZoDtT6QqtR
         aqOSA9HLXUKIjOtbTEohIhKAK+x6Tx5xE6ltwPPObzcfO5kfoHmNFT1iTEH4OEV3eoEk
         FXnuIUJbDxxc+xQ6h1I+yI08v8o/bMNGQC1tEZc18Jke4jeoPaJJBzNiJTMScHW5+SOq
         O2XjYgKF87Clcdl/rV0t1ZRWkuBBTxufRYGpGyFOwQKvRdftMlS8VfszbJ+NkJRD0SOv
         Tb8P0n5xF1oTRO+ks1hnr2c7PTViL8ESXXoh4fKXzL0+UUtDco7mDEcwWtUaI+Cwbvwn
         WwHQ==
X-Gm-Message-State: AOAM533nO7TvHTPxEVgadON4FGby8eXdVSRvxWQl5HiaJ+MXlnX+cIjD
	BZHqOEGUwq8nNQ9hZfGXrWmOxia1qny8afOJOZqFlC759x8YVfaKON/e4V6oOG106ACOuiH2f9Y
	eD7wryverk9tV/m0=
X-Received: by 2002:a05:620a:bcc:: with SMTP id s12mr40958054qki.440.1641480157670;
        Thu, 06 Jan 2022 06:42:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3FRhHacqx3hvXCbD5dR5jpsBPvBE8m7URZnWLXDzc/nf2wfv2oNDbZeyhxFZfEJhygNyDig==
X-Received: by 2002:a05:620a:bcc:: with SMTP id s12mr40958035qki.440.1641480157454;
        Thu, 06 Jan 2022 06:42:37 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id t3sm2038461qtc.7.2022.01.06.06.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 06:42:37 -0800 (PST)
Date: Thu, 6 Jan 2022 09:42:36 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Matthew Wilcox <willy@infradead.org>, dm-devel@redhat.com,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/4] dax: remove the copy_from_iter and copy_to_iter
 methods
Message-ID: <Ydb/3P+8nvjCjYfO@redhat.com>
References: <20211215084508.435401-1-hch@lst.de>
 <20211215084508.435401-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20211215084508.435401-5-hch@lst.de>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=snitzer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 15 2021 at  3:45P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> These methods indirect the actual DAX read/write path.  In the end pmem
> uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> while device mapper picks redirects to the underlying device.
> 
> Add set_dax_nocache() and set_dax_nomc() APIs to control which copy
> routines are used to remove indirect call from the read/write fast path
> as well as a lot of boilerplate code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Vivek Goyal <vgoyal@redhat.com> [virtiofs]

Late to the game here, but quite a lot of dax DM code removed, thanks!

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

