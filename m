Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6216.austin.hp.com (g1t6216.austin.hp.com [15.73.96.123])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3F7E1A1ED5
 for <linux-nvdimm@lists.01.org>; Mon,  6 Jun 2016 12:36:50 -0700 (PDT)
Subject: Re: [PATCH 01/13] driver core, libnvdimm: disable manual unbind of
 dimms while region active
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146507355828.8347.11600179233094511139.stgit@dwillia2-desk3.amr.corp.intel.com>
 <0d64fc79-fdfa-9d50-c8b8-fc7c3e79f1f4@hpe.com>
 <CAPcyv4j2saB7=k=uw3Ze-cmsHW-PkHY=Xez4AomAxWUFR1-x2Q@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <2860536d-ce69-1d2e-4ca5-ca2f10b9695e@hpe.com>
Date: Mon, 6 Jun 2016 15:36:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j2saB7=k=uw3Ze-cmsHW-PkHY=Xez4AomAxWUFR1-x2Q@mail.gmail.com>
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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 6/6/2016 3:31 PM, Dan Williams wrote:
> On Mon, Jun 6, 2016 at 12:25 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> On 6/4/2016 4:52 PM, Dan Williams wrote:
>>> There are scenarios where we need a middle ground between disabling all
>>> manual bind/unbind attempts (via driver->suppress_bind_attrs) and
>>> allowing unbind at any userspace-determined time.  Pinning modules takes
>>> away one vector for unwanted out-of-sequence device_release_driver()
>>> invocations, this new mechanism (via device->suppress_unbind_attr) takes
>>> away another.
>>>
>>> The first user of this mechanism is the libnvdimm sub-system where
>>> manual dimm disabling should be prevented while the dimm is active in
>>> any region.  Note that there is a 1:N dimm-to-region relationship which
>>> is why this is implemented as a disable count rather than a flag.  This
>>> forces userspace to disable regions before dimms when manually shutting
>>> down a bus topology.
>>
>> How is this related to deprecating pcommit?
> 
> We need guarantees that the flush hint mappings are valid for the
> duration of a pmem namespace being enabled.  I am going to move the
> mapping of the flush hint region from per-dimm to per-region.  However
> since multiple regions may reference the same dimm the mapping needs
> to be reference counted and shared across regions.  This will be
> similar to the arrangement we have for BLK-regions that share a
> control region mapping.

Why are things moving around?  Aren't flush hints defined per NFIT device
handle, making them an optional per-dimm thing?

I don't understand a lot of this patch series and had the same questions
as Jeff.  How does deprecating pcommit, because it's not necessary with ADR,
change so much?

-- ljk
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
