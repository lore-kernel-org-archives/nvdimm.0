Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4C221A1F9A
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 08:57:14 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id k142so31997424oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 08:57:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACTTzNZJyFZkGq-6sSTOzGBG3kc7E9c-Rp6Z8fdi9LRgExQPnQ@mail.gmail.com>
References: <CACTTzNZJyFZkGq-6sSTOzGBG3kc7E9c-Rp6Z8fdi9LRgExQPnQ@mail.gmail.com>
Date: Tue, 17 May 2016 08:57:09 -0700
Message-ID: <CAPcyv4ioeGGe3ujkpytzJKZHDVawX95KtrFEmBvO2oaB_j_RqA@mail.gmail.com>
Subject: Re: Legacy NVDIMM-F over EFI
From: Dan Williams <dan.j.williams@intel.com>
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
Cc: Toshi Kani <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 17, 2016 at 8:36 AM, Yigal Korman <yigal@plexistor.com> wrote:
> Hi all,
> I've got a couple of legacy 'type 12' NVDIMM-F modules in our lab I've
> been successfully testing.
> Recently I moved them to a new system where EFI bootloader is used
> (CentOS 7 installed with EFI) and  was surprised to see that they're
> not identified as legacy 'type 12' persistent memory, are not caught
> by the 'nd_pmem' driver and I don't get /dev/pmemX devices.
> They show as 'type 7' in the E820 map and 'Persistent memory' in /proc/iomem.
> Is this the intended behavior? shouldn't they be identified as legacy
> if they don't have NFIT?

If the BIOS identifies it as type-7 it is broken, as far as Linux is
concerned, if does not also export an NFIT with an ACPI0012 device.
One would hope there are no new BIOS images being produced that use
type-12...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
