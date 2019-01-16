Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 485DA21B02822
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 15:38:55 -0800 (PST)
Date: Wed, 16 Jan 2019 18:38:50 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 2/4] mm/memory-hotplug: allow memory resources to be
 children
Message-ID: <20190116233849.GE3617@redhat.com>
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181902.670EEBC3@viggo.jf.intel.com>
 <20190116191635.GD3617@redhat.com>
 <2b52778d-f120-eec7-3e7a-3a9c182170f0@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2b52778d-f120-eec7-3e7a-3a9c182170f0@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: thomas.lendacky@amd.com, dave@sr71.net, linux-nvdimm@lists.01.org, tiwai@suse.de, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 16, 2019 at 03:01:39PM -0800, Dave Hansen wrote:
> On 1/16/19 11:16 AM, Jerome Glisse wrote:
> >> We also rework the old error message a bit since we do not get
> >> the conflicting entry back: only an indication that we *had* a
> >> conflict.
> > We should keep the device private check (moving it in __request_region)
> > as device private can try to register un-use physical address (un-use
> > at time of device private registration) that latter can block valid
> > physical address the error message you are removing report such event.
> =

> If a resource can't support having a child, shouldn't it just be marked
> IORESOURCE_BUSY, rather than trying to somehow special-case
> IORES_DESC_DEVICE_PRIVATE_MEMORY behavior?

So the thing about IORES_DESC_DEVICE_PRIVATE_MEMORY is that they
are not necessarily link to any real resource ie they can just be
random range of physical address that at the time of registration
had no resource.

Now you can latter hotplug some memory that would conflict with
this IORES_DESC_DEVICE_PRIVATE_MEMORY and if that happens we want
to tell that to the user ie:
    "Sorry we registered some fake memory at fake physical address
     and now you have hotplug something that conflict with that."


Why no existing resource ? Well it depends on the platform. In some
case memory for HMM is just not accessible by the CPU _at_ all so
there is obviously no physical address from CPU point of view for
this kind of memory. The other case is PCIE and BAR size. If we
have PCIE bar resizing working everywhere we could potentialy
use the resized PCIE bar (thought i think some device have bug on
that front so i need to check device side too). So when HMM was
design without the PCIE resize and with totaly un-accessible memory
the only option was to pick some unuse physical address range as
anyway memory we are hotpluging is not CPU accessible.

It has been on my TODO to try to find a better way to reserve a
physical range but this is highly platform specific. I need to
investigate if i can report to ACPI on x86 that i want to make
sure the system never assign some physical address range.

Checking PCIE bar resize is also on my TODO (on device side as
i think some device are just buggy there and won't accept BAR
bigger than 256MB and freakout if you try).

So right now i would rather that we keep properly reporting this
hazard so that at least we know it failed because of that. This
also include making sure that we can not register private memory
as a child of an un-busy resource that does exist but might not
have yet been claim by its rightful owner.

Existing code make sure of that, with your change this is a case
that i would not be able to stop. Well i would have to hot unplug
and try a different physical address i guess.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
