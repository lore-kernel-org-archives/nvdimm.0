Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20C551A1EC1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 09:16:42 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id h6so11193278oia.2
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 09:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160324160452.GA5725@linux.intel.com>
References: <20160324011648.20651.33434.stgit@dwillia2-desk3.jf.intel.com>
 <20160324011653.20651.27454.stgit@dwillia2-desk3.jf.intel.com>
 <20160324160452.GA5725@linux.intel.com>
Date: Thu, 24 Mar 2016 09:15:49 -0700
Message-ID: <CAPcyv4gXGy2TrOaG6=GC8i=h9kspRPqDkvC0xVymCn_=swhCtw@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: provide a method to invalidate the bus
 list
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 24, 2016 at 9:04 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Mar 23, 2016 at 06:16:53PM -0700, Dan Williams wrote:
>> Consider the following scenario:
>>
>>     ndctl_new()
>>     ndctl_bus_foreach()
>>     <install a new nvdimm-bus provider>
>>     ndctl_bus_foreach()
>>
>> ...the second ndctl_bus_foreach() will not see any new buses because the
>> bus results are cached.  When the holder of the context knows that it
>> has invalidated the bus list it needs to call ndctl_invalidate() so that
>> subsequent ndctl_bus_foreach() scans are guaranteed to see new buses.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  lib/libndctl.c          |   22 ++++++++++++++++++----
>>  lib/libndctl.sym        |    1 +
>>  lib/ndctl/libndctl.h.in |    1 +
>
> I can't get this patch to apply because I don't have lib/ndctl/libndctl.h.in
> in my source tree.
>
> I'm using your upstream repo:
>
> https://github.com/pmem/ndctl.git
>
> and AFAICT this file doesn't exist in any upstream branches.

https://patchwork.kernel.org/patch/8584381/

I'll push this out to the -pending branch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
