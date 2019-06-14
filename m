Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22ED12194D3B3
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jun 2019 10:14:18 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id i8so3306673oth.10
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jun 2019 10:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <1560366952-10660-1-git-send-email-cai@lca.pw>
 <CAPcyv4hn0Vz24s5EWKr39roXORtBTevZf7dDutH+jwapgV3oSw@mail.gmail.com>
 <CAPcyv4iuNYXmF0-EMP8GF5aiPsWF+pOFMYKCnr509WoAQ0VNUA@mail.gmail.com>
 <1560376072.5154.6.camel@lca.pw> <87lfy4ilvj.fsf@linux.ibm.com>
 <20190614153535.GA9900@linux>
 <c3f2c05d-e42f-c942-1385-664f646ddd33@linux.ibm.com>
 <CAPcyv4j_QQB8SrhTqL2mnEEHGYCg4H7kYanChiww35k0fwNv8Q@mail.gmail.com>
 <24fcb721-5d50-2c34-f44b-69281c8dd760@linux.ibm.com>
 <CAPcyv4ixq6aRQLdiMAUzQ-eDoA-hGbJQ6+_-K-nZzhXX70m1+g@mail.gmail.com>
 <16108dac-a4ca-aa87-e3b0-a79aebdcfafd@linux.ibm.com>
 <x49ef3wytzz.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ef3wytzz.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Jun 2019 10:14:06 -0700
Message-ID: <CAPcyv4iADcyPP4su4tMnyMp8_uiBu8BYCSOjOgck8hE0ZPzLmg@mail.gmail.com>
Subject: Re: [PATCH -next] mm/hotplug: skip bad PFNs from pfn_to_online_page()
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 14, 2019 at 10:09 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
>
> > On 6/14/19 10:06 PM, Dan Williams wrote:
> >> On Fri, Jun 14, 2019 at 9:26 AM Aneesh Kumar K.V
> >> <aneesh.kumar@linux.ibm.com> wrote:
> >
> >>> Why not let the arch
> >>> arch decide the SUBSECTION_SHIFT and default to one subsection per
> >>> section if arch is not enabled to work with subsection.
> >>
> >> Because that keeps the implementation from ever reaching a point where
> >> a namespace might be able to be moved from one arch to another. If we
> >> can squash these arch differences then we can have a common tool to
> >> initialize namespaces outside of the kernel. The one wrinkle is
> >> device-dax that wants to enforce the mapping size,
> >
> > The fsdax have a much bigger issue right? The file system block size
> > is the same as PAGE_SIZE and we can't make it portable across archs
> > that support different PAGE_SIZE?
>
> File system blocks are not tied to page size.  They can't be *bigger*
> than the page size currently, but they can be smaller.
>
> Still, I don't see that as an arugment against trying to make the
> namespaces work across architectures.  Consider a user who only has
> sector mode namespaces.  We'd like that to work if at all possible.

Even with fsdax namespaces I don't see the concern. Yes, DAX might be
disabled if the filesystem on the namespace has a block size that is
smaller than the current system PAGE_SIZE, but the filesystem will
still work. I.e. it's fine to put a 512 byte block size filesystem on
a system that has a 4K PAGE_SIZE, you only lose DAX operations, not
your data access.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
