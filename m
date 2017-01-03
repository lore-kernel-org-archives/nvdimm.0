Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: [PATCH] x86: fix kaslr and memmap collision
References: <147977413859.13657.2181994710415174471.stgit@djiang5-desk3.ch.intel.com>
 <20161122084754.GA25596@gmail.com>
 <CAPcyv4i+2NxdTc1xzVL+KQs8hLfUhbpGX3zstO_b=RY3hCy64w@mail.gmail.com>
 <20170103083137.GA15788@x1>
 <CAPcyv4jTsUD25OGW2iwF1V7i2CTF_-+e4CsTw8NQXXVE8QhsYw@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c4b01273-abe2-c420-d20d-4817f5314e9e@intel.com>
Date: Tue, 3 Jan 2017 13:15:12 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jTsUD25OGW2iwF1V7i2CTF_-+e4CsTw8NQXXVE8QhsYw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Baoquan He <bhe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, X86 ML <x86@kernel.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, dyoung@redhat.com, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 01/03/2017 11:24 AM, Dan Williams wrote:
> On Tue, Jan 3, 2017 at 12:31 AM, Baoquan He <bhe@redhat.com> wrote:
>> Hi Dan,
>>
>> On 11/22/16 at 09:26am, Dan Williams wrote:
>>> [ replying for Dave since he's offline today and tomorrow ]
>>>
>>> On Tue, Nov 22, 2016 at 12:47 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>>
>>>> * Dave Jiang <dave.jiang@intel.com> wrote:
>>>>
>>>>> CONFIG_RANDOMIZE_BASE relocates the kernel to a random base address.
>>>>> However it does not take into account the memmap= parameter passed in from
>>>>> the kernel commandline.
>>>>
>>>> memmap= parameters are often used as a list.
>>>>
>>>>> [...] This results in the kernel sometimes being put in the middle of the user
>>>>> memmap. [...]
>>>>
>>>> What does this mean? If memmap= is used to re-define the memory map then the
>>>> kernel getting in the middle of a RAM area is what we want, isn't it? What we
>>>> don't want is for the kernel to get into reserved areas, right?
>>>
>>> Right, this is about teaching kaslr to not land the kernel in newly
>>> defined reserved regions that were not marked reserved in the initial
>>> e820 map from platform firmware.
>>
>> If only tell kaslr to not land kernel in newly defined reserved regions,
>> memory added by "memmap=nn[KMG]@ss[KMG]" should not be avoided since
>> it's usable memory. Kernel randomized into this region is also what we
>> want. Not sure if I understand it right.
> 
> You're right, this is supposed to be for memmap=nn!ss cases which
> defines reserved persistent memory ranges, not memmap=nn@ss which
> defines usable memory.
> 
> We need to fix mem_avoid_memmap() to only skip memmap= statements that
> specify reserved memory.
> 

I think nn@ss is the only one that we should skip over, otherwise
everything else looks like should be avoided. I'll update.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
