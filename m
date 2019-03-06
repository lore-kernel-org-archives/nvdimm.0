Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 6 Mar 2019 16:06:21 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/2] mm/dax: Don't enable huge dax mapping by default
Message-ID: <20190306130621.qrwybv5dpv3bzyym@kshutemo-mobl1>
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com>
 <20190306124453.126d36d8@naga.suse.cz>
 <df01bf6e-84a1-53fb-bf0c-0957af2f79e1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df01bf6e-84a1-53fb-bf0c-0957af2f79e1@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>, Dan Williams <dan.j.williams@intel.com>, Oliver <oohall@gmail.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 06, 2019 at 06:15:25PM +0530, Aneesh Kumar K.V wrote:
> On 3/6/19 5:14 PM, Michal Such�nek wrote:
> > On Wed, 06 Mar 2019 14:47:33 +0530
> > "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> wrote:
> > 
> > > Dan Williams <dan.j.williams@intel.com> writes:
> > > 
> > > > On Thu, Feb 28, 2019 at 1:40 AM Oliver <oohall@gmail.com> wrote:
> > > > > 
> > > > > On Thu, Feb 28, 2019 at 7:35 PM Aneesh Kumar K.V
> > > > > <aneesh.kumar@linux.ibm.com> wrote:
> > > Also even if the user decided to not use THP, by
> > > echo "never" > transparent_hugepage/enabled , we should continue to map
> > > dax fault using huge page on platforms that can support huge pages.
> > 
> > Is this a good idea?
> > 
> > This knob is there for a reason. In some situations having huge pages
> > can severely impact performance of the system (due to host-guest
> > interaction or whatever) and the ability to really turn off all THP
> > would be important in those cases, right?
> > 
> 
> My understanding was that is not true for dax pages? These are not regular
> memory that got allocated. They are allocated out of /dev/dax/ or
> /dev/pmem*. Do we have a reason not to use hugepages for mapping pages in
> that case?

Yes. Like when you don't want dax to compete for TLB with mission-critical
application (which uses hugetlb for instance).

-- 
 Kirill A. Shutemov
