Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH v2] mm: disallow mapping that conflict for
 devm_memremap_pages()
References: <152909478401.50143.312364396244072931.stgit@djiang5-desk3.ch.intel.com>
 <20180717143750.3cd7e77544d181a346212715@linux-foundation.org>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <3a5aad9d-8408-0d2a-ad53-86a9f6273f7b@intel.com>
Date: Tue, 17 Jul 2018 14:42:38 -0700
MIME-Version: 1.0
In-Reply-To: <20180717143750.3cd7e77544d181a346212715@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dan.j.williams@intel.com, elliott@hpe.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 07/17/2018 02:37 PM, Andrew Morton wrote:
> On Fri, 15 Jun 2018 13:33:39 -0700 Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> When pmem namespaces created are smaller than section size, this can cause
>> issue during removal and gpf was observed:
>>
>> ...
>>
>> Add code to check whether we have mapping already in the same section and
>> prevent additional mapping from created if that is the case.
>>
> 
> Which kernel version(s) do you believe need this fix, and why?
> 

It really should go into 4.18-rc and backported to stable since without
it a GPF can be triggered when pmem namespaces smaller than section size
are constructed.
