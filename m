From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8] libnvdimm/dax: Pick the right alignment default when
 creating dax devices
Date: Wed, 4 Sep 2019 19:59:43 -0700
Message-ID: <CAPcyv4hBHjrTSHRkwU8CQcXF4EHoz0rzu6L-U-QxRpWkPSAhUQ@mail.gmail.com>
References: <20190904065320.6005-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hD8SAFNNAWBP9q55wdPf-HYTEjpS4m+rT0VPoGodZULw@mail.gmail.com>
 <33b377ac-86ea-b195-fd83-90c01df604cc@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <33b377ac-86ea-b195-fd83-90c01df604cc-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "Kirill A . Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> > Keep this 'static' there's no usage of this routine outside of pfn_devs.c
> >
> >>   {
> >> -       /*
> >> -        * This needs to be a non-static variable because the *_SIZE
> >> -        * macros aren't always constants.
> >> -        */
> >> -       const unsigned long supported_alignments[] = {
> >> -               PAGE_SIZE,
> >> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >> -               HPAGE_PMD_SIZE,
> >> +       static unsigned long supported_alignments[3];
> >
> > Why is marked static? It's being dynamically populated each invocation
> > so static is just wasting space in the .data section.
> >
>
> The return of that function is address and that would require me to use
> a global variable. I could add a check
>
> /* Check if initialized */
>   if (supported_alignment[1])
>         return supported_alignment;
>
> in the function to updating that array every time called.

Oh true, my mistake. I was thrown off by the constant
re-initialization. Another option is to pass in the storage since the
array needs to be populated at run time. Otherwise I would consider it
a layering violation for libnvdimm to assume that
has_transparent_hugepage() gives a constant result. I.e. put this

        unsigned long aligns[4] = { [0] = 0, };

...in align_store() and supported_alignments_show() then
nd_pfn_supported_alignments() does not need to worry about
zero-initializing the fields it does not set.

> >> +       supported_alignments[0] = PAGE_SIZE;
> >> +
> >> +       if (has_transparent_hugepage()) {
> >> +
> >> +               supported_alignments[1] = HPAGE_PMD_SIZE;
> >> +
> >>   #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> -               HPAGE_PUD_SIZE,
> >> -#endif
> >> +               supported_alignments[2] = HPAGE_PUD_SIZE;
> >>   #endif
> >
> > This ifdef could be hidden in by:
> >
> > if IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> >
> > ...or otherwise moving this to header file with something like
> > NVDIMM_PUD_SIZE that is optionally 0 or HPAGE_PUD_SIZE depending on
> > the config
>
>
> I can switch to if IS_ENABLED but i am not sure that make it any
> different in the current code. So I will keep it same?

It at least follows the general guidance to keep #ifdef out of .c files.

>
> NVDIMM_PUD_SIZE is an indirection I find confusing.
>

Ok.

> >
> > Ok, this is better, but I think it can be clarified further.
> >
> > "For dax vmas, try to always use hugepage mappings. If the kernel does
> > not support hugepages, fsdax mappings will fallback to PAGE_SIZE
> > mappings, and device-dax namespaces, that try to guarantee a given
> > mapping size, will fail to enable."
> >
> > The last sentence about PAGE_SIZE namespaces is not relevant to
> > __transparent_hugepage_enabled(), it's an internal implementation
> > detail of the device-dax driver.
> >
>
> I will use the above update.
>

Thanks.
