Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A285C29CA
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 20:39:14 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id k26so6048080pfi.5
        for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 13:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dNq0S9jM6oQRJal+0WSVes7IZgEFq+dVFVbGdIMQsiQ=;
        b=P7pNUOZ2DTgMBbxk0VKaXrWd7ndp2wq8LUCQ/byoSzMEOs3mmcyilmwm682FET/u/0
         qJyGzoAyIph5uaKhkjikSo7dey8KyxToXw2eKTYYb6R+UwyqaJHixhWB7F5Fp09nYBe1
         US2s6gb6++va44GARjVnXaG3t8VZndk1X8If0CvR9L/zMFdP2pG/k+AGHrSaVUhXy1u8
         xmqsXPuoRU3m4KLNamOxcU8LhGCnAXHwZ7Ggt/Pe0iNSc875t9HZweOsXAfwenRd1OQG
         b7/CpSDZ6e2bVnooMcXzyioUUhz3qM/bBEfmeAfZlhRGZWU0CGAinoa+9tHG+5ZM1+w3
         0/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNq0S9jM6oQRJal+0WSVes7IZgEFq+dVFVbGdIMQsiQ=;
        b=RxLXSQr7o+At6ZwOJn369Rp0Dq16xIRRG8vWQ2budQoXtG8YZ7EvO2TjF9cPgn6IY6
         o2Bz2mfUjche8lXqNqhkyIq1IBtHOSpoSHlTSa8wRmaNuw+tRVfBW3DlgAqJtb0Ao+ql
         XzL5x4K78lrKp3R3qfPVrn2ceyD08iZpxdSmouC/r+T1fWP/DrNkrUwaLQhZyJzZ3ZQa
         cIqR0wYh9htXz6ZSHDfgnXEoXnBwuEzrEguhhG96059yAVb1CI+hsfzc8asShbHEpUfr
         DK4A72RbAWWEYnlh0qE0WZa6vX10WiKZZNds0E3iDAgfWW0oeu8ZsWo1Iku6sl6hofTB
         i+mQ==
X-Gm-Message-State: AOAM532C1u7SBus1xwoKLySX+2xJbIHQXPR++tfx83rRHTLll2Lh3CFq
	l9rqmM+bHIdavXNhK7KYBhmEzPCOnZ1T9fSfcz2jvQ==
X-Google-Smtp-Source: ABdhPJwlgg+ZscF8NFqN7WFkCR+RWTGX0tR9NcrsVnk4JGPy4Y4pdoZKGjKrnie+NjYu4dH+YrfmmU8SpTxXAo+i7Fk=
X-Received: by 2002:a63:d709:: with SMTP id d9mr6546860pgg.377.1633034354052;
 Thu, 30 Sep 2021 13:39:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YUHN1DqsgApckZ/R@zn.tnic> <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic> <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic> <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic> <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic> <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com> <YVYe9xrXiwF3IqB2@zn.tnic>
In-Reply-To: <YVYe9xrXiwF3IqB2@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Sep 2021 13:39:03 -0700
Message-ID: <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 30, 2021 at 1:34 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 30, 2021 at 08:15:51PM +0000, Luck, Tony wrote:
> > That may now be a confusing name for the page flag bit. Until the
> > pmem/storage use case we just simply lost the whole page (back
> > then set_mce_nospec() didn't take an argument, it just marked the
> > whole page as "not present" in the kernel 1:1 map).
> >
> > So the meaning of HWPoison has subtly changed from "this whole
> > page is poisoned" to "there is some poison in some/all[1] of this page"
>
> Is that that PMEM driver case Dan is talking about: "the owner of that
> page, PMEM driver, knows how to navigate around that poison to maximize
> data recovery flows."?
>
> IOW, even if the page is marked as poison, in the PMEM case the driver
> can access those sub-page ranges to salvage data? And in the "normal"
> case, we only deal with whole pages anyway because memory_failure()
> will mark the whole page as poison and nothing will be able to access
> sub-page ranges there to salvage data?
>
> Closer?
>

Yes, that's a good way to think about it. The only way to avoid poison
for page allocator pages is to just ditch the page. In the case of
PMEM the driver can do this fine grained dance because it gets precise
sub-page poison lists to consult and implements a non-mmap path to
access the page contents.
