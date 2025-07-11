Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1851D618C
	for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 18:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752259797; cv=none; b=dzvCG/bdW5tkRNXh7U5dbstngutK0m/rHgz0rwqqpdibVvmlDC0v3WDg/Y1WS/2nzLALhUxFp28CX5/FzVYutXT5XoliuC3Zt9L05Q1pAuNkkK9+TKvCe40dMxYEaLsobbVlaPtN1atKNm0Ugz/BuivQ70aLLx7AMp/k9ALxQWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752259797; c=relaxed/simple;
	bh=nbSjpgGOdBK1AyMAVCG4xKmRigRZohta54oD8PEn5yU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pKDxLzQFBsZ0H/LttBLxDlU5jXEKqyEJWFfQs7yqx4vVmNpw6Xm9bIpYP5IVevMEkilOeqaFYqW9NK5+A/EIGCMec1v1BuGwgJl+X406dJ9r+CJD2dUyAjMLT/hrwML2uf5I4rT9QhjEhZ5jKR18nQ5kV6REeHtaf6FGN6hmAtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dZ5pPIpQ; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dZ5pPIpQ"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e8b8893ef6dso763130276.1
        for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 11:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752259794; x=1752864594; darn=lists.linux.dev;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8uep3oUhxpHoW2J+JxDGwSw4zGQmgpsL58UQXesiGys=;
        b=dZ5pPIpQ6qtvMJdWIO0p2ak+FIlGGaii4sO6+5F4kiZBD4/tVMqJukr43vnZbO6U1R
         XnvMjcZ5BM/mlhek5+nZvWKAg6C7ckT0PKm6z+nIONgkHRd/6KeWmLVcDKvBuCJ/dKib
         09LFHm+nzFqeMFDhGPN7xIIkT+bAWI3f1FJuH+Pmxq59j4ohOGuRgEVdFShOsVNA2viT
         a+L+AW2CXUSQPdaWGe5o3exRn3+tje+21Kwy3h8rEDYqpIwcw4Wh+hKpNMYLlVgk2BEF
         fRo8Y6AKwdCRtrbicPDk0I+VPxizcCsj5vwFElQ0O2LXhQaIA3V6Nl80mqROhcF0U/7i
         gulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752259794; x=1752864594;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8uep3oUhxpHoW2J+JxDGwSw4zGQmgpsL58UQXesiGys=;
        b=IYRB0FoV4Q5FHTfXx5YA2uQbiM0qMGZUGGBd74i2wsEFkGLojZwJHfChmddiTQJKra
         qKKoRN1lqq8+chj+o+Ecpqmoa66D/S7nGwDHoUq5fufFTckzLYxqf2o4awvLL30LmK3R
         V2/0HaH7jQpA13zKOs9lHVansorpxvGbpTW63GNrfeEfqrJ1ITororNaSYTCCdb/k5yk
         e4MCy4o+9tTaduW1zY8mU4jDf0cWSPbvMuhpqtwOHJSSkynlvJQMQGiSVg/FHQu07LfV
         1NNOnl4pPrDgsSpY3Rlny9X8nBvaK2w3MI5EWwxuV3ejdu4AUHTKDRFR7vYf85kl0Ct+
         wn1A==
X-Forwarded-Encrypted: i=1; AJvYcCVw59ZUs4vpq+XQmTzgcZ1RdJ4+paUxu0jCMKk1aZsXKGZc/a1vT3EI4gEPe6Wlfv2WIu3ekw0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwS14vfcmENL9CnoUDWBxMxIrzkXjIA0l7hqkZ6zioE4JBVuNxR
	BScTfed/IZmlJDiKi7WjakoIBsQcgkcVTcccW9KOWIIwvhVhFh2C0DqQJ+0rEv3iRA==
X-Gm-Gg: ASbGncvLTlE0XzK9ixEEeVTBq8Q3lspbR4vyTLhFVHxIiKZBdSoPTpNXIMVstO0IoTk
	P7Ssnee69ck+2M/VpGzV5/YegPf98FXDQ7yH9+K/eA7J7VUiSeBX2k25bBjAyVOW7bX5dYmx837
	mRyWgGcYGE9uR4g6f5CV/6srNcBeCsvAZdqYcWV7z7dvnlkqLlzNcSfLpSJuxFLoxRqNwofA/zA
	O8udMS2VroCwO7WNsHqhUW7tWSwvclGokg6qkDFPhKsBy0g2/qEY6BD2trbGf02YoD9JYVhSw1S
	Wuv6WSBdd/cf1A0CdNq5h8PBk6m9nbOLawqegPDxWxIXL2W4hXYTiz4HxdAhu6wgJpIQZI/iv4q
	f8VFSHsJ09l/4EYjqVD3p9KFbBAxXSdn1CdT/nVJqq8VInEF6XnCorLuGGCZG+xt+J0KsgES0lD
	uYf6jETn4=
X-Google-Smtp-Source: AGHT+IGvwK4cqP6d4d0tDMpHq9UunLQhfUNAyIw9HuYDsHjNMvJlEOHyXdidbQDEQly7uE88Fgsoeg==
X-Received: by 2002:a05:6902:478b:b0:e82:24ae:c3ae with SMTP id 3f1490d57ef6-e8b85ae2af5mr5779939276.21.1752259794230;
        Fri, 11 Jul 2025 11:49:54 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8b7af9cd06sm1266310276.30.2025.07.11.11.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 11:49:53 -0700 (PDT)
Date: Fri, 11 Jul 2025 11:49:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev, 
    Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>, 
    Stefano Stabellini <sstabellini@kernel.org>, 
    Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
    Dan Williams <dan.j.williams@intel.com>, 
    Alistair Popple <apopple@nvidia.com>, Matthew Wilcox <willy@infradead.org>, 
    Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, Zi Yan <ziy@nvidia.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
    Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
    Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
    Lance Yang <ioworker0@gmail.com>
Subject: Re: [PATCH RFC 01/14] mm/memory: drop highest_memmap_pfn sanity
 check in vm_normal_page()
In-Reply-To: <056787ba-eed1-4517-89cd-20c7cc9935dc@redhat.com>
Message-ID: <5e439af4-6281-43b2-cbd2-616f5d115fdf@google.com>
References: <20250617154345.2494405-1-david@redhat.com> <20250617154345.2494405-2-david@redhat.com> <aFVZCvOpIpBGAf9w@localhost.localdomain> <c88c29d2-d887-4c5a-8b4e-0cf30e71d596@redhat.com> <CABzRoyZtxBgJUZK4p0V1sPAqbNr=6S-aE1S68u8tKo=cZ2ELSw@mail.gmail.com>
 <5e5e8d79-61b1-465d-ab5a-4fa82d401215@redhat.com> <aa977869-f93f-4c2b-a189-f90e2d3bc7da@linux.dev> <b6d79033-b887-4ce7-b8f2-564cad7ec535@redhat.com> <b0984e6e-eabd-ed71-63c3-4c4d362553e8@google.com> <36dd6b12-f683-48a2-8b9c-c8cd0949dfdc@redhat.com>
 <0b1cb496-4e50-252e-5bcf-74a89a78a8c0@google.com> <056787ba-eed1-4517-89cd-20c7cc9935dc@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 11 Jul 2025, David Hildenbrand wrote:
> On 08.07.25 04:52, Hugh Dickins wrote:
> > 
> > Of course it's limited in what it can catch (and won't even get called
> > if the present bit was not set - a more complete patch might unify with
> > those various "Bad swap" messages). Of course. But it's still useful for
> > stopping pfn_to_page() veering off the end of the memmap[] (in some
> > configs).
> 
> Right, probably in the configs we both don't care that much about nowadays :)

I thought it was the other way round: it's useful for stopping
pfn_to_page() veering off the end of the memmap[] if it's a memory model
where pfn_to_page() is a simple linear conversion.

As with SPARSEMEM_VMEMMAP, which I thought was the favourite nowadays.

If you don't care about that one much (does hotplug prevent it?), then
you do care about the complex pfn_to_page()s, and we should have worried
more when "page++"s got unnecessarily converted to folio_page(folio, i)
a year or two back (I'm thinking of in mm/rmap.c, maybe elsewhere).

Hugh
