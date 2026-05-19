Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594E1369D4F
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208044; cv=pass; b=GBQEZJkZboOqngGM7cTdVTHApKEKMw0Wfabw64ZF/inPslOzHlvEJP8AloH8N9lVJ5oYdo+TgAtA+MefgnA7ZuOFYXBDOuvcIhyp3DvPIAdo/07rHHIe4FUeMPSpLfL0gADi8Jt9IrsPmIYyKRXSdw+WrHpDTf1JqvxiZy7w+Ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208044; c=relaxed/simple;
	bh=B6BJ3Zsa1dczVVp0M9UD9HVDpJCBAvt2NLaHwYhQoew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fq2wTR/b2c4zGUDP4tOzOe2mOFd91Kq4DQGl4xLKR2csgL6wMyOBn9Fda5z31UhmR0KhbYBYc3a3LUkES44PHfK9Iu0C2UOvsV7N3lQJCpRjA11VGcd15ZDsYYRLuREnCOUxbgBXQA/A9JdPY7FEfWj12B2T50+QAf17qKlrEgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aWesqojd; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWesqojd"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd4f7f05e90so740226166b.2
        for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 09:27:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779208042; cv=none;
        d=google.com; s=arc-20240605;
        b=g00WQ0fvR+ILOoAKlfQUgZTr5DzLB0U0kDcTDFNkC+OMkU5ThRcvjoAX+8P+VZs+5m
         KHVVb2NbrlccdixsDxEPJMrgFU/IVloXcpQR0NsOtl25ylv7Y+4vf53qFTehG5MxOD3F
         yH71a3UiZ+ZJsxDk9ImyL3FCPG4ivkcJsWh7cNRCkbSF8tKyXqyG4eMe5qaTFOhHatzn
         Aog2LwFtsGg25Bw7/7HDUtKZgyUCBAxbsi4TEtuWJ7zeBnyNpUpC5eMw6PMT+qXa0c/V
         T/sgYKCw7QnvsMPLYLiSmvgfJpUkZb4NybDh6Fby9J69iiKX07o3v4YJDGfoSzHOwVa2
         1z4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5usbpjdW6V4GRZxIENdpTSPGB2A/F8Hn+HvhpsraCUY=;
        fh=fh5+mpEQJhCAegBrQpT8II4/g0ZNIggUDhHGZ1oNXbA=;
        b=cePwnVfhq7IEth6Wzo9C63c9TlETm+fy45dh+24kQjjv+CTfSB1t29FFKyK6GkK550
         gAnLuxB6SwxoegE2BXAFVsSTIuAOBuGkzqHYto0X8G4L/h3t54QiXlITWhyVswSJoIem
         DdmTSks2EN3OE6egA15Ywg8uN/AK9DSRzH8LuwnUwKt34q2PHTZwJw0ZfF0A/czvUfbf
         /jbzti4E3MgxK2cJEyND6qYubqHPapyGlCG+71Gee/+fV333J2mtrlqJ4HYTPoxZaRg/
         5aFbA05g3aNwBZrIdEKIa9PuYxELCdrKNPFbw38c8siw0/cmekG7ZlqL0TLday06eEr1
         unAQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779208042; x=1779812842; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5usbpjdW6V4GRZxIENdpTSPGB2A/F8Hn+HvhpsraCUY=;
        b=aWesqojdEecrV3KSqSPCNYYRd6LtzB0i7t27ukU7iEVXH5hLEFu7hFWB6ZAgkS3An8
         eclMi6ehw3nggyP3rh9gBYLkJEvGkujfOZ6lcLF7Is24zXa/4MXnjUPNNs0Sk0I6C9GQ
         7eeCXGJdzl90yzGCzBG4uVEQ22npTldMjH9sc2HqBcDnRnrcc414spAttaz1XZt8vqyM
         l5+E8yOprv9Mk1FPPP1RGOUGuR27g4ObdkNrOcCvfDvOXa7skdtzD+2HjWYU+XsRmCwd
         xS3XgHoTTQ4zLGEZyYS26K0kyHSAI7+1FvLv6+gqsQ6fI73tSLzy7dW9pX5D5ZWPA8vH
         7pfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779208042; x=1779812842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5usbpjdW6V4GRZxIENdpTSPGB2A/F8Hn+HvhpsraCUY=;
        b=TvLmvhfCtSuzvPlqtgKuupwBIB2hdyJwlB8HR0w38083t5JACr8Gb2LJYDjj+RZSRq
         gYnX0cTlHDOF67JymHCaX+VvWRi/jcCSw1O9q/DacrVLEOxlyqAHsGIBZiIXykK3MK9j
         v0nHcH42ckXd01lR3UXBgn9d0QSSq/ieYBAoxzPPJ6jRIDI2jrXoGqpo+8muXBCZgQ9v
         vNte75baC/dR7RNaR5l5zw9gVkso9FQUk3bk5BLdGcxL+lYg59FiLVsmiNLCI1aOs18M
         bZ+sJXwI6DddHsR+XUIcYs/99yNErP818A3F+STUCgnYva4AF4UePQ3/JeJuligOABDg
         zdeQ==
X-Forwarded-Encrypted: i=1; AFNElJ9KXK485TaKStWIGzhbNPUZmCSq2Qh38DJoBfBFg07rK2McpTlgbYGH0GVqNcT2EmBn8dABTL8=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywfe8wtlX3DZwOFYuCy8r+fCsJDB9sIrXX1OGpxUkqZG+JjGQ+6
	ni4LOfu0zmr9izozZU2angiDtQ8enfVtJ7b1ExGyxqNs6n3j6CC6RKqAIldQGHEdowW8MVLOuNV
	jeBFps6Ciz69yCz7ixl4u77/7NZtygdU=
X-Gm-Gg: Acq92OH73STmxerZhop0r9VkJ6uv7mKK9VunHwCcxc4ksO4aBp2MWtb+AX/FlypMj0U
	2IHb77nSWNH9yAwFsn2EnRD88GKb3IxRjPBNI3+oPiAiypK+KTgk1CGJ280E/vG2/PhtQVm1P2H
	m2Khak74Ra1QvjPRFSn8C2PJu2DTBs87KtLOceJzhJsYJH17nHD0B99lL0QNedsT0UdaGSqTfqY
	pZz8d7Wr/Y8d7vEkvcAsosZK7VvIvABzrEeGcfck9aOthu7PCy1KvavaRBxTjJopaVZXgrIn8cj
	FtGcX9g4J98UDrIwibgUP9Ft94PODw72urhRHDvj
X-Received: by 2002:a17:907:9719:b0:bd5:2a43:b471 with SMTP id
 a640c23a62f3a-bd52a43b4bfmr929160266b.48.1779208041621; Tue, 19 May 2026
 09:27:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260519151008.1399226-1-qkrwngud825@gmail.com> <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com>
In-Reply-To: <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Wed, 20 May 2026 01:27:10 +0900
X-Gm-Features: AVHnY4LdRR3qD6dMJRp9P0dqGJ2iwd73wpIsKyKrAimUaQe9thTXgPYirbbLgfM
Message-ID: <CAD14+f2p7D6eco+-O0X6zWwi-XaxGLs0nQKDAC8eVWhQmB1VhA@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, May 20, 2026 at 1:02=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 5/19/26 08:10, Juhyung Park wrote:
> >  #endif
> >       } else {
> > -             pagetable_free(page_ptdesc(page));
> > +             /*
> > +              * Use __free_pages() to honor @order: vmemmap PMD leaves
> > +              * freed here are not compound pages, so pagetable_free()
> > +              * would lose leak 511 of 512 pages per 2 MB chunk.
> > +              */
> > +             __free_pages(page, order);
> >       }
> >  }
>
> I find myself really wondering how much of this came from a human and
> how much from the LLM. Could you share that with us?

Not my first kernel contribution, just so you know. (first in mm tho)

I asked Claude to write both the commit body and comment and it was
too verbose. I manually trimmed it down.
Sorry if it still sounds too LLM-ish.

This was tested on a VM with virtualized CXL device and toggling it
back and forth was visibly causing leaks. kmemleak was unable to catch
this (rightfully so), so I skeptically asked Claude to see if it can
figure it out while pwd was the kernel source the VM was running.
"Access the VM at "ssh -p2223 root@192.168.0.185". There's a memory
leak whenever CXL memory switches modes via: daxctl reconfigure-device
--mode=3Dsystem-ram dax0.0 --force, daxctl reconfigure-device
--mode=3Ddevdax dax0.0 --force. Figure out why. If you need to reboot
the VM, do not do it yourself and ask me."

It did in 6 minutes and it basically told me to revert bf9e4e30f353. I
was very skeptical and reviewed manually (with my short knowledge of
mm) why this would be a correct fix.

>
> We're trying to get _away_ from using the 'struct page' APIs on page
> tables. This goes backwards. Worst case, do:
>
>         /* vmemmap PMD leaves are not compound pages */
>         for (i =3D 0; i < 1<<order; i++)
>                 pagetable_free(page_ptdesc(&page[i]));
>
> Right?

Shouldn't I worry about the loop overhead? With order =3D=3D 9, that's 512
iterations. That's compounded to O(N) when the entire memory size is
in consideration.

>
> Even better would be to *make* these compound pages.
>
> Even better than that would be to use some 'struct ptdesc' space to
> explicitly store the order, just like compound pages. But that's
> probably not trivial and probably not great for a bug fix.
