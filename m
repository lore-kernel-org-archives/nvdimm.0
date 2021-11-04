Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52842C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 18:10:30 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id b13so8626674plg.2
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 11:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7mdrEIaynFJhMAYVbY2RCFSQ3xBs/5manpadoyeA8Jg=;
        b=0YEcomScst+1AzYcEtB+P3/DmeUM77501UDi4utLMr5xdKJlnd8UevBd12j9FnZ3vM
         pfReEE9Mys+ZVEwliSTF7urxA8Wo0+Hi1QGvdNyLT71G18SgBjzWHXiXc01F/GMcT30o
         4sj59niVU83geSVU+jTxOcRmF241hREk19CsoBH8kxr2RQdc6rHN1RFVCxVTxuFK53C5
         ubx4NqJpME+C1zDILd+MfHjSjbqUFn2nDpjUaVUu+wM8te1yVWJyRStj28nUJ7WDbMUk
         H2RDjE1nkFNI+5JNwfhWiSHo+ZLBnVukougjDJ/S9PImKe7sfLSLlzrr4uAIBYjBE48z
         eouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7mdrEIaynFJhMAYVbY2RCFSQ3xBs/5manpadoyeA8Jg=;
        b=35W3CdZHod4IM2fUt1+c3ho57EKwwVG2f8XQn5yLZLFfb89+2FYan+UFGsvvta43Sn
         5Z9u+aOMO/ifz2E3vYAobF6Y7DQAOxh5m/g4m3egJ7kSA/1mASikmhcMIwTbFkUslYc1
         2b/STHs6/heEmtnlLB6o9lLns8tYZjbjIXOZHJW1akSDPpHnhMZLG9i8Qgqcp0elc9Ub
         CgGYtJggLY3zCiNloNqOCAm3xR/T57mkvrVyDcoSjNzJYtOkODZv5hTUfqxaa09EZ2bq
         XGYFQB1cZOyLiZ6UTFCWiAUUVGiZMNQ/YlMTfmshXc8E9vXnN7uNwSErmt6FJDy+SWUR
         8qXg==
X-Gm-Message-State: AOAM533LJc6RaEyi5iFIetOythNv65O0+XO1VshJVSI80x/pviX2CMtd
	o/WAP6rBxi+WvzG6StwzK9WylvFid7d5+SyJjETqXA==
X-Google-Smtp-Source: ABdhPJxpE7179nYWnBAffbsem/btoh3olrocKEPy5McMuIBWtGLmZ02iwXqFLVvSNceMnE3VXVk1wLsDAvNCq2GAmrQ=
X-Received: by 2002:a17:902:b697:b0:141:c7aa:e10f with SMTP id
 c23-20020a170902b69700b00141c7aae10fmr33445935pls.18.1636049430346; Thu, 04
 Nov 2021 11:10:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
 <20211104081740.GA23111@lst.de> <20211104173417.GJ2237511@magnolia> <20211104173559.GB31740@lst.de>
In-Reply-To: <20211104173559.GB31740@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 11:10:19 -0700
Message-ID: <CAPcyv4jbjc+XtX5RX5OL3vPadsYZwoK1NG1qC5AcpySBu5tL4g@mail.gmail.com>
Subject: Re: futher decouple DAX from block devices
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, 
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 4, 2021 at 10:36 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Nov 04, 2021 at 10:34:17AM -0700, Darrick J. Wong wrote:
> > /me wonders, are block devices going away?  Will mkfs.xfs have to learn
> > how to talk to certain chardevs?  I guess jffs2 and others already do
> > that kind of thing... but I suppose I can wait for the real draft to
> > show up to ramble further. ;)
>
> Right now I've mostly been looking into the kernel side.  An no, I
> do not expect /dev/pmem* to go away as you'll still need it for a
> not DAX aware file system and/or application (such as mkfs initially).
>
> But yes, just pointing mkfs to the chardev should be doable with very
> little work.  We can point it to a regular file after all.

Note that I've avoided implementing read/write fops for dax devices
partly out of concern for not wanting to figure out shared-mmap vs
write coherence issues, but also because of a bet with Dave Hansen
that device-dax not grow features like what happened to hugetlbfs. So
it would seem mkfs would need to switch to mmap I/O, or bite the
bullet and implement read/write fops in the driver.
