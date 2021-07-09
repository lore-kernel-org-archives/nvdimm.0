Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32178168
	for <nvdimm@lists.linux.dev>; Fri,  9 Jul 2021 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1625844238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iuJ/n0qs8bhR91+gnWnqd7nUfdrBif7RWxedZV9X4Bs=;
	b=CIh/HgsaE9hdr89i8EiB2+BkC2k13wiJUmrL2qmm5sTDlScGJ4ofa1W+oWyFfyy9/2Au/f
	eVVDZwqGJzyMVNDI//C/C6DM/o7Q+auzXoQgnNkY2vRI3PrCbRhAxu9CJxq1DFecgEvuDm
	qEhkPet4/qTHtJ09bOF+D3AVhQgJiGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-DIlH4F4LMsacLCNFiF0wbg-1; Fri, 09 Jul 2021 11:23:47 -0400
X-MC-Unique: DIlH4F4LMsacLCNFiF0wbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D58F100C660;
	Fri,  9 Jul 2021 15:23:45 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1F3C5D9C6;
	Fri,  9 Jul 2021 15:23:44 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Anandraj <james.sushanth.anandraj@intel.com>,  Linux NVDIMM
 <nvdimm@lists.linux.dev>,  Michal =?utf-8?Q?Such=C3=A1nek?=
 <msuchanek@suse.de>,  Adam Borowski <kilobyte@angband.pl>,
 bgurney@redhat.com
Subject: Re: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and reconfigure-region commands
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
	<CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 09 Jul 2021 11:25:09 -0400
In-Reply-To: <CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com>
	(Dan Williams's message of "Thu, 8 Jul 2021 14:24:04 -0700")
Message-ID: <x49eec7zezu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jmoyer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> [ add Jeff, Michal, and Adam ]

[ adding Bryan Gurney, who is helping out with RHEL packaging ]

> Hey ndctl distro maintainers,
>
> Just wanted to highlight this new tool submission for your
> consideration. The goal here is to have a Linux native provisioning
> tool that covers the basics of the functionality that is outside of
> the ACPI specification, and reduce the need for ipmctl outside of
> exceptional device-specific debug scenarios. Recall that the ACPI NFIT
> communicates the static region configuration to the OS, but changing
> that configuration is a device-specific protocol plus a reboot. Until
> the arrival of pcdctl, region provisioning required ipmctl.

It's great to see progress on this, thanks!  Shipping another utility as
part of the ndctl package is fine with me, though I'm not sure why we
wouldn't just make this an ndctl sub-command.  From a user's
perspective, these are all operations on or about nvdimms.  ipmctl
didn't have separate utilities for provisioning goals and namespace
configuration, for example.

> I will note that CXL moves the region configuration into the base CXL
> specification so the ndctl project will pick up a "cxl-cli" tool for
> that purpose. In general, the ndctl project is open to carrying
> support for persistent memory devices with open specifications. In
> this case the provisioning specification for devices formerly driven
> by ipmctl was opened up and provided here:

Is there a meaningful difference to the user?  Can you show some
examples of how configuration would be different between cxl-attached
pmem and memory-bus attached pmem?

> https://cdrdv2.intel.com/v1/dl/getContent/634430
>
> Please comment on its suitability for shipping in distros alongside
> the ndctl tool.

It's completely fine to ship more tools with ndctl.  I would like a
better overall picture of configuration from the admin's perspective.
At first glance, I think we're adding unneeded complexity.

Cheers,
Jeff

p.s. I don't find the name 'pdctl' particularly endearing.  If we do
stick with a separate utility, I'd suggest coming up with a more
descriptive name.

>
> On Thu, Jul 8, 2021 at 11:38 AM James Anandraj
> <james.sushanth.anandraj@intel.com> wrote:
>>
>> From: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>
>>
>> The Intel Optane Persistent Memory OS provisioning specification
>> describes how to support basic provisioning for Intel Optane
>> persistent memory 100 and 200 series for use in different
>> operating modes using OS software.
>>
>> This patch set introduces a new utility pcdctl that implements
>> basic provisioning as described in the provisioning specification
>> document at https://cdrdv2.intel.com/v1/dl/getContent/634430 .
>>
>> The pcdctl utility provides enumeration and region reconfiguration
>> commands for "nvdimm" subsystem devices (Non-volatile Memory). This
>> is implemented as a separate tool rather than as a feature of ndctl as
>> the steps for provisioning are specific to Intel Optane devices and
>> are as follows.
>> 1..Generate a new region configuration request using this utility.
>> 2. Reset the platform.
>> 3. Use this utility to list the status of operation.
>>
>> James Sushanth Anandraj (4):
>>   Documentation/pcdctl: Add documentation for pcdctl tool and commands
>>   pcdctl/list: Add pcdctl-list command to enumerate 'nvdimm' devices
>>   pcdctl/reconfigure: Add pcdctl-reconfigure-region command
>>   pcdctl/reconfigure: Add support for pmem and iso-pmem modes
>>
>>  Documentation/pcdctl/Makefile.am              |   59 +
>>  .../pcdctl/asciidoctor-extensions.rb          |   30 +
>>  Documentation/pcdctl/pcdctl-list.txt          |   56 +
>>  .../pcdctl/pcdctl-reconfigure-region.txt      |   50 +
>>  Documentation/pcdctl/pcdctl.txt               |   40 +
>>  Documentation/pcdctl/theory-of-operation.txt  |   28 +
>>  Makefile.am                                   |    4 +-
>>  configure.ac                                  |    2 +
>>  pcdctl/Makefile.am                            |   18 +
>>  pcdctl/builtin.h                              |    9 +
>>  pcdctl/list.c                                 |  114 ++
>>  pcdctl/list.h                                 |   11 +
>>  pcdctl/pcat.c                                 |   59 +
>>  pcdctl/pcat.h                                 |   13 +
>>  pcdctl/pcd.h                                  |  381 +++++
>>  pcdctl/pcdctl.c                               |   88 +
>>  pcdctl/reconfigure.c                          | 1458 +++++++++++++++++
>>  pcdctl/reconfigure.h                          |   12 +
>>  util/main.h                                   |    1 +
>>  19 files changed, 2431 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/pcdctl/Makefile.am
>>  create mode 100644 Documentation/pcdctl/asciidoctor-extensions.rb
>>  create mode 100644 Documentation/pcdctl/pcdctl-list.txt
>>  create mode 100644 Documentation/pcdctl/pcdctl-reconfigure-region.txt
>>  create mode 100644 Documentation/pcdctl/pcdctl.txt
>>  create mode 100644 Documentation/pcdctl/theory-of-operation.txt
>>  create mode 100644 pcdctl/Makefile.am
>>  create mode 100644 pcdctl/builtin.h
>>  create mode 100644 pcdctl/list.c
>>  create mode 100644 pcdctl/list.h
>>  create mode 100644 pcdctl/pcat.c
>>  create mode 100644 pcdctl/pcat.h
>>  create mode 100644 pcdctl/pcd.h
>>  create mode 100644 pcdctl/pcdctl.c
>>  create mode 100644 pcdctl/reconfigure.c
>>  create mode 100644 pcdctl/reconfigure.h
>>
>> --
>> 2.20.1
>>
>>

