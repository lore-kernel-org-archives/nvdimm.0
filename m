Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC2972
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 16:52:02 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id t32so5823937qtc.3
        for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 09:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nm5f4TdykV0Ij8N80OXzW6n74qiksoV2Mz6T3bNcU4c=;
        b=WpMImxTPH0oqNigcdNaPe3TalPVZxGNIypXpTMh6+4KoJHhi7xXR01+ileZaSM8UFm
         nmXdWe5LE6PVPClzBloI1zRgpV4Hf5SkcnnUgCWsOKNpVVNkksUvD2CJCDBOqD83sP+l
         IdlmSCqaJKHANuvGz6mBMIO0QO2jKhAlfZKNnxwmO8AwFT/FFU77A/jOeD7UAFa0V/bw
         KS6DF4fU86u9GkYKn+t6MFbRPVpjSv9+HPL7u29z9jbikqjShfG42wBcgnDvW/CUNkq7
         rA3ngjetilfeeJK5lyk6Gb/wjfQjeOiLIcOw2FJ4xHexazEAp7Bo1SMmrzHwpMSzHNLW
         u1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nm5f4TdykV0Ij8N80OXzW6n74qiksoV2Mz6T3bNcU4c=;
        b=qu+8NoZGHZDAxHWF7Tb+ut4ZifHjomOSPmwUIK0mT2W+XogNmQbv/z7mrstQrUfvX8
         ovn9bCn3+TnnVgC8df8VjI7mS0IR+PXVt+lk59dZr5GhIa2zJR5TGCqnnkCVXw3yxuYQ
         gtduHy79tLXiRl2vie5sMaQWHo14/Ga2V7zqWARZRzmIA0S4YsAspRoPtBTjcrtvdNis
         J/ra/xjz03i8AuTSw0PCT+ftHiYxLjIfNYcZvvW68ZI4ZgJ1vNdSSt8poD74mfoRFuTe
         hRfO8JkzR/acxAiNnCGAI5aeZBN5P/CiQA54TJso0+NMC5a+BlJAVbeXDKccZFsGeD7Y
         4wuw==
X-Gm-Message-State: AOAM533alYKMqXtyFNFl4A4nsFenOaCdx7i4bo0lvTg9j7M4sBy7iGYz
	WDkTIHqJqR6UAwn6dlb94Du4Gw==
X-Google-Smtp-Source: ABdhPJzfzX5zKzWjbUBZn31RTDJj2QP2YP2QnIppHCIOvhn1lTP8KwnEZv8V6Wd5jYKiX9XOx7WhOg==
X-Received: by 2002:ac8:7c44:: with SMTP id o4mr9135892qtv.82.1630083121426;
        Fri, 27 Aug 2021 09:52:01 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id x3sm4855078qkx.62.2021.08.27.09.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 09:52:00 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mJf5E-005kOn-4S; Fri, 27 Aug 2021 13:52:00 -0300
Date: Fri, 27 Aug 2021 13:52:00 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Li, Zhijian" <lizhijian@cn.fujitsu.com>,
	"lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	Yishai Hadas <yishaih@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>
Subject: Re: RDMA/rpma + fsdax(ext4) was broken since 36f30e486d
Message-ID: <20210827165200.GM1200268@ziepe.ca>
References: <8b2514bb-1d4b-48bb-a666-85e6804fbac0@cn.fujitsu.com>
 <68169bc5-075f-8260-eedc-80fdf4b0accd@cn.fujitsu.com>
 <20210806014559.GM543798@ziepe.ca>
 <b5e6c4cd-8842-59ef-c089-2802057f3202@cn.fujitsu.com>
 <10c4bead-c778-8794-f916-80bf7ba3a56b@fujitsu.com>
 <20210827121034.GG1200268@ziepe.ca>
 <d276eeda-7f30-6c91-24cd-a40916fcc4c8@cn.fujitsu.com>
 <CAPcyv4ho-42iZB3W5ypfwj-2=+v6rRUCcwE4ntPXyDPgFjzp7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ho-42iZB3W5ypfwj-2=+v6rRUCcwE4ntPXyDPgFjzp7g@mail.gmail.com>

On Fri, Aug 27, 2021 at 09:42:21AM -0700, Dan Williams wrote:
> On Fri, Aug 27, 2021 at 6:05 AM Li, Zhijian <lizhijian@cn.fujitsu.com> wrote:
> >
> >
> > on 2021/8/27 20:10, Jason Gunthorpe wrote:
> > > On Fri, Aug 27, 2021 at 08:15:40AM +0000, lizhijian@fujitsu.com wrote:
> > >> i looked over the change-log of hmm_vma_handle_pte(), and found that before
> > >> 4055062 ("mm/hmm: add missing call to hmm_pte_need_fault in HMM_PFN_SPECIAL handling")
> > >>
> > >> hmm_vma_handle_pte() will not check pte_special(pte) if pte_devmap(pte) is true.
> > >>
> > >> when we reached
> > >> "if (pte_special(pte) && !is_zero_pfn(pte_pfn(pte))) {"
> > >> the pte have already presented and its pte's flag already fulfilled the request flags.
> > >>
> > >>
> > >> My question is that
> > >> Per https://01.org/blogs/dave/2020/linux-consumption-x86-page-table-bits,
> > >> pte_devmap(pte) and pte_special(pte) could be both true in fsdax user case, right ?
> > > How? what code creates that?
> > >
> > > I see:
> > >
> > > insert_pfn():
> > >       /* Ok, finally just insert the thing.. */
> > >       if (pfn_t_devmap(pfn))
> > >               entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
> > >       else
> > >               entry = pte_mkspecial(pfn_t_pte(pfn, prot));
> > >
> > > So what code path ends up setting both bits?
> >
> >   pte_mkdevmap() will set both _PAGE_SPECIAL | PAGE_DEVMAP
> >
> >   395 static inline pte_t pte_mkdevmap(pte_t pte)
> >   396 {
> >   397         return pte_set_flags(pte, _PAGE_SPECIAL|_PAGE_DEVMAP);
> >   398 }
> 
> I can't recall why _PAGE_SPECIAL is there. I'll take a look, but I
> think setting _PAGE_SPECIAL in pte_mkdevmap() is overkill.

This is my feeling too, but every arch does it, so hmm should check
it, at least for now as a stable fix

devmap has a struct page so it should be refcounted inside the VMA and
that is the main thing that PAGE_SPECIAL disabled, AFAICR..

The only places where pte_special are used that I wonder if are OK for
devmap have to do with CPU cache maintenance

vm_normal_page(), hmm_vma_handle_pte(), gup_pte_range() all look OK to
drop the special bit

Jason
