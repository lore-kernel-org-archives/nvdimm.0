Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <54118B20.9070701@plexistor.com>
Date: Thu, 11 Sep 2014 14:44:32 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] SQUASHME: pmem: Add MODULE_ALIAS
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	 <540F1EC6.4000504@plexistor.com> <54108F64.9080201@plexistor.com> <1410376957.23970.4.camel@rzwisler-mobl1.amr.corp.intel.com>
In-Reply-To: <1410376957.23970.4.camel@rzwisler-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/10/2014 10:22 PM, Ross Zwisler wrote:
<>
>> +MODULE_ALIAS("pmem");
> 
> Umm...but the module is *already* named pmem?
> 
> Let's not set up an alias that is the same as our real name for code that
> isn't written yet?
> 

OK Cool you are right, please drop for now

> - Ross

Thanks
Boaz
