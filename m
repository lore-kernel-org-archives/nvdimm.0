Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6622768
	for <nvdimm@lists.linux.dev>; Mon,  1 Nov 2021 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635783562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C05du9bq5580dSm6IfhlDVs1xfqwhE2XhWSAZIf2yew=;
	b=ioV3bcGv85AIWOyDAkvGTS2TjAGuZiacWuWeZda+/ETDMsG5qLftSzKgmpK4q7FS2Umsnf
	OuoVbJYNu0QBQKDOLBcLohvnvmr9NWJFWEYFcXZ9DiQb5Vo6bNW/Ia5YX9AjfY0Qa//PCi
	FpPo81IXuUBBkxwQAldvhalUJRAF/xs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-Cq7RImp-MciwJOw2KEaE0A-1; Mon, 01 Nov 2021 12:19:21 -0400
X-MC-Unique: Cq7RImp-MciwJOw2KEaE0A-1
Received: by mail-qk1-f200.google.com with SMTP id s184-20020ae9dec1000000b00462de7f85b9so6633195qkf.3
        for <nvdimm@lists.linux.dev>; Mon, 01 Nov 2021 09:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C05du9bq5580dSm6IfhlDVs1xfqwhE2XhWSAZIf2yew=;
        b=btBz9JkV5Txr51C6P9QtsES8QW1NGPb2mv6jKwoTcuAYsS+2sCP5iXVw9DwBjDcCzj
         dBiUWOl48cZx/xzAaUtfsHnTzJ5ZS8xwqqnYjaRR8PjEkIuNUE40Mm78eqYBWkV8pZ5Y
         AKAfvynrXf5PNN1IX7Uv/44FYbECYdNgWcMWCKCnMArh5EXhT6d+KPGcPN9+z8fPKVCg
         znvOYP2VZ5G9//gzGKj7A8JHovNcnWdt/z6gcfTtAsc72UE2RMPSpjfEz7CBqpo7htsM
         CuJceP7gNq/txa+c2PBSYbCwXbaVP8OneJHOgutIS7fDp+LSnDj2LJEe1qg0CMEAaa2v
         d4DQ==
X-Gm-Message-State: AOAM5306YysDW6qIpLPzQAHQ+jCihZ8M8mIoV76PETIdxk/c63L1M0dV
	ujHcnlyFlNUdSGGDL2GjR1BAut1srhucq0B7jWrbfVZOFJljBaUJTt9Cura4OzK5jwg+H6Fj+t+
	9Asde2gVk2oUyVA0=
X-Received: by 2002:a0c:b341:: with SMTP id a1mr28270562qvf.21.1635783561031;
        Mon, 01 Nov 2021 09:19:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvmIEea110PcdB5LDCY7U1ej3BdqkCE7DUWVGoDnBFq+m2W3EEPnU5Ptqvnzv3GNnSJbsMew==
X-Received: by 2002:a0c:b341:: with SMTP id a1mr28270537qvf.21.1635783560844;
        Mon, 01 Nov 2021 09:19:20 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id g8sm1775746qko.27.2021.11.01.09.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:19:20 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:19:19 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Ira Weiny <ira.weiny@intel.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 09/11] dm-log-writes: add a log_writes_dax_pgoff helper
Message-ID: <YYATh6yxGehyjpcm@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-10-hch@lst.de>
 <CAPcyv4iaUPEo73+KsBdYhM72WqKqJpshL-YU_iWoujk5jNUhmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iaUPEo73+KsBdYhM72WqKqJpshL-YU_iWoujk5jNUhmA@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=snitzer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 27 2021 at  9:36P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a helper to perform the entire remapping for DAX accesses.  This
> > helper open codes bdev_dax_pgoff given that the alignment checks have
> > already been done by the submitting file system and don't need to be
> > repeated.
> 
> Looks good.
> 
> Mike, ack?
> 

Acked-by: Mike Snitzer <snitzer@redhat.com>

