Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAE12C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:21:39 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id f8so8292017plo.12
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 10:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/6CuCRx5fb37EHJ9n38zQtYbgem93jvMUTONL4h8ySQ=;
        b=twnoyg/DM84dkBr1m+MuZo6tfQ2iKnllFSsEJhOhJSn9OxgDUgR5Oy5mdxf4apNPDi
         ws9XTc9UOHll04oitV5nteUmUWxBAVTo7OIXaex7AEbuhO9z182/bWKks3vBQq+hn/ID
         bQVb7dKegcpF6idTOJF5vOyaqCFDqG1PbxuWWbOcgNRgn4k52vtdNEThpl9IPd0pq5yi
         vpc9MO0oETMN1X+DOy9OIkpVnLD7GNwoxzwxR7FK0SYTatM6uJTQgcGfcVlbgzR+a1g8
         QsGt+irtbOfEj9qACVOzLdkMKuaHrKZ7vflOImZDkT8Boih13KCqbIPh1MOB+0iBsV3M
         4ibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/6CuCRx5fb37EHJ9n38zQtYbgem93jvMUTONL4h8ySQ=;
        b=KSCU2t4RnAaue1JBNQNtu6gnNfvTCHFHdhN43muHF8j4nykhM30qvZgzRHRH17DZuf
         py7ZmSM1fR/ar7HGhW7UPtPL4EzwhY8Pegbr7dxX/xnu7dq/lRy/Z3X6sQIO9xClN+yw
         IcbCoS7b/mpLQ+o2kiRhLMwMxrByTidnBpLBryRmsZG1T1ut02QCu802bIGNOCD5s+hn
         HahtDjz7pTzGRWYDBiufRm+ZkZM+AWjtjsC4wwhNZfq6jMxQWzQwvXSRh6jJXWYlPk1Y
         r+JCFonhieU9o1CDk1hSrf70GKNvlorkZGwnSEn9CHISgu004iKT3Oa8iqHEGNH1PnWY
         gdeQ==
X-Gm-Message-State: AOAM533I4lCiF6qUOhUieXNGq+bNatN5fhB2P6Fjb1/yvJyiImeQXfPl
	CTS0T8ManJUvmlXG7FwflXUfz6eUCBnl3KsDzhnqQw==
X-Google-Smtp-Source: ABdhPJz0HKwUJObwXXczhg5xNU7PXsrGD9NSY7tr5qdCVGj3TQvdsY7J35uh/mTG8WpLWWG9rom1XQqBdXhnZjv1uuA=
X-Received: by 2002:a17:902:aa84:b0:142:36cb:2a47 with SMTP id
 d4-20020a170902aa8400b0014236cb2a47mr4177109plr.89.1636046499082; Thu, 04 Nov
 2021 10:21:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YYOLRW7yx9IFn9mG@infradead.org> <CAPcyv4hU+dFYc3fXnGhBPAsid03yFYZSym_sTBjHeUUrt6s5gQ@mail.gmail.com>
 <YYQEfxpVlxWjXgAU@infradead.org> <CAPcyv4hZ1+pEd0A1y2oqSsMjCh2phJxukBB8ZBwbN0ax-Gni9Q@mail.gmail.com>
 <YYQVq80QS77KkFV0@infradead.org> <YYQWOU//1oz0EMIu@infradead.org>
In-Reply-To: <YYQWOU//1oz0EMIu@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 10:21:28 -0700
Message-ID: <CAPcyv4hBJap0xpFqiW2apjzwWP+JKGDk0eSFsn-R1BBDz5z9Kw@mail.gmail.com>
Subject: Re: qemu-emulated nfit devices disappeared
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 4, 2021 at 10:20 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Nov 04, 2021 at 10:17:31AM -0700, Christoph Hellwig wrote:
> > On Thu, Nov 04, 2021 at 10:09:37AM -0700, Dan Williams wrote:
> > > Hmm, so the driver has 2 modes "labeled" and "label-less", in the
> > > labeled mode it waits for an explicit:
> > >
> > >     ndctl create-namespace
> > >
> > > ...to provision region capacity into a namespace. In label-less mode
> > > it just assumes that the boundaries of the region are the boundaries
> > > of the namespace. In this case it looks like the driver found a label
> > > index block with no namespaces defined so it's waiting for one to be
> > > created. Are you saying that the only thing you changed from a working
> > > config with defined namespace to this one was a kernel change? I.e.
> > > the content of those memory-backend files has not changed?
> >
> > Well, the config change is the only thing I though of as relevant.
> > The content of those files actually changes all the time, as I also
> > use them as the backing store for my qemu configs that use block
> > devices.  E.g. the previous run they did show up as NVMe devices.
>
> Ok, blowing the files away and recreating them makes the pmem
> devices show up again.
>

Cool, yeah, I was going to guess the label area might have been
clobbered, but there was just enough left to force the driver into
labeled mode. You can verify with something like:

ndctl read-labels -I -j all

...to see if nvdimms have label index blocks.
