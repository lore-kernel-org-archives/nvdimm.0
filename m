Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E362211B113D
 for <linux-nvdimm@lists.01.org>; Fri, 18 Jan 2019 12:26:24 -0800 (PST)
Date: Fri, 18 Jan 2019 15:26:18 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 2/4] mm/memory-hotplug: allow memory resources to be
 children
Message-ID: <20190118202618.GB3060@redhat.com>
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181902.670EEBC3@viggo.jf.intel.com>
 <20190116191635.GD3617@redhat.com>
 <c6df9b8d-571d-3b4f-c528-dc176f8577e2@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c6df9b8d-571d-3b4f-c528-dc176f8577e2@intel.com>
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

On Fri, Jan 18, 2019 at 11:58:54AM -0800, Dave Hansen wrote:
> On 1/16/19 11:16 AM, Jerome Glisse wrote:
> >> We *could* also simply truncate the existing top-level
> >> "Persistent Memory" resource and take over the released address
> >> space.  But, this means that if we ever decide to hot-unplug the
> >> "RAM" and give it back, we need to recreate the original setup,
> >> which may mean going back to the BIOS tables.
> >>
> >> This should have no real effect on the existing collision
> >> detection because the areas that truly conflict should be marked
> >> IORESOURCE_BUSY.
> > =

> > Still i am worrying that this might allow device private to register
> > itself as a child of some un-busy resource as this patch obviously
> > change the behavior of register_memory_resource()
> > =

> > What about instead explicitly providing parent resource to add_memory()
> > and then to register_memory_resource() so if it is provided as an
> > argument (!NULL) then you can __request_region(arg_res, ...) otherwise
> > you keep existing code intact ?
> =

> We don't have the locking to do this, do we?  For instance, all the
> locking is done below register_memory_resource(), so any previous
> resource lookup is invalid by the time we get to register_memory_resource=
().

Yeah you are right, maybe just a bool then ? bool as_child

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
