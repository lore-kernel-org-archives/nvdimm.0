Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF1DB211B76CF
 for <linux-nvdimm@lists.01.org>; Mon, 28 Jan 2019 17:34:54 -0800 (PST)
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/5] mm/resource: move HMM pr_debug() deeper into resource
 code
In-Reply-To: <b191ad4a-da4e-9bc7-4468-d6e4a8b3d66f@intel.com>
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231444.38182DD8@viggo.jf.intel.com>
 <CAErSpo4oSjQAxeRy8Tz_Jvo+cRovBvVx9WBeNb_P6PxT-A_XhA@mail.gmail.com>
 <b191ad4a-da4e-9bc7-4468-d6e4a8b3d66f@intel.com>
Date: Tue, 29 Jan 2019 12:34:50 +1100
Message-ID: <87imy8s0ud.fsf@concordia.ellerman.id.au>
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
To: Dave Hansen <dave.hansen@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, Huang Ying <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, zwisler@kernel.org, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Dave Hansen <dave.hansen@intel.com> writes:
> On 1/25/19 1:18 PM, Bjorn Helgaas wrote:
>> On Thu, Jan 24, 2019 at 5:21 PM Dave Hansen <dave.hansen@linux.intel.com> wrote:
>>> diff -puN kernel/resource.c~move-request_region-check kernel/resource.c
>>> --- a/kernel/resource.c~move-request_region-check       2019-01-24 15:13:14.453199539 -0800
>>> +++ b/kernel/resource.c 2019-01-24 15:13:14.458199539 -0800
>>> @@ -1123,6 +1123,16 @@ struct resource * __request_region(struc
>>>                 conflict = __request_resource(parent, res);
>>>                 if (!conflict)
>>>                         break;
>>> +               /*
>>> +                * mm/hmm.c reserves physical addresses which then
>>> +                * become unavailable to other users.  Conflicts are
>>> +                * not expected.  Be verbose if one is encountered.
>>> +                */
>>> +               if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
>>> +                       pr_debug("Resource conflict with unaddressable "
>>> +                                "device memory at %#010llx !\n",
>>> +                                (unsigned long long)start);
>> 
>> I don't object to the change, but are you really OK with this being a
>> pr_debug() message that is only emitted when enabled via either the
>> dynamic debug mechanism or DEBUG being defined?  From the comments, it
>> seems more like a KERN_INFO sort of message.
>
> I left it consistent with the original message that was in the code.
> I'm happy to change it, though, if the consumers of it (Jerome,
> basically) want something different.

At least using pr_debug() doesn't match the comment, ie. the comment
says "Be verbose" but pr_debug() is silent by default.

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
