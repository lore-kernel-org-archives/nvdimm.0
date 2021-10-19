Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05352C80
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 16:01:38 +0000 (UTC)
Received: by mail-qv1-f42.google.com with SMTP id e13so252580qvf.5
        for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 09:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3BGJn1dXdpzUd3tv3q+EmhfGtbVhe0Qd67sISQeDnw4=;
        b=D3VIbh9ttclotZ84lKsDn3X7RfkFlngL41uIfucxHeTNtiYydE1whz/r7jFojWxJzr
         IwRCHVsSlqyCKuylJCeriD2Qefn+j1/fvnIlM3d65YZUJrz7ZL7fl9tLcXBW9mYUvhqy
         5xpDPE/RU9PMih7sDjXvMU0edSmFgIV+++/zaNE2J4zW5uztqyyYAkJzV/1C4A3U+gyW
         U6b9VBKLc/Ca1IxjKLG5lhBNp9XrN8Hu+qrhLy38rNdpoUl7KOZ4xReT8hcKkCZ0/Hu/
         Yc6EMXS7JJJ0dd4WHusGYr40To/zWTF7J1Xh5LlZnFmkNu7G/b+P57DnWMN0taZYehmd
         AKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3BGJn1dXdpzUd3tv3q+EmhfGtbVhe0Qd67sISQeDnw4=;
        b=iVGdpxL58YlFMqH40aFAFBFFXOSAc6BvqztWwUrGeOZwvXl17kHeFXZxB1ob87yPTW
         PmnkcqvosD4St8hB2PG8lHk2Zi5+UmSJbo9xghm/2ReUBFoemqjEwNXIK9NKJZdmPBEv
         o0v5Kvr2B60LFsLLzOBXaivO9cJ3Rs7QbhiaZqOH0HC9MMo6ENTc7HjQEdMIRGlhPSxa
         552W+uJSi5J98HzfYS/5JoT5XBs9D5aqHEjCxuup91PgyI7lmknj/VfPcaCASYYIh1zI
         bnOWIuiRWXHkUJKPz6ttxCb5q0/45FWOG1NcbbiZsMzdFA+FwEcc0DvdUDmaABIHKJoq
         NGcQ==
X-Gm-Message-State: AOAM533epb0MNtaRquAtFeXu7nAR8j1XMoDCRHhjeAC1qKNW6j263clc
	80sRIL5UYdKWTL4JkJzH52xc1A==
X-Google-Smtp-Source: ABdhPJwvk+8tFb6J3QISFF+F14Y7KiyXAV1U8RUSPAMtZ9qpPCQT16Z2pmMVxiVutxUbz+C+YTG/ZA==
X-Received: by 2002:ad4:4725:: with SMTP id l5mr651407qvz.3.1634659297591;
        Tue, 19 Oct 2021 09:01:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id d6sm8054384qkj.11.2021.10.19.09.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 09:01:37 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mcrYW-00GjRc-GQ; Tue, 19 Oct 2021 13:01:36 -0300
Date: Tue, 19 Oct 2021 13:01:36 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alex Sierra <alex.sierra@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kuehling, Felix" <Felix.Kuehling@amd.com>,
	Linux MM <linux-mm@kvack.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	amd-gfx list <amd-gfx@lists.freedesktop.org>,
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
	Christoph Hellwig <hch@lst.de>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v1 2/2] mm: remove extra ZONE_DEVICE struct page refcount
Message-ID: <20211019160136.GH3686969@ziepe.ca>
References: <YWh6PL7nvh4DqXCI@casper.infradead.org>
 <CAPcyv4hBdSwdtG6Hnx9mDsRXiPMyhNH=4hDuv8JZ+U+Jj4RUWg@mail.gmail.com>
 <20211014230606.GZ2744544@nvidia.com>
 <CAPcyv4hC4qxbO46hp=XBpDaVbeh=qdY6TgvacXRprQ55Qwe-Dg@mail.gmail.com>
 <20211016154450.GJ2744544@nvidia.com>
 <CAPcyv4j0kHREAOG6_07E2foz6e4FP8D72mZXH6ivsiUBu_8c6g@mail.gmail.com>
 <20211018182559.GC3686969@ziepe.ca>
 <CAPcyv4jvZjeMcKLVuOEQ_gXRd87i3NUX5D=MmsJ++rWafnK-NQ@mail.gmail.com>
 <20211018230614.GF3686969@ziepe.ca>
 <499043a0-b3d8-7a42-4aee-84b81f5b633f@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499043a0-b3d8-7a42-4aee-84b81f5b633f@oracle.com>

On Tue, Oct 19, 2021 at 04:13:34PM +0100, Joao Martins wrote:
> On 10/19/21 00:06, Jason Gunthorpe wrote:
> > On Mon, Oct 18, 2021 at 12:37:30PM -0700, Dan Williams wrote:
> > 
> >>> device-dax uses PUD, along with TTM, they are the only places. I'm not
> >>> sure TTM is a real place though.
> >>
> >> I was setting device-dax aside because it can use Joao's changes to
> >> get compound-page support.
> > 
> > Ideally, but that ideas in that patch series have been floating around
> > for a long time now..
> >  
> The current status of the series misses a Rb on patches 6,7,10,12-14.
> Well, patch 8 too should now drop its tag, considering the latest
> discussion.
> 
> If it helps moving things forward I could split my series further into:
> 
> 1) the compound page introduction (patches 1-7) of my aforementioned series
> 2) vmemmap deduplication for memory gains (patches 9-14)
> 3) gup improvements (patch 8 and gup-slow improvements)

I would split it, yes..

I think we can see a general consensus that making compound_head/etc
work consistently with how THP uses it will provide value and
opportunity for optimization going forward.

> Whats the benefit between preventing longterm at start
> versus only after mounting the filesystem? Or is the intended future purpose
> to pass more context into an holder potential future callback e.g. nack longterm
> pins on a page basis?

I understood Dan's remark that the device-dax path allows
FOLL_LONGTERM and the FSDAX path does not ?

Which, IIRC, today is signaled basd on vma properties and in all cases
fast-gup is denied.

> Maybe we can start by at least not add any flags and just prevent
> FOLL_LONGTERM on fsdax -- which I guess was the original purpose of
> commit 7af75561e171 ("mm/gup: add FOLL_LONGTERM capability to GUP fast").
> This patch (which I can formally send) has a sketch of that (below scissors mark):
> 
> https://lore.kernel.org/linux-mm/6a18179e-65f7-367d-89a9-d5162f10fef0@oracle.com/

Yes, basically, whatever test we want for 'deny fast gup foll
longterm' is fine. 

Personally I'd like to see us move toward a set of flag specifying
each special behavior and not a collection of types that imply special
behaviors.

Eg we have at least:
 - Block gup fast on foll_longterm
 - Capture the refcount ==1 and use the pgmap free hook
   (confusingly called page_is_devmap_managed())
 - Always use a swap entry
 - page->index/mapping are used in the usual file based way?

Probably more things..

Jason
