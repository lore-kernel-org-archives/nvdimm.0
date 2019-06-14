Return-Path: <owner-linux-mm@kvack.org>
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
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Fri, 14 Jun 2019 22:25:18 +0530
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ixq6aRQLdiMAUzQ-eDoA-hGbJQ6+_-K-nZzhXX70m1+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Message-Id: <16108dac-a4ca-aa87-e3b0-a79aebdcfafd@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>, Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 6/14/19 10:06 PM, Dan Williams wrote:
> On Fri, Jun 14, 2019 at 9:26 AM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:

>> Why not let the arch
>> arch decide the SUBSECTION_SHIFT and default to one subsection per
>> section if arch is not enabled to work with subsection.
> 
> Because that keeps the implementation from ever reaching a point where
> a namespace might be able to be moved from one arch to another. If we
> can squash these arch differences then we can have a common tool to
> initialize namespaces outside of the kernel. The one wrinkle is
> device-dax that wants to enforce the mapping size,

The fsdax have a much bigger issue right? The file system block size is 
the same as PAGE_SIZE and we can't make it portable across archs that 
support different PAGE_SIZE?

-aneesh
