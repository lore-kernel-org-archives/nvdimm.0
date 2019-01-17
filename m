Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FB5D203B99BB
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 08:56:20 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id w25so11687771otm.13
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 08:56:20 -0800 (PST)
MIME-Version: 1.0
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181905.12E102B4@viggo.jf.intel.com>
 <5A90DA2E42F8AE43BC4A093BF06788482571FCB1@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <5A90DA2E42F8AE43BC4A093BF06788482571FCB1@SHSMSX103.ccr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 Jan 2019 08:56:08 -0800
Message-ID: <CAPcyv4heNGQf4NHYrMzUdBRw2n3tE08bMaVKzgYrPYVaVDWE9Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] dax: "Hotplug" persistent memory for use like normal
 RAM
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
To: "Du, Fan" <fan.du@intel.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "dave@sr71.net" <dave@sr71.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tiwai@suse.de" <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying" <ying.huang@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "mhocko@suse.com" <mhocko@suse.com>, "bp@suse.de" <bp@suse.de>, "baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "zwisler@kernel.org" <zwisler@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Wu,
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 16, 2019 at 9:21 PM Du, Fan <fan.du@intel.com> wrote:
[..]
> >From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> >Currently, a persistent memory region is "owned" by a device driver,
> >either the "Direct DAX" or "Filesystem DAX" drivers.  These drivers
> >allow applications to explicitly use persistent memory, generally
> >by being modified to use special, new libraries.
> >
> >However, this limits persistent memory use to applications which
> >*have* been modified.  To make it more broadly usable, this driver
> >"hotplugs" memory into the kernel, to be managed ad used just like
> >normal RAM would be.
> >
> >To make this work, management software must remove the device from
> >being controlled by the "Device DAX" infrastructure:
> >
> >       echo -n dax0.0 > /sys/bus/dax/drivers/device_dax/remove_id
> >       echo -n dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
> >
> >and then bind it to this new driver:
> >
> >       echo -n dax0.0 > /sys/bus/dax/drivers/kmem/new_id
> >       echo -n dax0.0 > /sys/bus/dax/drivers/kmem/bind
>
> Is there any plan to introduce additional mode, e.g. "kmem" in the userspace
> ndctl tool to do the configuration?
>

Yes, but not to ndctl. The daxctl tool will grow a helper for this.
The policy of what device-dax instances should be hotplugged at system
init will be managed by a persistent configuration file and udev
rules.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
