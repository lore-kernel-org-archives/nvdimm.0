From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8] libnvdimm/dax: Pick the right alignment default when
 creating dax devices
Date: Wed, 4 Sep 2019 22:15:57 -0700
Message-ID: <CAPcyv4impX2OEd3ZATz_4_UjOvC4N78uU+PBPRK+id3Nh0EPCw@mail.gmail.com>
References: <20190904065320.6005-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hD8SAFNNAWBP9q55wdPf-HYTEjpS4m+rT0VPoGodZULw@mail.gmail.com>
 <33b377ac-86ea-b195-fd83-90c01df604cc@linux.ibm.com>
 <CAPcyv4hBHjrTSHRkwU8CQcXF4EHoz0rzu6L-U-QxRpWkPSAhUQ@mail.gmail.com>
 <d46212fb-7bbb-3db8-5a65-2c8799021fd6@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <d46212fb-7bbb-3db8-5a65-2c8799021fd6-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
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

On Wed, Sep 4, 2019 at 9:10 PM Aneesh Kumar K.V
<aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> wrote:
>
> On 9/5/19 8:29 AM, Dan Williams wrote:
> >>> Keep this 'static' there's no usage of this routine outside of pfn_devs.c
> >>>
> >>>>    {
> >>>> -       /*
> >>>> -        * This needs to be a non-static variable because the *_SIZE
> >>>> -        * macros aren't always constants.
> >>>> -        */
> >>>> -       const unsigned long supported_alignments[] = {
> >>>> -               PAGE_SIZE,
> >>>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >>>> -               HPAGE_PMD_SIZE,
> >>>> +       static unsigned long supported_alignments[3];
> >>>
> >>> Why is marked static? It's being dynamically populated each invocation
> >>> so static is just wasting space in the .data section.
> >>>
> >>
> >> The return of that function is address and that would require me to use
> >> a global variable. I could add a check
> >>
> >> /* Check if initialized */
> >>    if (supported_alignment[1])
> >>          return supported_alignment;
> >>
> >> in the function to updating that array every time called.
> >
> > Oh true, my mistake. I was thrown off by the constant
> > re-initialization. Another option is to pass in the storage since the
> > array needs to be populated at run time. Otherwise I would consider it
> > a layering violation for libnvdimm to assume that
> > has_transparent_hugepage() gives a constant result. I.e. put this
> >
> >          unsigned long aligns[4] = { [0] = 0, };
> >
> > ...in align_store() and supported_alignments_show() then
> > nd_pfn_supported_alignments() does not need to worry about
> > zero-initializing the fields it does not set.
>
> That requires callers to track the size of aligns array. If we add
> different alignment support later, we will end up updating all the call
> site?

2 sites for something that gets updated maybe once a decade?

>
> How about?
>
> static const unsigned long *nd_pfn_supported_alignments(void)
> {
>         static unsigned long supported_alignments[4];
>
>         if (supported_alignments[0])
>                 return supported_alignments;
>
>         supported_alignments[0] = PAGE_SIZE;
>
>         if (has_transparent_hugepage()) {
>                 supported_alignments[1] = HPAGE_PMD_SIZE;
>                 if (IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
>                         supported_alignments[2] = HPAGE_PUD_SIZE;
>         }

Again, this makes assumptions that has_transparent_hugepage() always
returns the same result every time it is called.
