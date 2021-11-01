Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B0668
	for <nvdimm@lists.linux.dev>; Mon,  1 Nov 2021 16:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635783176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+G6SzjVTR+LCyYNlG0zbcp2+gduPxDNU+2Zc+nwBRpo=;
	b=OSGCzH7a9iwXipiTHXUGo0ViW4DQj+HOpxAD9jdj6SQT3OMsIMINUJqLIoxrv37CEdPivy
	BBYalGl+Hf/j1rPWI5ToSbwXQmb4zIXtemJC726Rt+HykiFddlTIctqsfIt08KH+Wtk5NW
	nmF8FM6EQKMZHFJ7vPOmuIz1BuWLhjk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-R9DXjertOkGZ0tJ3dlkenQ-1; Mon, 01 Nov 2021 12:12:55 -0400
X-MC-Unique: R9DXjertOkGZ0tJ3dlkenQ-1
Received: by mail-qk1-f197.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so10884183qkd.0
        for <nvdimm@lists.linux.dev>; Mon, 01 Nov 2021 09:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+G6SzjVTR+LCyYNlG0zbcp2+gduPxDNU+2Zc+nwBRpo=;
        b=aN5bwzEMB/aBx0UakktVK+qOsPjd/Cs8NhxgXvcLArEBk1VZ+y683n2l6DnDkfA+Gg
         pSlf52M7XDvU6o5VJ6Z+97drMVyGtQf/Zo+8QU0ly1t0uokUmmbdGsRNlRld6X0i65rr
         qqRMPIpX8qr2ASQxchH3urWGu2AZ5d398wGsBVtbagGk0ZQSh+viafAwWZAjjkoZ5eV4
         tITcWcFabZ4EmBqy6KRtSIfK7xd6G4RKX9grtWDYp2j9oPRdq5szt+DYLBJGdyTobiiJ
         24xh5dllkDkSPs8oSRZH6SrNRCB8zmrhTBPlKJnh7VRNCE8FAD8NF0CEE2KWDoSHdblu
         tdfg==
X-Gm-Message-State: AOAM533BPrzeOBI74q+HiMusrg4018qBotwDWOuGaG9b7BVsVlR1UXZn
	2okrmv5ncaqpb4m3XAUTXhXcEnItyrsQc1omqG7gJn7tYABxsBClgf90ddocBGQS+oUf/twAhh6
	MaaS6jCIPfYVc7wk=
X-Received: by 2002:a0c:e708:: with SMTP id d8mr23264792qvn.62.1635783175419;
        Mon, 01 Nov 2021 09:12:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/H7B1fdn7PP13//AwKmpta1av9FRTtOajPRoBskVHgoJcCnXd+0D44u/s4udzcALoTqA+Rw==
X-Received: by 2002:a0c:e708:: with SMTP id d8mr23264758qvn.62.1635783175189;
        Mon, 01 Nov 2021 09:12:55 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id v16sm167031qtw.90.2021.11.01.09.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:12:54 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:12:53 -0400
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
Subject: Re: [PATCH 01/11] dm: make the DAX support dependend on CONFIG_FS_DAX
Message-ID: <YYASBVuorCedsnRL@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-2-hch@lst.de>
 <CAPcyv4hrEPizMOH-XhCqh=23EJDG=W6VwvQ1pVstfe-Jm-AsiQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hrEPizMOH-XhCqh=23EJDG=W6VwvQ1pVstfe-Jm-AsiQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=snitzer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 27 2021 at  4:53P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > The device mapper DAX support is all hanging off a block device and thus
> > can't be used with device dax.  Make it depend on CONFIG_FS_DAX instead
> > of CONFIG_DAX_DRIVER.  This also means that bdev_dax_pgoff only needs to
> > be built under CONFIG_FS_DAX now.
> 
> Looks good.
> 
> Mike, can I get an ack to take this through nvdimm.git? (you'll likely
> see me repeat this question on subsequent patches in this series).

Sorry for late reply, but I see you punted on pushing for 5.16 merge
anyway (I'm sure my lack of response didn't help, sorry about that).

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks!

