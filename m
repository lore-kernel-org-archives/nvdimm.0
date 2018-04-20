Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FC652279CEE0
 for <linux-nvdimm@lists.01.org>; Fri, 20 Apr 2018 14:33:42 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: Write through caching on NVDIMM
Date: Fri, 20 Apr 2018 21:33:35 +0000
Message-ID: <1524259971.2693.432.camel@hpe.com>
References: <CAKccVayU9NW6gWao=w-h3aZaRrCW-=-J7he0hVeWjBA+hjhJ=g@mail.gmail.com>
In-Reply-To: <CAKccVayU9NW6gWao=w-h3aZaRrCW-=-J7he0hVeWjBA+hjhJ=g@mail.gmail.com>
Content-Language: en-US
Content-ID: <82629B403C3B104DBA74F9FB6AE4D420@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "brian.stark@sanmina.com" <brian.stark@sanmina.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-04-19 at 16:12 -0700, Brian Stark wrote:
> I was comparing different caching techniques using MTRR entries and I
> found something strange.  Note the output is from a basic utility that
> uses mmap.
> 
> NV Memory:
> 
> Write-back
> 
> Writes took 2075.993408 Megabytes per second
> Reads took 2130.842529 Megabytes per second No Errors Found
> 
> Write-Through
> 
> Writes took 55.332256 Megabytes per second
> Reads took 92.310310 Megabytes per second No Errors Found  !!!I was
> expecting this number to be the same as Write-back
> 
> Uncached
> 
> Writes took 55.331089 Megabytes per second
> Reads took 92.315132 Megabytes per second No Errors Found
> 
> Regular memory:
> 
> Write-back
> 
> Writes took 1875.560791 Megabytes per second
> Reads took 2070.452637 Megabytes per second No Errors Found
> 
> Write-Through
> 
> Writes took 54.903713 Megabytes per second
> Reads took 2106.244629 Megabytes per second No Errors Found  !!!This
> is what I expected to see for NV Memory
> 
> Uncached
> 
> Writes took 54.903923 Megabytes per second
> Reads took 90.150986 Megabytes per second No Errors Found
> 
> I am using the same driver (which adds MTRR entries to change caching
> type) there is no physical reason why write through should behave
> differently when using NV Memory.  Does anybody on this mailing list
> who may be more familiar with caching techniques know why this might
> me the case?

I reran my old test and did not see this problem.  So, I think there is
an issue in your setup that it somehow ended up with UC...

My test driver calls ioremap_wt to an NVDIMM range and access it from
the driver itself.  It does not modify MTRR entries.

-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
