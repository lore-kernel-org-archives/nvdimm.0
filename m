Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3F9E2129EBA6
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jun 2019 10:08:59 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH -next] mm/hotplug: skip bad PFNs from pfn_to_online_page()
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
Date: Fri, 14 Jun 2019 13:08:48 -0400
In-Reply-To: <16108dac-a4ca-aa87-e3b0-a79aebdcfafd@linux.ibm.com> (Aneesh
 Kumar K. V.'s message of "Fri, 14 Jun 2019 22:25:18 +0530")
Message-ID: <x49ef3wytzz.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> On 6/14/19 10:06 PM, Dan Williams wrote:
>> On Fri, Jun 14, 2019 at 9:26 AM Aneesh Kumar K.V
>> <aneesh.kumar@linux.ibm.com> wrote:
>
>>> Why not let the arch
>>> arch decide the SUBSECTION_SHIFT and default to one subsection per
>>> section if arch is not enabled to work with subsection.
>>
>> Because that keeps the implementation from ever reaching a point where
>> a namespace might be able to be moved from one arch to another. If we
>> can squash these arch differences then we can have a common tool to
>> initialize namespaces outside of the kernel. The one wrinkle is
>> device-dax that wants to enforce the mapping size,
>
> The fsdax have a much bigger issue right? The file system block size
> is the same as PAGE_SIZE and we can't make it portable across archs
> that support different PAGE_SIZE?

File system blocks are not tied to page size.  They can't be *bigger*
than the page size currently, but they can be smaller.

Still, I don't see that as an arugment against trying to make the
namespaces work across architectures.  Consider a user who only has
sector mode namespaces.  We'd like that to work if at all possible.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
