Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C84B12130309C
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 14:31:44 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] mm/memremap: Fix reuse of pgmap instances with internal
 references
References: <156530042781.2068700.8733813683117819799.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49blwuidqn.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jZWbBUrig3wnE+VGptMEv3fHeRJbRhmMncQwkjLUbvxg@mail.gmail.com>
Date: Mon, 12 Aug 2019 17:29:24 -0400
In-Reply-To: <CAPcyv4jZWbBUrig3wnE+VGptMEv3fHeRJbRhmMncQwkjLUbvxg@mail.gmail.com>
 (Dan Williams's message of "Mon, 12 Aug 2019 09:44:10 -0700")
Message-ID: <x49ftm6gjij.fsf@segfault.boston.devel.redhat.com>
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
Cc: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Mon, Aug 12, 2019 at 8:51 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>> > Currently, attempts to shutdown and re-enable a device-dax instance
>> > trigger:
>>
>> What does "shutdown and re-enable" translate to?  If I disable and
>> re-enable a device-dax namespace, I don't see this behavior.
>
> I was not seeing this either until I made sure I was in 'bus" device model mode.
>
> # cat /etc/modprobe.d/daxctl.conf
> blacklist dax_pmem_compat
> alias nd:t7* dax_pmem
>
> # make TESTS="daxctl-devices.sh" check -j 40 2>out
>
> # dmesg | grep WARN.*devm
> [  225.588651] WARNING: CPU: 10 PID: 9103 at mm/memremap.c:211
> devm_memremap_pages+0x234/0x850
> [  225.679828] WARNING: CPU: 10 PID: 9103 at mm/memremap.c:211
> devm_memremap_pages+0x234/0x850

Ah, you see this when reconfiguring the device.  So, the lifetime of the
pgmap is tied to the character device, which doesn't get torn down.  The
fix looks good to me, and tests out fine.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
