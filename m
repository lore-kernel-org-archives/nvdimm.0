Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181905.12E102B4@viggo.jf.intel.com>
 <5ef5d5e9-9d35-fb84-b69e-7456dcf4c241@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <1e9377c6-11a0-3bbd-763d-d9347bd556cf@intel.com>
Date: Thu, 17 Jan 2019 07:17:24 -0800
MIME-Version: 1.0
In-Reply-To: <5ef5d5e9-9d35-fb84-b69e-7456dcf4c241@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, dave@sr71.net
Cc: dan.j.williams@intel.com, dave.jiang@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, thomas.lendacky@amd.com, akpm@linux-foundation.org, mhocko@suse.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ying.huang@intel.com, fengguang.wu@intel.com, bp@suse.de, bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de
List-ID: <linux-nvdimm@lists.01.org>

On 1/17/19 12:19 AM, Yanmin Zhang wrote:
>>
> I didn't try pmem and I am wondering it's slower than DRAM.
> Should a flag, such like _GFP_PMEM, be added to distinguish it from
> DRAM?

Absolutely not. :)

We already have performance-differentiated memory, and lots of ways to
enumerate and select it in the kernel (all of our NUMA infrastructure).

PMEM is also just the first of many "kinds" of memory that folks want to
build in systems and use a "RAM".  We literally don't have space to put
a flag in for each type.
