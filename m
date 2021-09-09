Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DBB3FEE
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 21:05:35 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id k24so3117463pgh.8
        for <nvdimm@lists.linux.dev>; Thu, 09 Sep 2021 14:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r9nTFihajPT2Iqk8ZopYtdl8lBrpPnI8ljufyAKr/Pg=;
        b=WJP/qryO/ykQpdkF715lk6SUgRWDnPXqdE5cUrfLrpAiOTFlGFe6o7ivyT5hFmgFqr
         jj+cwVygT00VOkUeLdWCbOxfWgz5YybNumnmU6QD1/bMF5UQJgvFiQ2RCfqU2ssunav5
         drD6mxR3/cVRmAeq1PPY9ivp9Yym/KJGyzDeLk+ZJi5x0aZ+8xDOBiZwcqWpyE2T9DUU
         GhmNfXuZNsbBSzXVH7HSA7mfbHQnD65db9yGDMv3plNfEzi2YtHFZKmhkY2l28dRkVJW
         q3JlI+pF6M1FjvHyfuDHcryYlotp0+3bU1cWxp2QdvMKOoV8VXz+Ae34+VKbb9+S9TY8
         JtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r9nTFihajPT2Iqk8ZopYtdl8lBrpPnI8ljufyAKr/Pg=;
        b=n3hyk8OxIG9lJV0J3v+C2mLOQuUDhFTt42PFNOJ2qfCzRuOeynoJ1YSEXzGezZvyRO
         hGwcmGMOP/4MaYTcWO/lzSafRXz1PHB0CJWiPxC7mmHHVS1d//eKtrS1bWN+Ccepfz7c
         XT54MIcY6AE1PANC58Od9RTo+M1SJ9jbGuZmWWv2kEyhEgz0D/xqalnIp6p91L+fFvvN
         1lnaXZ4IiAfmV7I8WNVbL/82p9eXBfNWAZBikTXydjc53zQeEkAikXtltjToE1ua7/OD
         h5rvu/ADDRJ1Q78TjAthC0DfeEcN6OaUP9RCP7sYjEfHs/yc1j8UkE/2lTzCeNB7xp3K
         YVpg==
X-Gm-Message-State: AOAM532dD8FsYvaROfdfmcUsfdJq8Rdl+n9E1mmHlwuDnYL8erKT145N
	GaO9Mr7tf6pWRltt4r48uEox0L0eW8GS/c/8Uw8HVQ==
X-Google-Smtp-Source: ABdhPJy5t00AiPBsUbAmSCDIvNoWFWeQLItHqldUuEFfYjgZjINCpyLTrOzu9xzyoVljKWz6lbDFpTMxpZh770ctrdQ=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr4778204pfb.3.1631221535444; Thu, 09
 Sep 2021 14:05:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116435233.2460985.16197340449713287180.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210909164125.ttvptq6eiiirvnnp@intel.com> <CAPcyv4hH7=cbnpz9dcKFEByqZkVxJVXpuks4g_63VguisDdPPw@mail.gmail.com>
 <20210909203528.frq547zd26efumpz@intel.com>
In-Reply-To: <20210909203528.frq547zd26efumpz@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Sep 2021 14:05:24 -0700
Message-ID: <CAPcyv4j+2nPomZg4=PeCbJnFAw7Jj3jR+U=sgb8UmrEHQ10ycQ@mail.gmail.com>
Subject: Re: [PATCH v4 11/21] cxl/mbox: Move mailbox and other non-PCI
 specific infrastructure to the core
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 9, 2021 at 1:35 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-09-09 11:50:01, Dan Williams wrote:
> > On Thu, Sep 9, 2021 at 9:41 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > On 21-09-08 22:12:32, Dan Williams wrote:
> > > > Now that the internals of mailbox operations are abstracted from the PCI
> > > > specifics a bulk of infrastructure can move to the core.
> > > >
> > > > The CXL_PMEM driver intends to proxy LIBNVDIMM UAPI and driver requests
> > > > to the equivalent functionality provided by the CXL hardware mailbox
> > > > interface. In support of that intent move the mailbox implementation to
> > > > a shared location for the CXL_PCI driver native IOCTL path and CXL_PMEM
> > > > nvdimm command proxy path to share.
> > > >
> > > > A unit test framework seeks to implement a unit test backend transport
> > > > for mailbox commands to communicate mocked up payloads. It can reuse all
> > > > of the mailbox infrastructure minus the PCI specifics, so that also gets
> > > > moved to the core.
> > > >
> > > > Finally with the mailbox infrastructure and ioctl handling being
> > > > transport generic there is no longer any need to pass file
> > > > file_operations to devm_cxl_add_memdev(). That allows all the ioctl
> > > > boilerplate to move into the core for unit test reuse.
> > > >
> > > > No functional change intended, just code movement.
> > >
> > > At some point, I think some of the comments and kernel docs need updating since
> > > the target is no longer exclusively memory devices. Perhaps you do this in later
> > > patches....
> >
> > I would wait to rework comments when/if it becomes clear that a
> > non-memory-device driver wants to reuse the mailbox core. I do not see
> > any indications that the comments are currently broken, do you?
>
> I didn't see anything which is incorrect, no. But to would be non-memory-driver
> writers, they could be scared off by such comments... I don't mean that it
> should hold this patch up btw.

Ok, we can cross that bridge when it comes to it. I don't expect
someone to reinvent mailbox command infrastructure especially when the
the changelog for the commit creating drivers/cxl/core/mbox.c
specifically mentions disconnecting the mailbox core from the cxl_pci
driver.

>
> >
> > [..]
> > > > diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> > > > index 036a3c8106b4..c85b7fbad02d 100644
> > > > --- a/drivers/cxl/core/core.h
> > > > +++ b/drivers/cxl/core/core.h
> > > > @@ -14,7 +14,15 @@ static inline void unregister_cxl_dev(void *dev)
> > > >       device_unregister(dev);
> > > >  }
> > > >
> > > > +struct cxl_send_command;
> > > > +struct cxl_mem_query_commands;
> > > > +int cxl_query_cmd(struct cxl_memdev *cxlmd,
> > > > +               struct cxl_mem_query_commands __user *q);
> > > > +int cxl_send_cmd(struct cxl_memdev *cxlmd, struct cxl_send_command __user *s);
> > > > +
> > > >  int cxl_memdev_init(void);
> > > >  void cxl_memdev_exit(void);
> > > > +void cxl_mbox_init(void);
> > > > +void cxl_mbox_exit(void);
> > >
> > > cxl_mbox_fini()?
> >
> > The idiomatic kernel module shutdown function is suffixed _exit().
> >
> > [..]
>
> Got it, I argue that these aren't kernel module init/exit functions though. I
> will leave it at that.

I would expect a _fini() function to destruct a single object, not a
void _exit() that is tearing down global static infrastructure related
to a compilation unit.
