Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F468
	for <nvdimm@lists.linux.dev>; Mon,  1 Nov 2021 16:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635783689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E9idZ9g7Qiy202IHm24WOcqzjkMEWV4Amwu/3bidfKY=;
	b=Jb2ieF+UJCAXaI4awu80SUFZWF1CkD+S/ZJK/qbpHthY8oUap767smt5XzxZrVboica49v
	Gc/NLA+cN/NPFJyzzwDixs9cL1vW5tpevJ1qXmdcl2xVTclP6wi6hIsKzEOnYopmlUHAik
	6/rk9NCN9qyolMzY00bExSCWPb1mljU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-zQgG6L0cPpy5-FmDIwf7GA-1; Mon, 01 Nov 2021 12:21:28 -0400
X-MC-Unique: zQgG6L0cPpy5-FmDIwf7GA-1
Received: by mail-qt1-f200.google.com with SMTP id z17-20020a05622a029100b002a824f0a71bso12383889qtw.17
        for <nvdimm@lists.linux.dev>; Mon, 01 Nov 2021 09:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E9idZ9g7Qiy202IHm24WOcqzjkMEWV4Amwu/3bidfKY=;
        b=o08QTO3Pak/b5U5ujzptRsNuX5RfvZpkqPGE50AfhBHhpjIqeHgAFBh/rTo8+Ec46e
         bzE7NDMBfpickDMXe/A+4XLf8N3wfF8UDYZTfRZEloIyaF27JA+mvDpLjWA6yItJ0DJc
         aDYJnBoJGStUDI+VaaL2b4D7MNsZYubgVVkOsG2lxlYZDDBqXr72RlnKFjWcVvN7AgmG
         2++GvlrOTaUlxWQ+9V83pzbA6VbvNhIxkfj0Fcue1TWP8nwU2I56DAU1FbAl/hBVfEat
         TBGvXtfO8ragMPPKwFRQAqCia98FFKpR1/coMM9DNHh01XPxXyNKd3wRNioty8YdFgxi
         kKNQ==
X-Gm-Message-State: AOAM5331lhYOz7i2Q2R2+XsNP0dkBTwuImqKnDAGHYwe12wavi4lCTjs
	nLGPY8hZVjFWjnUdlyPXBz6Oh4pzhcAt1WvvcoCVAuuyUQtxU+efbc6jjjbSHZbNpBrfNHqzki4
	I8CKGQMyfVL61eMc=
X-Received: by 2002:ac8:7d04:: with SMTP id g4mr30472033qtb.183.1635783688230;
        Mon, 01 Nov 2021 09:21:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXhGf8N2V91WU2Co6WJDyYs4GGgkn9JXnS/oEwWuG4J0RZNo7zMUQJUBh2KgjI9ZclpX5QJg==
X-Received: by 2002:ac8:7d04:: with SMTP id g4mr30472009qtb.183.1635783688071;
        Mon, 01 Nov 2021 09:21:28 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id bj3sm2670847qkb.75.2021.11.01.09.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:21:27 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:21:26 -0400
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
Subject: Re: [PATCH 10/11] dm-stripe: add a stripe_dax_pgoff helper
Message-ID: <YYAUBkiPlRCVPnyv@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-11-hch@lst.de>
 <CAPcyv4iLbbqyAsy1yjFXT48D3Ssp+jy4EMJt+Sj_o2W-WMgK9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iLbbqyAsy1yjFXT48D3Ssp+jy4EMJt+Sj_o2W-WMgK9w@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=snitzer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 27 2021 at  9:41P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a helper to perform the entire remapping for DAX accesses.  This
> > helper open codes bdev_dax_pgoff given that the alignment checks have
> > already been done by the submitting file system and don't need to be
> > repeated.
> 
> Again, looks good. Kind of embarrassing when the open-coded version is
> less LOC than using the helper.
> 
> Mike, ack?

Acked-by: Mike Snitzer <snitzer@redhat.com>

