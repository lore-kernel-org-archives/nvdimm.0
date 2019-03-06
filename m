Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] mm/dax: Don't enable huge dax mapping by default
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com> <20190306124453.126d36d8@naga.suse.cz>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Wed, 6 Mar 2019 18:15:25 +0530
MIME-Version: 1.0
In-Reply-To: <20190306124453.126d36d8@naga.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Message-Id: <df01bf6e-84a1-53fb-bf0c-0957af2f79e1@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Oliver <oohall@gmail.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 3/6/19 5:14 PM, Michal Suchánek wrote:
> On Wed, 06 Mar 2019 14:47:33 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> wrote:
> 
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>>> On Thu, Feb 28, 2019 at 1:40 AM Oliver <oohall@gmail.com> wrote:
>>>>
>>>> On Thu, Feb 28, 2019 at 7:35 PM Aneesh Kumar K.V
>>>> <aneesh.kumar@linux.ibm.com> wrote:
>   
>> Also even if the user decided to not use THP, by
>> echo "never" > transparent_hugepage/enabled , we should continue to map
>> dax fault using huge page on platforms that can support huge pages.
> 
> Is this a good idea?
> 
> This knob is there for a reason. In some situations having huge pages
> can severely impact performance of the system (due to host-guest
> interaction or whatever) and the ability to really turn off all THP
> would be important in those cases, right?
> 

My understanding was that is not true for dax pages? These are not 
regular memory that got allocated. They are allocated out of /dev/dax/ 
or /dev/pmem*. Do we have a reason not to use hugepages for mapping 
pages in that case?

-aneesh
