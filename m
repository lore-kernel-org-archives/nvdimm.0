Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com
 [IPv6:2607:f8b0:4864:20::443])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2505621197B20
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 01:44:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id i19so13225578pfd.0
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 01:44:44 -0700 (PDT)
Date: Tue, 19 Mar 2019 11:44:39 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/2] mm/dax: Don't enable huge dax mapping by default
Message-ID: <20190319084439.eya2pisiirattuil@kshutemo-mobl1>
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com>
 <20190306124453.126d36d8@naga.suse.cz>
 <df01bf6e-84a1-53fb-bf0c-0957af2f79e1@linux.ibm.com>
 <CAPcyv4iLm09DSiF3niFprP3PTFrgB5pZPp9AysBpRa-m725tmw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iLm09DSiF3niFprP3PTFrgB5pZPp9AysBpRa-m725tmw@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 13, 2019 at 09:07:13AM -0700, Dan Williams wrote:
> On Wed, Mar 6, 2019 at 4:46 AM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:
> >
> > On 3/6/19 5:14 PM, Michal Such=E1nek wrote:
> > > On Wed, 06 Mar 2019 14:47:33 +0530
> > > "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> wrote:
> > >
> > >> Dan Williams <dan.j.williams@intel.com> writes:
> > >>
> > >>> On Thu, Feb 28, 2019 at 1:40 AM Oliver <oohall@gmail.com> wrote:
> > >>>>
> > >>>> On Thu, Feb 28, 2019 at 7:35 PM Aneesh Kumar K.V
> > >>>> <aneesh.kumar@linux.ibm.com> wrote:
> > >
> > >> Also even if the user decided to not use THP, by
> > >> echo "never" > transparent_hugepage/enabled , we should continue to =
map
> > >> dax fault using huge page on platforms that can support huge pages.
> > >
> > > Is this a good idea?
> > >
> > > This knob is there for a reason. In some situations having huge pages
> > > can severely impact performance of the system (due to host-guest
> > > interaction or whatever) and the ability to really turn off all THP
> > > would be important in those cases, right?
> > >
> >
> > My understanding was that is not true for dax pages? These are not
> > regular memory that got allocated. They are allocated out of /dev/dax/
> > or /dev/pmem*. Do we have a reason not to use hugepages for mapping
> > pages in that case?
> =

> The problem with the transparent_hugepage/enabled interface is that it
> conflates performing compaction work to produce THP-pages with the
> ability to map huge pages at all.

That's not [entirely] true. transparent_hugepage/defrag gates heavy-duty
compaction. We do only very limited compaction if it's not advised by
transparent_hugepage/defrag.

I believe DAX has to respect transparent_hugepage/enabled. Or not
advertise its huge pages as THP. It's confusing for user.

-- =

 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
