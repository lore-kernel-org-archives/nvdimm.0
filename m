Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDAA921A07A82
 for <linux-nvdimm@lists.01.org>; Wed,  7 Nov 2018 11:54:33 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id g10so15912344otl.12
 for <linux-nvdimm@lists.01.org>; Wed, 07 Nov 2018 11:54:33 -0800 (PST)
MIME-Version: 1.0
References: <154161803120.1679566.5287706874058480752.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49tvksvfip.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49tvksvfip.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Nov 2018 11:54:21 -0800
Message-ID: <CAPcyv4g1Z2-eykTVE54Sv7xwXk8hy+B9JE4Oc2aQSc0K+qAmbQ@mail.gmail.com>
Subject: Re: [daxctl PATCH] daxctl: Opt-in to /sys/bus/dax ABI
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
To: jmoyer <jmoyer@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 7, 2018 at 11:44 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > In support of the kernel's conversion of the dax-subsystem from a
> > 'class' to a 'bus', teach the libdaxctl subsystem-layout-specific code
> > to parse the new layout. The kernel changes do not effect the primary
> > ndctl use case of putting namespaces into 'dax' mode since that uses
> > libnvdimm namespace device relative paths, but it does break 'ndctl list
> > -X' and 'daxctl list'. For that reason the kernel provides a
> > dax_pmem_compat driver to support the old layout and give time for
> > userspace components to switch.
>
> I must've missed this.  What kernel commit(s) introduced this change?

Not committed yet, only posted:

    https://lore.kernel.org/patchwork/cover/1004684/

> > Installation of the latest libdaxctl package arranges for a daxctl
> > configuration file to be dropped in /etc/modprobe.d. The modprobe
> > configuration blacklists dax_pmem_compat modules and sets the proper
> > alias for the dax_pmem module. The modprobe configuration upgrades the
> > default kernel handling to the /sys/bus/dax scheme.
>
> And what happens when the user boots an old kernel after this new rule
> is put in place?

Just works.

With older kernels there is no such thing as "dax_pmem_compat" and the
default dax_pmem module alias will do the right thing. Newer ndctl /
daxctl understands both ABIs. The only way to cause confusion is to
revert to an older ndctl on a newer kernel *and* leave the override
set to blacklist the compat driver. I.e. you should be able to upgrade
either component kernel or ndctl with no concerns, but would need to
be careful about downgrading ndctl without also removing the override.
I'll check that downgrading via rpm does the right thing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
