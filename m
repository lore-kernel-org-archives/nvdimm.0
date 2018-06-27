Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1885E202E53F3
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 06:03:11 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id a6-v6so2097182otf.2
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 06:03:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACTTzNbu5FNXiyDeSBgTZCE7x=aNKQWvMLnhy5rkE51JJV9Rzg@mail.gmail.com>
References: <alpine.LRH.2.02.1806180846300.22626@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4i_xqo1AgF7znUYi+Eo_obTBYA5vMv7=Q0VP755Kmm9bg@mail.gmail.com>
 <CACTTzNbu5FNXiyDeSBgTZCE7x=aNKQWvMLnhy5rkE51JJV9Rzg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Jun 2018 06:03:09 -0700
Message-ID: <CAPcyv4hzfy0pvniMz4-PcaAXo6kFC=n4hyPzd=0v-JxCsUhMhQ@mail.gmail.com>
Subject: Re: [PATCH] x86: optimize memcpy_flushcache
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
To: Yigal Korman <yigal@plexistor.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, device-mapper development <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, pmem <pmem@googlegroups.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 27, 2018 at 4:23 AM, Yigal Korman <yigal@plexistor.com> wrote:
> Hi,
> I'm a bit late on this but I have a question about the original patch -
> I thought that in order for movnt (movntil, movntiq) to push the data
> into the persistency domain (ADR),
> one must work with length that is multiple of cacheline size,
> otherwise the write-combine buffers remain partially
> filled and you need to commit them with a fence (sfence) - which ruins
> the whole performance gain you got here.
> Am I wrong, are the write-combine buffers are part of the ADR domain
> or something?

The intent is to allow a batch of memcpy_flushcache() calls followed
by a single sfence. Specifying a multiple of a cacheline size does not
necessarily help as sfence is still needed to make sure that the movnt
result has reached the ADR-safe domain.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
