Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EFADD1A1E26
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 12:57:35 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id j185so78008839oih.0
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 12:57:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7096cc8e-f49b-5900-5ffd-a4633e827c62@hpe.com>
References: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
 <a3a59c82-ccbb-75ac-ee21-12c58ac51d39@hpe.com>
 <20160728094518.cqtaavikkrzqnf7k@c203.arch.suse.de>
 <92aa03b2-326d-a932-90df-36cae9b11ecc@hpe.com>
 <CAPcyv4iuz-KbZ_cQ6R7nueyXYsiA43zwWqTX0JCJuYaqAr9+bQ@mail.gmail.com>
 <7096cc8e-f49b-5900-5ffd-a4633e827c62@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Jul 2016 12:57:34 -0700
Message-ID: <CAPcyv4ioWKYafQ7cgPK5hvhtFHKabM9G9Q6gpunaUfce2fY6Vw@mail.gmail.com>
Subject: Re: HPE SMART data retreival
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 28, 2016 at 11:46 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
>
> On 7/28/2016 2:20 PM, Dan Williams wrote:
>> On Thu, Jul 28, 2016 at 10:43 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>
>>>
>>> On 7/28/2016 5:45 AM, Johannes Thumshirn wrote:
>>>> On Wed, Jul 27, 2016 at 02:23:51PM -0400, Linda Knippers wrote:
>>>>> Hi Johannes,
>>>>>
>>>>> I hope Dan and Jerry also reply but I have recently started looking at
>>>>> this too and have some comments below.
>>>>
>>>> So if we two are looking into it we might want to work together so we don't do
>>>> all the work twice.
>>>
>>> Definitely!
>>>
>>>> I've pasted my current work to export HPE DIMM commands at the bottom of the
>>>> mail, but I don't like it very much (see below for a proposal of a more
>>>> elegant way).
>>>>
>>>>>
>>>>> On 7/27/2016 6:35 AM, Johannes Thumshirn wrote:
>>>>>> Hi Dan and Jerry,
>>>>>>
>>>>>> I'm currently looking into SMART data retrieval on HPE NVDIMMs.
>>>>>>
>>>>>> After the first obstacle (like getting cat
>>>>>> /sys/class/nd/ndctl0/device/nmem0/commands reutrn smart so ndctl will issue
>>>>>> the ioctl) I ran into a rather nasty problem. According to [1] HPEDIMMs
>>>>>> need the input buffer specially crafted for SMART data, according to [2]
>>>>>> Intel DIMMs don't.
>>>>>
>>>>> It is unfortunate that the DSM functions are different for different NVDIMM
>>>>>
>>>>> types.  There is a desire for standardization but for now this is what we have.
>>>>
>>>> Sure, let's see what we can come up with to "fix" the situation.
>>>>
>>>> I had a quick chat here internally at SUSE and one suggestion was to create
>>>> something, let's call it "filter drivers", to support different DSMs for
>>>> different NVDIMM families. I actually like the idea and if no-one objects I'll
>>>> try to implement some kind of prototype for the "filter drivers".
>>>
>>> I think a question we need to answer is what should be in the kernel vs. in user
>>> space and what the interface between the two should look like.  The kernel
>>> doesn't necessarily need to know that function 1 returns health information
>>> and function 2 returns threshold information unless it needs the information
>>> itself.  I think the intent of cmd_call was just as a pass-through mechanism
>>> to keep from adding more code into the kernel.  We could create ndctl functions
>>> instead.  I know this is different from how the original Intel DSM functions
>>> are implemented but that could be considered legacy code to support existing
>>> applications at this point.
>>>
>>> For history, the first discussions about this approach were on the nvdimm
>>> list back in November and it went from there.
>>> https://lists.01.org/pipermail/linux-nvdimm/2015-November/002721.html
>>>
>>
>> To me, the cmd_call mechanism is useful for commands that libnvdimm
>> does not and may never care about.  For the generally useful commands
>> that the kernel needs to be involved with I'd like to define a common
>> kernel command set and do in-kernel translation across the
>> different-for-difference sake implementations.
>
> I don't think any of them are different-for-different sake.
>
> No one has time for busy work.
>
>
>
> It takes a lot of work and collaboration to standardize these things
>
> and so far, we're still not even through the potential root device functions.
>
> Standardizing functions across different device types with different
>
> characteristics is even harder.

I understand that it is hard, we are where we are due to expediency,
and Linux now supports all the known first generation command sets.
The "different for difference sake" comment was made with my Linux hat
on where I see the kernel supporting the _INTEL and _HPE2 command sets
which are frustratingly similar.

Linux has always been a vehicle for discovering and refactoring
commonality across vendors.  We can use a common Linux command format
to inform the standardization discussion going forward.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
