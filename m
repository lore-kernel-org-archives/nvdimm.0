Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54FD81C7.3080000@plexistor.com>
Date: Mon, 09 Mar 2015 13:19:35 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
References: <54F82CE0.4040502@plexistor.com>	<54F82ED1.8030900@plexistor.com> <CAPcyv4i5WfR48hmGwqLDgTFRpUPaAxusHXKKUKY4FBxu1Mqm+w@mail.gmail.com>
In-Reply-To: <CAPcyv4i5WfR48hmGwqLDgTFRpUPaAxusHXKKUKY4FBxu1Mqm+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 03/05/2015 10:56 PM, Dan Williams wrote:
> On Thu, Mar 5, 2015 at 2:24 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>>
<>
>> Now the ACPI comity, as far as I know, did not yet define a
>> standard type for NvDIMM. Also, as far as I know any NvDIMM
>> standard will only be defined for DDR4. So DDR3 NvDIMM is
>> probably stuck with this none STD type.
> 
> There's no relation between E820 types and DDR technology revisions.
> 

Yes and no, I mean the DDR4 has extra legs and signals defined
for NvDIMM. So DDR3 will always mean different style of NvDIMM.

You tell me. Say the standard finally comes out. Will I have a
new bios from Intel for my DDR3 system here in the lab that will
report the new STD type ?

What I meant is that DDR3 is too old for the proposed STD and probably
only DDR4 NvDIMMs will be supported in systems. The way the STD defined
it.

<>
>> In this patch I name type-12 "unknown-12". This is because of
>> ACPI politics that refuse to reserve type-12 as DDR3-NvDIMM
> 
> It's not "politics".  Setting standards takes time and the platforms
> in question simply jumped the gun to enable a proof-of-concept.
> 

So ye, but once you have 100,000 devices out there, then the dichotomy
between standards-takes-time vs proof-of-concept, becomes politics.

This is the definition of politics, when life moves faster than some
"body", the "body" stands on its back feet and shoots fire from
his head.

>> and members keep saying:
>>         "What if ACPI assigns type-12 for something else in future"
>>
>> [And I say: Then just don't. Please?]
> 
> Once a standard number is assigned, platform firmwares can update
> type-12 to that number.  We might consider a compile time override for
> these niche/pre-standard systems that can't/won't update, but it's not
> clear to me that we even need to go that far.
> 

OK, so I do not understand what you want. Yes or No to this patch?

This patch with unknown-12 is for NOW. For systems already running.

So we can differentiate between  reserved-unknown which might mean
type-13 and this here bastard type-12 which we know is NvDIMM but
for future sake we do not call by name?

Or maybe we should call it NVDIMM-12 ?

Thanks
Boaz

