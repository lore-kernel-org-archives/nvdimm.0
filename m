Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: [PATCH] x86: Add warning when memmap=nn!ss and
 CONFIG_RANDOMIZE_BASE enabled
References: <147941499514.131046.6450643991764692220.stgit@djiang5-desk3.ch.intel.com>
 <alpine.DEB.2.20.1611181224440.3615@nanos>
 <c3dc208d-c604-0a45-13a4-2aa0e92a7ac7@intel.com>
 <CAA9_cmf9bPnPLZN0m1_OtLxZBJZhE6X16fRzkC7WOQQBZnu4QA@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <ef0f4b1c-2a18-3dd9-a2f4-8c49d980c2ff@intel.com>
Date: Fri, 18 Nov 2016 10:13:05 -0700
MIME-Version: 1.0
In-Reply-To: <CAA9_cmf9bPnPLZN0m1_OtLxZBJZhE6X16fRzkC7WOQQBZnu4QA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, the arch/x86 maintainers <x86@kernel.org>, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



On 11/18/2016 10:07 AM, Dan Williams wrote:
> On Fri, Nov 18, 2016 at 8:47 AM, Dave Jiang <dave.jiang@intel.com>
> wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA256
>> 
>> 
>> 
>> On 11/18/2016 04:33 AM, Thomas Gleixner wrote:
>>> On Thu, 17 Nov 2016, Dave Jiang wrote:
>>>> CONFIG_RANDOMIZE_BASE can place the kernel anywhere. This
>>>> causes a problem for when memmap=nn!ss is used. This
>>>> information is not known until after the kernel starts
>>>> executing and the decision for where the randomized base goes
>>>> happens before the kernel is uncompressed. memmap=nn!ss is
>>>> not reliable in the presence of CONFIG_RANDOMIZE_BASE.
>>> 
>>> So this is a description of a problem. Now what's missing is a 
>>> useful explanation why you think that adding a warning will
>>> make things better.
>>> 
>>> IMNSHO adding that warning is just a pointless exercise.
>>> 
>>> Why aren't you addressing the real issue and make the boot
>>> code parse that option and prevent that region from being used
>>> for kernel placement?
>>> 
>>> The same issue exists for other memmap options as well, not
>>> just for that PMEM thingy.
>>> 
>>> Thanks,
>>> 
>>> tglx
>>> 
>> 
>> I wasn't planning to fix it because the pmem memmap option is
>> really only used for testing. Is it possible to parse the kernel
>> commandline parameters before the kernel is uncompressed?
> 
> Apologies, this was my mistake.  I missed that we have early boot 
> command line parsing in addition to the in-kernel cmdline parsing.
> 
> Dave, I think we could fix this in: 
> arch/x86/boot/compressed/kaslr.c::choose_random_location().
> 

Actually it was my fault. I was digging around that and somehow
totally missed the early command line parsing bits.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlgvNqEACgkQZBXE8WajuT71LAD9GGV5sL9bAkunWlZZylNGZ+Ug
XRfcnKB1g1+SJ4JFDuYA/RxrHAyBBhteIfSuORl5T+1ACYqwTA0MuHFwiASHXbuQ
=+j9S
-----END PGP SIGNATURE-----
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
