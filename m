Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCC12C87
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 02:54:20 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso1609868pjo.3
        for <nvdimm@lists.linux.dev>; Mon, 22 Nov 2021 18:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Al5JsM62A3tHtpfVSPPyo8ez+nZ96myx/BqVadpnmZE=;
        b=xC+R2Ze1hcDaIg+74cuixxadPvoKZHVUfRh3cG7NL6liGTAKRC1u/dtLV2Upl+DjCb
         lz8tF4p8hd5xqtUPL0FFIN4COIFn8gNO0kZEDg0AZkuF8D8jKwc0aEvQ7rx69yXQ0Onu
         ygsv6Lso/1XQ2tNifMHR6wKXy6FdeML5mJLZDRvnaAHvQPYqIVreOhkxmGyxQPa6SI/i
         eitCea7WNPUHw+NWqm+DDMhFpduBZks6zZt+EcfeE8ME4X0s0nFvXWdxr1dRMwydHs/r
         NeInAl4EFa9zlunOlALEVrXarilVx4ntLaJRr9tg/Qn0MoP7TxRpqBu+w38vRZVF2hEy
         GCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Al5JsM62A3tHtpfVSPPyo8ez+nZ96myx/BqVadpnmZE=;
        b=bO8a46bFEhh98laexz47FPwNnIPga+CMX2knvgeUwV4PU2F82zsLxydjA3MjoarSew
         k/2pN8j2XF3ADsugezd7p1Fpr+W7+TVIVXdQkvFyy2+/GBshcQ5XFUxXI1s8fWhTeGT9
         7BF73G5yUWl3VkssHAKj3A0pohbg6+xRivhFan1fF3PT5EoqIaRxA+1HRS2NxiTyPrTn
         K4kWxgeQjmg6PJXRKEup9EINoH3Y3dtkU8EvzAQ6iqyC3MRKCyHIMhiA6njGxVE2HRxg
         stOgSw/8pkZO1/k5GtzXAl2zt9zvCikA+SpS4ir212cCZmf4nh3YHoyEkJpZd/RfRfM0
         z3uA==
X-Gm-Message-State: AOAM531mXrBQiA6NU3QGDXLqN2xgUCcXrtupJ4FD5X4dDupTYu8wo5XB
	ZsC5YZPa9HQ2HBy+Vn4/ydgxWlcQHbxnO04BDc+n1g==
X-Google-Smtp-Source: ABdhPJzVmbqwkteuXJ4hKBjAQTD1mqO5WV/z0skpRbQzjFZ3o+tEVCfuAJYtWwfPr8oZjtyH1KqF3yLKCjaZBtlyJ4k=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr2220703pjb.93.1637636060294;
 Mon, 22 Nov 2021 18:54:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-3-hch@lst.de>
 <CAPcyv4iPOcD8OsimpSZMnbTEsGZKj-GqSY=cWC0tPvoVs6DE1Q@mail.gmail.com> <20211119065457.GA15524@lst.de>
In-Reply-To: <20211119065457.GA15524@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 18:54:09 -0800
Message-ID: <CAPcyv4iDujo8ZZp=8xNEhB3u6Vyc6nzq_THGiGRON7x3oi9enw@mail.gmail.com>
Subject: Re: [PATCH 02/29] dm: make the DAX support dependend on CONFIG_FS_DAX
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 18, 2021 at 10:55 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Nov 17, 2021 at 09:23:44AM -0800, Dan Williams wrote:
> > Applied, fixed the spelling of 'dependent' in the subject and picked
> > up Mike's Ack from the previous send:
> >
> > https://lore.kernel.org/r/YYASBVuorCedsnRL@redhat.com
> >
> > Christoph, any particular reason you did not pick up the tags from the
> > last posting?
>
> I thought I did, but apparently I've missed some.

I'll reply with the ones I see missing that need carrying over and add
my own reviewed-by then you can send me a pull request when ready,
deal?
