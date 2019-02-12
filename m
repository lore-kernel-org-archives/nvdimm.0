Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
 <26ac36f4-7391-5321-217b-50d67e2119d7@intel.com>
From: Brice Goglin <Brice.Goglin@inria.fr>
Message-ID: <453f13cd-a7fe-33eb-9a27-8490825ca29c@inria.fr>
Date: Tue, 12 Feb 2019 20:59:45 +0100
MIME-Version: 1.0
In-Reply-To: <26ac36f4-7391-5321-217b-50d67e2119d7@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, ying.huang@intel.com, linux-mm@kvack.org, jglisse@redhat.com, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Le 11/02/2019 à 17:22, Dave Hansen a écrit :

> On 2/9/19 3:00 AM, Brice Goglin wrote:
>> I've used your patches on fake hardware (memmap=xx!yy) with an older
>> nvdimm-pending branch (without Keith's patches). It worked fine. This
>> time I am running on real Intel hardware. Any idea where to look ?
> I've run them on real Intel hardware too.
>
> Could you share the exact sequence of commands you're issuing to
> reproduce the hang?  My guess would be that there's some odd interaction
> between Dan's latest branch and my now (slightly) stale patches.
>
> I'll refresh them this week and see if I can reproduce what you're seeing.

# ndctl disable-region all
# ndctl zero-labels all
# ndctl enable-region region0
# ndctl create-namespace -r region0 -t pmem -m devdax
{
  "dev":"namespace0.0",
  "mode":"devdax",
  "map":"dev",
  "size":"1488.37 GiB (1598.13 GB)",
  "uuid":"ad0096d7-3fe7-4402-b529-ad64ed0bf789",
  "daxregion":{
    "id":0,
    "size":"1488.37 GiB (1598.13 GB)",
    "align":2097152,
    "devices":[
      {
        "chardev":"dax0.0",
        "size":"1488.37 GiB (1598.13 GB)"
      }
    ]
  },
  "align":2097152
}
# ndctl enable-namespace namespace0.0
# echo -n dax0.0 > /sys/bus/dax/drivers/device_dax/remove_id
<hang>

I tried with and without dax_pmem_compat loaded, but it doesn't help.

Brice
