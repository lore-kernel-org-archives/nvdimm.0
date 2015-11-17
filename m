Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <564B285A.9060604@plexistor.com>
Date: Tue, 17 Nov 2015 15:15:06 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [RFC 1/1] memremap: devm_memremap_pages has wrong nid
References: <5643B043.3010103@plexistor.com>		 <CAPcyv4jCg58-Je4hW=O4TT9ESeJTV-GFEUidLD9n60-z9w9V2Q@mail.gmail.com>	 <1447430433.21443.85.camel@hpe.com> <56484DA1.5060506@plexistor.com> <1447694386.21443.140.camel@hpe.com>
In-Reply-To: <1447694386.21443.140.camel@hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/16/2015 07:19 PM, Toshi Kani wrote:
<>
>> (Ok and we might have a slight problem with an NFIT only Node, where there
>>  is no volatile memory at all)
> 
> The NFIT driver sets it to the closest on-line node (i.e. where regular memory
> resides) in this case.
> 

This is a real problem then. I know it used to be the same with type-12 pmem
and we had real trouble with it on systems performance. Eventually one of your
patches fixed it.

We should fix this for NFIT, yes specially with ZONE_DEVICE and page support.
It will hurt performance a lot.

Eventually I'll get to it, again when NFIT becomes more relevant to us.

<>
> 
> Thanks,
> -Toshi
> 

Thanks Toshi
Boaz


