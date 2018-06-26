Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9873421A143EF
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 15:37:52 -0700 (PDT)
Received: by mail-ot0-x244.google.com with SMTP id i19-v6so50710otk.10
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 15:37:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180626223041.15653-1-ross.zwisler@linux.intel.com>
References: <20180626223041.15653-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 15:37:51 -0700
Message-ID: <CAPcyv4hm=fiupZWwX=o1aFf8uSWnAwr8dKpUGHVFs6HEwmtn2A@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] Fix DM DAX handling
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26, 2018 at 3:30 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> This series fixes a few issues that I found with DM's handling of DAX
> devices.  Here are some of the issues I found:
>
>  * We can create a dm-stripe or dm-linear device which is made up of an
>    fsdax PMEM namespace and a raw PMEM namespace but which can hold a
>    filesystem mounted with the -o dax mount option.  DAX operations to
>    the raw PMEM namespace part lack struct page and can fail in
>    interesting/unexpected ways when doing things like fork(), examining
>    memory with gdb, etc.
>
>  * We can create a dm-stripe or dm-linear device which is made up of an
>    fsdax PMEM namespace and a BRD ramdisk which can hold a filesystem
>    mounted with the -o dax mount option.  All I/O to this filesystem
>    will fail.
>

For the series:

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
