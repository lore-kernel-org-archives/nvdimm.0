Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A96A21309DB1
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 09:46:42 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r21so155320579otq.6
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 09:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <156530042781.2068700.8733813683117819799.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49blwuidqn.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49blwuidqn.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Aug 2019 09:44:10 -0700
Message-ID: <CAPcyv4jZWbBUrig3wnE+VGptMEv3fHeRJbRhmMncQwkjLUbvxg@mail.gmail.com>
Subject: Re: [PATCH] mm/memremap: Fix reuse of pgmap instances with internal
 references
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 8:51 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > Currently, attempts to shutdown and re-enable a device-dax instance
> > trigger:
>
> What does "shutdown and re-enable" translate to?  If I disable and
> re-enable a device-dax namespace, I don't see this behavior.

I was not seeing this either until I made sure I was in 'bus" device model mode.

# cat /etc/modprobe.d/daxctl.conf
blacklist dax_pmem_compat
alias nd:t7* dax_pmem

# make TESTS="daxctl-devices.sh" check -j 40 2>out

# dmesg | grep WARN.*devm
[  225.588651] WARNING: CPU: 10 PID: 9103 at mm/memremap.c:211
devm_memremap_pages+0x234/0x850
[  225.679828] WARNING: CPU: 10 PID: 9103 at mm/memremap.c:211
devm_memremap_pages+0x234/0x850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
