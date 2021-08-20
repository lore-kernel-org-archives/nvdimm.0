Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8262072
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 17:42:25 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id x4so9878597pgh.1
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 10:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t7zxR3GQPr0QInweAIaxU197r+IFtwnG1bELnryA2Nc=;
        b=y4/Hw46Tyt6CJOhTJfOE9fPJwnCmNjav/irCOd0ITLClJD4kBaZFBaPNmhLEKgYk24
         Hrn4r2Q6w0DlrkDpplN5QtQ32ovoKcPRjDTAMkD9QJK5aMAVOCpaLmPMsv8Ynxwaqj6f
         WmOlyA0WtJ5TPCJRNxPn6MHwS7eqaV2F1eDWLLCoxAaVymwJ9jxj3xYIE91Q5EUjsJzC
         jVxKWlEcmgKOf+CO4n7s8cE/7MXPCK3rCpb7xWKV1lachJIXVfNCEjHlfVbDdaL3q9XN
         gl+uy4N15WJagMIN/VjftSEo27OpebEh8C6kXfSgj2ssk2DfVYJqw/XsBBrc8MY8MFBD
         bhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t7zxR3GQPr0QInweAIaxU197r+IFtwnG1bELnryA2Nc=;
        b=UPezGW+fttNllEtMxbkd08ShKJtmfm9CzhtO462flgB+pnxxCwdvX3/79FqNYtoutT
         VHZusrNTnXOFsEApNKX0WxUTUPlf7ccfhqUAfViEtnYd+pDg8pQXe5J1HULW/7ohKsIN
         +ErRwtFxGyPmvqpRo9cwFRXAJJpHCL8o3W3OarPp7fA/tuBx032l2fbcuelYJL2YnsNy
         4cua1HyJFdlB5NYca+3xC7+j1sas/JAWsTh/DS/yP0wRLPbj9n6AfGZ7eO0KDjC+msEL
         GIeROBtujZ8ciUHDeUWm30fWJwHKMGV4gOIMLxxPQLavsonQywXe1L4aEWP2iEuaaVoi
         WcOw==
X-Gm-Message-State: AOAM530P3ZEtpj9K0a90Ja61FVswC6lQxMZR/AzMgq10EtqCLzAl0cRm
	lfG1ej4A4DVtHRrjivR0NXdmjwuQtaM3NVGfnwAbCg==
X-Google-Smtp-Source: ABdhPJy2ILzpIq5YTLy4oxmLmrYnnk2awznkg3/qDwfw/fFwC3GliRWtSeNdqupJrLFOLcKAPGKCJjUInVx1+HGlrs0=
X-Received: by 2002:a63:311:: with SMTP id 17mr19557200pgd.450.1629481344998;
 Fri, 20 Aug 2021 10:42:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210820054340.GA28560@lst.de> <CAPcyv4i5GHUXPCEu4RbD1x_=usTdK2VWqHfvHFEHijDYBg+CLw@mail.gmail.com>
In-Reply-To: <CAPcyv4i5GHUXPCEu4RbD1x_=usTdK2VWqHfvHFEHijDYBg+CLw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 10:42:14 -0700
Message-ID: <CAPcyv4jpHX4U3XisqVoaMf_qADDzKyDS1wOijCs3JR_ByrXmHA@mail.gmail.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Christoph Hellwig <hch@lst.de>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>, Joao Martins <joao.m.martins@oracle.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

[ fix Gerald's email ]

On Fri, Aug 20, 2021 at 8:41 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> [ add Gerald and Joao ]
>
> On Thu, Aug 19, 2021 at 10:44 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Hi all,
> >
> > looking at the recent ZONE_DEVICE related changes we still have a
> > horrible maze of different code paths.  I already suggested to
> > depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
> > architectures have anyway.  But the other odd special case is
> > CONFIG_FS_DAX_LIMITED which is just used for the xpram driver.  Does
> > this driver still see use?  If so can we make it behave like the
> > other DAX drivers and require a pgmap?  I think the biggest missing
> > part would be to implement ARCH_HAS_PTE_DEVMAP for s390.
> >
>
> Gerald,
>
> Might you still be looking to help dcssblk get out of FS_DAX_LIMITED
> jail [1]? I recall Martin saying that 'struct page' overhead was
> prohibitive. I don't know if Joao's 'struct page' diet patches could
> help alleviate that at all (would require the filesystem to only
> allocate blocks in large page sizes).
>
> [1]: https://lore.kernel.org/r/20180523205017.0f2bc83e@thinkpad
