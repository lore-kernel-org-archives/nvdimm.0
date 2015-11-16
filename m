Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <56499AB4.6060507@plexistor.com>
Date: Mon, 16 Nov 2015 10:58:28 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] sound: depend on ZONE_DMA
References: <20151112201357.11045.22705.stgit@dwillia2-desk3.jf.intel.com>	<s5h1tbv3qdi.wl-tiwai@suse.de>	<56486417.7090802@plexistor.com> <s5h6112fl2z.wl-tiwai@suse.de>
In-Reply-To: <s5h6112fl2z.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>, Stable Tree <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, linux-nvdimm@lists.01.org, Jaroslav Kysela <perex@perex.cz>, Jeff Moyer <jmoyer@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 11/16/2015 09:40 AM, Takashi Iwai wrote:
> On Sun, 15 Nov 2015 11:53:11 +0100,
> Boaz Harrosh wrote:
>>
>> On 11/12/2015 10:38 PM, Takashi Iwai wrote:
>>> On Thu, 12 Nov 2015 21:13:57 +0100,
>>> Dan Williams wrote:
>>>>
>>>> There are several sound drivers that 'select ZONE_DMA'.  This is
>>>> backwards as ZONE_DMA is an architecture capability exported to drivers.
>>>> Switch the polarity of the dependency to disable these drivers when the
>>>> architecture does not support ZONE_DMA.  This was discovered in the
>>>> context of testing/enabling devm_memremap_pages() which depends on
>>>> ZONE_DEVICE.  ZONE_DEVICE in turn depends on !ZONE_DMA.
>>>
>>> Makes sense.  I applied it now, thanks.
>>>
>>
>> Please add:
>> CC: Stable Tree <stable@vger.kernel.org>
> 
> Sorry, too late, already merged.
> 
> 
> Takashi
> 

Hi Greg

Please include the mainline patch:
	[2db1a57] ALSA: pci: depend on ZONE_DMA (by Dan Williams)

To the stable tree for v4.3.X Kernel.

This patch is needed for proper operation of the 4.3 pmem.ko driver. Long
story, but without this patch the persistent-memory will not be able to
work with the new 4.3 support of page-struct which is needed if we want to
RDMA and/or IO directly to persistent memory.
[Is to do with the new ZONE_DEVICE and too many ZONE(s) if ZONE_DMA is enabled]

Thanks
Boaz

