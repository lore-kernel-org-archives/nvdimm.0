Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 974E621959CB2
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 13:15:06 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id v198-v6so18233809oif.2
 for <linux-nvdimm@lists.01.org>; Thu, 08 Nov 2018 13:15:06 -0800 (PST)
MIME-Version: 1.0
References: <154161803120.1679566.5287706874058480752.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49lg63cmp2.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49lg63cmp2.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Nov 2018 13:14:54 -0800
Message-ID: <CAPcyv4hq5Z5YtO7MNkx=H34p_fb_U_MKLEb_XNS=BqP=VbnUiQ@mail.gmail.com>
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

On Thu, Nov 8, 2018 at 12:57 PM Jeff Moyer <jmoyer@redhat.com> wrote:
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
> >
> > Installation of the latest libdaxctl package arranges for a daxctl
> > configuration file to be dropped in /etc/modprobe.d. The modprobe
> > configuration blacklists dax_pmem_compat modules and sets the proper
> > alias for the dax_pmem module. The modprobe configuration upgrades the
> > default kernel handling to the /sys/bus/dax scheme.
>
> OK, one other snafu: pmdk also uses the /sys/class/dax path (see
> src/common/file.c).  Since ndctl isn't the only consumer, we'd have to
> coordinate the class->bus switch among all parties.

Yes, the only way I can see to do this is to whack-a-mole convert
/sys/class/dax users over to libdaxctl. At a minimum I need to
disconnect the opt-in from a package upgrade and make it an explicit
command with a man page explaining the details and consequences.

> Is there a way to just keep the class-based paths working alongside the
> bus interface?

Unfortunately, devices can't have a 'class' and 'bus' association at
the same time because they will collide on the 'subsystem'
designation. The subsystem association is 1:1.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
