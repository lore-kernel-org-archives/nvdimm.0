Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69F5E21951C80
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 11:41:11 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] libnvdimm, region: sysfs trigger for nvdimm_flush()
References: <149307780135.7155.11108531648914675756.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149315140303.23340.14688142799059150805.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49zif23nvl.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jQXRQVHnNMqJDrwSMM=1kJx_7sWifUN-u1yusVCZ0roQ@mail.gmail.com>
 <x49y3umufpm.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jOP6fhk4wXahdEWH2O_93LQe9yzrWYZatSXXDwEk5OBA@mail.gmail.com>
Date: Thu, 27 Apr 2017 14:41:08 -0400
In-Reply-To: <CAPcyv4jOP6fhk4wXahdEWH2O_93LQe9yzrWYZatSXXDwEk5OBA@mail.gmail.com>
 (Dan Williams's message of "Thu, 27 Apr 2017 09:56:44 -0700")
Message-ID: <x49d1bxsngb.fsf@segfault.boston.devel.redhat.com>
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

>> The sentiment is that programs shouldn't have to grovel around in sysfs
>> to do stuff related to an open file descriptor or mapping.  I don't take
>> issue with the name.  I do worry that something like 'wpq_drain' may be
>> too platform specific, though.  The NVM Programming Model specification
>> is going to call this "deep flush", so maybe that will give you
>> some inspiration if you do want to change the name.
>
> I'll change to "deep_flush", and I quibble that this is related to a
> single open file descriptor or mapping. It really is a "region flush"
> for giving extra protection for global metadata, but the persistence
> of individual fds or mappings is handled by ADR. I think an ioctl
> might give the false impression that every time you flush a cacheline
> to persistence you need to call the ioctl.

fsync, for example, may affect more than one fd--all data in the drive
write cache will be flushed.  I don't see how this is so different.  I
think a sysfs file is awkward because it requires an application to
chase down the correct file in the sysfs hierarchy.  If the application
already has an open fd or a mapping, it should be able to operate on
that.

As for confusion on when to use the interface, I think that's inevitable
no matter how it's implemented.  We're introducing a flush type that has
never been exposed before, and we're not giving any information on how
likely an ADR failure is, or how expensive this flush will be.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
