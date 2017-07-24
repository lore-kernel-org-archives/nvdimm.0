Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD99C2095DB9C
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jul 2017 16:41:43 -0700 (PDT)
Subject: Re: don't control-c during ndctl create-namespace?
References: <556dc70b-2759-b483-868e-041f1be772f7@hpe.com>
 <CAPcyv4jHi6UW+EHpotJyX+3CtY=_KqG3+84z8p6zLAWR5Z3BLQ@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <59768605.2040308@hpe.com>
Date: Mon, 24 Jul 2017 19:43:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jHi6UW+EHpotJyX+3CtY=_KqG3+84z8p6zLAWR5Z3BLQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/24/2017 07:35 PM, Dan Williams wrote:
> On Mon, Jul 24, 2017 at 4:15 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> Hi Dan,
>>
>> I've got 4 NVDIMMs in an interleave set in a configuration that supports labels.
>> I'm running a 4.12 kernel with the latest ndctl.
>>
>> I had three namespaces configured and all seemed well.  When I configured the
>> fourth one, I made a mistake in the name so I hit control-c.  I wasn't sure what
>> state I was in but according to what I could see with ndctl, it had created the
>> namespace but not  enabled it, so I enabled it manually with ndctl and that
>> seemed ok.
>>
>> Then I tried to use ndctl create-namespace to change the name, which failed
>> because the namespace was enabled so I disabled it and tried again.  At some
>> point, not really sure where, I got this kernel warning:
>>
>> # [ 5224.196085] nd namespace4.3: failed to track label: 4
>>
>> (details in the attached file)
>>
>> At this point I rebooted the system.  When it came back up, nmem0 was disabled.
>> I dumped the labels (also attached) and I see that nmem0 has some extra labels
>> that correspond to the namespace that I was struggling with.
>>
>> I think my troubles started with the control-c. It doesn't look like ndctl traps
>> signals when creating namespaces so perhaps we can get into an inconsistent
>> state.
>>
>> It also seems like that kernel warning is a bit more important than a
>> WARN_ONCE would imply.  I think that was the beginning of the end of my
>> configuration.  It might have been better to just panic.
> 
> In general if the system is even remotely recoverable we don't panic.
> In this case it is recoverable. The WARN_ONCE() is really there as a
> loud, "this is a kernel bug, but we'll do our best to keep going".

Keeping going is ok unless you're risking data.

>> I was trying to figure out if I could fix my configuration without
>> losing the good namespaces but I don't see a way.  The check-labels option
>> isn't very helpful because I think it only looks at the info blocks,
>> which are fine, even though the labels on nmem0 are not.  The destroy-namespace
>> option doesn't help because it only works with a good namespace.
>>
>> I'm going to wipe my nvdimms and start over.  I suspect the problem is
>> reproducible but it could depend on the timing of the control-c, unless
>> the root cause was actually trying to rename a namespace.  Maybe I'll try
>> that again but not today.
> 
> The recovery method when the labels are corrupted is:
> 
> ndctl disable-region all
> ndctl zero-labels all
> ndctl enable-region all
> 
> ...and that should get you back to square one.

Right, but that blows away all my namespaces.  I was hoping to find a way
to just fix up (delete) what appeared to be extraneous labels.
> 
> If you are able to reproduce I'd like to see the state of the DIMM
> label areas. You can dump them in json format with the following:
> 
> ndctl read-labels -j all

That was in one of the attachments.

-- ljk
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
