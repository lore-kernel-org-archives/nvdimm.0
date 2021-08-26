Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9664E3FCB
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1629994794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7/3gAXjsOYCjvInZsh1tv7Gv6tJXcvyBWH3X0vwJBWc=;
	b=Zueo4q4yEvBIJA4qWhu6z4/96YHvSKdIKEk8fpHvvUrZR/UVPm5MyKPjvsGT4GjvzQ/Ots
	glGB758ud99myr+Njk5fcHJzErdME0T4xBoKgBLcWeqU4D7Ox6aqmq+iKjUhlu33sY69t1
	wketC1lTFuNPzHuMczwa8BFiprU9A8U=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-aOPAe0JUMbmAvaSmu58xQA-1; Thu, 26 Aug 2021 12:19:52 -0400
X-MC-Unique: aOPAe0JUMbmAvaSmu58xQA-1
Received: by mail-qv1-f69.google.com with SMTP id u8-20020a0cec880000b029035825559ec4so465164qvo.22
        for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 09:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7/3gAXjsOYCjvInZsh1tv7Gv6tJXcvyBWH3X0vwJBWc=;
        b=t/Tyz0Iy1xe3vmEQkMNbzQgx9Q9lcsXLaSI/U+cOXiN5tfHtESdSTkFr8zQoQz716H
         8FwiSJrfVY5WG4d3yg1qxSk24u/3dUuBUhau+FWDG0ytPKIrGA5oPgKIHhf6CRJr4Rur
         fmMTQi88NjpzJr457SnqCH2fz/KOxtmZWUgx+QNhLZ7RX2g9gUi3WSRDYlPOajRtYl7s
         qtkEsXEkQwq1Bk8xNH9UkNfVXq5rwJhYYfRBypRoay47/8y5aSeRUWEhgpxsRiAh/5P9
         J8coIiqkkVJo3bIN7/uFAqRraSDb3OyrJL0/VQX25QFMGehkP7XOdXpnZpYgVbaBgm7P
         xMVw==
X-Gm-Message-State: AOAM5338W73502MtQRmpzmuWRITKAwaUhsy0J9ASQhtyMbK+W7WwPsGh
	lQrLw6seFSZIUMvGepngGF6sne+sZCp/9M+hrINDiih06hZ/RKRzRMNNwBaN1ndLegd4wZADIIR
	LR6/Shemilw4jLVg=
X-Received: by 2002:ac8:6697:: with SMTP id d23mr4123801qtp.34.1629994791989;
        Thu, 26 Aug 2021 09:19:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJjb+DXO5M4rPM3LGWmmf30ajsbDc366at2OsGm2R0vZu/YOovqERPcrnuHp7PIFCzTyaymQ==
X-Received: by 2002:ac8:6697:: with SMTP id d23mr4123780qtp.34.1629994791782;
        Thu, 26 Aug 2021 09:19:51 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id m8sm2619535qkk.130.2021.08.26.09.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 09:19:51 -0700 (PDT)
Date: Thu, 26 Aug 2021 12:19:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/9] dm: use fs_dax_get_by_bdev instead of dax_get_by_host
Message-ID: <YSe/JtXqoiHsRGqX@redhat.com>
References: <20210826135510.6293-1-hch@lst.de>
 <20210826135510.6293-4-hch@lst.de>
 <CAPcyv4ieXdjgxE+PkcUjuL7vdcnQfXhb_1aG2YeLtX9BZWVQfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ieXdjgxE+PkcUjuL7vdcnQfXhb_1aG2YeLtX9BZWVQfQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=snitzer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 26 2021 at 10:42P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Thu, Aug 26, 2021 at 6:59 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > There is no point in trying to finding the dax device if the DAX flag is
> > not set on the queue as none of the users of the device mapper exported
> > block devices could make use of the DAX capability.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/md/dm.c | 2 +-
> 
> Mike, any objections to me taking this through a dax branch?

No.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Thanks.

