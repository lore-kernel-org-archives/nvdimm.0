Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0313FC2
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 15:42:03 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id t1so9558839pgv.3
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 08:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q8jZHSiFFfLy2DZDlFqcLZRFcfHsQs2eaK/uITfLozM=;
        b=gxFhBBzJw6MYFPO85nq5sl6q+X4IPCdfY+KIwfcptL3vT1Ic1lmczfKpNv9t+6QewK
         r2T354UoS+XEdkGmAhxUsU2UUxrO+eR+uOmoTVMjcJVpb4kAvTvwawGynAndCvpGr8tn
         p9ocBNhfb7tGVAiP/UnDbnPOvuWYf7ivb2ybXL4eMxRPL3+CEZobUEvQQkBw7AAWv16W
         yp2ozgyOt3nxeQxMUcDZjxCcV1A46xL86HRuujYwJHUCVHPIJ6QgasgsTl6XiLm3S1qK
         lMFf4Z+zOfL2T40sJ8y1hGqYWXbL1ZdWFCaa9WTNf4MGih+CCOuoYrkgfwmNeu4iMthf
         hXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q8jZHSiFFfLy2DZDlFqcLZRFcfHsQs2eaK/uITfLozM=;
        b=gV6I/md4VrUG73vlNQAOE0uHPw2mQZYnMu456ORlVZYF5x5y4vGWjE6HJUdP5qR2NL
         o+wPpL+05HCKWVjtpLgMc8+DHPPWVnKplIR8XucpcsnXSXUvR1Am32HyiuL1LGlO9yv5
         76RsTqC1cSdc8JOfuXn/BOoe39SP4HSk+qOLOp7QqDKX/sw8bUDep4xynNryV8RNqTlN
         KqRic0tQm+76+xQMeyxPrsMWM1P3LfHogzxBEmHTixll0fpdybLs6SEB0uiWagyMOgeC
         7nsWoLvJ8mnRiBh1hNqS4673MD2fBSGe/bTA8xc8duG5/pofQ7zDZE9ggGGebWY9XBz0
         Fk0A==
X-Gm-Message-State: AOAM533CjN02Jop6vfh81cM4zucKw7R3XaRmlPowON5+qbN/6Zq+tCVa
	c5AuvTu66XuEvwX939w0DIetZ/DGGr+t+LvrAnBkqQ==
X-Google-Smtp-Source: ABdhPJziD/dmI1/E002HyAJ5OylTk+JhXSjQ5FRN2yxl8+RzYWMFBCQEuK+/1sCUgSRaUjkwUyvDHK2r4a8SFvshsMM=
X-Received: by 2002:a63:311:: with SMTP id 17mr19133524pgd.450.1629474123284;
 Fri, 20 Aug 2021 08:42:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210820054340.GA28560@lst.de>
In-Reply-To: <20210820054340.GA28560@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 08:41:52 -0700
Message-ID: <CAPcyv4i5GHUXPCEu4RbD1x_=usTdK2VWqHfvHFEHijDYBg+CLw@mail.gmail.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Christoph Hellwig <hch@lst.de>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, 
	Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"

[ add Gerald and Joao ]

On Thu, Aug 19, 2021 at 10:44 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi all,
>
> looking at the recent ZONE_DEVICE related changes we still have a
> horrible maze of different code paths.  I already suggested to
> depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
> architectures have anyway.  But the other odd special case is
> CONFIG_FS_DAX_LIMITED which is just used for the xpram driver.  Does
> this driver still see use?  If so can we make it behave like the
> other DAX drivers and require a pgmap?  I think the biggest missing
> part would be to implement ARCH_HAS_PTE_DEVMAP for s390.
>

Gerald,

Might you still be looking to help dcssblk get out of FS_DAX_LIMITED
jail [1]? I recall Martin saying that 'struct page' overhead was
prohibitive. I don't know if Joao's 'struct page' diet patches could
help alleviate that at all (would require the filesystem to only
allocate blocks in large page sizes).

[1]: https://lore.kernel.org/r/20180523205017.0f2bc83e@thinkpad
