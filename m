Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 862C021B02822
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 11:34:17 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [daxctl PATCH] daxctl: Opt-in to /sys/bus/dax ABI
References: <154161803120.1679566.5287706874058480752.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49tvksvfip.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4g1Z2-eykTVE54Sv7xwXk8hy+B9JE4Oc2aQSc0K+qAmbQ@mail.gmail.com>
Date: Thu, 08 Nov 2018 14:34:15 -0500
In-Reply-To: <CAPcyv4g1Z2-eykTVE54Sv7xwXk8hy+B9JE4Oc2aQSc0K+qAmbQ@mail.gmail.com>
 (Dan Williams's message of "Wed, 7 Nov 2018 11:54:21 -0800")
Message-ID: <x49a7mje53c.fsf@segfault.boston.devel.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Wed, Nov 7, 2018 at 11:44 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>> > In support of the kernel's conversion of the dax-subsystem from a
>> > 'class' to a 'bus', teach the libdaxctl subsystem-layout-specific code
>> > to parse the new layout. The kernel changes do not effect the primary
>> > ndctl use case of putting namespaces into 'dax' mode since that uses
>> > libnvdimm namespace device relative paths, but it does break 'ndctl list
>> > -X' and 'daxctl list'. For that reason the kernel provides a
>> > dax_pmem_compat driver to support the old layout and give time for
>> > userspace components to switch.
>>
>> I must've missed this.  What kernel commit(s) introduced this change?
>
> Not committed yet, only posted:
>
>     https://lore.kernel.org/patchwork/cover/1004684/

Ah, thanks.

>> > Installation of the latest libdaxctl package arranges for a daxctl
>> > configuration file to be dropped in /etc/modprobe.d. The modprobe
>> > configuration blacklists dax_pmem_compat modules and sets the proper
>> > alias for the dax_pmem module. The modprobe configuration upgrades the
>> > default kernel handling to the /sys/bus/dax scheme.
>>
>> And what happens when the user boots an old kernel after this new rule
>> is put in place?
>
> Just works.
>
> With older kernels there is no such thing as "dax_pmem_compat" and the
> default dax_pmem module alias will do the right thing. Newer ndctl /
> daxctl understands both ABIs. The only way to cause confusion is to
> revert to an older ndctl on a newer kernel *and* leave the override
> set to blacklist the compat driver. I.e. you should be able to upgrade
> either component kernel or ndctl with no concerns, but would need to
> be careful about downgrading ndctl without also removing the override.
> I'll check that downgrading via rpm does the right thing.

That seems completely reasonable.

Thanks!
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
