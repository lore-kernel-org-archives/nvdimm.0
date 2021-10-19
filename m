Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930E929CA
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 19:21:19 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id s1so12585885plg.12
        for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 12:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0ozvNXsQJNcX/pewDd9ckpqp0ETylCl5PX4CkgxTjA=;
        b=dIpN/4YGGNH4r1EZENPOoUM36qbNMxX0AlEbDXR+QAUuWgDJulDqEi3wGiq/1+ers/
         MtNK0sg7f9C/QkJyKAJlFRYKqMBrTfln8PJngSh8ITqopx0o8J1obkFmoFdux9294FXa
         0ool0au7ytqQW+k+FPfqnMPWwg5vnKGiVhNgNjwxlfxeranZOVIdAnN2DTdpI6wVKD3S
         78DmFolU0SXPPnnv6NF8puovRVgO1rRm/SJEGKuOaaGFJvzVcaTz85rlz8++NBOOAXd7
         t/YIuxqKfUmA5B4vTl9lTDomRDwyKSQWYZDfBGBNdaXHm7+cgFxwO+idryj4IONEZqwU
         vC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0ozvNXsQJNcX/pewDd9ckpqp0ETylCl5PX4CkgxTjA=;
        b=2g2kZ+aR4fAKwmenNFuZhp3JIuSpehhPV/WyCCbqhyY3cbL1MtzbG1U0ryjRqvr8iR
         GCUtL9NzNd4f2U6AFjYHLl3uRn6a9+9zZurqSfguVd0igLAzX+bn7BdAoqNJzXpwBcyv
         OuFeOMrw4vhYFoEDeY67EIaK5sYGmfptY7HILi62eG0z1CQQyf/HhUtnC5aaMwxWMlTa
         gI7W1bdqkkokewn3LEN1mnfVoMZ8OMJCGbDGEnQb9NwoxzdHyfooF+64vf90Zxat935j
         m4vdE/YlkiD2L5d5IKosBCEe8eCRSR/TExRcm5ffOYXamFUtPlZF08gFKq89Akf/3tgk
         6doQ==
X-Gm-Message-State: AOAM532E678iwQHDBJ2LuX6gmF5WrW8JtxZDvXy6YAp6UsgWxKPrRinq
	Vz9wUnLDkUV+NbbP3TEsgtXFlQhcaWiT0slnEhDIkA==
X-Google-Smtp-Source: ABdhPJxnZNNxl4GB/nPoKZm/Jigqlqq+b5Yi5opJ2SeB60SRKWrnwAOzNK7EVcYCxhzXA3M9GeWcrmYdSBdgg3eEB9o=
X-Received: by 2002:a17:90b:350f:: with SMTP id ls15mr1918933pjb.220.1634671278933;
 Tue, 19 Oct 2021 12:21:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YWh6PL7nvh4DqXCI@casper.infradead.org> <CAPcyv4hBdSwdtG6Hnx9mDsRXiPMyhNH=4hDuv8JZ+U+Jj4RUWg@mail.gmail.com>
 <20211014230606.GZ2744544@nvidia.com> <CAPcyv4hC4qxbO46hp=XBpDaVbeh=qdY6TgvacXRprQ55Qwe-Dg@mail.gmail.com>
 <20211016154450.GJ2744544@nvidia.com> <CAPcyv4j0kHREAOG6_07E2foz6e4FP8D72mZXH6ivsiUBu_8c6g@mail.gmail.com>
 <20211018182559.GC3686969@ziepe.ca> <CAPcyv4jvZjeMcKLVuOEQ_gXRd87i3NUX5D=MmsJ++rWafnK-NQ@mail.gmail.com>
 <20211018230614.GF3686969@ziepe.ca> <499043a0-b3d8-7a42-4aee-84b81f5b633f@oracle.com>
 <20211019160136.GH3686969@ziepe.ca>
In-Reply-To: <20211019160136.GH3686969@ziepe.ca>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Oct 2021 12:21:09 -0700
Message-ID: <CAPcyv4gmvxi5tpT+xgxPLMPGZiLqKsft_5PzpMQZ-aCvwpbCvw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm: remove extra ZONE_DEVICE struct page refcount
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joao Martins <joao.m.martins@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Alex Sierra <alex.sierra@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Kuehling, Felix" <Felix.Kuehling@amd.com>, Linux MM <linux-mm@kvack.org>, 
	Ralph Campbell <rcampbell@nvidia.com>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, 
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Christoph Hellwig <hch@lst.de>, 
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 19, 2021 at 9:02 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Oct 19, 2021 at 04:13:34PM +0100, Joao Martins wrote:
> > On 10/19/21 00:06, Jason Gunthorpe wrote:
> > > On Mon, Oct 18, 2021 at 12:37:30PM -0700, Dan Williams wrote:
> > >
> > >>> device-dax uses PUD, along with TTM, they are the only places. I'm not
> > >>> sure TTM is a real place though.
> > >>
> > >> I was setting device-dax aside because it can use Joao's changes to
> > >> get compound-page support.
> > >
> > > Ideally, but that ideas in that patch series have been floating around
> > > for a long time now..
> > >
> > The current status of the series misses a Rb on patches 6,7,10,12-14.
> > Well, patch 8 too should now drop its tag, considering the latest
> > discussion.
> >
> > If it helps moving things forward I could split my series further into:
> >
> > 1) the compound page introduction (patches 1-7) of my aforementioned series
> > 2) vmemmap deduplication for memory gains (patches 9-14)
> > 3) gup improvements (patch 8 and gup-slow improvements)
>
> I would split it, yes..
>
> I think we can see a general consensus that making compound_head/etc
> work consistently with how THP uses it will provide value and
> opportunity for optimization going forward.
>
> > Whats the benefit between preventing longterm at start
> > versus only after mounting the filesystem? Or is the intended future purpose
> > to pass more context into an holder potential future callback e.g. nack longterm
> > pins on a page basis?
>
> I understood Dan's remark that the device-dax path allows
> FOLL_LONGTERM and the FSDAX path does not ?
>
> Which, IIRC, today is signaled basd on vma properties and in all cases
> fast-gup is denied.

Yeah, I forgot that 7af75561e171 eliminated any possibility of
longterm-gup-fast for device-dax, let's not disturb that status quo.

> > Maybe we can start by at least not add any flags and just prevent
> > FOLL_LONGTERM on fsdax -- which I guess was the original purpose of
> > commit 7af75561e171 ("mm/gup: add FOLL_LONGTERM capability to GUP fast").
> > This patch (which I can formally send) has a sketch of that (below scissors mark):
> >
> > https://lore.kernel.org/linux-mm/6a18179e-65f7-367d-89a9-d5162f10fef0@oracle.com/
>
> Yes, basically, whatever test we want for 'deny fast gup foll
> longterm' is fine.
>
> Personally I'd like to see us move toward a set of flag specifying
> each special behavior and not a collection of types that imply special
> behaviors.
>
> Eg we have at least:
>  - Block gup fast on foll_longterm
>  - Capture the refcount ==1 and use the pgmap free hook
>    (confusingly called page_is_devmap_managed())
>  - Always use a swap entry
>  - page->index/mapping are used in the usual file based way?
>
> Probably more things..

Yes, agree with the principle of reducing type-implied special casing.
