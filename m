Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEE82ED17E
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554225; cv=none; b=KhCmUoThv7HfsiG9mr9nxewnPJHEQ94jWoaWXtoTN0AKhmAPsZR/z6sS/LY3S8ZqZsANGnsM1q/ozWdDVa6KmelYAgFysSiiIzORtYcei/+fFewLIvJoZBaH/aS4fjZaam85o4B6OZabMeq1KEScoLcPge0d4aaE6hnVMK9m2a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554225; c=relaxed/simple;
	bh=wAu0Srl3KlrnuOT7XKfRmg7X9fvoPiPkkGiyEdQ4yjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p7ol+aHT38OZOczjTXFOBN52P8rjoEHx1QSC14z+4CFmmAR7V7cpo/om9z/7oZ3rpSNP/ucX98y3wdjexuDP9Ocfg+dmME1ft4BnKZSivS3A0QpL8jln6BjfYgdgNI7m4jK6sjXX/q4m/WofZHkOdpZJ1jDtk3ljePoOouZfY3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fTZkYx9B; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTZkYx9B"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6facc3b9559so77318436d6.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751554222; x=1752159022; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAu0Srl3KlrnuOT7XKfRmg7X9fvoPiPkkGiyEdQ4yjw=;
        b=fTZkYx9Bmw82GGGSwnQEK7GWUGdl3aMXK5JMrERC0wooChgvzipqe0+5GmSkQsRyss
         u1C5vpJK1JguAylnVNgU8ysf67O3a77V4QrqqBIyVaiCY7vsxzfYW6Fk+FTnqaD73JB8
         KN5cMflYCTx0D+hZ8KatVCNBYrm3pD4F3nyfCUQVaxfL0hii0Cyzms+q9wqQT18Abc5J
         0i3n+c2SIPJvta1e0bj8CSo5DqdAKz4WYz8pLHgu5AsiI/3DYfCBIf2sNoUoy74WolRw
         XWnhUGjS5nLLCe3pGo9eqOJAHOLwOMNKIIqPnJpGTKdJw6rToWUlW9467KVWW3eg11QV
         T4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751554222; x=1752159022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wAu0Srl3KlrnuOT7XKfRmg7X9fvoPiPkkGiyEdQ4yjw=;
        b=uZw4aFqfp8+LKiRwC7pERNzVibmWY2JipHM9chipQ6lklTrXiIp6pcFGImu3XJGAaT
         D1gtz5tVEJvIb77pHLyM7M7XCvICzzNRAQLh5yIy0KnL3lVmJknAMCOSIS+3rUCBE6NR
         9qiHLAAg99wN3SmwhYzbPjtssuxV2vxoqupF9tWqhBO6Cip8euIYR2q0/iHpOvFxvBtx
         a1tV+nZDvKZkRR0BBe3yFsEY74FTLfBYgWMv5i2Df/+FeTK0EBu3i3EEpHiRKtynhmmF
         9J//mEAWsghVaPYEFZ1G09O6yyx3Z2QqPdVMiBllgBH6yRep7MH68+SdYZO/aH5WLeei
         umFA==
X-Forwarded-Encrypted: i=1; AJvYcCUpxJBLfUo1YoQe7XwLfC16xKA7LZ+XxrKidqWH+DKS0MFI2+pDzWfKVeczZ20CBjjesk/r6mI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcRGSHyDEBxRODu/oBdQ+Jfpugu5Q5rr9RN8PCJj3QRMBrWYrT
	V/0NLHY1UJ/BtTcy9vyiq+NsDo5t0BgW2fRCIGN9rwVXy4/q7OTiausbEiGtwtDJHHGQH5AA6Lu
	FmuupZnPekmDdrqO7H4WmwlRTStKLnd0=
X-Gm-Gg: ASbGnctX8pJXwbru3Bp9HYLLL/M0wq47Tkw4VskhlZh+TPqd91zLzPmdWjrXYvDojj1
	6qZVAX2k2UgyqUTGtAVJBMoaX3uZL+LLlju/Rod1dIFTNip626EsKHA1Ehai191IxGH5582Mrzo
	Dj89Z1igbaGLts1vzPNXxN7BmYarPaYDzgekgqDKozSC8erLs=
X-Google-Smtp-Source: AGHT+IHam6lHXqujRmliCd8fP53JY0cmIKecpqja2QUPkFqqfyOqhuHsgnCtrvS2/8TMwwLErUkaLQ0u6woBONIJHz8=
X-Received: by 2002:ad4:5966:0:b0:6ff:16da:ae22 with SMTP id
 6a1803df08f44-702bc8c8946mr56172046d6.17.1751554222280; Thu, 03 Jul 2025
 07:50:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617154345.2494405-1-david@redhat.com> <20250617154345.2494405-2-david@redhat.com>
In-Reply-To: <20250617154345.2494405-2-david@redhat.com>
From: Lance Yang <ioworker0@gmail.com>
Date: Thu, 3 Jul 2025 22:50:09 +0800
X-Gm-Features: Ac12FXy9pobZ-Tyl0lhkLRCeovsWyWwet9l7NdvI0FrXp3EdnqPiHRcREj1ytcE
Message-ID: <CABzRoyaea-qmw4JsA85H4QgRAEPPXWKuq2z2Bi41hEXMKifnjg@mail.gmail.com>
Subject: Re: [PATCH RFC 01/14] mm/memory: drop highest_memmap_pfn sanity check
 in vm_normal_page()
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, nvdimm@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Dan Williams <dan.j.williams@intel.com>, 
	Alistair Popple <apopple@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 11:44=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
>
> In 2009, we converted a VM_BUG_ON(!pfn_valid(pfn)) to the current
> highest_memmap_pfn sanity check in commit 22b31eec63e5 ("badpage:
> vm_normal_page use print_bad_pte"), because highest_memmap_pfn was
> readily available.
>
> Nowadays, this is the last remaining highest_memmap_pfn user, and this
> sanity check is not really triggering ... frequently.
>
> Let's convert it to VM_WARN_ON_ONCE(!pfn_valid(pfn)), so we can
> simplify and get rid of highest_memmap_pfn. Checking for
> pfn_to_online_page() might be even better, but it would not handle
> ZONE_DEVICE properly.
>
> Do the same in vm_normal_page_pmd(), where we don't even report a
> problem at all ...
>
> What might be better in the future is having a runtime option like
> page-table-check to enable such checks dynamically on-demand. Something
> for the future.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM. Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks,
Lance
