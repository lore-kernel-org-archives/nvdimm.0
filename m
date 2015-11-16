Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <5649A6A9.1030101@plexistor.com>
Date: Mon, 16 Nov 2015 11:49:29 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] sound: depend on ZONE_DMA
References: <20151112201357.11045.22705.stgit@dwillia2-desk3.jf.intel.com>	<s5h1tbv3qdi.wl-tiwai@suse.de>	<56486417.7090802@plexistor.com>	<s5h6112fl2z.wl-tiwai@suse.de>	<56499AB4.6060507@plexistor.com> <s5hd1vafg3j.wl-tiwai@suse.de>
In-Reply-To: <s5hd1vafg3j.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Stable Tree <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, linux-nvdimm@lists.01.org, Jaroslav Kysela <perex@perex.cz>, Jeff Moyer <jmoyer@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 11/16/2015 11:28 AM, Takashi Iwai wrote:
<>
>>
>> Hi Greg
>>
>> Please include the mainline patch:
>> 	[2db1a57] ALSA: pci: depend on ZONE_DMA (by Dan Williams)
>>
>> To the stable tree for v4.3.X Kernel.
>>
>> This patch is needed for proper operation of the 4.3 pmem.ko driver. Long
>> story, but without this patch the persistent-memory will not be able to
>> work with the new 4.3 support of page-struct which is needed if we want to
>> RDMA and/or IO directly to persistent memory.
>> [Is to do with the new ZONE_DEVICE and too many ZONE(s) if ZONE_DMA is enabled]
> 
> Well, it's not exactly true: you just need to deselect some drivers to
> allow CONFIG_ZONE_DMA to be disabled.  It's merely another side of
> coin.
> 
> I don't mind including this to 4.3, though, but just want to correct
> the statement.
> 

This is true. Sorry for not being clear. We already have a script that we
give to clients to enable ZONE_DEVICE for 4.3 based systems. Is currently
simple based on this patch. Without this patch it will need to be more
complicated.

Thanks Takashi
Boaz

> 
> Takashi
> 

