Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABC170
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 20:19:28 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id v7so19514362pgl.2
        for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 13:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NcDTSK2SyGzqxn352v1/pJljtqtRqc945/5yQu27H1A=;
        b=e/miEMeBmwnOeZpId9tB9/3OqlpDvKsfTx0WxfvqpJS67Xy62BrRBHC2z+EOenJOWD
         Vwa/52i0YzSUzcaXqIsBwVddgnRO73MoL3FIfufkv3A9XyPKSu4vDAQpy4NG+WHUkVvo
         FeAUoqAy7Uzj+X3fn5KfQBfXjj1Xv9hAMa1Y1iRCfwiTJ7QzeuC6qqZzQD5Irsq4YC68
         mTKteresWYgXEKSs02KnlIsCU7p4IluNXzLMotS/0EnxeLXivUaNFNyY5kn6AqHfoH6p
         ttGLo+LjV2zCGCrsCJaFcj3KJRHaC4rF9Jo60H3qbHcytHRLDeil1n+pAVSedZQ3qZSU
         cZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NcDTSK2SyGzqxn352v1/pJljtqtRqc945/5yQu27H1A=;
        b=Yw8CGdcJzxSqGKNJEAlgzflLZkcC3zeNyQMFAuxGuwVvg+faKkRwRSj/Wz4yNfyfKb
         WNign066Xczcy4WJldPRDgWCbmzGQoEK5t9ufsAuGisMWPcrYidvsNUsiq5NY2XbhUSS
         zjqeAS6cOovIJ2wgAuKGdJCbePslwtFIcZIISUPBgfauWDZ6rPB6jCyZSvpJB0bXP3pj
         9Q8xgojIqw/sF0Wgdj3DpP7nI8LIWLTWQAhTmsnoPK2BBOZxSrn+bBDFIoay8jNH9NTg
         5ycUaCt4HzOA/ftFibA1U1F40ZKf/oBEZ4dstGPpLAXn8lLItBXPHLWmyP2WX8hf6ezo
         4Xag==
X-Gm-Message-State: AOAM532lMQ2G+y1rLyaf8orP+NlyEfd6XWej8DPbrcPXwI6fQWx6H7cD
	iIO54MK/LBzeD0x5aRCCFsswffhrTG1aUvQMK3h4sg==
X-Google-Smtp-Source: ABdhPJzA6MmsJuSG+p+eg6Nl/g+B9eFEUKhOg0GH+lS4ijRXSMS6C2ivFSXL9A0R9qnlE1r5WoOmhSoFxJUms3jrIrY=
X-Received: by 2002:a05:6a00:d53:b029:32a:2db6:1be3 with SMTP id
 n19-20020a056a000d53b029032a2db61be3mr746801pfv.71.1626121167608; Mon, 12 Jul
 2021 13:19:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
 <CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com>
 <x49eec7zezu.fsf@segfault.boston.devel.redhat.com> <CAPcyv4jTqY4hzdnTp4CpS5WWLsDS9Q0RsZkNZ7Bxr0oRXDLLFw@mail.gmail.com>
 <20210712140051.GD3829@kitsune.suse.cz>
In-Reply-To: <20210712140051.GD3829@kitsune.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Jul 2021 13:19:16 -0700
Message-ID: <CAPcyv4gOS1Sx56+sGiBMnDGji=+sqaxCDKciw7K4NckaXbAh_w@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and
 reconfigure-region commands
To: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc: Jeff Moyer <jmoyer@redhat.com>, James Anandraj <james.sushanth.anandraj@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Adam Borowski <kilobyte@angband.pl>, bgurney@redhat.com, 
	Coly Li <colyli@suse.de>, Raymund Will <rw@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 12, 2021 at 7:03 AM Michal Such=C3=A1nek <msuchanek@suse.de> wr=
ote:
>
> [ CC people who have some experience with the ACPI pmem ]
>
> Hello,
>
> On Fri, Jul 09, 2021 at 11:58:49AM -0700, Dan Williams wrote:
> > On Fri, Jul 9, 2021 at 8:24 AM Jeff Moyer <jmoyer@redhat.com> wrote:
> > >
> > > Dan Williams <dan.j.williams@intel.com> writes:
> > >
> > > > [ add Jeff, Michal, and Adam ]
> > >
> > > [ adding Bryan Gurney, who is helping out with RHEL packaging ]
> > >
> > > > Hey ndctl distro maintainers,
> > > >
> > > > Just wanted to highlight this new tool submission for your
> > > > consideration. The goal here is to have a Linux native provisioning
> > > > tool that covers the basics of the functionality that is outside of
> > > > the ACPI specification, and reduce the need for ipmctl outside of
> > > > exceptional device-specific debug scenarios. Recall that the ACPI N=
FIT
> > > > communicates the static region configuration to the OS, but changin=
g
> > > > that configuration is a device-specific protocol plus a reboot. Unt=
il
> > > > the arrival of pcdctl, region provisioning required ipmctl.
> > >
> > > It's great to see progress on this, thanks!  Shipping another utility=
 as
> > > part of the ndctl package is fine with me, though I'm not sure why we
> > > wouldn't just make this an ndctl sub-command.  From a user's
> > > perspective, these are all operations on or about nvdimms.  ipmctl
> > > didn't have separate utilities for provisioning goals and namespace
> > > configuration, for example.
> >
> > True, but ipmctl also did not make an attempt to support anything
> > other than Intel devices, and later versions abandoned the namespace
> > setup code in favor of "native OS" capabilities (ndctl on Linux).
> >
> > The main rationale for splitting region provisioning to dedicated
> > tooling is the observation that region provisioning semantics are
> > platform specific. It is already the case that IBM devices have their
> > own provisioning tool with different semantics for the "PAPR" family.
> > CXL region provisioning semantics again are much different than what
> > is done for DDR-T devices (see below). So rather than try to abstract
> > all that under ndctl that wants to be vendor agnostic, offload that to
> > platform specific tools. My hope is that more tools like this do not
> > proliferate as the industry unifies on common standards for persistent
> > memory like CXL.
> >
> > That said, the new commands could be placed under a
> > vendor/platform-specific name in ndctl, like:
> >
> > ndctl list-ipm-region
> > ndctl reconfigure-ipm-region
> >
> > ...just not my first choice given the success to date of keeping
> > vendor details out of the command line interface of ndctl. The primary
> > blocker for ndctl to generic region provisioning would be a kernel
> > driver model for it, but I don't know how to reconcile "ipm-regions"
> > requiring a reboot and a BIOS validation step vs buses like CXL that
> > can reconfigure interleave sets at runtime.
> >
> > > > I will note that CXL moves the region configuration into the base C=
XL
> > > > specification so the ndctl project will pick up a "cxl-cli" tool fo=
r
> > > > that purpose. In general, the ndctl project is open to carrying
> > > > support for persistent memory devices with open specifications. In
> > > > this case the provisioning specification for devices formerly drive=
n
> > > > by ipmctl was opened up and provided here:
> > >
> > > Is there a meaningful difference to the user?  Can you show some
> > > examples of how configuration would be different between cxl-attached
> > > pmem and memory-bus attached pmem?
> >
> > Yes, CXL exposes several more details and degrees of freedom to system
> > software. Before I list those I'll point out that to keep pcdctl
> > simple it only handles the simple / common configurations: all
> > performance-pmem (interleaved), all fault tolerant pmem
> > (non-interleaved), all volatile with memory-side-caching. Any
> > custom/expert configuration outside of those common cases is punted to
> > ipmctl.
>
> What is the purpose of having the new tool when it cannot handle the
> full configuration, and users still need to refer to the old tool for
> some cases?

A valid question, indeed I neglected to clarify the original
motivation to go this route. So a small bit of history: ndctl was
built to be Linux native and vendor agnostic, and ipmctl was built to
be OS agnostic and vendor specific. For that reason ipmctl was slower
to be picked up by distributions and some distributions still do not
ship it in their supported repos today.

One of the feedback items we, ndctl + ipmctl developers, heard is that
ndctl is easier for a distribution to support because of its
organization as a Linux-native open-source project, i.e. no OS
abstraction + typical open development on a public mailing list. We
also heard the feedback that ndctl was frustratingly deficient in
being able to handle all the major provisioning flows for DDR-T
devices except for "goal" / region management.

> Then to make life or users simpler I vould completely skip the new
> partial tool.

I think that's a reasonable position. If a distribution is already
comfortable shipping and supporting ipmctl then there's little need to
ship this new tool. Conversely if a distribution has not promoted
ipmctl to a supported package this new tool can fill a gap.

Again, this gets better for CXL where all provisioning is standardized
across vendors.

> Other than that if the new tools provide some value but are
> platform-specific it is slight annoyance to package different set of
> tools depending on target architecture but it's not something that
> cannot be managed.

Understood, I can see how this new tool requires a decision to be made
about whether to ignore it, or ship both for distributions that are
already carrying ipmctl. I don't have a strong opinion either way, I
just know that this option is something that some distributions may
want.
